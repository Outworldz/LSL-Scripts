// :CATEGORY:Bird
// :NAME:flamingo
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:53
// :ID:314
// :NUM:416
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// FLappy wings
// :CODE:

default
{

    state_entry()
    {
        llSetAlpha(0,ALL_SIDES);
    }
    
    link_message(integer s, integer num, string str, key id)
    {
        if (str=="flap")
            llSetPrimitiveParams([ PRIM_FLEXIBLE, 1, 2, num, 0.0, 0.0, 2.0, <0,0,0>] );
            
        else if (str == "fly")
        {
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

