// :CATEGORY:Clock
// :NAME:Rotation_Clock
// :AUTHOR:Fred Kinsei
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:01
// :ID:712
// :NUM:977
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Minute Hand: 
// :CODE:
//Credit to the creator:
//Made by SL resident Fred Kinsei
integer hours;
integer min;
integer sec;
GetTimeNow() 
{
    integer timeNow;
    timeNow = llRound(llGetWallclock());
    hours = timeNow / 3600;
    min = (timeNow % 3600) / 60;
    sec = timeNow % 60;
}

default
{
    state_entry()
    {
        llSetTimerEvent(1);
    }
    timer()
    {
        GetTimeNow();
        //llSay(0, (string)min);
        rotation CHANGE = llEuler2Rot(-(<0,0,((min-15) * 6) * DEG_TO_RAD>));
        llSetRot(CHANGE); 
    }
}
