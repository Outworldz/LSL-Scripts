// :CATEGORY:Building
// :NAME:Side_Numbering
// :AUTHOR:Xylor Baysklef
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:02
// :ID:751
// :NUM:1034
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Side Numbering.lsl
// :CODE:

////////////////////////////////////////////
// Side Numbering Script
//
// Written by Xylor Baysklef
////////////////////////////////////////////

/////////////// CONSTANTS ///////////////////
key NUMBERS_TEXTURE = "fc8df679-ca1b-3ec9-c4ce-b1c832b5b5ce";
///////////// END CONSTANTS /////////////////

///////////// GLOBAL VARIABLES ///////////////
/////////// END GLOBAL VARIABLES /////////////

ShowNumber(integer num, integer face) {
    integer Row = num / 10;
    integer Col = num % 10;
    llOffsetTexture(-0.45 + 0.1 * Col, 0.45 - 0.1 * Row, face);
}

default {
    state_entry() {
        // Reset rotation, alpha, color and turn off animations.
        llRotateTexture(0.0, ALL_SIDES);
        llSetAlpha(1.0, ALL_SIDES);
        llSetColor(<1, 1, 1>, ALL_SIDES);
        llSetTextureAnim(FALSE, 0, 0, 0, 0, 0, 0);
        
        // Show the numbers texture.
        llSetTexture(NUMBERS_TEXTURE, ALL_SIDES);
        llScaleTexture(0.1, 0.1, ALL_SIDES);

        // Go through each side and show a number.
        integer i;
        for (i = 0; i < llGetNumberOfSides(); i++) {
            ShowNumber(i, i);
        }
    }
}
// END //
