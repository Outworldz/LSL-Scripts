// :CATEGORY:Avatar
// :NAME:Halfatar
// :AUTHOR:Ferd Frederix
// :CREATED:2013-10-04 11:11:27
// :EDITED:2013-10-04 11:11:27
// :ID:999
// :NUM:1532
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Individual eye script for random wiggles
// :CODE:
// script to control each eye
// Use in half-avatars
// :Author: Ferd Frederix



default
{
    link_message( integer sender_num, integer num, string str, key id )
    {
        float x = (float) str;
        float y = x;
        if (llFrand(2) < 1)
            y = -x;
        llSetPrimitiveParams([PRIM_TEXTURE,ALL_SIDES,"bloodshot eye",<2,3,0>,<x,y,0>,0.0]);
    }
}
