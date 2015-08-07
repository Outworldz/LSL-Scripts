// :CATEGORY:Texture
// :NAME:TextureSwitcher__Touch
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:07
// :ID:882
// :NUM:1245
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// TextureSwitcher - Touch.lsl
// :CODE:

default
{
  
     touch_start(integer total_number)
    {
        integer number = llGetInventoryNumber(INVENTORY_TEXTURE);
        float rand = llFrand(number);
        integer choice = (integer)rand;
        string name = llGetInventoryName(INVENTORY_TEXTURE, choice);
        if (name != "")
            llSetTexture(name, 2);
    }
}// END //
