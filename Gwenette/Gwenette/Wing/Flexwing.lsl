// :CATEGORY:Egret
// :NAME:Gwenette
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:54
// :ID:370
// :NUM:506
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// for the flex wing
// :CODE:

default
{

    state_entry()
    {
        llSetAlpha(0,ALL_SIDES);
    }
    
    link_message(integer s, integer num, string str, key id)
    {
        if (str=="flapup") 
        {
            llSetPrimitiveParams([ PRIM_FLEXIBLE, 1, 2, 2, 2.0, 0.0, 10.0, <0,0,0>] );
        }
        else if (str == "flapdown")
        {
            llSetPrimitiveParams([ PRIM_FLEXIBLE, 1, 2, -2, 2.0, 0.0, 10.0, <0,0,0>] );
        }   
        else if (str == "fly")
        {
            llSleep(2);
            llSetAlpha(1,ALL_SIDES);
        }
        else if (str == "land")
        {
            llSetAlpha(0,ALL_SIDES);
        }
        
    }

    on_rez(integer p)
    {
        llSetAlpha(0,ALL_SIDES);
    }
}

