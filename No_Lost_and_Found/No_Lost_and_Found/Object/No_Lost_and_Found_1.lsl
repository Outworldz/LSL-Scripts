// :CATEGORY:Die
// :NAME:No_Lost_and_Found
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:556
// :NUM:760
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// No Lost and Found.lsl
// :CODE:

// This script keeps objects that get away from you from going into your lost and found when they leave the world due to getting away. The objects delete at the edge of the world, but doesn't go into your trash. So be carefull with this, make sure you have a copy of your object before letting an object go  that has this.
default
{
    state_entry()
    {
        llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
    }
}
// END //
