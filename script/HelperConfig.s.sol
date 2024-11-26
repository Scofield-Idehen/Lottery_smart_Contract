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
            entrancefee : 0.01 ether,
            interval: 30,
            vrfcoodinator: ,
            gasLane:  ,
            subscriptionId: 0,
            cllbackGasLimit: 50000 

        });
    }



}