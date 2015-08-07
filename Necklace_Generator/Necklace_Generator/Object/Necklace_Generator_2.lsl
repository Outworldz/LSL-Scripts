// :CATEGORY:Jewelry
// :NAME:Necklace_Generator
// :AUTHOR:Ariane Brodie
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:552
// :NUM:754
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Link Script
// :CODE:
default
{
    
    link_message(integer channel, integer sender, string message, key id) {

        if (message == "gold")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <0.9, 0.9, 0.5>, 1.0,
            PRIM_FULLBRIGHT, ALL_SIDES, FALSE]);
            
        if (message == "silver")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <0.8, 0.8, 0.8>, 1.0,
            PRIM_FULLBRIGHT, ALL_SIDES, FALSE]);
            
        if (message == "glow")
            llSetPrimitiveParams([
            PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);

        if (message == "hideneck")
            llSetPrimitiveParams([
            PRIM_COLOR, ALL_SIDES, <1,1,1>, 0.0,
            PRIM_FULLBRIGHT, ALL_SIDES, FALSE]);
    }

}
