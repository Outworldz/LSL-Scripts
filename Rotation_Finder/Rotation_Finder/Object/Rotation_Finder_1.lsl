// :CATEGORY:Rotation
// :NAME:Rotation_Finder
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:01
// :ID:713
// :NUM:978
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Rotation Finder.lsl
// :CODE:


1// Remove this number for this script to work




string Text = "Rotion finder now Online, left click to find rotaion vector"; //This is the message the Object the script is placed in to will say when it is spawned.


default
{
    
    state_entry()
    {
        llSay(0, Text);
    }

    touch_start(integer number)
    {
        key owner = llGetOwner();
        rotation gQuatRotation = llGetRot();
        vector gRotation = llRot2Euler(gQuatRotation);
    
    llInstantMessage(owner, "Quat rotation =" + (string)gQuatRotation);
    llInstantMessage(owner, "vector rotation =" + (string)gRotation);

    }

}// END //
