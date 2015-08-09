// :CATEGORY:Teleport
// :NAME:Long_distance_teleport_version_1
// :AUTHOR:Lisbeth Cohen
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:492
// :NUM:659
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Long distance teleport version 1.lsl
// :CODE:

//********************************************************
//This Script was pulled out for you by YadNi Monde from the SL FORUMS at http://forums.secondlife.com/forumdisplay.php?f=15, it is intended to stay FREE by it s author(s) and all the comments here in ORANGE must NOT be deleted. They include notes on how to use it and no help will be provided either by YadNi Monde or it s Author(s). IF YOU DO NOT AGREE WITH THIS JUST DONT USE!!!
//********************************************************







// Long distance teleport version 1.1 by Lisbeth Cohen
// ----------------------------------
//This is something I cooked together from other free scripts found at this forum. Just put it into a prim and sit on it to teleport - pretty standard. If you move the prim you'll have to reset the script so it will remember its new home position.
//Thanks to original authors for their great work and permitting me to publish this!
// This script is based on other public domain free scripts, so I don't
// take credit for any of the work here.
// Bits and pieces combined by Lisbeth Cohen - plus added show/hide.
//
// The basics of the script is based on Till Sterling's simple teleport
// script, with cross sim transportation routine developed by
// Keknehv Psaltery, modified by Strife Onizuka, Talarus Luan and
// Keknehv Psaltery.
// The transportation functionality is based upon Nepenthes Ixchel's
// 1000m Menu-driven Intra-Sim Teleporter
//
// Thank you to authors who have given me permission to publish this script.
// A special thank you to Keknehv Psaltery for suggesting small improvements!
//
// Realeased as public domain - you are NOT allowed to sell it without the
// permissions of all the authors I've credited above (except those who
// may have left sl at the time)!
// Feel free to use it in freebies and to give it to your friends :-)
//
// Please do not take credit for the work of all those great authors
// mentioned above!
// If you edit the script, please do not change the lines above - thanks!
// ------------------------------------------------------------------------


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
