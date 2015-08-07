// :CATEGORY:Die
// :NAME:TIMED_DIE
// :AUTHOR:Scorpse Ghost
// :CREATED:2010-02-07 09:46:19.537
// :EDITED:2013-09-18 15:39:07
// :ID:891
// :NUM:1267
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This Script is to be dropped in a prim set the timer to as long as you need and it will auto delete the prim its in after the set time currently set at 2 seconds
// :CODE:
default
{
    on_rez(integer param)
    {
        llSetTimerEvent(2.0);
    }
    
    timer()
    {
        llDie();
    }
}
