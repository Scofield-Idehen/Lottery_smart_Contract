//SPDX-License-Identifier: MIT 
pragma solidity ^0.8.19;
import {Script} from "forge-std/Script.sol";
import {VRFCoordinatorV2_Mock} from "chainlink/contracts/src/v0.8/vrf/mocks/VRFCoordinatorV2_Mock.sol";

abstract contract CodeConstants{
    uint256 public constant ETH_SAPOLIA_CHAIN_ID = 11155111;
    uint256 public constant LOCAL_CHAIN_ID = 31337;
}


contract HelperConfig is Script{
    error HelperConfig__InvalidCHAIN_ID;

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
        networkConfigs[ETH_SAPOLIA_CHAIN_ID] = getSapolia();
    }

    function getConfigByChainId(uint256 chainId) public view returns(networkConfig memory){
        if(networksConfigs[chainId].vrfCoordinator != address(0)){
            return networkConfigs[chainId]
        }else if (chainId = LOCAL_CHAIN_ID){
            return getCreateAnvilETHconfig()
        }else {
            revert HelperConfig__InvalidCHAIN_ID()
        }
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
    function getCreateAnvilETHconfig() public returns (NetworkConfig memory){
        if (localNetworkConfig.vrfcoodinator != address(0)){
            return localNetworkConfig;
        }

        vm.startBroadcast();
        VRFCoodinatorV2_5Mock vrfCoodinatorMock = new VRFCoodinatorV2_5Mock(MOCK_BASE)
        vm.stopBroadcast();
    }



}