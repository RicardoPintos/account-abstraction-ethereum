// SPDX-License-Identifier: MIT

pragma solidity 0.8.24;

import {IAccount} from "account-abstraction/contracts/interfaces/IAccount.sol";
import {PackedUserOperation} from "account-abstraction/contracts/interfaces/PackedUserOperation.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {IEntryPoint} from "account-abstraction/contracts/interfaces/IEntryPoint.sol";
import {SIG_VALIDATION_FAILED, SIG_VALIDATION_SUCCESS} from "account-abstraction/contracts/core/Helpers.sol";

/**
 * @title Minimal Account Ethereum
 * @author Ricardo Pintos
 * @notice This contract is a minimal implementation of the Account Abstraction specification. Is not intended to be used as a contract in production. It is designed for networks that work with Alt-Mempools and EntryPoint contracts. It supports paymasters and alternative signatures.
 */
contract MinimalAccount is IAccount, Ownable {
    //////////////
    /// Errors ///
    //////////////
    error MinimalAccount__NotFromEntryPoint();
    error MinimalAccount__NotFromEntryPointOrOwner();
    error MinimalAccount__CallFailed(bytes);
    error MinimalAccount__EmptyMissingAccountFunds();

    ///////////////////////
    /// State Variables ///
    ///////////////////////
    IEntryPoint private immutable i_entryPoint;

    /////////////////
    /// Modifiers ///
    /////////////////
    modifier requireFromEntryPoint() {
        if (msg.sender != address(i_entryPoint)) {
            revert MinimalAccount__NotFromEntryPoint();
        }
        _;
    }

    modifier requireFromEntryPointOrOwner() {
        if (msg.sender != address(i_entryPoint) && msg.sender != owner()) {
            revert MinimalAccount__NotFromEntryPointOrOwner();
        }
        _;
    }

    /////////////////
    /// Functions ///
    /////////////////
    constructor(address entryPoint) Ownable(msg.sender) {
        i_entryPoint = IEntryPoint(entryPoint);
    }

    receive() external payable {}

    //////////////////////////
    /// External Functions ///
    //////////////////////////
    /**
     * @param dest The destination contract
     * @param value The amount of ETH to send
     * @param functionData The abi encoded function data
     */
    function execute(address dest, uint256 value, bytes calldata functionData) external requireFromEntryPointOrOwner {
        (bool success, bytes memory result) = dest.call{value: value}(functionData);
        if (!success) {
            revert MinimalAccount__CallFailed(result);
        }
    }

    /**
     * @param userOp The user operation to validate.
     * @param userOpHash The hash of the user operation. It has to be converted to the correct format with the _toEthSignedMessageHash function.
     * @param missingAccountFunds Missing funds on the account's deposit in the entrypoint.
     * @notice This function is intended to be called by the EntryPoint contract.
     * @dev The signature is validated by the owner of the contract. When the owner changes the signature is validated by the new owner.
     */
    function validateUserOp(PackedUserOperation calldata userOp, bytes32 userOpHash, uint256 missingAccountFunds)
        external
        requireFromEntryPoint
        returns (uint256 validationData)
    {
        validationData = _validateSignature(userOp, userOpHash);
        _payPrefund(missingAccountFunds);
    }

    //////////////////////////
    /// Internal Functions ///
    //////////////////////////
    function _validateSignature(PackedUserOperation calldata userOp, bytes32 userOpHash)
        internal
        view
        returns (uint256 validationData)
    {
        bytes32 ethSignedMessageHash = MessageHashUtils.toEthSignedMessageHash(userOpHash);
        address signer = ECDSA.recover(ethSignedMessageHash, userOp.signature);
        if (signer != owner()) {
            return SIG_VALIDATION_FAILED;
        }
        return SIG_VALIDATION_SUCCESS;
    }

    /**
     * @param missingAccountFunds Missing funds on the account's deposit in the entrypoint.
     * @notice This function pays the entrypoint contract.
     */
    function _payPrefund(uint256 missingAccountFunds) internal {
        if (missingAccountFunds != 0) {
            (bool success,) = payable(msg.sender).call{value: missingAccountFunds, gas: type(uint256).max}("");
            (success);
        } else {
            revert MinimalAccount__EmptyMissingAccountFunds();
        }
    }

    ///////////////
    /// Getters ///
    ///////////////
    function getEntryPoint() external view returns (address) {
        return address(i_entryPoint);
    }
}
