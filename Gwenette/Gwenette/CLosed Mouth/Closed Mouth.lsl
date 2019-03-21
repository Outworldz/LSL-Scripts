// :CATEGORY:Egret
// :NAME:Gwenette
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:54
// :ID:370
// :NUM:504
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// For the closed mouth
// :CODE:

default
{

    state_entry()
    {
        llSetAlpha(1,ALL_SIDES);
    }
    
    link_message(integer s, integer num, string str, key id)
    {
      
        if (str == "open")
        {
            llSetAlpha(0,ALL_SIDES);
        }
        else if (str =="close")
        {
            llSetAlpha(1,ALL_SIDES);
        }
        
    }

    on_rez(integer p)
    {
        llResetScript();
    }
}

