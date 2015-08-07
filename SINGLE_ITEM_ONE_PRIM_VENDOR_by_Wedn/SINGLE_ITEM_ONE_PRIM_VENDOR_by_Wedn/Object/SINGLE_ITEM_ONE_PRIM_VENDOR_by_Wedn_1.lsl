// :CATEGORY:Vendor
// :NAME:SINGLE_ITEM_ONE_PRIM_VENDOR_by_Wedn
// :AUTHOR:Wednesday Grimm
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:02
// :ID:771
// :NUM:1059
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// SINGLE ITEM ONE PRIM VENDOR by Wednesday Grimm.lsl
// :CODE:

// vendor
// Wednesday Grimm
// June 10, 2003
//
// Simple vending script, gives correct change.



//////////////////////////////////////////////////////////////////////////////////////////
// HOW TO USE THIS SCRIPT By Jacqueline Bancroft
//
//This is a vendor program for a single item. This is how it works:
//
//You rez a cube and pretty it up.. maybe put a texture of what you're selling on the side.
//Put the item that you want to sell into the cube you made.
//Put this script inside the cube you made, and then open up the script to edit it.
//
//Where it says gPrice, put the price of the item you want to sell after the equal sign.
//
//Where it says itemName, put the item name of the item that you want to sell after the equal sign. Be very aware that the script is case sensitive, so make sure you spell it correctly. For example, "My Object" is different than "my object".
//
//Where it says summary1 and summary 2, fill in a description of the item what you wish to sell. make sure that you surround the description with quotation marks, or else the script will go wonky. When a potential customer touches (clicks) on your box vendor, your box vendor will whisper summary1 and summary2 to them.
//
//That's about it. Be sure to thank Wednesday if you use this script.
//////////////////////////////////////////////////////////////////////////////////////////






integer gPrice = 5;  // cost of the item

 // name of the item in object's inventory, to vend
string itemName = "test_note"; 

// two summary lines to describe the object
string summary1 = "this is a test note, it tests this script";
string summary2 = "it is very interesting.  Cost is $5";

// give the item to a customer
dispense(key toWhom)
{
    llGiveInventory(toWhom, itemName);
}

default
{
    state_entry()
    {
        // we need this permission to give change
        llRequestPermissions(llGetOwner(), PERMISSION_DEBIT);
    }

    touch_end(integer total_number)
    {
        // if someone touches object describe what's for sale
        llWhisper(0, summary1);
        llWhisper(0, summary2);
    }
    
    money(key id, integer amt)
    {
        if (amt >= gPrice)
        {
            // customer has given us at least enough money
            amt -= gPrice;
            dispense(id);
        }
        if (amt > 0) // give back change
        {
            llGiveMoney(id, amt);
        }            
    }
}// END //
