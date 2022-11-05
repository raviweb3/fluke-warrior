// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

library FWArmourDatatypes {
    // Represents the type of Metal the Armour is made of
    enum ElementType{        
        Iron,
        Bronze,
        Silver,
        Gold,      
        Titanium
    }

    // Represents the type of parts that can be individually Minted    
    enum ArmourType{
        Head,
        Body,
        LeftHand,
        RightHand,
        LeftLeg,
        RightLeg
    }

    enum ArmourPartStatus{
        owned,
        staked,
        burnt
    }

    // Armour for each part
    struct ArmourPart{
        address owner;
        uint256 allocatedTime;
        uint256 counterId;
        ArmourType armourType;
        ElementType elementType;
        ArmourPartStatus armourStatus;
    }
}