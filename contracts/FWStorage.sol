// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";

import "./Contants.sol";
import "./FWArmourDatatypes.sol";
import "./FWStockController.sol";
import "./FWRandomAllocator.sol";
import "./FWStakeParts.sol";

import "./FWWarriorCollection.sol";
import "./FWRewards.sol";

import "./lib/FWArmourLib.sol";


// This contract is a bridge between Stock Controller
// and Minting Contract
// Also provision for Armour Market place
contract FWStorage is FWRandomAllocator {
    // Stake for a fixed period
    FWStakeParts private s_fwStakeParts;
    FWWarriorCollection private s_fwWarriorCollection;
    FWRewards private s_fWRewards; 

    // Constructor
    constructor(address vrfCoordinatorV2, 
    FWStockController fwStockController,
    FWStakeParts fwStakeParts,
    FWWarriorCollection fwWarriorCollection,
    FWRewards fWRewards,
    bytes32 gasLane,
    uint64 subscriptionId,
    uint32 callbackGasLimit
    ) FWRandomAllocator(vrfCoordinatorV2, 
    fwStockController,
    gasLane,
    subscriptionId,
    callbackGasLimit){
        // Any initialization if needed.
        s_fwStakeParts = fwStakeParts;
        s_fwWarriorCollection = fwWarriorCollection;
        s_fWRewards = fWRewards;
    }
    
    // Returns the Armour the user holds
    function myArmours() public view returns(FWArmourDatatypes.ArmourPart[] memory){
        return s_addressToArmourParts[msg.sender];
    }

    function stakeArmourPart(uint256 counterId) public {
        FWArmourDatatypes.ArmourPart storage armourPart = s_addressToArmourParts[msg.sender][counterId];
        require(armourPart.armourStatus == FWArmourDatatypes.ArmourPartStatus.owned,"You can stake parts that you own");

        s_fwStakeParts.stakeToUpgrade(counterId,armourPart.elementType);        
        // Mark it as staked
        s_addressToArmourParts[msg.sender][counterId].armourStatus =  FWArmourDatatypes.ArmourPartStatus.staked;   
    }

    function unStakeArmourPart(uint256 counterId) public {
        FWArmourDatatypes.ArmourPart storage armourPart = s_addressToArmourParts[msg.sender][counterId];
        require(armourPart.armourStatus == FWArmourDatatypes.ArmourPartStatus.staked,"You part is not staked");
        FWArmourDatatypes.ElementType newElementType = s_fwStakeParts.unstake(counterId);    

        // Update the Element type
        s_addressToArmourParts[msg.sender][counterId].armourStatus = FWArmourDatatypes.ArmourPartStatus.owned;
        s_addressToArmourParts[msg.sender][counterId].elementType = newElementType;
    }

    function isUpgradable(uint256 counterId) public view returns(bool){
        return s_fwStakeParts.isUpgradable(counterId); 
    }


    function canMintWarrior() public view returns(bool){
        FWArmourDatatypes.ArmourPart[] memory armourParts = s_addressToArmourParts[msg.sender];
        for (uint i = 0; i < armourParts.length; i++) {
           require(armourParts[i].armourStatus == FWArmourDatatypes.ArmourPartStatus.owned,"You dont have parts ready to Mint");
        }
        return (armourParts.length == 6);// 6 Armours should exist
    }

    // User has to pay for Minting the Warrior
    function mintWarrior() public payable {
        require(canMintWarrior(),"You dont have parts to mint");
        FWArmourDatatypes.ArmourPart[] storage armourParts = s_addressToArmourParts[msg.sender];
        FWWarriorTypes.WarriorType warriorType = FWArmourLib.getWarriorToMint(armourParts);

        // Build the IPFS File location for WarriorType
        // Mint the warrior
        string memory uri= "";
        if(warriorType == FWWarriorTypes.WarriorType.Iron){
            // Assign the right Uri
        }
        s_fwWarriorCollection.safeMint(msg.sender,uri);
    }    

    function earnedRewards() external view returns(uint256[2] memory info){
        // Show what are the earnings of NFT holder since the last time he claimed
        // and pending to be claimed
    }

    function claimRewards() external {
        // Transfer Rewards to Holder of NFT
    }
}