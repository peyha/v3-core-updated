# Foundry Tests for Uniswap V3 Core

This directory contains Foundry tests converted from TypeScript tests.

## Test Files Converted

### Library Tests
- `BitMath.t.sol` - Tests for BitMath library
- `FullMath.t.sol` - Tests for FullMath library
- `LiquidityMath.t.sol` - Tests for LiquidityMath library
- `TickMath.t.sol` - Tests for TickMath library
- `SqrtPriceMath.t.sol` - Tests for SqrtPriceMath library
- `SwapMath.t.sol` - Tests for SwapMath library
- `TickBitmap.t.sol` - Tests for TickBitmap library

### Contract Tests
- `NoDelegateCall.t.sol` - Tests for NoDelegateCall functionality
- `UniswapV3Factory.t.sol` - Tests for UniswapV3Factory

## Running Tests

```bash
forge test
```

To run a specific test file:
```bash
forge test --match-path test-foundry/BitMath.t.sol
```

To run with verbose output:
```bash
forge test -vvv
```

## Notes

- Some complex pool tests have been simplified compared to the original TypeScript versions
- Gas snapshot tests emit gas costs during execution
