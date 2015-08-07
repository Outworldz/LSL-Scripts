// :CATEGORY:Inventory Giver
// :NAME:SeagelYadNiContentGiverOnTouch
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:01
// :ID:729
// :NUM:997
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// SeagelYadNiContentGiverOnTouch.lsl
// :CODE:

default
{
    on_rez(integer start_parm)
    {
        llResetScript();
    }
    state_entry()
    {
        llOwnerSay( "Click me to get my Contents!");
        string      folderName = llGetObjectName();
        llSetText(folderName,<0,1,0>,1.0);
    }
    touch_start(integer total_number)
    {
        list        contents_list;
        string      contents_name;
        integer     contents_num = llGetInventoryNumber(INVENTORY_ALL);
        string      folderName = llGetObjectName();
        integer     i;        
        for (i = 0; i < contents_num; ++i)
        {
            contents_name = llGetInventoryName(INVENTORY_ALL, i);
            contents_list += contents_name;
        }
        i = llListFindList(contents_list, [llGetScriptName()]); //  Delete this script
        contents_list = llDeleteSubList(contents_list, i, i);
        
        if (llGetListLength(contents_list) < 1)
        {
            llWhisper(0, "Sorry, This box allows only owner to open it.");
        }
        else
        {
            llGiveInventoryList(llGetOwner(), folderName, contents_list);
            llInstantMessage(llGetOwner(), "Look in your inventory for a folder called: "
            + folderName + ". This folder contains your Stuff."); // Alert the user.
        }
    }
}// END //
