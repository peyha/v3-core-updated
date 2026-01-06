// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../contracts/test/LiquidityMathTest.sol";

contract LiquidityMathTestFoundry is Test {
    LiquidityMathTest liquidityMath;

    function setUp() public {
        liquidityMath = new LiquidityMathTest();
    }

    function testAddDelta_1Plus0() public {
        assertEq(liquidityMath.addDelta(1, 0), 1);
    }

    function testAddDelta_1PlusNegative1() public {
        assertEq(liquidityMath.addDelta(1, -1), 0);
    }

    function testAddDelta_1Plus1() public {
        assertEq(liquidityMath.addDelta(1, 1), 2);
    }

    function testAddDelta_2Pow128Minus15Plus15Overflows() public {
        vm.expectRevert();
        liquidityMath.addDelta(2 ** 128 - 15, 15);
    }

    function testAddDelta_0PlusNegative1Underflows() public {
        vm.expectRevert();
        liquidityMath.addDelta(0, -1);
    }

    function testAddDelta_3PlusNegative4Underflows() public {
        vm.expectRevert();
        liquidityMath.addDelta(3, -4);
    }

    function testAddDelta_GasAdd() public {
        uint256 gasCost = liquidityMath.getGasCostOfAddDelta(15, 4);
        console.log("Gas cost for addDelta (add):", gasCost);
    }

    function testAddDelta_GasSub() public {
        uint256 gasCost = liquidityMath.getGasCostOfAddDelta(15, -4);
        console.log("Gas cost for addDelta (sub):", gasCost);
    }
}
