// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./FWArmourDatatypes.sol";
import "./Contants.sol";


// Manages the total Supply of Armour Parts
contract FWStockController is Ownable {
    using Counters for Counters.Counter;

    // Track Each Body Part
    Counters.Counter private s_headCounter;
    Counters.Counter private s_bodyCounter;
    Counters.Counter private s_leftHandCounter;
    Counters.Counter private s_rightHandCounter;
    Counters.Counter private s_leftLegCounter;
    Counters.Counter private s_rightLegCounter;

    // Quick and easy access to available Armour parts
    mapping(FWArmourDatatypes.ArmourType => Counters.Counter) private s_armourToCounter;

    // Only 10000 is the max supply for each part and hence
    // if one address mints a part, only that address can mint the remaining parts
    // We can let more then 10 as that will leave the Armour get distributed and 
    // we will have to create a marketplace for Parts instead of Full Armour
    struct PermittedAddress{
        uint counter;
        bool head;
        bool body;
        bool rightHand;
        bool leftHand;
        bool rightLeg;
        bool leftLeg;
    }
   
    Counters.Counter private s_permittedAddressCounter;

    // Only addresses with in the max supply can mint
    // Map of Unique Addresses allocated to ensure distribution
    // is managed
    mapping (address => PermittedAddress) private s_permittedAddresses;

    function isAvailable(FWArmourDatatypes.ArmourType _armourType) public view returns (bool){
        // check if we have supply for the armour
        require(s_armourToCounter[_armourType].current() < Constants.MAX_SUPPLY,"Sorry, we ran out of supply");
        return true;
    }

    function whiteList(address _owner) public onlyOwner{
         require(s_permittedAddressCounter.current() < Constants.MAX_SUPPLY,"Sorry, we ran out of supply");
         s_permittedAddresses[_owner] = PermittedAddress(s_permittedAddressCounter.current(),false,false,false,false,false,false);
         s_permittedAddressCounter.increment();
    }

    // Implement logic to Allocate Parts
    function assignArmourPart(address _owner,FWArmourDatatypes.ArmourType _armourType ) public onlyOwner {
       require(s_permittedAddresses[_owner].counter > 0,"Should be whitelisted first");
       PermittedAddress storage permittedAddress = s_permittedAddresses[_owner];

       if(_armourType == FWArmourDatatypes.ArmourType.Body){
         require(permittedAddress.body!=true,"You already minted Body");
         permittedAddress.body = true;
         s_bodyCounter.increment();
       }
       else if(_armourType == FWArmourDatatypes.ArmourType.Head){
         require(permittedAddress.head!=true,"You already minted Head");
         permittedAddress.head = true;
         s_headCounter.increment();
       }
       else if(_armourType == FWArmourDatatypes.ArmourType.RightHand){
         require(permittedAddress.rightHand!=true,"You already minted Right Hand");
         permittedAddress.rightHand = true;
         s_rightHandCounter.increment();
       }
       else if(_armourType == FWArmourDatatypes.ArmourType.LeftHand){
         require(permittedAddress.leftHand!=true,"You already minted Left Hand");
         permittedAddress.leftHand = true;
         s_leftHandCounter.increment();
       }
        else if(_armourType == FWArmourDatatypes.ArmourType.RightLeg){
         require(permittedAddress.rightLeg!=true,"You already minted Right Leg");
         permittedAddress.rightLeg = true;
         s_rightLegCounter.increment();
       }
       else if(_armourType == FWArmourDatatypes.ArmourType.LeftLeg){
         require(permittedAddress.leftLeg!=true,"You already minted Left Leg");
         permittedAddress.leftLeg = true;
         s_leftLegCounter.increment();
       }
    }
}