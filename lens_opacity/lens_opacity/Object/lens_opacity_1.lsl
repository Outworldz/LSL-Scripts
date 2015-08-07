// :CATEGORY:Windows
// :NAME:lens_opacity
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:465
// :NUM:626
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// lens opacity.lsl
// :CODE:

// script that changes opacity of object based on external messages

default
{
    state_entry()
    {
    }
    
    link_message(integer sender_num, integer num, string str, key id)
    {
        float opacityLvl = (float)num;
        opacityLvl = 1.1 - ((opacityLvl / 3) * 0.9);
        llSetAlpha(opacityLvl, ALL_SIDES);
    } 
} // END //
