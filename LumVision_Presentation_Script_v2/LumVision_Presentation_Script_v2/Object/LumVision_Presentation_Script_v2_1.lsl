// :CATEGORY:Signs
// :NAME:LumVision_Presentation_Script_v2
// :AUTHOR:Lum Pfohl
// :CREATED:2011-01-22 12:41:14.497
// :EDITED:2013-09-18 15:38:56
// :ID:498
// :NUM:666
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This is my script for an in-world slide show. Rez a cube and fill it with textures followed by this script. If the textures are named to be sequential, this presentations script will display each texture in that order.// // Touch the cube to start. A drop down menu will provide options to go back, go forward in the sequence of textures, or reset the script.
// :CODE:
//
// LumVision-Presentation Script v 0.2
//
// Written by Lum Pfohl December 11, 2007
//
// January 02, 2008 - Added code to precache the next texture after a short time delay
 
 
// set to TRUE if you want debug messages written to chat screen
integer __debug = FALSE;
string __version_id = "LumVision-Presentation Script v 0.2";
 
// global variables
integer interval;
integer currentTexture = 0;
integer previousTexture = 0;
integer totalTextures = 0;
list textureList =[];
integer messageChannel = 999888;
list dynMenu =["Back", "Version", "Forward", "Reset"];
 
// this is a list of all the possible inventory types, as constants.
list list_types = [INVENTORY_NONE, INVENTORY_TEXTURE, INVENTORY_SOUND, INVENTORY_LANDMARK,
                   INVENTORY_CLOTHING, INVENTORY_OBJECT, INVENTORY_NOTECARD, INVENTORY_SCRIPT,
                   INVENTORY_BODYPART, INVENTORY_ANIMATION, INVENTORY_GESTURE];
 
// this list is of the string names corresponding to the one above.
list list_names = ["None", "Texture", "Sound", "Landmark", "Clothing", "Object", "Notecard",
                   "Script", "Body Part", "Animation", "Gesture"];
 
default {
    state_entry() {
 
        // read in the textures in the prim and store it
        integer typeCount = llGetInventoryNumber(INVENTORY_TEXTURE);
 
        integer j;
 
        for (j = 0; j < typeCount; ++j) {
            string invName = llGetInventoryName(INVENTORY_TEXTURE, j);
            if (__debug) {
                llWhisper(0, "Inventory " + invName);
            }
            textureList += invName;
            ++totalTextures;
        }
 
        if (__debug) {
            llWhisper(0, "Found " + (string) totalTextures + " textures");
        }
 
        llSetTexture(llList2String(textureList, 0), 0);
 
 
        // initialize the channel on which the vendor will talk to the owner via dialog
        messageChannel = (integer) llFrand(2000000000.0);
        llListen(messageChannel, "", NULL_KEY, "");
        // llOwnerSay((string)messageChannel);
        currentTexture = 0;
    }
 
    on_rez(integer start_param) {
        llResetScript();
    }
 
 
    touch_start(integer total_number) {
 
        if (llDetectedKey(0) == llGetOwner()) {
            llDialog(llDetectedKey(0), "What do you want to do?", dynMenu, messageChannel);
        }
 
    }
 
    // listen for for dialog box messages and respond to them as appropriate
 
    listen(integer channel, string name, key id, string message) {
 
        if (id != llGetOwner()) {
            return;
        }
 
        if (message == "Version") {
            llWhisper(0, __version_id);
            return;
        }
 
        if (message == "Reset") {
            llResetScript();
        }
 
        if (message == "Back" && currentTexture > 0) {
            previousTexture = currentTexture;
            --currentTexture;
        } else if (message == "Forward" && (currentTexture >= 0) && (currentTexture < totalTextures)) {
            previousTexture = currentTexture;
            ++currentTexture;
 
        } else {
            llDialog(llGetOwner(), "What do you want to do?", dynMenu, messageChannel);
            return;
        }
 
        // If there are textures to apply, do so now.  Otherwise - quietly
        // do nothing.
        if (totalTextures > 0) {
 
            // Ensure that we do not go out of bounds with the index
            if (currentTexture >= totalTextures) {
                currentTexture = 0;
            }
            // Set the new prim texture
            llSetTexture(llList2String(textureList, currentTexture), 0);
 
            // set up so that in 3 seconds, we display the next image on a different face (hidden)
            llSetTimerEvent(3.00);
 
            llDialog(llGetOwner(), "What do you want to do?", dynMenu, messageChannel);
        }
    }
 
    timer() {
        // Cancel any further timer events
        llSetTimerEvent(0.00);
 
        // set the next texture (as a pre-cache) on the reverse face
        integer nextTexture = currentTexture + 1;
        if (nextTexture >= totalTextures) {
            nextTexture = 0;
        }
        llSetTexture(llList2String(textureList, nextTexture), 1);
    }
 
}
