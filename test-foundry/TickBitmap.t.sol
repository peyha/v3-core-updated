// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../contracts/test/TickBitmapTest.sol";

contract TickBitmapTestFoundry is Test {
    TickBitmapTest tickBitmap;

    function setUp() public {
        tickBitmap = new TickBitmapTest();
    }

    function testIsInitialized_IsFalseAtFirst() public {
        assertEq(tickBitmap.isInitialized(1), false);
    }

    function testIsInitialized_IsFlippedByFlipTick() public {
        tickBitmap.flipTick(1);
        assertEq(tickBitmap.isInitialized(1), true);
    }

    function testIsInitialized_IsFlippedBackByFlipTick() public {
        tickBitmap.flipTick(1);
        tickBitmap.flipTick(1);
        assertEq(tickBitmap.isInitialized(1), false);
    }

    function testFlipTick_FlipsOnlyTheSpecifiedTick() public {
        tickBitmap.flipTick(-230);
        assertEq(tickBitmap.isInitialized(-230), true);
        assertEq(tickBitmap.isInitialized(-231), false);
        assertEq(tickBitmap.isInitialized(-229), false);
    }

    function testNextInitializedTickWithinOneWord_LteTrue() public {
        tickBitmap.flipTick(-200);
        tickBitmap.flipTick(-55);

        (int24 next, bool initialized) = tickBitmap.nextInitializedTickWithinOneWord(-55, true);
        assertEq(next, -55);
        assertEq(initialized, true);
    }

    function testNextInitializedTickWithinOneWord_LteFalse() public {
        tickBitmap.flipTick(-200);
        tickBitmap.flipTick(-55);
        tickBitmap.flipTick(-4);
        tickBitmap.flipTick(70);
        tickBitmap.flipTick(78);
        tickBitmap.flipTick(84);

        (int24 next, bool initialized) = tickBitmap.nextInitializedTickWithinOneWord(-56, false);
        assertEq(next, -55);
        assertEq(initialized, true);
    }
}
