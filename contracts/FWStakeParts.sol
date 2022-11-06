// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./FWArmourDatatypes.sol";

// You can lock the FW Armour part for a predefined window and they will qualify for Upgrade.
contract FWStakeParts is Ownable {
    struct Stake {
        uint256 counterId;
        uint256 stakedAtTimeStamp;
        FWArmourDatatypes.ElementType elementType;
    }

     mapping(uint256 => Stake) public stakedParts;

    function stakeToUpgrade(uint256 counterId, FWArmourDatatypes.ElementType elementType) public {
        require(stakedParts[counterId].counterId == 0,"Part is already Staked");
        require(elementType!= FWArmourDatatypes.ElementType.Titanium,"Staking will not earn any more score");            
        stakedParts[counterId] = Stake(counterId,block.timestamp,elementType);
    }

    function isUpgradable(uint256 counterId) public pure returns(bool){
        // pending implementation
        return true;
    }

    function unstake(uint256 counterId) public returns(FWArmourDatatypes.ElementType){
        require(stakedParts[counterId].counterId != 0,"Part should be Staked");
        // (block.timestamp - stakedAtTimeStamp)/ 1 days;
        FWArmourDatatypes.ElementType newElementType;
        uint stakedTime = (block.timestamp - stakedParts[counterId].stakedAtTimeStamp)/ 1 days;  

        require(stakedTime > 30,"You cannot unstake it before 30 days");
        
        if(stakedParts[counterId].elementType == FWArmourDatatypes.ElementType.Iron){
            newElementType = FWArmourDatatypes.ElementType.Bronze;
            delete stakedParts[counterId];
        }
        else if(stakedParts[counterId].elementType == FWArmourDatatypes.ElementType.Bronze){
            newElementType = FWArmourDatatypes.ElementType.Silver;
            delete stakedParts[counterId];
        }
        else if(stakedParts[counterId].elementType == FWArmourDatatypes.ElementType.Silver){
            newElementType = FWArmourDatatypes.ElementType.Gold;
            delete stakedParts[counterId];
        }
        else if(stakedParts[counterId].elementType == FWArmourDatatypes.ElementType.Gold){
            newElementType = FWArmourDatatypes.ElementType.Titanium;
            delete stakedParts[counterId];
        }
        return newElementType;
    }
}