//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.7.0;

// import "@nomiclabs/buidler/console.sol";
import './BaseToken.sol';
import './BaseUBI.sol';

contract GasHolder is BaseToken {
    uint8 public decimals;
    string public name;
    string public symbol;
    address payable public server;

    constructor(address payable _server, uint8 _decimals, string memory _name, string memory _symbol) {
        server = _server;
        decimals = _decimals;
        name = _name;
        symbol = _symbol;
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

    function setAccount(BaseUBI _ubi, address _user, uint256 _startTime, uint _esiaID) external {
        uint256 _refund = (gasleft() + TODO) * tx.gasprice;
        require(_refund <= balances[_user], "Not enough balance");
        server.transfer(_refund); // refund gas to the server
        balances[_user] -= _refund;
        require(msg.sender == server, "System function");
        _ubi.setAccount{gas: balances[_user]}(_user, _startTime, _esiaID);
    }
}
