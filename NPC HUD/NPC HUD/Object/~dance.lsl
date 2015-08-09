// :CATEGORY:NPC
// :NAME:NPC HUD
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:58
// :ID:568
// :NUM:777
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// dance
// :CODE:

// npc dance
list lstAnilMenu = ["WeLoveYou","AKEYO","Full of it","Caramel","Kiss my Buttons","Room with a View","Shamo","Dambuster","Everybody Loves Me","Washing Machine","Yipe","Stop"];
integer channel = -32;
vector npcPos;
integer listener;
key npc;
string clonetype;
string curAnim;

list order_buttons(list buttons)
{
    return llList2List(buttons, -3, -1) + llList2List(buttons, -6, -4) + llList2List(buttons, -9, -7) + llList2List(buttons, -12, -10);
}


default
{
    link_message(integer sender_number, integer number, string msg, key id)
    {
        if (number == 22)
        {
            llDialog(llGetOwner(), "Select a Dance:", order_buttons(lstAnilMenu), channel);
            listener = llListen(channel, "", NULL_KEY, "");
            npcPos = llGetPos();
            clonetype=msg;
            npc= id;
            llSetTimerEvent(30.0);
        }
    }

    listen(integer channel, string name, key id, string msg)
    {
        llListenRemove(listener);
        llSetTimerEvent(0.0);
        //--------------------------------------
        // main menu results here
        //--------------------------------------

            if (msg != "Stop")
            {
            string anim = llToLower(msg);
            osAvatarStopAnimation(npc,curAnim);
            curAnim = anim;
            osAvatarPlayAnimation(npc,anim);
        }
        else
        {
            osAvatarStopAnimation(npc,curAnim);
            }
        
        //}

    }
    timer()
    {
        llListenRemove(listener);
    }
}
