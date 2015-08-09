// :CATEGORY:Touch
// :NAME:Delayed_Touch
// :AUTHOR:Sylar Lawksley
// :CREATED:2010-09-07 23:52:51.867
// :EDITED:2013-09-18 15:38:51
// :ID:225
// :NUM:311
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Pretty self-explanatory. Perfect for anyone who wants to do a separate menu for the owner by holding their "touch" for X amount of time versus a standard click.
// :CODE:
integer true_touch = 0; //Used to determine if we have completed the touch-and-hold or not.

default
{
    touch_start(integer h)
    {
        true_touch = 0;
        llSetTimerEvent(5.0); // How long you want the user to click-and-hold before the timed function goes off.
    }

    touch_end(integer i)
    {
        if (true_touch != 1)
        {
            llSay(0, "Nope!"); // Didn't hold long enough.
            // Regular menu location
        }
        llSetTimerEvent(0.0);
    }

    timer()
    {
        true_touch = 1;
        llSay(0, "Yep!"); //Held long enough, perform function!
        // Owner menu location
    }
}
