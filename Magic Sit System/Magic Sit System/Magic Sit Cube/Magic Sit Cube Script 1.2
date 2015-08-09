// :CATEGORY:Sit
// :NAME:Magic Sit System
// :AUTHOR:Whidou Bienstock
// :KEYWORDS:
// :CREATED:2014-12-04 12:16:31
// :EDITED:2014-12-04
// :ID:1059
// :NUM:1689
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Magic sit system
// :CODE:
// :AUTHOR: Whidou Bienstock

// This script is licensed under GPL license version 2
//
// In short: feel free to redistribute and modify it, as long as
// any copies of it can be redistributed and modified as well.
//
// The official text of the licence is available at
// http://www.gnu.org/licences/gpl.html
//
// (c) The owner of Avatar Whidou Bienstock, 2008
 
integer CHANNEL = 48;                               // Channel of communication with the object
string NAME = "Magic Sit Cube - 1.2";               // Name of the Magic Sit Cube
 
// Wait for the owner to sit down on the cube
default
{
    state_entry()                                   // Set the default parameters
    {
        llSetObjectName(NAME);
        llSitTarget(<0.0, 0.0, 0.00001>, ZERO_ROTATION);
        llSetScale(<0.2, 0.2, 0.2>);
        llSetText("Sit on the Magic Cube to begin", <1.0, 0.0, 0.0>, 1.0);
        llSetTouchText("Doc");
        llSetSitText("Sitpose");
    }
 
    changed(integer change)
    {
        if (change & CHANGED_LINK)                  // If someone sits down
        {
            key who = llAvatarOnSitTarget();
 
            if (who == llGetOwner())                // and if it's the owner
                state config;                       // then change state
            else                                    // else
                llUnSit(who);                       // unsit the intruder
        }
    }
 
    touch_start(integer total_number)               // If someone touches the cube
    {
        integer i;
 
        for (i = 0; i < total_number; i++)          // give the documentation
        {
            key who = llDetectedKey(i);
            key what = llGetInventoryName(INVENTORY_NOTECARD, 0);
            string name = llDetectedName(i);
 
            llGiveInventory(who, what);
            llInstantMessage(who, "Here is the documentation, " + name + ".");
        }
    }
}
 
// The owner sat on the cube
state config
{
    state_entry()                                  // Set the new parameters
    {
        llSetText("", ZERO_VECTOR, 0.0);
        llOwnerSay("Welcome to the Magic Sit Configurator!\nPlease be sure to know how the Cube works before to use it.\nIf you don't, right click on the cube and select 'Manual' to get the documentation.\nHave fun!");
        llSetScale(<5.0, 0.2, 0.2>);
        llSay(CHANNEL, "*");                       // Tell the object to start animating the avatar, if needed
    }
 
    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {
            if (llAvatarOnSitTarget() == NULL_KEY)  // When the user unsits
            {
                rotation rot = llGetRot();          // Rotation of the cube (and of the avatar)
                vector pos =                        // Position of the avatar
                    llGetPos() + <0, 0, 0.4> * rot;
 
                llSay(CHANNEL,                      // Send those data to the object
                      (string) pos + "|" + (string) rot);
                state default;                      // Return to normal state
            }
        }
    }
}
