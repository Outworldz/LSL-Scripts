// :CATEGORY:Pet
// :NAME:Follow_Me
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:330
// :NUM:443
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Follow Me.lsl
// :CODE:

default
{
    state_entry()
    {
        vector pos = llGetPos();
        llSetStatus(STATUS_ROTATE_Z, FALSE);
        llSetStatus(STATUS_PHYSICS, TRUE);
        llSleep(0.1);
        llMoveToTarget(pos,0.1);
        key id = llGetOwner();
        llSensorRepeat("","",AGENT,200000,7000*PI,.4);
    }

    sensor(integer total_number)
    {
        vector pos = llDetectedPos(0);
        vector offset =<-1,0,1>;
        pos+=offset;
        llMoveToTarget(pos,.3);     
    }
}
// END //
