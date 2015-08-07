// :CATEGORY:Building
// :NAME:Stay_in_sim
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:834
// :NUM:1162
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Stay in sim!.lsl
// :CODE:

1// remove this number for the script to work.

//This script makes sure that your objects stay in the sim that they are created. You can't save an object to inventory and rez in in another sim while this script is active.


{
    state_entry()
    {
        llSetStatus(STATUS_DIE_AT_EDGE,TRUE);
        vector INITCorner = llGetRegionCorner();
        while(TRUE)
        {
            if(llGetRegionCorner() != INITCorner)
            {
                llDie();
            }
        }
    }
}
// END //
