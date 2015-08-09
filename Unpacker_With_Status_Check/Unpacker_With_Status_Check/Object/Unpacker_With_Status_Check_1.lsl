// :CATEGORY:Inventory Giver
// :NAME:Unpacker_With_Status_Check
// :AUTHOR:Bastian McConach
// :CREATED:2013-04-19 21:42:57.627
// :EDITED:2013-09-18 15:39:08
// :ID:937
// :NUM:1347
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The only things you'll need to change are the creator_key and a few strings. After replacing the blank key with your own, use the search function to find and replace "Creator Name" with your own name and "Creator's" with your first name.// // Find: Creator Name// Replace With: Bastian McConach// Find: Creator's
// Replace With: Bastian's
// 
// After doing so, drop this script into your choice of packaged product and you're good to go. When your customer rezzes your product out, they will be presented with a menu that allows them to unpack their product or check your online status.
// 
// I've adjusted the online status messages to my needs, letting the customer know to use a notecard if I'm offline or an IM if I'm on, as well as indicating that they should do so before I begin work on my next project. Feel free to customize this as you wish!
// 
// Please feel free to use this in your products, but do not sell it. This script was pieced together for my use and I've had quite a few people ask for it, so I've decided to share it. All I ask is that you point others to this location should they ask you about it and to not sell this script, even if for only L$1.
// 
// Thanks and I hope you find this useful!
// :CODE:
integer menu_handler;
integer menu_channel;
key creator_key = "00000000-0000-0000-0000-000000000000";
key creator_query;
key owner;
string creator_status;

menu(key user,string title,list buttons)
{
    menu_channel = (integer)(llFrand(99999.0) * -1);
    menu_handler = llListen(menu_channel,"","","");
    llDialog(user,title,buttons,menu_channel);
    llSetTimerEvent(30.0);
}

default
{
    on_rez(integer times)
    {
        creator_query = llRequestAgentData(creator_key, DATA_ONLINE);
        owner = llGetOwner();
        menu(owner,"Thank you for your purchase!\n\nUnpack - Give a folder with your purchase\nStatus - Check if Creator's online.",["Unpack","Status"]);
    }

    state_entry()
    {
        creator_query = llRequestAgentData(creator_key, DATA_ONLINE);
        owner = llGetOwner();
    }

    timer()
    {
        llSetTimerEvent(0.0);
        llListenRemove(menu_handler);
    }

    listen(integer channel,string name,key id,string message)
    {
        if (channel == menu_channel)
        {
            if (message == "Unpack")
            {
                list contents_list;
                string contents_name;
                integer contents_num = llGetInventoryNumber(INVENTORY_ALL);
                string folderName = llGetObjectName();
                integer i;        
                for (i = 0; i < contents_num; ++i)
                {
                    contents_name = llGetInventoryName(INVENTORY_ALL, i);
                    contents_list += contents_name;
                }
                i = llListFindList(contents_list, [llGetScriptName()]);
                contents_list = llDeleteSubList(contents_list, i, i);
                llGiveInventoryList(llGetOwner(), folderName, contents_list);
                if (creator_status == "online")
                {
                    llInstantMessage(llGetOwner(), "Look in your inventory for a folder called \"" + folderName + "\". This folder contains your purchase. If you have any problems, please don't hesitate to contact Creator Name. They're online at the moment, so send them an IM before they dive into their next project!");
                }
                else if (creator_status == "offline")
                {
                    llInstantMessage(llGetOwner(), "Look in your inventory for a folder called \"" + folderName + "\". This folder contains your purchase. If you have any problems, please don't hesitate to contact Creator Name. They're not online at the moment, so you should send them a notecard before their deliveries cap!");
                }
            }
            else if (message == "Status")
            {
                creator_query = llRequestAgentData(creator_key, DATA_ONLINE);
                if (creator_status == "online")
                {
                    llInstantMessage(owner, "Creator Name is online at the moment. If you need assistance, be sure to IM them before they begin work on their next project!");
                }
                else if (creator_status == "offline")
                {
                    llInstantMessage(owner, "Creator Name is offline at the moment. If you need assistance, drop a notecard on them and they'll get back to you before they begin work on their next project!");
                }   
            }
        }
    }

    touch_start(integer total_number)
    {
        owner = llGetOwner();
        if (llDetectedKey(0) == owner)
        {
            menu(owner,"Thank you for your purchase!\n\nUnpack - Give a folder with your purchase\nStatus - Check if Creator's online.",["Unpack","Status"]);
        }
        else
        {
            llInstantMessage(llDetectedKey(0), "Sorry, but this package isn't yours! If you really want one of your own, check out Creator Name's store!");
        }
    }

    dataserver(key queryid, string data)
    {
        if (creator_query == queryid)
        {
            if ( data == "1" ) 
            {
                creator_status = "online";
            }
            else if (data == "0")
            {
                creator_status = "offline";
            }
        }
    }
}
