// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

library Constants {
    uint constant MAX_SUPPLY = 10000;

    // Score by Element
    uint constant IRON_SCORE = 1;
    uint constant BRONZE_SCORE = 2;
    uint constant SILVER_SCORE = 3;
    uint constant GOLD_SCORE = 4;
    uint constant TITANIUM_SCORE = 5;

    // Score by Armour
    uint constant HEAD_SCORE = 5;
    uint constant BODY_SCORE = 4;
    uint constant LEFTHAND_SCORE = 1;
    uint constant RIGHTHAND_SCORE = 2;
    uint constant LEFTLEG_SCORE = 1;
    uint constant RIGHTLEG_SCORE = 2;
    
    uint constant SCORE_INCREMENT = 1 days;

    uint constant IRON_WARRIOR = 15;
    uint constant BRONZE_WARRIOR = 30;
    uint constant SILVER_WARRIOR = 45;
    uint constant GOLD_WARRIOR = 60;
    uint constant TITANIUM_WARRIOR = 75;    
}