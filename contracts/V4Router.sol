// SPDX-License-Identifier: GPL-2.0-or-later
// Copyright (C) 2025 SunSwap
pragma solidity ^0.8.24;

import {IVault} from "v4-core/src/interfaces/IVault.sol";
import {ICLPoolManager} from "v4-core/src/interfaces/ICLPoolManager.sol";
import {Currency} from "v4-core/src/types/Currency.sol";
import {BipsLibrary} from "./libraries/BipsLibrary.sol";
import {CalldataDecoder} from "./libraries/CalldataDecoder.sol";
import {IV4Router} from "./interfaces/IV4Router.sol";
import {BaseActionsRouter} from "./base/BaseActionsRouter.sol";
import {DeltaResolver} from "./base/DeltaResolver.sol";
import {Actions} from "./libraries/Actions.sol";
import {CLCalldataDecoder} from "./pool-cl/libraries/CLCalldataDecoder.sol";
import {CLRouterBase} from "./pool-cl/CLRouterBase.sol";

/// @title V4Router
/// @notice Abstract contract that contains all internal logic needed for routing through Pancakeswap v4 pools
/// @dev the entry point to executing actions in this contract is calling `BaseActionsRouter._executeActions`
/// An inheriting contract should call _executeActions at the point that they wish actions to be executed
abstract contract V4Router is IV4Router, CLRouterBase, BaseActionsRouter {
    using BipsLibrary for uint256;
    using CalldataDecoder for bytes;
    using CLCalldataDecoder for bytes;

    constructor(IVault _vault, ICLPoolManager _clPoolManager) BaseActionsRouter(_vault) CLRouterBase(_clPoolManager) {}

    function _handleAction(uint256 action, bytes calldata params) internal override {
        // swap actions and payment actions in different blocks for gas efficiency
        if (action < Actions.SETTLE) {
            if (action == Actions.CL_SWAP_EXACT_IN) {
                IV4Router.CLSwapExactInputParams calldata swapParams = params.decodeCLSwapExactInParams();
                _swapExactInput(swapParams);
                return;
            } else if (action == Actions.CL_SWAP_EXACT_IN_SINGLE) {
                IV4Router.CLSwapExactInputSingleParams calldata swapParams = params.decodeCLSwapExactInSingleParams();
                _swapExactInputSingle(swapParams);
                return;
            } else if (action == Actions.CL_SWAP_EXACT_OUT) {
                IV4Router.CLSwapExactOutputParams calldata swapParams = params.decodeCLSwapExactOutParams();
                _swapExactOutput(swapParams);
                return;
            } else if (action == Actions.CL_SWAP_EXACT_OUT_SINGLE) {
                IV4Router.CLSwapExactOutputSingleParams calldata swapParams = params.decodeCLSwapExactOutSingleParams();
                _swapExactOutputSingle(swapParams);
                return;
            }
        } else {
            if (action == Actions.SETTLE_ALL) {
                (Currency currency, uint256 maxAmount) = params.decodeCurrencyAndUint256();
                uint256 amount = _getFullDebt(currency);
                if (amount > maxAmount) revert TooMuchRequested(maxAmount, amount);
                _settle(currency, msgSender(), amount);
                return;
            } else if (action == Actions.TAKE_ALL) {
                (Currency currency, uint256 minAmount) = params.decodeCurrencyAndUint256();
                uint256 amount = _getFullCredit(currency);
                if (amount < minAmount) revert TooLittleReceived(minAmount, amount);
                _take(currency, msgSender(), amount);
                return;
            } else if (action == Actions.SETTLE) {
                (Currency currency, uint256 amount, bool payerIsUser) = params.decodeCurrencyUint256AndBool();
                _settle(currency, _mapPayer(payerIsUser), _mapSettleAmount(amount, currency));
                return;
            } else if (action == Actions.TAKE) {
                (Currency currency, uint256 amount) = params.decodeCurrencyAndUint256();
                _take(currency, msgSender(), _mapTakeAmount(amount, currency));
                return;
            } else if (action == Actions.TAKE_PORTION) {
                (Currency currency, uint256 bips) = params.decodeCurrencyAndUint256();
                _take(currency, msgSender(), _getFullCredit(currency).calculatePortion(bips));
                return;
            }
        }
        revert UnsupportedAction(action);
    }
}
