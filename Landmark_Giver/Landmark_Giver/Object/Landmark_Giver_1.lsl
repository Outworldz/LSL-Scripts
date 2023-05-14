// :SHOW:
// :CATEGORY:Inventory Giver
// :NAME:Landmark_Giver
// :AUTHOR:Anonymous
// :KEYWORDS:
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2022-05-18  22:48:34
// :ID:456
// :NUM:612
// :REV:1.0
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Landmark Giver.lsl
// :CODE:


default
{

    touch_start(integer total_number)
    {
        llGiveInventory(llDetectedKey(0),llGetInventoryName(INVENTORY_LANDMARK, 0));
    }
}
// END //
