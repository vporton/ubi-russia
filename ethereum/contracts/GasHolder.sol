//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.6.8;

// import "@nomiclabs/buidler/console.sol";
import './BaseToken.sol';
import './BaseUBI.sol';

contract GasHolder is BaseToken {
    address payable public server;

    constructor(address payable _server) public {
        server = _server;
    }

    function setServer(address payable _server) external {
        require(msg.sender == server, "System function");
        require(server != address(0), "Server cannot be zero");
        server = _server;
    }

    receive() external payable {
        balances[msg.sender] += msg.value;
        totalSupply += msg.value;
        server.transfer(msg.value);
        emit Transfer(address(0), msg.sender, msg.value);
    }

    function setAccount(BaseUBI _ubi, address _user, uint256 _startTime) external {
        require(msg.sender == server, "System function");
        _ubi.setAccount{gas: balances[msg.sender]}(_user, _startTime); // The server pays for gas.
    }
}
