// :CATEGORY:Birds
// :NAME:Gracie and George Flamingos
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2014-12-04 12:13:18
// :EDITED:2014-12-04
// :ID:1057
// :NUM:1683
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// DESCRIPTION: []::Free-flight bird system without physics
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
            llSetPrimitiveParams([ PRIM_FLEXIBLE, 1, 2, num, 0.0, 0.0, 10.0, <0,0,0>] );
            
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
