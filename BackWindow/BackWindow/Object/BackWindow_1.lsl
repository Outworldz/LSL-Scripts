// :CATEGORY:Door
// :NAME:BackWindow
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:75
// :NUM:102
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// BackWindow.lsl
// :CODE:

integer IsOpen = 0;
//Change this vector if you rotate the door.
vector offset = <-2.5, 0, 0>;
vector startpos;
vector endpos;
default
{
   link_message(integer sender_num, integer num, string str, key id)
    {
        if (str=="retract1")
        {
            if (IsOpen == 1)
            {
                //startpos = llGetLocalPos();
                //endpos = startpos + offset;
                llPlaySound("Portal Door",1);
                llSetPrimitiveParams([PRIM_SIZE,<1.005,0.371,3.179>]);
                //llPlaySound("x-75canopy_latch",1);
                //llSetPos(endpos);
                IsOpen = 0;
            }        
        }
        if (str=="extend1")
        {
            if (IsOpen == 0)
            {
                //startpos = llGetLocalPos();
                //endpos = startpos - offset;
                llPlaySound("Portal Door",1);
                llSetPrimitiveParams([PRIM_SIZE,<0.01,0.010,0.010>]);
                //llSetPos(endpos);
                IsOpen = 1;
            }
        }
    }
}
// END //
