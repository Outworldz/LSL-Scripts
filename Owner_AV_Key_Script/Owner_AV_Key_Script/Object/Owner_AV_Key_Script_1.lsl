// :CATEGORY:Avatar Key
// :NAME:Owner_AV_Key_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:599
// :NUM:821
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Owner AV Key Script.lsl
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
