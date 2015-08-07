// :CATEGORY:Positioning
// :NAME:Averagepositioner
// :AUTHOR:Nitsuj Kidd
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:74
// :NUM:101
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// A avatar follower, positions a prim at the waist of the nearest avatar.  
// :CODE:
//By Nitsuj Kidd
default
{
    state_entry()
    {
        llSensorRepeat("", "", AGENT, 0.1, TWO_PI, 0.1);
    }

    sensor(integer num)
    {
        if(!llGetStatus(STATUS_PHYSICS)) llSetStatus(STATUS_PHYSICS,TRUE);
        vector pos;
        integer i;
        for(i=0;i<num;i++)
        {
            pos += llDetectedPos(i);
        }
        pos = pos/num;
        llMoveToTarget(pos, 0.1);
    }
    no_sensor()
    {
        llSetStatus(STATUS_PHYSICS,FALSE);
    }
}
