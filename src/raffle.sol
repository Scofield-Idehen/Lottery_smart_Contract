//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";

import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

/**
 * @title A simple raffle contract
 * @author scofield Blackspider
 * @notice creating a raffle contract
 * @dev implements chainlink VRFv2.3
 */


contract Raffle is VRFConsumerBaseV2 {
    /**
     * Errors
     */
    error Raffle__NotEnoughETH();
    error Transfer__Failed();
    error Raffle__NotOPen()
    
    //Types Declarations
    enum RaffleState{
        OPEN,
        CLOSED
    }


    // state variables
    uint16 private constant REQUEST_CONFIRMATION = 3;
    uint16 private constant NUM_WORDS = 1;
    uint256 private immutable i_entrancefee;
    // intervals betwen thecdurations of lottery in secs
    uint256 private immutable i_interval;
    bytes32 private immutable i_keyHash;
    uint256 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;

    address payable[] private s_players;
    address [] private s_recentwinners;
    uint256 private s_lastTimestamp;

    RaffleState private s_raffleState;

    /**
     * Evenrts
     */
    event Raffledentered(address indexed players);
    event WinnerPicked(address indexed winners)

    //this set an entrace fee to enter the raffle contract
    constructor(
        uint256 entrancefee,
        uint256 interval,
        address vrfcoordinator,
        bytes32 gasLane,
        uint256 subscriptionId,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2(vrfcoordinator) {
        i_entrancefee = entrancefee;
        i_interval = interval;
        i_keyHash = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;

        s_lastTimestamp = block.timestamp;
        s_raffleState = RaffleState.OPEN;
       
    }

    function enterraffle() external payable {
        //previouse method but not gas efficient!!!
        // require(msg.value == i_entrancefee);
        if (msg.value < i_entrancefee) {
            revert Raffle__NotEnoughETH();
        }
        if(s_raffleState != RaffleState.OPEN) {
            revert Raffle__NotOPen();
        }
        s_players.push(payable(msg.sender));
        //makes migrationn easier
        emit Raffledentered(msg.sender);
    }

    //get a random number of players
    function pickWinner() external {
        if ((block.timestamp - s_lastTimestamp) > i_interval) {
            revert();
        }
        s_raffleState = RaffleState.CLOSED;
        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient.RandomWordsRequest({
            keyHash: i_keyHash,
            subId: i_subscriptionId,
            requestConfirmations: REQUEST_CONFIRMATION,
            callbackGasLimit: i_callbackGasLimit,
            numWords: NUM_WORDS,
            extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: false}))
        });
        uint256 s_requestId = s_vrfCoordinator.requestRandomWords(request);
        //get a random number from chainlinkVRF 2.5
    }

    function fulfillRandomWords(uint256 requestId, uint256[] calldata randomwords) internal override {
        uint indexwinner = randomeWords[0] % s_players.length;
        address payable recentwinners = s_players[indexwinner];
        s_recentwinners = recentwinners;
        s_raffleState = RaffleState.OPEN;
        
        s_players = new address[](0);
        s_lastTimestamp = block.timestamp;


        (bool success,) = recentwinners.call{value: address(this).balance}("");
        if(!success){
            revert Transfer__Failed();
        }
        emit winnerPicked(s_recentwinners);
    }

    function getentracefee() external view returns (uint256) {
        return i_entrancefee;
    }
}
