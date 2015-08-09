// :CATEGORY:Boat
// :NAME:DaVinci Boat
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-08
// :EDITED:2013-09-18 15:38:51
// :ID:220
// :NUM:300
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Makes the double gear spin
// :CODE:
default
{
    state_entry()
    {
        llTargetOmega(<0,0,0>,1,.1);
    }


    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "spin")
            llTargetOmega(<1,0,0>,((float) num)/10,0.1);
    }
}
