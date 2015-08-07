// :CATEGORY:Weapons
// :NAME:Sand_Hurricane_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:01
// :ID:719
// :NUM:984
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Sand Hurricane! Script.lsl
// :CODE:

default
{
    on_rez(integer startparam)
    {
        llResetScript();
    }
    state_entry()
    {
        llListen(0,"",llGetOwner(),"Sand Hurricane!");
    }

    listen(integer channel, string name, key id, string message)
    {
        
        
            llRezObject("Sand Hurricane!", llGetPos(), ZERO_VECTOR, ZERO_ROTATION, 0);
         
    }
}// END //
