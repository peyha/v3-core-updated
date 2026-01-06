// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./helpers/TestUtils.sol";
import "../contracts/test/TickMathTest.sol";
import "forge-std/console.sol";

contract TickMathTestFoundry is TestUtils {
    TickMathTest tickMath;

    function setUp() public {
        tickMath = new TickMathTest();
    }

    function testGetSqrtRatioAtTick_ThrowsForTooLow() public {
        vm.expectRevert();
        tickMath.getSqrtRatioAtTick(MIN_TICK - 1);
    }

    function testGetSqrtRatioAtTick_ThrowsForTooHigh() public {
        vm.expectRevert();
        tickMath.getSqrtRatioAtTick(MAX_TICK + 1);
    }

    function testGetSqrtRatioAtTick_MinTick() public {
        assertEq(tickMath.getSqrtRatioAtTick(MIN_TICK), MIN_SQRT_RATIO);
    }

    function testGetSqrtRatioAtTick_MaxTick() public {
        assertEq(tickMath.getSqrtRatioAtTick(MAX_TICK), MAX_SQRT_RATIO);
    }

    function testMinSqrtRatio_EqualsGetSqrtRatioAtTickMinTick() public {
        uint160 min = tickMath.getSqrtRatioAtTick(MIN_TICK);
        assertEq(min, tickMath.MIN_SQRT_RATIO());
        assertEq(min, MIN_SQRT_RATIO);
    }

    function testMaxSqrtRatio_EqualsGetSqrtRatioAtTickMaxTick() public {
        uint160 max = tickMath.getSqrtRatioAtTick(MAX_TICK);
        assertEq(max, tickMath.MAX_SQRT_RATIO());
        assertEq(max, MAX_SQRT_RATIO);
    }

    function testGetTickAtSqrtRatio_ThrowsForTooLow() public {
        vm.expectRevert();
        tickMath.getTickAtSqrtRatio(MIN_SQRT_RATIO - 1);
    }

    function testGetTickAtSqrtRatio_ThrowsForTooHigh() public {
        vm.expectRevert();
        tickMath.getTickAtSqrtRatio(MAX_SQRT_RATIO);
    }

    function testGetTickAtSqrtRatio_RatioOfMinTick() public {
        assertEq(tickMath.getTickAtSqrtRatio(MIN_SQRT_RATIO), MIN_TICK);
    }

    function testGetTickAtSqrtRatio_RatioClosestToMaxTick() public {
        assertEq(tickMath.getTickAtSqrtRatio(MAX_SQRT_RATIO - 1), MAX_TICK - 1);
    }
}
