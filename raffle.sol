//SPDX-License-Identifier: MIT 
pragma solidity ^0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts@1.2.0/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";

/**
 * @title A simple raffle contract
 * @author scofield Blackspider
 * @notice creating a raffle contract
 * @dev implements chainlink VRFv2.3
 */

 error Raffle__NotEnoughETH();


contract raffle{

    /** Errors */
     error Rafle__NotEnoughETH();

    uint256 private immutable i_entrancefee;
    // intervals betwen thecdurations of lottery in secs
    uint256 private immutable i_interval;
    address payable[] private s_players;
    uint256 private s_lastTimestamp;

    /** Evenrts */

    events Raffledentered (address indexed players); 

    //this set an entrace fee to enter the raffle contract
    constructor(uint256 entrancefee, uint intervals){
        i_entrancefee = entrancefee;
        i_interval = intervals;
        s_lastTimestamp = block.timestamp;
    }
    function enterraffle()external payable{
        //previouse method but not gas efficient!!!
        // require(msg.value == i_entrancefee);
        if(msg.value < i_entrancefee){
            revert Raffle__NotEnoughETH();
        }
        s_players.push(payable(msg.sender));
        //makes migrationn easier 
        emit Raffledentered(msg.sender);

    }

    //get a random number of players
    function pickWinner()external{
        if (block.timestamp - s_lastTimestamp) > i_interval;{
            revert();
        }
        s_requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: keyHash,
                subId: s_subscriptionId,
                requestConfirmations: requestConfirmations,
                callbackGasLimit: callbackGasLimit,
                numWords: numWords,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({nativePayment: false})
                )
            })
        );
        //get a random number from chainlinkVRF 2.5
    }

    function getentracefee() external view returns (uint256){
        return i_entrancefee;
    }
}