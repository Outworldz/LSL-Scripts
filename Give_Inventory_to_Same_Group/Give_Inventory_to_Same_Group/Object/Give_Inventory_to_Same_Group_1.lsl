// :CATEGORY:Inventory Giver
// :NAME:Give_Inventory_to_Same_Group
// :AUTHOR:Ryker Beck
// :CREATED:2010-11-16 11:18:18.540
// :EDITED:2013-09-18 15:38:54
// :ID:351
// :NUM:474
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Give_Inventory_to_Same_Group
// :CODE:
default
{
    touch_start(integer total_number)
    {
        integer number = 0;
        do
        {
            if (llDetectedGroup(number)) //same as llSameGroup(llDetectedKey(0)) (with llSameGroup, detected must be in the sim)
                llGiveInventory(llDetectedKey(number), llGetInventoryName(INVENTORY_OBJECT,0));
            else
                llSay(0, "Wrong active group!");
        }while(total_number > ++number);
    }
}
