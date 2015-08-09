// :CATEGORY:HoverText
// :NAME:Floating_Name_Script
// :AUTHOR:Xylor Baysklef
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:324
// :NUM:433
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Floating Name Script By Xylor Baysklef.lsl
// :CODE:

//////////////////////////////
// Floating Name Script By Xylor Baysklef
//
// This script periodically updates
// the text above the object to 
// display the name of the object
///////////////////////////////

integer SIDE_TO_CHECK_COLOR = 0;

UpdateText() {
    vector RGB = llGetColor(SIDE_TO_CHECK_COLOR);
    
    // Rotate the Hue 180 degrees, and
    // invert the Luminance.
    RGB.x = 1.0 - RGB.x;
    RGB.y = 1.0 - RGB.y;
    RGB.z = 1.0 - RGB.z;

    llSetText(llGetObjectName(), RGB, 1.0);
}

default {
    state_entry() {
        UpdateText();
        // Update the text every 5 seconds.
        llSetTimerEvent(5.0);
    }
    
    changed(integer change) {
        if (change == CHANGED_COLOR) {
            UpdateText();
        }
    }
    
    timer() {
        UpdateText();
    }
}// END //
