// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./../FWArmourDatatypes.sol";
import "./../Contants.sol";
import "./../FWWarriorTypes.sol";

library FWArmourLib{
    function getWarriorToMint(FWArmourDatatypes.ArmourPart[] memory armourParts) public pure returns(FWWarriorTypes.WarriorType warriorType){
        uint256 totalScore;
        for(uint i =0; i < armourParts.length; i++){
            FWArmourDatatypes.ArmourPart memory part = armourParts[i];
            if(part.armourType == FWArmourDatatypes.ArmourType.Head){
                if(part.elementType == FWArmourDatatypes.ElementType.Iron){
                    totalScore = totalScore + (Constants.HEAD_SCORE * Constants.IRON_SCORE);
                }
                if(part.elementType == FWArmourDatatypes.ElementType.Bronze){
                    totalScore = totalScore + (Constants.HEAD_SCORE * Constants.BRONZE_SCORE);
                }
                if(part.elementType == FWArmourDatatypes.ElementType.Silver){
                    totalScore = totalScore + (Constants.HEAD_SCORE * Constants.SILVER_SCORE);
                }
                if(part.elementType == FWArmourDatatypes.ElementType.Gold){
                    totalScore = totalScore + (Constants.HEAD_SCORE * Constants.GOLD_SCORE);
                }
                 if(part.elementType == FWArmourDatatypes.ElementType.Titanium){
                    totalScore = totalScore + (Constants.HEAD_SCORE * Constants.TITANIUM_SCORE);
                }
            }     

             if(part.armourType == FWArmourDatatypes.ArmourType.Body){
                if(part.elementType == FWArmourDatatypes.ElementType.Iron){
                    totalScore = totalScore + (Constants.BODY_SCORE * Constants.IRON_SCORE);
                }
                if(part.elementType == FWArmourDatatypes.ElementType.Bronze){
                    totalScore = totalScore + (Constants.BODY_SCORE * Constants.BRONZE_SCORE);
                }
                if(part.elementType == FWArmourDatatypes.ElementType.Silver){
                    totalScore = totalScore + (Constants.BODY_SCORE * Constants.SILVER_SCORE);
                }
                if(part.elementType == FWArmourDatatypes.ElementType.Gold){
                    totalScore = totalScore + (Constants.BODY_SCORE * Constants.GOLD_SCORE);
                }
                 if(part.elementType == FWArmourDatatypes.ElementType.Titanium){
                    totalScore = totalScore + (Constants.BODY_SCORE * Constants.TITANIUM_SCORE);
                }
            }     

            if(part.armourType == FWArmourDatatypes.ArmourType.LeftHand){
                if(part.elementType == FWArmourDatatypes.ElementType.Iron){
                    totalScore = totalScore + (Constants.LEFTHAND_SCORE * Constants.IRON_SCORE);
                }
                if(part.elementType == FWArmourDatatypes.ElementType.Bronze){
                    totalScore = totalScore + (Constants.LEFTHAND_SCORE * Constants.BRONZE_SCORE);
                }
                if(part.elementType == FWArmourDatatypes.ElementType.Silver){
                    totalScore = totalScore + (Constants.LEFTHAND_SCORE * Constants.SILVER_SCORE);
                }
                if(part.elementType == FWArmourDatatypes.ElementType.Gold){
                    totalScore = totalScore + (Constants.LEFTHAND_SCORE * Constants.GOLD_SCORE);
                }
                 if(part.elementType == FWArmourDatatypes.ElementType.Titanium){
                    totalScore = totalScore + (Constants.LEFTHAND_SCORE * Constants.TITANIUM_SCORE);
                }
            }  

            if(part.armourType == FWArmourDatatypes.ArmourType.RightHand){
                if(part.elementType == FWArmourDatatypes.ElementType.Iron){
                    totalScore = totalScore + (Constants.RIGHTHAND_SCORE * Constants.IRON_SCORE);
                }
                if(part.elementType == FWArmourDatatypes.ElementType.Bronze){
                    totalScore = totalScore + (Constants.RIGHTHAND_SCORE * Constants.BRONZE_SCORE);
                }
                if(part.elementType == FWArmourDatatypes.ElementType.Silver){
                    totalScore = totalScore + (Constants.RIGHTHAND_SCORE * Constants.SILVER_SCORE);
                }
                if(part.elementType == FWArmourDatatypes.ElementType.Gold){
                    totalScore = totalScore + (Constants.RIGHTHAND_SCORE * Constants.GOLD_SCORE);
                }
                 if(part.elementType == FWArmourDatatypes.ElementType.Titanium){
                    totalScore = totalScore + (Constants.RIGHTHAND_SCORE * Constants.TITANIUM_SCORE);
                }
            }    

            if(part.armourType == FWArmourDatatypes.ArmourType.RightLeg){
                if(part.elementType == FWArmourDatatypes.ElementType.Iron){
                    totalScore = totalScore + (Constants.RIGHTLEG_SCORE * Constants.IRON_SCORE);
                }
                if(part.elementType == FWArmourDatatypes.ElementType.Bronze){
                    totalScore = totalScore + (Constants.RIGHTLEG_SCORE * Constants.BRONZE_SCORE);
                }
                if(part.elementType == FWArmourDatatypes.ElementType.Silver){
                    totalScore = totalScore + (Constants.RIGHTLEG_SCORE * Constants.SILVER_SCORE);
                }
                if(part.elementType == FWArmourDatatypes.ElementType.Gold){
                    totalScore = totalScore + (Constants.RIGHTLEG_SCORE * Constants.GOLD_SCORE);
                }
                 if(part.elementType == FWArmourDatatypes.ElementType.Titanium){
                    totalScore = totalScore + (Constants.RIGHTLEG_SCORE * Constants.TITANIUM_SCORE);
                }
            }  

            if(part.armourType == FWArmourDatatypes.ArmourType.LeftLeg){
                if(part.elementType == FWArmourDatatypes.ElementType.Iron){
                    totalScore = totalScore + (Constants.LEFTLEG_SCORE * Constants.IRON_SCORE);
                }
                if(part.elementType == FWArmourDatatypes.ElementType.Bronze){
                    totalScore = totalScore + (Constants.LEFTLEG_SCORE * Constants.BRONZE_SCORE);
                }
                if(part.elementType == FWArmourDatatypes.ElementType.Silver){
                    totalScore = totalScore + (Constants.LEFTLEG_SCORE * Constants.SILVER_SCORE);
                }
                if(part.elementType == FWArmourDatatypes.ElementType.Gold){
                    totalScore = totalScore + (Constants.LEFTLEG_SCORE * Constants.GOLD_SCORE);
                }
                 if(part.elementType == FWArmourDatatypes.ElementType.Titanium){
                    totalScore = totalScore + (Constants.LEFTLEG_SCORE * Constants.TITANIUM_SCORE);
                }
            }  
        } 

        if(totalScore <= Constants.IRON_WARRIOR) {
             warriorType = FWWarriorTypes.WarriorType.Iron;
        }
        else if(totalScore > Constants.IRON_WARRIOR && totalScore < Constants.BRONZE_WARRIOR){
            warriorType = FWWarriorTypes.WarriorType.Bronze;
        }
        else if(totalScore > Constants.BRONZE_WARRIOR && totalScore < Constants.SILVER_WARRIOR){
            warriorType = FWWarriorTypes.WarriorType.Silver;
        }
          else if(totalScore > Constants.SILVER_WARRIOR && totalScore < Constants.GOLD_WARRIOR){
            warriorType = FWWarriorTypes.WarriorType.Gold;
        }
        else if(totalScore > Constants.GOLD_WARRIOR ){
            warriorType = FWWarriorTypes.WarriorType.Titanium;
        }
    }
}
