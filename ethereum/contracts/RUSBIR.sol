//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.7.0;

import './BaseUBI.sol';

contract RUSBIR is BaseUBI {
    constructor(address _owner, address _gasHolder, uint8 _decimals, string memory _name, string memory _symbol)
        BaseUBI(_owner, _gasHolder, 18, "Russian UBI Since Birth", "RUSBIR")
    { }
}
