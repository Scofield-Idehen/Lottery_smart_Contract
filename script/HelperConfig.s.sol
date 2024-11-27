//SPDX-License-Identifier: MIT 
pragma solidity ^0.8.19;
import {Script} from "forge-std/Script.sol";


contract HelperConfig is Script{
    struct NetworkConfig {
        uint256 entrancefee,
        uint256 interval,
        address vrfcoordinator,
        bytes32 gasLane,
        uint256 subscriptionId,
        uint32 callbackGasLimit
    }
    NetworkConfig public localNetworkConfig;
    mapping (uint256 chainId => NetworkConfig) public networkConfigs;

    constructor () {
        
    }

    function getSapolia() public view returns (Networkconfig memory){
        return NetworkConfig({
            entrancefee : 0.01 ether, //1e16
            interval: 30, //30 seconds 
            vrfcoodinator: 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B,
            gasLane: 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae ,
            subscriptionId: 0,
            cllbackGasLimit: 50000 

        });
    }



}