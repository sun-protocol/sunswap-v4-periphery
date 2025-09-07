// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {PoolKey} from "infinity-core/src/types/PoolKey.sol";
import {Currency} from "infinity-core/src/types/Currency.sol";
import {IHooks} from "infinity-core/src/interfaces/IHooks.sol";
import {IPoolManager} from "infinity-core/src/interfaces/IPoolManager.sol";
import {ICLPoolManager} from "infinity-core/src/interfaces/ICLPoolManager.sol";
import {IAllowanceTransfer} from "permit2/src/interfaces/IAllowanceTransfer.sol";
import {ICLMigrator,IBaseMigrator} from "../../src/pool-cl/interfaces/ICLMigrator.sol";

/// @title MockReentrantPositionManager
/// @notice This contract is used to test reentrancy in PositionManager
/// @dev Can add more reentrant types if needed
contract MockReentrantPositionManager is Test {
    ICLMigrator public clMigrator;
    IAllowanceTransfer public immutable permit2;

    // CLMigrator need to query this in constructor
    ICLPoolManager public clPoolManager;

    enum ReentrantType {
        CLMigrateFromV3,
        CLMigrateFromV2
    }

    ReentrantType public reentrantType;

    constructor(IAllowanceTransfer _permit2) {
        permit2 = _permit2;
    }

    // need to set clMigrator after clMigrator is deployed
    function setCLMigrator(ICLMigrator _migrator) external {
        clMigrator = _migrator;
    }

    // need to set clPoolManager after MockReentrantPositionManager is deployed
    function setCLPoolMnager(ICLPoolManager _clPoolManager) external {
        clPoolManager = _clPoolManager;
    }

    function setRenentrantType(ReentrantType _type) external {
        reentrantType = _type;
    }

    function modifyLiquidities(bytes calldata, uint256) external payable {

        ICLMigrator.InfiCLPoolParams memory infiCLPoolParams = _generateMockInfiCLPoolParams();

        IBaseMigrator.V3PoolParams memory v3PoolParams = _generateMockV3PoolParams();

        IBaseMigrator.V2PoolParams memory v2PoolParams = _generateMockV2PoolParams();
        // Mock data can fulfill the requirement because it will trigger ContractLocked revert before any operations are executed
        if (reentrantType == ReentrantType.CLMigrateFromV2) {
            clMigrator.migrateFromV2(v2PoolParams, infiCLPoolParams, 0, 0);
        } else if (reentrantType == ReentrantType.CLMigrateFromV3) {
            clMigrator.migrateFromV3(v3PoolParams, infiCLPoolParams, 0, 0);
        }
    }

    function _generateMockPoolKey() internal returns (PoolKey memory) {
        return PoolKey({
            currency0: Currency.wrap(makeAddr("currency0")),
            currency1: Currency.wrap(makeAddr("currency1")),
            hooks: IHooks(makeAddr("hook")),
            fee: 100,
            parameters: hex"1022"
        });
    }

    function _generateMockInfiCLPoolParams() internal returns (ICLMigrator.InfiCLPoolParams memory) {
        return ICLMigrator.InfiCLPoolParams({
            poolKey: _generateMockPoolKey(),
            tickLower: 0,
            tickUpper: 0,
            liquidityMin: 0,
            recipient: address(0),
            deadline: 0,
            hookData: new bytes(0)
        });
    }

    function _generateMockV3PoolParams() internal pure returns (IBaseMigrator.V3PoolParams memory) {
        return IBaseMigrator.V3PoolParams({
            nfp: address(0),
            tokenId: 0,
            liquidity: 0,
            amount0Min: 0,
            amount1Min: 0,
            collectFee: false,
            deadline: 0
        });
    }

    function _generateMockV2PoolParams() internal pure returns (IBaseMigrator.V2PoolParams memory) {
        return IBaseMigrator.V2PoolParams({pair: address(0), migrateAmount: 0, amount0Min: 0, amount1Min: 0});
    }
}
