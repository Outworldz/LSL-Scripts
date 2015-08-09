// :CATEGORY:Door
// :NAME:phantomdoorwithpasswordowner
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:626
// :NUM:853
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// phantomdoorwithpassword(owner).lsl
// :CODE:

string password = "saysme";

default
{
    state_entry()
    {
        llSetStatus(STATUS_PHANTOM, FALSE);
        llSetAlpha(10.0,ALL_SIDES);
        llListen(0, "", llGetOwner(), password);
    }

    listen(integer channel, string name, key id, string text)
    {
        llSetStatus(STATUS_PHANTOM, TRUE);
        llSetAlpha(0.1,ALL_SIDES);
        llSleep(20.0);
        llSetStatus(STATUS_PHANTOM, FALSE);
        llSetAlpha(10.0,ALL_SIDES);
}        
}
// END //
