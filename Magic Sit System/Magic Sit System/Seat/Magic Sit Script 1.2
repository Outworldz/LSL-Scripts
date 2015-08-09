// :CATEGORY:Sit
// :NAME:Magic Sit System
// :AUTHOR:Whidou Bienstock
// :KEYWORDS:
// :CREATED:2014-12-04 12:25:56
// :EDITED:2014-12-04
// :ID:1059
// :NUM:1690
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Magic Sit System for no poseballs
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
 
integer CHANNEL = 48;                                           // Channel of communication with the object
string NAME = "Magic Sit Cube - 1.2";                           // Name of the Magic Sit Cube
 
integer listen_num;
 
// Start the first animation stored in the object, if any
startAnimation()
{
    if (llGetInventoryNumber(INVENTORY_ANIMATION))              // If there is at least one animation in the inventory
    {
        integer perm = llGetPermissions();
 
        if (perm & PERMISSION_TRIGGER_ANIMATION)                // and if we can animate the avatar
        {
            string name = llGetInventoryName(INVENTORY_ANIMATION, 0);
 
            llStopAnimation("sit");                             // stop the default animation
            llStartAnimation(name);                             // and start the new one
        }
        else                                                    // else ask the permission
            llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
    }
}
 
// Stop the first animation stored in the object, if any
stopAnimation()
{
    if (llGetInventoryNumber(INVENTORY_ANIMATION))              // If there is at least one animation in the inventory
    {
        integer perm = llGetPermissions();
 
        if (perm & PERMISSION_TRIGGER_ANIMATION)                // and if we can animate the avatar
        {
            string name = llGetInventoryName(INVENTORY_ANIMATION, 0);
 
            llStopAnimation(name);                              // stop the animation
        }
    }
}
 
// Set the sit target
sitPose(string message)
{
    list msg = llParseString2List(message, [ "|" ], []);        // Split the data
    vector avPos = (vector) llList2String(msg, 0);              // Avatar's position
    rotation avRot = (rotation) llList2String(msg, 1);          // Avatar's rotation
 
    rotation rot = avRot / llGetRot();                          // Difference between the 2 rotations
    vector pos =                                                // Sit target offset
            (avPos - llGetPos()) / llGetRot() - <0, 0, 0.4>;
 
    llSitTarget(pos, rot);                                      // Sitpose the objet (the purpose of the whole thing)
    llOwnerSay("Object sitposed. I used the following instruction: \nllSitTarget(" + (string) pos + ", " + (string) rot + ");");
    llSetClickAction(CLICK_ACTION_SIT);                         // Make it easy to sit for new residents
    llOwnerSay("Sit target set. Your object is ready.");        // Warn the owner
}
 
default
{
    state_entry()
    {
        listen_num = llListen(CHANNEL, NAME, NULL_KEY, "");     // Listen to the cube
        llOwnerSay("Magic Sit Script ready");                   // Inform the owner
    }
 
    listen(integer channel, string name, key id, string message)
    {
        if (llGetOwnerKey(id) == llGetOwner())                  // Check that the cube has the same owner as the object
        {
            if (message == "*")                                 // If the owner sits on the cube
            {
                startAnimation();                               // then possibly animate his/her avatar
            }
            else                                                // else if the owner unsits from the cube
            {
                llListenRemove(listen_num);                     // then remove the listen
                sitPose(message);                               // calculate the sit target
                stopAnimation();                                // possibly stop the animation
                llRemoveInventory(llGetScriptName());           // and destroy this script
            }
        }
    }
 
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION)                // If the permission is granted
        {
            string name = llGetInventoryName(INVENTORY_ANIMATION, 0);
 
            llStopAnimation("sit");                             // stop the default animation
            llStartAnimation(name);                             // and start the new one
        }
    }
}
