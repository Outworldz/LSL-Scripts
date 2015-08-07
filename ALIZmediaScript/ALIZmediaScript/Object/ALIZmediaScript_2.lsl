// :CATEGORY:Tip Jar
// :NAME:ALIZmediaScript
// :AUTHOR:Ali Virgo
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:26
// :NUM:37
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This script produces your  avatar key.  Click it, then add the key it prints to "key payee = "your key" in the other script.
// :CODE:


1// Remove this number for this script to work


default
{
    state_entry()
    {
        llSay(0, "AV Key");
    }

    touch_start(integer total_number)
    {
        llWhisper(0, (string)llGetOwner());
    }
    on_rez(integer start_param)
    {
        llResetScript();
    }
}
// END //
