// :CATEGORY:Floating Text
// :NAME:TypingName
// :AUTHOR:Xylor
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:08
// :ID:932
// :NUM:1338
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// TypingName.lsl
// :CODE:

1// remove this number for the script to work.

//////////////////////////////
// Floating Name Script
//
// This script periodically updates
// the text above the object to 
// display the name of the object
//
// Written by Xylor
///////////////////////////////

vector OVERRIDE_COLOR = <0, 1, 1>;  // Cyan
integer gUseOverride = FALSE;

integer SIDE_TO_CHECK_COLOR = 0;
string gFloatingText;
integer gStringPos;
integer gStringSize;

float gLetterDelayBase = 0.1;
float gLetterDelayVar  = 1;

float gLineRepeatDelayBase = 2.5;
float gLineRepeatDelayVar  = 1;

key gOwner;

UpdateText() {
    string ObjName =  llGetObjectName();
    if (ObjName != gFloatingText) {
        gFloatingText = ObjName;
        gStringPos = 0;
        gStringSize = llStringLength(gFloatingText);
    }
}

vector GetTextColor() {
    // Override color?
    if (gUseOverride)
        return OVERRIDE_COLOR;
        
    vector RGB = llGetColor(SIDE_TO_CHECK_COLOR);
    
    // Rotate the Hue 180 degrees, and
    // invert the Luminance.
    RGB.x = 1.0 - RGB.x;
    RGB.y = 1.0 - RGB.y;
    RGB.z = 1.0 - RGB.z;
    
    
    return RGB;
}

default {
    state_entry() {
        gOwner = llGetOwner();
        UpdateText();
        llSetTimerEvent(0.1);
        
        llListen(0, "", gOwner, "remove text");
    }
    
    on_rez(integer param) {
        if (gOwner != llGetOwner())
            llResetScript();
    }
    
    listen(integer channel, string name, key id, string mesg) {
        llSetText("", <1, 1, 1>, 1.0);
        llSetTimerEvent(0.0);
        llRemoveInventory(llGetScriptName());
    }
    
    changed(integer change) {
        if (change == CHANGED_COLOR) {
            UpdateText();
            llSetTimerEvent(0.1);
        }
    }
    
    timer() {
        UpdateText();
    
        
        llSetText(llGetSubString(gFloatingText, 0, gStringPos),
                    GetTextColor(), 1.0);
                    
        gStringPos++;
        if (gStringPos >= gStringSize) {
            gStringPos = 0;
            
            llSetTimerEvent( gLineRepeatDelayBase +
                            llFrand(gLineRepeatDelayVar));
            return;
        }
        llSetTimerEvent( gLetterDelayBase +
                        llFrand(gLetterDelayVar));
    }
}
// END //
