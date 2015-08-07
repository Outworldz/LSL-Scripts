// :CATEGORY:NPC
// :NAME:NPC HUD
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:58
// :ID:568
// :NUM:774
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// clone
// :CODE:

// npc sit
list sitbuttons;
float scanrange=10;
string sitprompt = "Pick the object on which you want the clone to sit.  If it's not in the list, have the clone move closer and try again.\n";
list sitkeys;
integer channel= -21;
integer listener;
key npc;
string clonetype;


list order_buttons(list buttons)
{
    return llList2List(buttons, -3, -1) + llList2List(buttons, -6, -4) + llList2List(buttons, -9, -7) + llList2List(buttons, -12, -10);
}

default
{
    
    listen(integer channel, string name, key id, string message)
    {
        llListenRemove(listener);
        llSetTimerEvent(0.0);
        integer seatnum = (integer)message - 1 ;
        osNpcSit(npc, llList2String(sitkeys, seatnum),OS_NPC_SIT_NOW);

    }
    link_message(integer sender_number, integer number, string msg, key id)
    { 
        if (number == 30)
        {
            clonetype=msg;
            npc= id;
            llSensor("", NULL_KEY, SCRIPTED, scanrange, PI);
        }
        if (number == 31)
        {
            osNpcStand(id);
            sitkeys = [];
            sitbuttons = [];
            llMessageLinked(LINK_ROOT,99,"",npc);
        }
    }
    sensor(integer num)
    {
        sitkeys = [];
        sitbuttons = [];
        //give menuuser a list of things to choose from
        //lop the list off at 11 so we don't need multipage menu
        if (num > 12)
        {
            num = 12;
        }
        integer n;
        for (n = 0; n < num; n ++)
        {
            //don't add things named "Object"
            string name = llDetectedName(n);
            if (name != "Object")
            {
                sitbuttons += [(string)(n + 1)];
                if (llStringLength(name) > 44)
                {   //added to prevent errors due to 512 char limit in poup prompt text
                    name = llGetSubString(name, 0, 40) + "...";
                }
                sitprompt += "\n" + (string)(n + 1) + " - " + name;
                sitkeys += [llDetectedKey(n)];
            }
        }
        //prompt can only have 512 chars
        while (llStringLength(sitprompt) >= 512)
        {
            //pop the last item off the buttons, keys, and prompt
            sitbuttons = llDeleteSubList(sitbuttons, -1, -1);
            sitkeys = llDeleteSubList(sitkeys, -1, -1);
            sitprompt = llDumpList2String(llDeleteSubList(llParseString2List(sitprompt, ["\n"], []), -1, -1), "\n");
        }
        llDialog(llGetOwner(), sitprompt, order_buttons(sitbuttons), channel);
        listener = llListen(channel, "", llGetOwner(), "");
        llSetTimerEvent(30.0);

    }
    no_sensor()
    {
        //nothing close by to sit on, tell menuuser
        llInstantMessage(llGetOwner(), "Unable to find sit targets.");
    }
    timer()
    {
        llListenRemove(listener);
        llSetTimerEvent(0.0);
        
    }



}
