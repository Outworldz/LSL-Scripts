// :CATEGORY:NPC
// :NAME:NPC HUD
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:58
// :ID:568
// :NUM:773
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// animator
// :CODE:

// npc animator
list lstAnilMenu = ["Nadu","Beauty","Bracelets","Cutie","Kneel","NaduWide","Submit", "Tower" , "Whip", "Chain", "Bara", "Stop"];
integer channel = -31;
vector npcPos;
integer listener;
key npc;
string clonetype;
string curAnim;

list order_buttons(list buttons)
{
    return llList2List(buttons, -3, -1) + llList2List(buttons, -6, -4) + llList2List(buttons, -9, -7) + llList2List(buttons, -12, -10);
}

rotation getRotToPointAxisAt(vector axis)
{
    return llGetRot() * llRotBetween(axis * osNpcGetRot(npc),  llGetPos()- osNpcGetPos(npc) );
}

default
{
    link_message(integer sender_number, integer number, string msg, key id)
    {
        if (number == 21)
        {
            llDialog(llGetOwner(), "Select an Animation:", order_buttons(lstAnilMenu), channel);
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
            
            rotation tempRot = getRotToPointAxisAt(<0,0,1>);
            
            //osNpcSetRot(npc, llGetRot() * (llEuler2Rot(<0, 0, 0> * DEG_TO_RAD)));
            osNpcSetRot(npc,tempRot) ;
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
