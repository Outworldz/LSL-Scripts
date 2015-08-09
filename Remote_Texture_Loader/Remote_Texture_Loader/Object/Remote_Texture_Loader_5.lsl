// :CATEGORY:Texture
// :NAME:Remote_Texture_Loader
// :AUTHOR:Bobbyb30 Swashbuckler
// :CREATED:2010-12-27 12:20:34.060
// :EDITED:2013-09-18 15:39:01
// :ID:691
// :NUM:945
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Print inventory texture keys.lsl
// :CODE:
//***********************************************************************************************************
//                                                                                                          *
//                                       -- Print inventory texture keys--                                  *
//                                                                                                          *
//***********************************************************************************************************
// www.lsleditor.org  by Alphons van der Heijden (SL: Alphons Jano)
//Creator: Bobbyb30 Swashbuckler
//Attribution: None required, but it is appreciated.
//Created: November 28, 2009
//Last Modified: November 28, 2009
//Released: Saturday, November 28, 2009
//License: Public Domain
 
//Status: Fully Working/Production Ready
//Version: 1.0.1
 
//Name: Print inventory texture keys.lsl
//Purpose: Prints out the UUID of inventory textures on chat for use in Main Display and Remote
//         Load texture display.
//Description: Prints out the keys of inventory textures on touch.
//Directions: Create a prim. Add desired texture. Add this script. Touch.
 
//Compatible: Mono & LSL compatible
//Other items required: None
//Notes: Commented for easier following.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
default
{
    state_entry()
    {
        llOwnerSay("Bobbyb's 'Print inventory texture keys.lsl' (Public Domain 2009)");
        llOwnerSay("Touch to readout inventory texture keys.");
    }
    touch_start(integer total_number)
    {
        if(llDetectedKey(0) == llGetOwner())
        {
            integer inventorynumber = llGetInventoryNumber(INVENTORY_TEXTURE);
            integer counter;
            llOwnerSay("Found " + (string)inventorynumber + " textures...");
            llSetObjectName("");
            do
            {
                string inventoryname = llGetInventoryName(INVENTORY_TEXTURE,counter);
                llOwnerSay("/me " + "\"" + (string)llGetInventoryKey(inventoryname) + "\""
                    + ", // " + inventoryname);
            }while(++counter < inventorynumber);
            llSetObjectName("Print out");
            llOwnerSay("Please remove the comma from the last one.");
        }
    }
}
