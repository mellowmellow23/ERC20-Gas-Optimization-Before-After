// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {BeforeERC20} from "../src/before/BeforeERC20.sol";

contract DeployBefore is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        uint256 initialSupply = 1_000_000 ether;

        vm.startBroadcast(deployerKey);
        new BeforeERC20(initialSupply);
        vm.stopBroadcast();
    }
}
