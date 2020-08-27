//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.6.8;

// import "@nomiclabs/buidler/console.sol";
import './BaseToken.sol';
import './BaseUBI.sol';

contract GasHolder is BaseToken {
    address public server;

    constructor(address _server) public {
        server = _server;
    }

    receive() external payable {
        balances[msg.sender] += msg.value;
        totalSupply += msg.value;
        emit Transfer(address(0), msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) external {
        require(_amount >= balances[msg.sender], "Not enough balance");
        msg.sender.transfer(_amount);
        balances[msg.sender] -= _amount;
        totalSupply -= _amount;
        emit Transfer(msg.sender, address(0), _amount);
    }

    function setAccount(BaseUBI _ubi, address _user, uint256 _startTime) external {
        require(msg.sender == server, "System function");
        _ubi.setAccount(_user, _startTime);
    }
}
