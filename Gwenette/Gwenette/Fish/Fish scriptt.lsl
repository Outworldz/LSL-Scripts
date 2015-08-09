// :CATEGORY:Egret
// :NAME:Gwenette
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:54
// :ID:370
// :NUM:503
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// script for the fish
// :CODE:

default
{

    state_entry()
    {
        llSetAlpha(0,ALL_SIDES);
    }
    
    link_message(integer s, integer num, string str, key id)
    {
      
        if (str == "peck")
        {
            llSetAlpha(1,ALL_SIDES);
        }
        else 
        {
            llSetAlpha(0,ALL_SIDES);
        }
        
    }

    on_rez(integer p)
    {
        llResetScript();
    }
}

