// :CATEGORY:NPC
// :NAME:NPC HUD
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:58
// :ID:568
// :NUM:780
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Recall
// :CODE:

list lstRecallMenu = ["Bunny T","Latex Slut","Barbosa","Whitey","3A", "Voodoo", "Vanessa", "White 06"];
integer channel = -20;
vector npcPos;
integer listener;
key npc;

list order_buttons(list buttons)
{
    return llList2List(buttons, -3, -1) + llList2List(buttons, -6, -4) + llList2List(buttons, -9, -7) + llList2List(buttons, -12, -10);
}

default
{
    link_message(integer sender_number, integer number, string message, key id)

    {
        if (number == 10)
        {
            llDialog(id, "Select the clone you want to create?", order_buttons(lstRecallMenu), channel);
            listener = llListen(channel, "", NULL_KEY, "");
            npcPos = llGetPos() + <3,0,0>;
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
        if (channel == channel)
        {
            if (message =="Bunny T")
            { 
                npc = osNpcCreate("Bunneh","Fuckme", npcPos, "BunnyT");
                llMessageLinked(LINK_ROOT,99,"Bunny T",npc);
                llMessageLinked(LINK_ALL_CHILDREN,1,"green",npc);
            }
            if (message =="Latex Slut")
            { 
                npc = osNpcCreate("Your","LSlut", npcPos, "LatexSlut");
                llMessageLinked(LINK_ROOT,99,"LatexSlut",npc);
                llMessageLinked(LINK_ALL_CHILDREN,1,"green",npc);
            }
            if (message =="Barbosa")
            { 
                npc = osNpcCreate("Barbosa","Aardvark", npcPos, "Barbosa");
                llMessageLinked(LINK_ROOT,99,"Barbosa",npc);
                llMessageLinked(LINK_ALL_CHILDREN,1,"green",npc);
            }
            if (message =="Whitey")
            { 
                npc = osNpcCreate("Whitey","Aardvark", npcPos, "Whitey Basic 02");
                llMessageLinked(LINK_ROOT,99,"Whitey Basic 02",npc);
                llMessageLinked(LINK_ALL_CHILDREN,1,"green",npc);
            }
            if (message =="3A")
            { 
                npc = osNpcCreate("Aaacky","Aardvark", npcPos, "yo");
                llMessageLinked(LINK_ROOT,99,"yo",npc);
                llMessageLinked(LINK_ALL_CHILDREN,1,"green",npc);
            }
            if (message =="Voodoo")
            { 
                npc = osNpcCreate("Voodoo","Aardvark", npcPos, "voodoo");
                llMessageLinked(LINK_ROOT,99,"voodoo",npc);
                llMessageLinked(LINK_ALL_CHILDREN,1,"green",npc);
            }
            if (message =="Vanessa")
            { 
                npc = osNpcCreate("Vanessa","Aardvark", npcPos, "Vanessa");
                llMessageLinked(LINK_ROOT,99,"Vanessa",npc);
                llMessageLinked(LINK_ALL_CHILDREN,1,"green",npc);
            }
            if (message =="White 06")
            { 
                npc = osNpcCreate("White","Aardvark", npcPos, "White 06");
                llMessageLinked(LINK_ROOT,99,"White 06",npc);
                llMessageLinked(LINK_ALL_CHILDREN,1,"green",npc);
            }
        }
    }
    timer()
    {
        llListenRemove(listener);
    }

}
