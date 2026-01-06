// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./helpers/TestUtils.sol";
import "../contracts/test/SqrtPriceMathTest.sol";

contract SqrtPriceMathTestFoundry is TestUtils {
    SqrtPriceMathTest sqrtPriceMath;

    function setUp() public {
        sqrtPriceMath = new SqrtPriceMathTest();
    }

    function testGetNextSqrtPriceFromInput_FailsIfPriceIsZero() public {
        vm.expectRevert();
        sqrtPriceMath.getNextSqrtPriceFromInput(0, 0, expandTo18Decimals(1) / 10, false);
    }

    function testGetNextSqrtPriceFromInput_ReturnsMinimumPriceForMaxInputs() public {
        uint160 sqrtP = type(uint160).max;
        uint128 liquidity = MAX_UINT128;
        uint256 maxAmountNoOverflow;
        unchecked {
            maxAmountNoOverflow = type(uint256).max - ((uint256(liquidity) << 96) / sqrtP);
        }
        assertEq(sqrtPriceMath.getNextSqrtPriceFromInput(sqrtP, liquidity, maxAmountNoOverflow, true), 1);
    }

    function testGetNextSqrtPriceFromInput_InputAmountOf01Token1() public {
        uint160 sqrtQ = sqrtPriceMath.getNextSqrtPriceFromInput(
            encodePriceSqrt(1, 1), uint128(expandTo18Decimals(1)), expandTo18Decimals(1) / 10, false
        );
        assertEq(sqrtQ, 87150978765690771352898345369);
    }

    function testGetNextSqrtPriceFromOutput_FailsIfLiquidityIsZero() public {
        vm.expectRevert();
        sqrtPriceMath.getNextSqrtPriceFromOutput(1, 0, expandTo18Decimals(1) / 10, true);
    }

    function testGetNextSqrtPriceFromOutput_OutputAmountOf01Token1() public {
        uint160 sqrtQ = sqrtPriceMath.getNextSqrtPriceFromOutput(
            encodePriceSqrt(1, 1), uint128(expandTo18Decimals(1)), expandTo18Decimals(1) / 10, false
        );
        assertEq(sqrtQ, 88031291682515930659493278152);
    }

    function testGetAmount0Delta_ReturnsZeroIfLiquidityIsZero() public {
        uint256 amount0 = sqrtPriceMath.getAmount0Delta(encodePriceSqrt(1, 1), encodePriceSqrt(2, 1), 0, true);
        assertEq(amount0, 0);
    }

    function testGetAmount1Delta_ReturnsCorrectAmount() public {
        uint256 amount1 = sqrtPriceMath.getAmount1Delta(
            encodePriceSqrt(1, 1), encodePriceSqrt(121, 100), uint128(expandTo18Decimals(1)), true
        );
        assertGt(amount1, 0);
    }
}
