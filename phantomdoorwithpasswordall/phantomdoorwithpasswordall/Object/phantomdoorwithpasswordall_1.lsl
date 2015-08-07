// :CATEGORY:Door
// :NAME:phantomdoorwithpasswordall
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:625
// :NUM:852
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// phantomdoorwithpassword(all).lsl
// :CODE:

string password = "sky67chi";

default
{
    state_entry()
    {
        llSetStatus(STATUS_PHANTOM, FALSE);
        llSetAlpha(10.0,ALL_SIDES);
        llListen(0, "","","");
    }

    listen(integer channel, string name, key id, string text)
    {
        if (text=="right cdoor open")
        {
        llSetStatus(STATUS_PHANTOM, TRUE);
        llSetAlpha(0.1,ALL_SIDES);
        llSleep(02.0);
        llSetStatus(STATUS_PHANTOM, FALSE);
        llSetAlpha(10.0,ALL_SIDES);
    }
   
}        
}
// END //
