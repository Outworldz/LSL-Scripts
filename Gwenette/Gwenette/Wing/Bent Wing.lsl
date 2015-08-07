// :CATEGORY:Egret
// :NAME:Gwenette
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:54
// :ID:370
// :NUM:507
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// for the bent wing
// :CODE:

default
{
    state_entry()
    {
        llSetAlpha(0,ALL_SIDES);
    }

    link_message(integer s, integer num, string str, key id)
    {
 
        if (str == "fly")
        {
            llSetAlpha(1,ALL_SIDES);
            llSleep(2);
            llSetAlpha(0,ALL_SIDES);
        }
        else if (str == "land")
        {
            llSetAlpha(1,ALL_SIDES);
            llSleep(2);
            llSetAlpha(0,ALL_SIDES);
        }
        
    }
}

