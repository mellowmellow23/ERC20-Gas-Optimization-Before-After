// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/after/AfterERC20.sol";

contract DeployAfter is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        uint256 initialSupply = 1_000_000 ether;

        vm.startBroadcast(deployerKey);
        new AfterERC20(initialSupply);
        vm.stopBroadcast();
    }
}