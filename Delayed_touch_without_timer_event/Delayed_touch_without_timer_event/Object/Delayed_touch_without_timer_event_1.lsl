// :CATEGORY:Touch
// :NAME:Delayed_touch_without_timer_event
// :AUTHOR:aria.dragonash
// :CREATED:2010-09-08 10:25:21.070
// :EDITED:2013-09-18 15:38:51
// :ID:226
// :NUM:312
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Instead of llSetTimerEvent() we use llGetTime().// It is refreshed continuously while the object is clicked and doesn't need to be cleaned like a timer afterwards.
// :CODE:
float delay=1.0;     // how long the mousebutton must be held down to perform action
integer active;

default
{
    touch_start(integer num_detected)
    {
        llResetTime();
        active=FALSE;
    }
    
    touch (integer num_detected)
    {
       float time=llGetTime();
       if (time>=delay && !active)
       {
           llSay(0,"Do something cool here.");
           active=TRUE;
        }
    }
}
