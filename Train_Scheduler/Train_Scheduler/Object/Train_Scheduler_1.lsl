// :CATEGORY:Train
// :NAME:Train_Scheduler
// :AUTHOR:Barney Boomslang
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:08
// :ID:916
// :NUM:1314
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Train_Scheduler
// :CODE:
// copyright 2007 Barney Boomslang
//
// this is under the CC GNU GPL
// http://creativecommons.org/licenses/GPL/2.0/
//
// prim-based builds that just use this code are not seen as derivative
// work and so are free to be under whatever license pleases the builder.
//
// Still this script will be under GPL, so if you build commercial works
// based on this script, keep this script open!

// This script is the scheduler for the train stations. It will show the
// next train going, it's destination and when appropriate, send a rezzer
// command via chat to the train rezzer

integer last = -1;

// set this to the number of seconds after the full hour to start the train
integer offset = 1800;

setTimer()
{
    integer sec = (integer)llGetWallclock() + offset;
    integer h = sec / 3600;
    h = h * 3600;
    integer minutes = 60 - (sec - h) / 60;
    if ((last > 0) && (minutes > last))
    {
        llShout(474747, "start train");
    }
    if (minutes < 5)
    {
        llSetText("Next train in " + (string)minutes + " minutes", <1,0,0>, 1.0);
    }
    else if (minutes < 10)
    {
        llSetText("Next train in " + (string)minutes + " minutes", <1,1,0>, 1.0);
    }
    else
    {
        llSetText("Next train in " + (string)minutes + " minutes", <0,1,0>, 1.0);
    }
    last = minutes;
}

default
{
    state_entry()
    {
        setTimer();
        llSetTimerEvent(60.0);
    }
    
    on_rez(integer start_param)
    {
        llResetScript();
    }
    
    timer()
    {
        setTimer();
    }
}

