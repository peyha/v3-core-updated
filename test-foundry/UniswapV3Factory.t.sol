// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./helpers/TestUtils.sol";
import "../contracts/UniswapV3Factory.sol";
import "../contracts/UniswapV3Pool.sol";

contract UniswapV3FactoryTest is TestUtils {
    UniswapV3Factory factory;
    address wallet;
    address other;

    address constant TEST_ADDRESS_0 = 0x1000000000000000000000000000000000000000;
    address constant TEST_ADDRESS_1 = 0x2000000000000000000000000000000000000000;

    event PoolCreated(
        address indexed token0,
        address indexed token1,
        uint24 indexed fee,
        int24 tickSpacing,
        address pool
    );
    event OwnerChanged(address indexed oldOwner, address indexed newOwner);
    event FeeAmountEnabled(uint24 indexed fee, int24 indexed tickSpacing);

    function setUp() public {
        wallet = address(this);
        other = address(0x1234);
        factory = new UniswapV3Factory();
    }

    function testOwnerIsDeployer() public {
        assertEq(factory.owner(), wallet);
    }

    function testInitialEnabledFeeAmounts() public {
        assertEq(factory.feeAmountTickSpacing(FEE_LOW), TICK_SPACING_LOW);
        assertEq(factory.feeAmountTickSpacing(FEE_MEDIUM), TICK_SPACING_MEDIUM);
        assertEq(factory.feeAmountTickSpacing(FEE_HIGH), TICK_SPACING_HIGH);
    }

    function testCreatePool_SucceedsForMediumFeePool() public {
        address pool = factory.createPool(TEST_ADDRESS_0, TEST_ADDRESS_1, FEE_MEDIUM);
        assertEq(factory.getPool(TEST_ADDRESS_0, TEST_ADDRESS_1, FEE_MEDIUM), pool);
        
        UniswapV3Pool poolContract = UniswapV3Pool(pool);
        assertEq(poolContract.factory(), address(factory));
        assertEq(poolContract.token0(), TEST_ADDRESS_0);
        assertEq(poolContract.token1(), TEST_ADDRESS_1);
        assertEq(poolContract.fee(), FEE_MEDIUM);
        assertEq(poolContract.tickSpacing(), TICK_SPACING_MEDIUM);
    }

    function testCreatePool_FailsIfTokenAEqualsTokenB() public {
        vm.expectRevert();
        factory.createPool(TEST_ADDRESS_0, TEST_ADDRESS_0, FEE_LOW);
    }

    function testCreatePool_FailsIfTokenIsZero() public {
        vm.expectRevert();
        factory.createPool(TEST_ADDRESS_0, address(0), FEE_LOW);
    }

    function testCreatePool_FailsIfFeeAmountIsNotEnabled() public {
        vm.expectRevert();
        factory.createPool(TEST_ADDRESS_0, TEST_ADDRESS_1, 250);
    }

    function testSetOwner_UpdatesOwner() public {
        factory.setOwner(other);
        assertEq(factory.owner(), other);
    }

    function testSetOwner_FailsIfCallerIsNotOwner() public {
        vm.prank(other);
        vm.expectRevert();
        factory.setOwner(wallet);
    }

    function testEnableFeeAmount_SetsFeeAmount() public {
        factory.enableFeeAmount(100, 5);
        assertEq(factory.feeAmountTickSpacing(100), 5);
    }

    function testEnableFeeAmount_FailsIfCallerIsNotOwner() public {
        vm.prank(other);
        vm.expectRevert();
        factory.enableFeeAmount(100, 2);
    }
}
