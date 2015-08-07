// :CATEGORY:Invisibility
// :NAME:Invisible_prim_script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:405
// :NUM:561
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Invis script.lsl
// :CODE:


//This script will make an object totally Invisible. It does the same thing as editing it and setting the texture to the default transparent texture

default
{
    state_entry()
    {
         llSetAlpha(0.0, ALL_SIDES);
    }
    on_rez(integer start_param)
    {
        llResetScript();
    }
}
// END //
