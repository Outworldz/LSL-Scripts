// :CATEGORY:Giver
// :NAME:Give Inventory List
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:54
// :ID:349
// :NUM:472
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Give inventory List
// :CODE:





//  llGiveInventoryList


//    * This function causes the script to sleep for 3.0 seconds.
//    * If inventory is missing from the prim's inventory then an error is shouted on DEBUG_CHANNEL.
//    * Avatar must be, or have recently been, within the same Region as sending object.
//    * Does not create a folder when avatar is a prim UUID.
//         o The prim must be in the same region. 

//Examples

// When a user clicks this object, this script will give a folder containing everything in the objects inventory
// This can serve as a unpacker script for boxed objects
 
default {
 
    touch_start(integer total_number) {
 
        list        inventory;
        string      name;
        integer     num = llGetInventoryNumber(INVENTORY_ALL);
        integer     i;
 
        for (i = 0; i < num; ++i) {
            name = llGetInventoryName(INVENTORY_ALL, i);
            if(llGetInventoryPermMask(name, MASK_NEXT) & PERM_COPY)
                inventory += name;
            else
                llSay(0, "Don't have permissions to give you \""+name+"\".");
        }
 
 
        //we don't want to give them this script
        i = llListFindList(inventory, [llGetScriptName()]);
        inventory = llDeleteSubList(inventory, i, i);
 
        if (llGetListLength(inventory) < 1) {
            llSay(0, "No items to offer."); 
        } else {
            // give folder to agent, use name of object as name of folder we are giving
            llGiveInventoryList(llDetectedKey(0), llGetObjectName(), inventory);
        }

    }
}

