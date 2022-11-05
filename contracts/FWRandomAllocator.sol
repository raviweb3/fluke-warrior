// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";

import "./Contants.sol";
import "./FWArmourDatatypes.sol";
import "./FWStockController.sol";

// This contract is a bridge between Stock Controller
// and Minting Contract
// Also provision for Armour Market place
contract FWRandomAllocator is VRFConsumerBaseV2 {
    // Generate and allocate Random Armour type
    // Based on type, the warrior strength/Importance will vary    
    FWStockController internal s_fwStockController;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;

    bytes32 private immutable i_gasLane;
    uint64 private immutable i_subscriptionId;
    uint16 private constant REQUEST_CONFIRMATION = 3;
    uint32 private immutable i_callbackGasLimit;
    uint32 private constant NUM_WORDS = 1;
    
    // Tracking the request
    struct ArmourRequest{
        address requestor;
        FWArmourDatatypes.ArmourType armourType;        
    }
    mapping (uint => ArmourRequest) private s_vrfRequestIdToArmourRequest;

    // Allocated Parts to Users
    mapping (address => FWArmourDatatypes.ArmourPart[]) internal s_addressToArmourParts;

    // Event on Armour Part Allocation
    event ArmourAlloted(address indexed owner, FWArmourDatatypes.ArmourType indexed armourType, FWArmourDatatypes.ElementType indexed elementType);

    // Constructor
    constructor(address vrfCoordinatorV2, 
    FWStockController fwStockController,
    bytes32 gasLane,
    uint64 subscriptionId,
    uint32 callbackGasLimit

    ) VRFConsumerBaseV2(vrfCoordinatorV2){
        i_vrfCoordinator =  VRFCoordinatorV2Interface(vrfCoordinatorV2);
        s_fwStockController = fwStockController;
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
    }

    // VRF Chain Link
    function requestRandomNumber(address requestor, FWArmourDatatypes.ArmourType armourType) internal {
        // Request a Random number
        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane,
            i_subscriptionId,
            REQUEST_CONFIRMATION,
            i_callbackGasLimit,
            NUM_WORDS
        );
        // Record the request Submitted to VRF Chain Link
        s_vrfRequestIdToArmourRequest[requestId] = ArmourRequest(requestor,armourType);
    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        // call back from ChainLink
        uint256 elementIndex = randomWords[0] % 4;
        ArmourRequest memory armourRequest = s_vrfRequestIdToArmourRequest[requestId];
        FWArmourDatatypes.ElementType elementType =  FWArmourDatatypes.ElementType(elementIndex);
        
        // Record Allocation of Armour Type
        s_fwStockController.assignArmourPart(armourRequest.requestor,armourRequest.armourType);
        FWArmourDatatypes.ArmourPart[] storage armourParts = s_addressToArmourParts[armourRequest.requestor];
        armourParts.push(FWArmourDatatypes.ArmourPart(armourRequest.requestor, block.timestamp, requestId,armourRequest.armourType,elementType, FWArmourDatatypes.ArmourPartStatus.owned));

        // Notify Front end
        emit ArmourAlloted(armourRequest.requestor, armourRequest.armourType,elementType);
    }

    function requestPart(FWArmourDatatypes.ArmourType armourType) internal {
        if(s_fwStockController.isAvailable(armourType)){
            // Whitelist the caller
            s_fwStockController.whiteList(msg.sender);
            // Requested Part is available for Allocation
            // and we can whitelist the requestor
            requestRandomNumber(msg.sender, armourType);
        }
    }
}