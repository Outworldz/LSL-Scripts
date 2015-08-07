// :CATEGORY:Door
// :NAME:Whos_at_the_door
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:979
// :NUM:1401
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Who's at the door_.lsl
// :CODE:

default
{
    state_entry()
    {
    }
    
    touch_start(integer a)
    {
            string sName = llKey2Name(llDetectedKey(0));
            llSay(0, sName + " is at the Door");
    }
}// END //
