// :CATEGORY:Bling
// :NAME:good_white_blinker
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:361
// :NUM:494
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// good white blinker.lsl
// :CODE:

float color = 0.5;

default
{
    
    state_entry()
    {
        llSetTimerEvent(1.0);
        llSetPrimitiveParams([PRIM_FULLBRIGHT,ALL_SIDES,TRUE ]);
        
        }
    
    timer()
    {
        if (color == 0.5) color = 1.0;
        else if (color == 1.0) color = 0.5;
        llSetPrimitiveParams([ PRIM_COLOR, ALL_SIDES, <color, color, color>, 1.0,PRIM_POINT_LIGHT, TRUE, <color, color, color>, 1.0, 5.0, 0.0 ]);
    }
}
 // END //
