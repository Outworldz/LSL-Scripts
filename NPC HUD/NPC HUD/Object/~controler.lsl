// :CATEGORY:NPC
// :NAME:NPC HUD
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:58
// :ID:568
// :NUM:776
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// controller
// :CODE:

// npc control
list lstCrtllMenu = ["Animate","Dance","Come Here","Follow","Force Sit", "Unsit" ];//"Move","Speak",
integer channel = -30;
vector npcPos;
integer listener;
key npc;
string clonetype;

list order_buttons(list buttons)
{
    return llList2List(buttons, -3, -1) + llList2List(buttons, -6, -4) + llList2List(buttons, -9, -7) + llList2List(buttons, -12, -10);
}


default
{
    link_message(integer sender_number, integer number, string msg, key id)
    {
        if (number == 20)
        {
            llDialog(llGetOwner(), "Select control option:", order_buttons(lstCrtllMenu), channel);
            listener = llListen(channel, "", NULL_KEY, "");
            npcPos = llGetPos();
            clonetype=msg;
            npc= id;
            llSetTimerEvent(30.0);
        }
    }

    listen(integer channel, string name, key id, string message)
    {
        llListenRemove(listener);
        llSetTimerEvent(0.0);
        //--------------------------------------
        // main menu results here
        //--------------------------------------
        if (message =="Animate")
            { 
                llMessageLinked(LINK_ROOT,21,clonetype,npc);
            }
        if (message =="Dance")
            { 
                llMessageLinked(LINK_ROOT,22,clonetype,npc);
            }
     if (message =="Come Here")
            { 
                llMessageLinked(LINK_ROOT,23,clonetype,npc);
            }
     if (message =="Follow")
            { 
                llMessageLinked(LINK_ROOT,24,clonetype,npc);
            }
    if (message =="Force Sit")
            { 
                llMessageLinked(LINK_SET,30,clonetype,npc);
                //llSay(0,"30");
            }
    if (message =="Unsit")
            { 
                llMessageLinked(LINK_ROOT,31,clonetype,npc);
            }
    }
    
    timer()
    {
        llListenRemove(listener);
    }
}
