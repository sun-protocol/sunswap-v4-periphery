// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2024 PancakeSwap
pragma solidity 0.8.26;

import {ICLPoolManager} from "v4-core/src/interfaces/ICLPoolManager.sol";
import {PoolId} from "v4-core/src/types/PoolId.sol";
import {Tick} from "v4-core/src/libraries/Tick.sol";
import {CLPosition} from "v4-core/src/libraries/CLPosition.sol";
import {FullMath} from "v4-core/src/libraries/FullMath.sol";
import {FixedPoint128} from "v4-core/src/libraries/FixedPoint128.sol";

/// @notice Helper contract to get the LP fees for a given position
/// @dev warning: the value calculated through this contract might not exactly match the actual value received due to the potential charge from hooks contract
contract CLLPFeesHelper {
    /// @notice Get the LP fees for a given position
    /// @param poolManager The address of pool manager
    /// @param id The pool id
    /// @param owner The owner of the position, for positions held by CLPositionManager, it should be the CLPositionManager address
    /// @param tickLower The lower tick of the position
    /// @param tickUpper The upper tick of the position
    /// @param salt The salt of the position, for positions created by CLPositionManager, it should be the corresponding NFT id
    /// @return feesOwed0 The lp fees owed to the owner of the position in token0
    /// @return feesOwed1 The lp fees owed to the owner of the position in token1
    function getLPFees(
        ICLPoolManager poolManager,
        PoolId id,
        address owner,
        int24 tickLower,
        int24 tickUpper,
        bytes32 salt
    ) external view returns (uint256 feesOwed0, uint256 feesOwed1) {
        (, int24 tickCurrent,,) = poolManager.getSlot0(id);
        Tick.Info memory lower = poolManager.getPoolTickInfo(id, tickLower);
        Tick.Info memory upper = poolManager.getPoolTickInfo(id, tickUpper);

        (uint256 feeGrowthGlobal0X128, uint256 feeGrowthGlobal1X128) = poolManager.getFeeGrowthGlobals(id);

        // calculate fee growth below
        uint256 feeGrowthBelow0X128;
        uint256 feeGrowthBelow1X128;
        unchecked {
            if (tickCurrent >= tickLower) {
                feeGrowthBelow0X128 = lower.feeGrowthOutside0X128;
                feeGrowthBelow1X128 = lower.feeGrowthOutside1X128;
            } else {
                feeGrowthBelow0X128 = feeGrowthGlobal0X128 - lower.feeGrowthOutside0X128;
                feeGrowthBelow1X128 = feeGrowthGlobal1X128 - lower.feeGrowthOutside1X128;
            }

            // calculate fee growth above
            uint256 feeGrowthAbove0X128;
            uint256 feeGrowthAbove1X128;
            if (tickCurrent < tickUpper) {
                feeGrowthAbove0X128 = upper.feeGrowthOutside0X128;
                feeGrowthAbove1X128 = upper.feeGrowthOutside1X128;
            } else {
                feeGrowthAbove0X128 = feeGrowthGlobal0X128 - upper.feeGrowthOutside0X128;
                feeGrowthAbove1X128 = feeGrowthGlobal1X128 - upper.feeGrowthOutside1X128;
            }

            uint256 feeGrowthInside0X128 = feeGrowthGlobal0X128 - feeGrowthBelow0X128 - feeGrowthAbove0X128;
            uint256 feeGrowthInside1X128 = feeGrowthGlobal1X128 - feeGrowthBelow1X128 - feeGrowthAbove1X128;

            CLPosition.Info memory position = poolManager.getPosition(id, owner, tickLower, tickUpper, salt);

            ///@dev Tho overflow is expected, it's technically possible users can lose their rewards if it hits type(uint128).max
            feesOwed0 = FullMath.mulDiv(
                feeGrowthInside0X128 - position.feeGrowthInside0LastX128, position.liquidity, FixedPoint128.Q128
            );
            feesOwed1 = FullMath.mulDiv(
                feeGrowthInside1X128 - position.feeGrowthInside1LastX128, position.liquidity, FixedPoint128.Q128
            );
        }
    }
}