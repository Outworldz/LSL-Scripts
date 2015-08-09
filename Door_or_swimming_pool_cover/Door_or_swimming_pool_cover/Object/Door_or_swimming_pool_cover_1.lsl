// :CATEGORY:Door
// :NAME:Door_or_swimming_pool_cover
// :AUTHOR:Ferd Frederix
// :CREATED:2012-12-02 23:07:08.757
// :EDITED:2013-09-18 15:38:52
// :ID:254
// :NUM:345
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// For a  swimming pool, put this into the root prim of a two-prim swimming pool cover, or door.  It hollows out to 90% the second prim.
// :CODE:

integer open;


default
{
    state_entry()
    {
        llSetLinkPrimitiveParamsFast(2, [PRIM_TYPE,PRIM_TYPE_BOX, PRIM_HOLE_SQUARE, <0,1,0>, 0.9, <0,0,0>, <1,1,0>, <0,0,0>]);
    }

    touch_start(integer total_number)
    {
        open = ~ open;
        if (!open)
        {
            llSetLinkPrimitiveParamsFast(2, [PRIM_TYPE,PRIM_TYPE_BOX, PRIM_HOLE_SQUARE, <0,1,0>, 0.9, <0,0,0>, <1,1,0>, <0,0,0>]); 
        }
        else
        {
            llSetLinkPrimitiveParamsFast(2, [PRIM_TYPE,PRIM_TYPE_BOX, PRIM_HOLE_SQUARE, <0,1,0>, 0, <0,0,0>, <1,1,0>, <0,0,0>]);
        }
    }
}
