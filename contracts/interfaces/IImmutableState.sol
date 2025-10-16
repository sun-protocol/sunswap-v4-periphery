// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IVault} from "infinity-core/src/interfaces/IVault.sol";

/// @title IImmutableState
/// @notice Interface for the ImmutableState contract
interface IImmutableState {
    /// @notice The SunSwap V4 poolManager
    function vault() external view returns (IVault);
}
