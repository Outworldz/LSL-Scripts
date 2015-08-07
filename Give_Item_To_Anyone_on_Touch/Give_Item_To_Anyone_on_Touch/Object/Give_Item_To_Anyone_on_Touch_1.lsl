// :CATEGORY:Inventory Giver
// :NAME:Give_Item_To_Anyone_on_Touch
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:353
// :NUM:476
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Give Item (To Anyone) on Touch.lsl
// :CODE:

1
default

    
{
    touch_start(integer param)
    {
        llGiveInventory(llDetectedKey(0),"NAME_OF_ITEM_TO_GIVE");
    }
    
}
// END //
