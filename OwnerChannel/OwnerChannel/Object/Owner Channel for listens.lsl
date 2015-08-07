// :CATEGORY:Utilities
// :NAME:OwnerChannel
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:59
// :ID:600
// :NUM:822
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// makes a unique channel for listeners specific to the owner
// :CODE:


default
{
    state_entry()
    {
        integer channel = (integer)("0x"+llGetSubString((string)llGetOwner(),-16,-1)) ;
        llSay(0, "channel: "+(string)channel);
        llListen(channel,"","","");
    }

    listen(integer channel, string name, key id, string message)
    {
        llSay(0,"Heard " + message);
    }
}
