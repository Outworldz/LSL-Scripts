// :CATEGORY:Teleport
// :NAME:teleport_anywhere_script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:06
// :ID:871
// :NUM:1231
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// teleport anywhere script.lsl
// :CODE:


//The target location .. change this to where you want to end up (x, y, z) 
vector gTargetPos = <246, 181, 415>; 
// Text for the "pie menu" 
string gSitText="Teleport"; 
// Define channel number to listen to user commands from 
integer myChannel = 123; 


// No need to edit the global variables below 

// Return position for tp object - no need to edit 
vector gStartPos=<0,0,0>; 
// Key for avatar sitting on object, if any 
key gAvatarID=NULL_KEY; 
// If you don't enable this the teleport object will be left at the destination. 
integer gReturnToStartPos=TRUE; 


// This routine do the actual transport 
warpPos( vector destpos) 
{   //R&D by Keknehv Psaltery, 05/25/2006 
    //with a little pokeing by Strife, and a bit more 
    //some more munging by Talarus Luan 
    //Final cleanup by Keknehv Psaltery 
    // Compute the number of jumps necessary 
    integer jumps = (integer)(llVecDist(destpos, llGetPos()) / 10.0) + 1; 
    // Try and avoid stack/heap collisions 
    if (jumps > 100 ) 
        jumps = 100;    //  1km should be plenty 
    list rules = [ PRIM_POSITION, destpos ];  //The start for the rules list 
    integer count = 1; 
    while ( ( count = count << 1 ) < jumps) 
        rules = (rules=[]) + rules + rules;   //should tighten memory use. 
    llSetPrimitiveParams( rules + llList2List( rules, (count - jumps) << 1, count) ); 
} 

default 
{ 
    state_entry() 
    { 
        // Put the teleport text in place of the Sit in the pie menu 
        llSetSitText(gSitText); 
        // Read the objects position so it can return to it after teleporting 
        gStartPos = llGetPos(); 
        // Sit the avatar on the object 
        llSitTarget(<0,0,1>,ZERO_ROTATION); 
        // Define commands to listen for 
        llListen(myChannel,"","",""); 
    } 
     
    on_rez(integer startup_param) 
    { 
        llResetScript(); 
    } 
     
    listen(integer chan, string name, key id, string cmd) 
    { 
        if (cmd == "show") 
        { 
            llSetAlpha( 1, ALL_SIDES ); 
        } 
        else if (cmd == "hide") 
        { 
            llSetAlpha( 0, ALL_SIDES ); 
        } 
        else if (cmd == "reset") 
        { 
            llResetScript(); 
        } 
        else if (cmd == "help") 
        { 
            llSay(0, "Usage:");             
            llSay(0, "");             
            llSay(0, "show      Make teleporter visible");             
            llSay(0, "hide      Make teleporter invisible");             
            llSay(0, "reset     Resets teleporter script");             
            llSay(0, "help      This text");             
        } 
    } 

    changed(integer change){ 
        if(change & CHANGED_LINK) 
        { 
            // Find id for avatar sitting on the object 
            gAvatarID = llAvatarOnSitTarget(); 
            // If someone sits on it... 
            if(gAvatarID != NULL_KEY) 
            { 
                // Move avatar to destination 
                warpPos(gTargetPos); 
                // Pause for 1 second 
                llSleep(1); 
                // Unsit avatar 
                llUnSit(gAvatarID); 
                // Wait 1 second more 
                llSleep(1); 
                // If teleporter should return to original position.... 
                if (gReturnToStartPos) 
                { 
                    // ... send object to its start position 
                    warpPos(gStartPos); 
                } 
            } 
        } 
    } 
      
} // END //
