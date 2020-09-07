//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

// import "@nomiclabs/buidler/console.sol";
import './BaseToken.sol';
import './BaseUBI.sol';

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

    function setAccounts(address _user, SetAccountInfo[] calldata _infos, bool _withdraw) external {
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
        require(_refund <= balances[_user], "Not enough balance");
        if(_withdraw) {
            balances[_user] = 0; // must be called before transfer() against reentrancy attack?
            beneficary.transfer(balances[_user] - _refund);
        } else {
            balances[_user] -= _refund; // must be called before transfer() against reentrancy attack
        }
        server.transfer(_refund); // refund gas to the server
        for(uint i = 0; i < _infos.length; ++i) {
            _setAccount(_user, _infos[i]);
        }
    }

    function _setAccount(address _user, SetAccountInfo calldata _info) internal {
        _info.ubi.setAccount{gas: balances[_user]}(_user, _info.startTime, _info.esiaID, _info.setToZero);
    }

    function donateToUs(uint256 _amount) external {
        require(balances[msg.sender] >= _amount, "Not enough funds");
        balances[msg.sender] -= _amount;
        totalSupply -= _amount;
        emit Transfer(msg.sender, address(0), _amount);
    }

    uint256 totalSupply;
    mapping (address => uint256) public balances;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
}
