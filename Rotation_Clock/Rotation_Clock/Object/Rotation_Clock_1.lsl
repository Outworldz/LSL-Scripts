// :CATEGORY:Clock
// :NAME:Rotation_Clock
// :AUTHOR:Fred Kinsei
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:01
// :ID:712
// :NUM:976
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// made this to be a floor clock, so the script is set up to rotate on the z axis, change this for an upright clock.// // Place these scripts in a root prim, which is at the center of the clock face.// // // Hour Hand: 
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
    if(hours > 12)
    {
        hours = hours - 12;
    }
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
        //llSay(0, (string)hours);
        rotation CHANGE = llEuler2Rot(-( < 0, 0, (((hours) * 30)+(0.5*min)) * DEG_TO_RAD > ));
        llSetRot(CHANGE); 
    }
}
