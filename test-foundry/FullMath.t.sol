// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/test/FullMathTest.sol";

contract FullMathTestFoundry is Test {
    FullMathTest fullMath;
    uint256 constant Q128 = 2 ** 128;
    uint256 constant MAX_UINT256 = type(uint256).max;

    function setUp() public {
        fullMath = new FullMathTest();
    }

    // mulDiv tests
    function testMulDiv_RevertsIfDenominatorIsZero() public {
        vm.expectRevert();
        fullMath.mulDiv(Q128, 5, 0);
    }

    function testMulDiv_RevertsIfDenominatorIsZeroAndNumeratorOverflows() public {
        vm.expectRevert();
        fullMath.mulDiv(Q128, Q128, 0);
    }

    function testMulDiv_RevertsIfOutputOverflowsUint256() public {
        vm.expectRevert();
        fullMath.mulDiv(Q128, Q128, 1);
    }

    function testMulDiv_RevertsOnOverflowWithAllMaxInputs() public {
        vm.expectRevert();
        fullMath.mulDiv(MAX_UINT256, MAX_UINT256, MAX_UINT256 - 1);
    }

    function testMulDiv_AllMaxInputs() public {
        assertEq(fullMath.mulDiv(MAX_UINT256, MAX_UINT256, MAX_UINT256), MAX_UINT256);
    }

    function testMulDiv_AccurateWithoutPhantomOverflow() public {
        uint256 result = Q128 / 3;
        // 0.5 = 50 * Q128 / 100, 1.5 = 150 * Q128 / 100
        assertEq(fullMath.mulDiv(Q128, (50 * Q128) / 100, (150 * Q128) / 100), result);
    }

    function testMulDiv_AccurateWithPhantomOverflow() public {
        uint256 result = (4375 * Q128) / 1000;
        assertEq(fullMath.mulDiv(Q128, 35 * Q128, 8 * Q128), result);
    }

    function testMulDiv_AccurateWithPhantomOverflowAndRepeatingDecimal() public {
        uint256 result = (1 * Q128) / 3;
        uint256 b;
        uint256 denominator;
        unchecked {
            b = 1000 * Q128;
            denominator = 3000 * Q128;
        }
        assertEq(fullMath.mulDiv(Q128, b, denominator), result);
    }

    // mulDivRoundingUp tests
    function testMulDivRoundingUp_RevertsIfDenominatorIsZero() public {
        vm.expectRevert();
        fullMath.mulDivRoundingUp(Q128, 5, 0);
    }

    function testMulDivRoundingUp_RevertsIfDenominatorIsZeroAndNumeratorOverflows() public {
        vm.expectRevert();
        fullMath.mulDivRoundingUp(Q128, Q128, 0);
    }

    function testMulDivRoundingUp_RevertsIfOutputOverflowsUint256() public {
        vm.expectRevert();
        fullMath.mulDivRoundingUp(Q128, Q128, 1);
    }

    function testMulDivRoundingUp_RevertsOnOverflowWithAllMaxInputs() public {
        vm.expectRevert();
        fullMath.mulDivRoundingUp(MAX_UINT256, MAX_UINT256, MAX_UINT256 - 1);
    }

    function testMulDivRoundingUp_RevertsIfMulDivOverflows256BitsAfterRoundingUp() public {
        vm.expectRevert();
        fullMath.mulDivRoundingUp(535006138814359, 432862656469423142931042426214547535783388063929571229938474969, 2);
    }

    function testMulDivRoundingUp_RevertsIfMulDivOverflows256BitsAfterRoundingUpCase2() public {
        vm.expectRevert();
        fullMath.mulDivRoundingUp(
            115792089237316195423570985008687907853269984659341747863450311749907997002549,
            115792089237316195423570985008687907853269984659341747863450311749907997002550,
            115792089237316195423570985008687907853269984653042931687443039491902864365164
        );
    }

    function testMulDivRoundingUp_AllMaxInputs() public {
        assertEq(fullMath.mulDivRoundingUp(MAX_UINT256, MAX_UINT256, MAX_UINT256), MAX_UINT256);
    }

    function testMulDivRoundingUp_AccurateWithoutPhantomOverflow() public {
        uint256 result = Q128 / 3 + 1;
        // 0.5 = 50 * Q128 / 100, 1.5 = 150 * Q128 / 100
        assertEq(fullMath.mulDivRoundingUp(Q128, (50 * Q128) / 100, (150 * Q128) / 100), result);
    }

    function testMulDivRoundingUp_AccurateWithPhantomOverflow() public {
        uint256 result = (4375 * Q128) / 1000;
        assertEq(fullMath.mulDivRoundingUp(Q128, 35 * Q128, 8 * Q128), result);
    }

    function testMulDivRoundingUp_AccurateWithPhantomOverflowAndRepeatingDecimal() public {
        uint256 result = (1 * Q128) / 3 + 1;
        uint256 b;
        uint256 denominator;
        unchecked {
            b = 1000 * Q128;
            denominator = 3000 * Q128;
        }
        assertEq(fullMath.mulDivRoundingUp(Q128, b, denominator), result);
    }
}
