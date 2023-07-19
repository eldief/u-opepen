// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {UniversalOpepenRenderer} from "../src/UniversalOpepenRenderer.sol";
import {UnversalOpepen} from "../src/UnversalOpepen.sol";

// forge script ./script/Deploy.s.sol:UniversalOpepenDeployScript -vvvv --broadcast --verify --rpc-url ${GOERLI_RPC_URL}
// forge script ./script/Deploy.s.sol:UniversalOpepenDeployScript -vvvv --broadcast --verify --rpc-url ${MAINNET_RPC_URL}
contract UniversalOpepenDeployScript is Script {
    function setUp() public {}

    function run() public {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(pk);

        UniversalOpepenRenderer renderer = new UniversalOpepenRenderer();
        console.log("UniversalOpepenRenderer:", address(renderer));
        UnversalOpepen uOpepen = new UnversalOpepen(address(renderer));
        console.log("UnversalOpepen:", address(uOpepen));

        vm.stopBroadcast();
    }
}
