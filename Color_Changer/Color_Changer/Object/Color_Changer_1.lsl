// :CATEGORY:Color
// :NAME:Color_Changer
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:192
// :NUM:265
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Color Changer.lsl
// :CODE:

default
{
    
    state_entry()
    {
        llSetTimerEvent(3.0);
    }
    
    timer()
    {
        float x = llFrand(1);
        float y = llFrand(1);
        float z = llFrand(1);
        llSetColor(<x,y,z>,ALL_SIDES);
    }
}
// END //
