//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.7.0;

// import "@nomiclabs/buidler/console.sol";
import './BaseToken.sol';
import './BaseUBI.sol';
import '@nomiclabs/buidler/console.sol';

contract GasHolder {
    uint8 public decimals;
    address payable public server;
    address payable public beneficary;

    constructor(address payable _server, address payable _beneficary, uint8 _decimals) {
        server = _server;
        beneficary = _beneficary;
        decimals = _decimals;
    }

    function setServer(address payable _server) external {
        require(msg.sender == server, "System function");
        require(server != address(0), "Server cannot be zero");
        server = _server;
    }

    receive() external payable {
        balances[msg.sender] += msg.value;
        totalSupply += msg.value;
        emit Transfer(address(0), msg.sender, msg.value);
    }

    struct SetAccountInfo {
        BaseUBI ubi;
        uint256 startTime;
        uint esiaID;
        bool setToZero;
    }

    function setAccounts(address _user,
                         BaseUBI[] calldata _ubi,
                         uint256[] calldata _startTime,
                         uint[] calldata _esiaID,
                         bool[] calldata _setToZero,
                         bool _withdraw) external
    {
        // Compiles to this with Solidity 0.7.1 without optimization
        // PUSH1 0x00 // 3
        // GASPRICE // 2
        // PUSH2 0xXXXX // 3
        // GAS // 2
        // ADD // 3
        // MUL // 5
        // SWAP1 // 3
        // POP // 2
        uint256 _refund = (gasleft() + 23) * tx.gasprice;
        require(msg.sender == server, "System function"); // don't refund otherwise
        require(_refund <= balances[_user], "Not enough balance"); // prevents valuating gas, the server will not break this rule
        if(_withdraw) {
            totalSupply -= balances[_user];
            balances[_user] = 0; // must be called before transfer() against reentrancy attack?
        } else {
            totalSupply -= _refund;
            balances[_user] -= _refund; // must be called before transfer() against reentrancy attack
        }
        server.transfer(_refund); // refund gas to the server
        require(_ubi.length == _startTime.length && _ubi.length == _esiaID.length && _ubi.length == _setToZero.length,
                "Lengths don't match");
        for(uint i = 0; i < _ubi.length; ++i) {
            _setAccount(_user, _ubi[i], _startTime[i], _esiaID[i], _setToZero[i]);
        }
    }

    function _setAccount(address _user,
                         BaseUBI _ubi,
                         uint256 _startTime,
                         uint _esiaID,
                         bool _setToZero) internal
    {
        _ubi.setAccount(_user, _startTime, _esiaID, _setToZero);
    }

    function donateToUs(uint256 _amount) external {
        require(balances[msg.sender] >= _amount, "Not enough funds");
        balances[msg.sender] -= _amount;
        totalSupply -= _amount;
        emit Transfer(msg.sender, address(0), _amount);
    }

    // FIXME: Be able to withdraw a part of ETH
    function withdraw() external {
        require(msg.sender == beneficary, "Only owner");
        beneficary.transfer(address(this).balance - totalSupply);
    }

    uint256 public totalSupply;
    mapping (address => uint256) public balances;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
}
