// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../contracts/test/NoDelegateCallTest.sol";

contract NoDelegateCallTestFoundry is Test {
    NoDelegateCallTest testContract;

    function setUp() public {
        testContract = new NoDelegateCallTest();
    }

    function testCanCallIfNotDelegatecall() public {
        testContract.cannotBeDelegateCalled();
    }

    function testCanBeDelegatecalledViewFunction() public view {
        testContract.canBeDelegateCalled();
    }

    function testGetGasCostOfCannotBeDelegateCalled() public {
        uint256 gasCost = testContract.getGasCostOfCannotBeDelegateCalled();
        console.log("Gas cost of cannotBeDelegateCalled:", gasCost);
    }

    function testGetGasCostOfCanBeDelegateCalled() public {
        uint256 gasCost = testContract.getGasCostOfCanBeDelegateCalled();
        console.log("Gas cost of canBeDelegateCalled:", gasCost);
    }
}
