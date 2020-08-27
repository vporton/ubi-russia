//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.6.8;

// import "@nomiclabs/buidler/console.sol";
import './BaseToken.sol';

contract BaseUBI {
    uint public digits;
    address public owner;
    address public gasHolder;
    uint256 public lastTotalSupply;
    uint256 public lastTotalCheck;
    uint numberOfUsers;
    mapping (address => mapping (address => uint256)) public allowed;
    mapping (address => int256) public lastBalances;
    mapping (address => uint256) public lastTimes;

    constructor(address _owner, address _gasHolder, uint _digits) public {
        owner = _owner;
        gasHolder = _gasHolder;
        digits = _digits;
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

    function setAccount(address _user, uint256 _startTime) external {
        require(msg.sender == gasHolder, "System function");
        if(lastTimes[_user] != 0) ++numberOfUsers;
        lastTimes[_user] = _startTime;
        lastBalances[_user] = 0;
    }

    function balanceOf(address _user) external view returns (uint256 balance) {
        int256 result = _balanceOf(_user);
        return result < 0 ? 0 : uint256(result);
    }

    function transfer(address _to, uint256 _value) external returns (bool success) {
        require(msg.sender == owner || _balanceOf(msg.sender) >= int256(_value), "Not enough funds");
        uint256 _passedTime = now - lastTotalCheck;
        uint256 _difference = _passedTime * 10**digits / (24*3600);
        lastBalances[msg.sender] = _balanceOf(msg.sender) - int256(_value);
        lastTimes[msg.sender] = now;
        lastBalances[_to] = _balanceOf(msg.sender) + int256(_value);
        lastTimes[_to] = now;
        lastTotalSupply += _difference;
        lastTotalCheck = now;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
        require(msg.sender == owner || _balanceOf(_from) >= int256(_value) && allowed[_from][msg.sender] >= _value, "Not enough funds");
        uint256 _passedTime = now - lastTotalCheck;
        uint256 _difference = _passedTime * 10**digits / (24*3600);
        lastBalances[_to] = _balanceOf(msg.sender) + int256(_value);
        lastTimes[_to] = now;
        lastBalances[_from] = _balanceOf(msg.sender) - int256(_value);
        lastTimes[_from] = now;
        allowed[_from][msg.sender] -= _value;
        lastTotalSupply += _difference;
        lastTotalCheck = now;
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
    function _balanceOf(address _holder) private view returns (int256 balance) {
        if(lastTimes[_holder] == 0) // no such user
            return 0;
        int256 _passedTime = int256(now) - int256(lastTimes[_holder]);
        return int256(lastBalances[_holder]) + _passedTime * int256(10**digits / (24*3600));
    }

    // may be negative
    function _totalSupply() private view returns (int256) {
        int256 _passedTime = int256(now) - int256(lastTotalCheck);
        return int256(lastTotalSupply) + _passedTime * int256(numberOfUsers * 10**digits / (24*3600));
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _holder, address indexed _spender, uint256 _value);
}
