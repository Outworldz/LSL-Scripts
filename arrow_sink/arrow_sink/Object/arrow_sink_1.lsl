// :CATEGORY:Weapons
// :NAME:arrow_sink
// :AUTHOR:Martin
// :CREATED:2010-06-23 19:10:32.967
// :EDITED:2013-09-18 15:38:48
// :ID:53
// :NUM:80
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// won't stick i the ground will fall straight through.
// :CODE:
integer toss = 0;

default
{
    state_entry()
    {
        llVolumeDetect(TRUE);
        llSetStatus(STATUS_DIE_AT_EDGE,TRUE);
    }

    collision_start(integer total_number)
    {
        if(llDetectedType(0) != AGENT && toss == 0)
        {
            toss = 1;
            vector speed = llGetVel();
            float dispeed = llVecDist(<0,0,0>,speed);
            if(dispeed >= 20)
            {
                llSetStatus(STATUS_PHYSICS,FALSE);
                llVolumeDetect(FALSE);
                llSetPos(llGetPos() + speed / 85);
            }
        }
        else if(toss == 0)
        {
            llDie();
        }
        llSetTimerEvent(30);
    }
    
    timer()
    {
        llDie();
    }
}
