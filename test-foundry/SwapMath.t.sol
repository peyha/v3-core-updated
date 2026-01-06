// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./helpers/TestUtils.sol";
import "../contracts/test/SwapMathTest.sol";
import "../contracts/test/SqrtPriceMathTest.sol";

contract SwapMathTestFoundry is TestUtils {
    SwapMathTest swapMath;
    SqrtPriceMathTest sqrtPriceMath;

    function setUp() public {
        swapMath = new SwapMathTest();
        sqrtPriceMath = new SqrtPriceMathTest();
    }

    function testComputeSwapStep_ExactAmountInCappedAtPriceTarget() public {
        uint160 price = encodePriceSqrt(1, 1);
        uint160 priceTarget = encodePriceSqrt(101, 100);
        uint128 liquidity = uint128(expandTo18Decimals(2));
        int256 amount = int256(expandTo18Decimals(1));
        uint24 fee = 600;

        (uint160 sqrtQ, uint256 amountIn, uint256 amountOut, uint256 feeAmount) =
            swapMath.computeSwapStep(price, priceTarget, liquidity, amount, fee);

        assertEq(amountIn, 9975124224178055);
        assertEq(feeAmount, 5988667735148);
        assertEq(amountOut, 9925619580021728);
        assertLt(amountIn + feeAmount, uint256(amount));
        assertEq(sqrtQ, priceTarget);
    }

    function testComputeSwapStep_TargetPriceOfOne() public {
        uint160 price = encodePriceSqrt(1, 1);
        uint160 priceTarget = encodePriceSqrt(1, 1);
        uint128 liquidity = uint128(expandTo18Decimals(1));
        int256 amount = int256(expandTo18Decimals(1) / 10);
        uint24 fee = 600;

        (uint160 sqrtQ, uint256 amountIn, uint256 amountOut, uint256 feeAmount) =
            swapMath.computeSwapStep(price, priceTarget, liquidity, amount, fee);

        assertEq(amountIn, 0);
        assertEq(amountOut, 0);
        assertEq(feeAmount, 0);
        assertEq(sqrtQ, priceTarget);
    }
}
