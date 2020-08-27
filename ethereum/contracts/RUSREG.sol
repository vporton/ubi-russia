//SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.7.0;

import './BaseUBI.sol';

contract RUSREG is BaseUBI {
    constructor(address _owner, address _gasHolder)
        BaseUBI(_owner, _gasHolder, 18, "Russian UBI Since Registration", "RUSREG")
    { }
}
