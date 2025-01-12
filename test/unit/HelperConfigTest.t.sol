// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {Test, console} from "forge-std/Test.sol";
import {MinimalAccount} from "src/MinimalAccount.sol";
import {DeployMinimal} from "script/DeployMinimal.s.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import {SendPackedUserOp, PackedUserOperation} from "script/SendPackedUserOp.s.sol";
import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import {IEntryPoint} from "account-abstraction/contracts/interfaces/IEntryPoint.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract HelperConfigTest is Test {
    error HelperConfig__InvalidChainId();

    DeployMinimal deployMinimal;
    HelperConfig helperConfig;
    MinimalAccount minimalAccount;
    ERC20Mock usdc;
    SendPackedUserOp sendPackedUserOp;

    function setUp() public {}

    function testDeployRun() public {
        deployMinimal = new DeployMinimal();
        deployMinimal.run();
    }

    function testGetConfigMainnet() public {
        deployMinimal = new DeployMinimal();
        vm.chainId(1);
        (helperConfig, minimalAccount) = deployMinimal.deployMinimalAccount();
        HelperConfig.NetworkConfig memory config = helperConfig.getEthMainnetConfig();
        assertEq(config.entryPoint, 0x0000000071727De22E5E9d8BAf0edAc6f37da032);
    }

    function testGetConfigSepolia() public {
        deployMinimal = new DeployMinimal();
        vm.chainId(11155111);
        (helperConfig, minimalAccount) = deployMinimal.deployMinimalAccount();
        HelperConfig.NetworkConfig memory config = helperConfig.getEthSepoliaConfig();
        assertEq(config.entryPoint, 0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789);
    }

    function testGetConfigArbitrum() public {
        deployMinimal = new DeployMinimal();
        vm.chainId(42161);
        (helperConfig, minimalAccount) = deployMinimal.deployMinimalAccount();
        HelperConfig.NetworkConfig memory config = helperConfig.getArbMainnetConfig();
        assertEq(config.entryPoint, 0x0000000071727De22E5E9d8BAf0edAc6f37da032);
    }

    function testAnvilConfigAlreadyDeployed() public {
        deployMinimal = new DeployMinimal();
        (helperConfig, minimalAccount) = deployMinimal.deployMinimalAccount();
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        assert(config.entryPoint != address(0));
        helperConfig.getOrCreateAnvilEthConfig();
        assert(config.entryPoint != address(0));
    }

    function testInvalidChainId() public {
        deployMinimal = new DeployMinimal();
        (helperConfig, minimalAccount) = deployMinimal.deployMinimalAccount();
        vm.chainId(123);
        vm.expectRevert(HelperConfig__InvalidChainId.selector);
        helperConfig.getConfig();
    }
}
