//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.7.0;

// import "@nomiclabs/buidler/console.sol";
import './BaseToken.sol';

contract BaseUBI {
    uint8 public decimals;
    string public name;
    string public symbol;
    address public owner;
    address public gasHolder;
    int256 public lastTotalSupply;
    uint256 public lastTotalCheck;
    uint numberOfActiveUsers;
    bool enabledMinting = true;
    mapping (address => mapping (address => uint256)) public allowed;
    mapping (address => int256) public lastBalances;
    mapping (address => uint256) public lastTimes;
    mapping (uint => address) public addresses; // ESIA ID -> address
    mapping (address => uint) public esiaIDs;   // address -> ESIA ID

    constructor(address _owner, address _gasHolder, uint8 _decimals, string memory _name, string memory _symbol) {
        owner = _owner;
        gasHolder = _gasHolder;
        decimals = _decimals;
        name = _name;
        symbol = _symbol;
    }

    function setOwner(address _owner) external {
        require(msg.sender == owner, "Requires owner");
        require(owner != address(0), "Owner cannot be zero");
        owner = _owner;
    }

    function removeOwner() external {
        require(msg.sender == owner, "Requires owner");
        owner = address(0);
    }

    function disableMinting() external {
        require(msg.sender == owner, "Only the admin");
        enabledMinting = false;
    }

    function setAccount(address _user, uint256 _startTime, uint _esiaID, bool _setToZero) external {
        require(msg.sender == gasHolder, "System function");
        require(esiaIDs[_user] == 0 || esiaIDs[_user] == _esiaID, "Account busy by other user");
        if(addresses[_esiaID] == address(0)) {
            // Creating new user:
            int256 _userTime = int256(lastTotalCheck) - int256(_startTime);
            int256 _balance = _userTime * int256(10**decimals / (24*3600));
            lastTotalSupply += _balance;
            ++numberOfActiveUsers;
            addresses[_esiaID] = _user;
            esiaIDs[_user] = _esiaID;
            lastBalances[_user] = _balance;
            lastTimes[_user] = lastTotalCheck;
        } else if(_startTime == 0) {
            // Removing a user, for example if he is dead.
            int256 _userTime = int256(lastTotalCheck) - int256(_startTime);
            --numberOfActiveUsers;
            if(_setToZero) {
                lastTotalSupply -= _userTime * int256(10**decimals / (24*3600));
                lastBalances[_user] = 0;
                lastTimes[_user] = 0;
            }
            addresses[_esiaID] = address(0);
            esiaIDs[_user] = 0;
        } else {
            // Moving user to new account:
            address _oldUser = addresses[_esiaID];
            if(_user != _oldUser) {
                lastBalances[_user] = lastBalances[_oldUser];
                lastTimes[_user] = lastTimes[_oldUser];
                lastBalances[_oldUser] = 0;
                lastTimes[_oldUser] = 0;
                addresses[_esiaID] = _user;
                esiaIDs[_user] = _esiaID;
            }
        }
        lastTimes[_user] = _startTime;
        lastBalances[_user] = 0;
    }

    function transferUBI(address _newAddress) external {
        require(_newAddress != msg.sender, "Cannot transfer to yourself");
        require(esiaIDs[msg.sender] != 0); // needed?
        uint _esiaID = esiaIDs[_newAddress];
        require(_esiaID == 0, "Account busy by a user");

        addresses[_esiaID] = _newAddress;
        esiaIDs[msg.sender] = 0;
        esiaIDs[_newAddress] = _esiaID;

        lastBalances[_newAddress] = lastBalances[msg.sender];
        lastTimes[_newAddress] = lastTimes[msg.sender];
        lastBalances[msg.sender] = 0;
        lastTimes[msg.sender] = 0;

    }

    function balanceOf(address _user) external view returns (uint256 balance) {
        int256 result = _balanceOf(_user);
        return result < 0 ? 0 : uint256(result);
    }

    function transfer(address _to, uint256 _value) external returns (bool success) {
        require(enabledMinting && msg.sender == owner || _balanceOf(msg.sender) >= int256(_value), "Not enough funds");
        int256 _passedTime = int256(block.timestamp) - int256(lastTotalCheck);
        int256 _difference = _passedTime * int256(10**decimals / (24*3600));
        lastBalances[msg.sender] = _balanceOf(msg.sender) - int256(_value);
        lastTimes[msg.sender] = block.timestamp;
        lastBalances[_to] = _balanceOf(msg.sender) + int256(_value);
        lastTimes[_to] = block.timestamp;
        lastTotalSupply += _difference;
        lastTotalCheck = block.timestamp;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
        require((enabledMinting && msg.sender == owner || _balanceOf(_from) >= int256(_value)) && allowed[_from][msg.sender] >= _value, "Not enough funds");
        int256 _passedTime = int256(block.timestamp) - int256(lastTotalCheck);
        int256 _difference = _passedTime * int256(10**decimals / (24*3600));
        lastBalances[_to] = _balanceOf(msg.sender) + int256(_value);
        lastTimes[_to] = block.timestamp;
        lastBalances[_from] = _balanceOf(msg.sender) - int256(_value);
        lastTimes[_from] = block.timestamp;
        allowed[_from][msg.sender] -= _value;
        lastTotalSupply += _difference;
        lastTotalCheck = block.timestamp;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) external returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _holder, address _spender) external view returns (uint256 remaining) {
      return allowed[_holder][_spender];
    }

    function totalSupply() external view returns (uint256) {
        int256 result = _totalSupply();
        return result < 0 ? 0 : uint256(result);
    }

    // may be negative
    function _balanceOf(address _holder) private view returns (int256 _balance) {
        _balance = lastBalances[_holder];
        if(esiaIDs[_holder] != 0) {
            int256 _passedTime = int256(block.timestamp) - int256(lastTimes[_holder]);
            _balance += _passedTime * int256(10**decimals / (24*3600));
        }
    }

    // may be negative
    function _totalSupply() private view returns (int256) {
        int256 _passedTime = int256(block.timestamp) - int256(lastTotalCheck);
        return lastTotalSupply + _passedTime * int256(numberOfActiveUsers * 10**decimals / (24*3600));
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _holder, address indexed _spender, uint256 _value);
}
