// :CATEGORY:Inventory Giver
// :NAME:Landmark_Giver
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:456
// :NUM:612
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Landmark Giver.lsl
// :CODE:

// Bedlam Enterprises

default
{
    state_entry()
    {
        llResetScript();
    }

    touch_start(integer total_number)
    {
        llGiveInventory(llDetectedKey(0),llGetInventoryName(INVENTORY_LANDMARK, 0));
    }
}
// END //
