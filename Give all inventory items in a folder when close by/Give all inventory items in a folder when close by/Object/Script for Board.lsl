// :SHOW:
// :CATEGORY:Presentation
// :NAME:Give all inventory items in a folder when close by
// :AUTHOR:Lum Pfohl
// :KEYWORDS:
// :CREATED:2015-11-24 20:25:32
// :EDITED:2015-11-24  19:25:32
// :ID:1086
// :NUM:1833
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// LumVision-Presentation Script v 0.2
// :CODE:
// Mods by Fred Beckhusen (Ferd Frederix) to support GIFS
//
// LumVision-Presentation Script v 0.2
//
// Written by Lum Pfohl December 11, 2007
//
// January 02, 2008 - Added code to precache the next texture after a short time delay


// set to TRUE if you want debug messages written to chat screen
integer __debug = FALSE;
string __version_id = "Presentation Script v 0.3";

// global variables
integer interval;
integer currentTexture = 0;

integer totalTextures = 0;
list textureList =[];
integer messageChannel = 999888;
list dynMenu =["Back", "Version", "Forward", "Reset"];


gif()
{
     string t = llList2String(textureList, currentTexture);
    list gif = llParseString2List(t,[";"],[]);
    string aname = llList2String(gif,0);
    integer X  = (integer) llList2String(gif,1);
    integer Y  = (integer) llList2String(gif,2);
    float   FPS  = (float)   llList2String(gif,3);
    float product = X * Y;
    

    
     // Set the new prim texture
    
    llSetTexture(llList2String(textureList, currentTexture), 0);

    if (X) {
        llSetTextureAnim( ANIM_ON | LOOP, ALL_SIDES, X, Y, 0.0, product, FPS);
    } else {
        llSetTextureAnim(  LOOP, ALL_SIDES, 1,1, 0.0, 1 , FPS);
    }
    
}
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
    gif();
    
    // initialize the channel on which the vendor will talk to the owner via dialog
        messageChannel = (integer) llFrand(2000000000.0);
        llListen(messageChannel, "", NULL_KEY, "");
       
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
        --currentTexture;
    } else if (message == "Forward") {
        ++currentTexture;
    } else {
         llDialog(llGetOwner(), "What do you want to do?", dynMenu, messageChannel);
        return;
    }

    // If there are textures to apply, do so now. Otherwise - quietly
    // do nothing.
    if (totalTextures > 0) {
    
     // Ensure that we do not go out of bounds with the index
        if (currentTexture >= totalTextures) {
            currentTexture = 0;
        }
        if (currentTexture < 0 ) {
            currentTexture = 0;
        }
        
        gif();
        
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

    changed(integer what)
    {
        if (what & CHANGED_INVENTORY)
            llResetScript();
    }

}
