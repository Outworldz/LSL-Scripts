// :CATEGORY:Sculpt
// :NAME:sculpt_change
// :AUTHOR:Fractal Mandala
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:01
// :ID:727
// :NUM:995
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// sculpt_change.lsl
// :CODE:

//original touch script courtesy of Fractal Mandala
//modified by YadNi Monde to make it Automatic

integer numsculpts;
integer sculptindex = -1;

default
{

state_entry()
{
    numsculpts = llGetInventoryNumber(INVENTORY_TEXTURE);
    llSetTimerEvent( 5 );
}

timer()
{
    sculptindex++;
    if(sculptindex >= numsculpts) {
        sculptindex = 0;
    }
    
    llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_SCULPT, llGetInventoryName(INVENTORY_TEXTURE, sculptindex), PRIM_SCULPT_TYPE_SPHERE]);
    }
}// END //
