// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../contracts/test/BitMathTest.sol";

contract BitMathTestFoundry is Test {
    BitMathTest bitMath;

    function setUp() public {
        bitMath = new BitMathTest();
    }

    // mostSignificantBit tests
    function testMostSignificantBit_Reverts_ForZero() public {
        vm.expectRevert();
        bitMath.mostSignificantBit(0);
    }

    function testMostSignificantBit_1() public {
        assertEq(bitMath.mostSignificantBit(1), 0);
    }

    function testMostSignificantBit_2() public {
        assertEq(bitMath.mostSignificantBit(2), 1);
    }

    function testMostSignificantBit_AllPowersOf2() public {
        for (uint256 i = 0; i < 255; i++) {
            assertEq(bitMath.mostSignificantBit(2 ** i), i);
        }
    }

    function testMostSignificantBit_MaxUint256() public {
        assertEq(bitMath.mostSignificantBit(type(uint256).max), 255);
    }

    function testMostSignificantBit_Gas_SmallNumber() public {
        uint256 gasCost = bitMath.getGasCostOfMostSignificantBit(3568);
        console.log("Gas cost for mostSignificantBit(3568):", gasCost);
    }

    function testMostSignificantBit_Gas_MaxUint128() public {
        uint256 gasCost = bitMath.getGasCostOfMostSignificantBit(type(uint128).max);
        console.log("Gas cost for mostSignificantBit(max uint128):", gasCost);
    }

    function testMostSignificantBit_Gas_MaxUint256() public {
        uint256 gasCost = bitMath.getGasCostOfMostSignificantBit(type(uint256).max);
        console.log("Gas cost for mostSignificantBit(max uint256):", gasCost);
    }

    // leastSignificantBit tests
    function testLeastSignificantBit_Reverts_ForZero() public {
        vm.expectRevert();
        bitMath.leastSignificantBit(0);
    }

    function testLeastSignificantBit_1() public {
        assertEq(bitMath.leastSignificantBit(1), 0);
    }

    function testLeastSignificantBit_2() public {
        assertEq(bitMath.leastSignificantBit(2), 1);
    }

    function testLeastSignificantBit_AllPowersOf2() public {
        for (uint256 i = 0; i < 255; i++) {
            assertEq(bitMath.leastSignificantBit(2 ** i), i);
        }
    }

    function testLeastSignificantBit_MaxUint256() public {
        assertEq(bitMath.leastSignificantBit(type(uint256).max), 0);
    }

    function testLeastSignificantBit_Gas_SmallNumber() public {
        uint256 gasCost = bitMath.getGasCostOfLeastSignificantBit(3568);
        console.log("Gas cost for leastSignificantBit(3568):", gasCost);
    }

    function testLeastSignificantBit_Gas_MaxUint128() public {
        uint256 gasCost = bitMath.getGasCostOfLeastSignificantBit(type(uint128).max);
        console.log("Gas cost for leastSignificantBit(max uint128):", gasCost);
    }

    function testLeastSignificantBit_Gas_MaxUint256() public {
        uint256 gasCost = bitMath.getGasCostOfLeastSignificantBit(type(uint256).max);
        console.log("Gas cost for leastSignificantBit(max uint256):", gasCost);
    }
}
