// :CATEGORY:Texture
// :NAME:Cycle_Textures
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:208
// :NUM:282
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Cycle Textures.lsl
// :CODE:

default
{
    state_entry()
    {
        llSetText("Avatar Texture Bundle", <0,1,0>,1);
        llSetTimerEvent(5.0);
    }
    timer()
    {
        integer number = llGetInventoryNumber(INVENTORY_TEXTURE);
        float rand = llFrand(number);
        integer choice = (integer)rand;
        string name = llGetInventoryName(INVENTORY_TEXTURE, choice);
        llSetTexture(name, 4);
    }
}
// END //
