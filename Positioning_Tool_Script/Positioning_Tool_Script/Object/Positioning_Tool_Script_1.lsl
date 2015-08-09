// :CATEGORY:Building
// :NAME:Positioning_Tool_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:00
// :ID:646
// :NUM:876
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Positioning Tool Script.lsl
// :CODE:

1// Remove this number for this script to work



// This script is to give you the position of the object the script is in.

default

{
    state_entry()
    {
        llInstantMessage(llGetOwner(), "Positioning tool is now Online, click for the exact postion");
    }
    touch_start(integer total_number)
    {
        llInstantMessage(llGetOwner(), (string)llGetPos());
    }
}
// END //
