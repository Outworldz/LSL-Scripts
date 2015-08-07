// :CATEGORY:NPC
// :NAME:NPC HUD
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:58
// :ID:568
// :NUM:778
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// follow
// :CODE:

// npc follow
list lstFollowMenu = ["Start","Stop"];
integer channel = -34;
integer listener;
key npc;
string clonetype;
vector offset = < 3, 0, 1.0>; //3 meter behind. 1.5 up (bot does seamto walk if not raised a bit


list order_buttons(list buttons)
{
    return llList2List(buttons, -3, -1) + llList2List(buttons, -6, -4) + llList2List(buttons, -9, -7) + llList2List(buttons, -12, -10);
}


default
{
    link_message(integer sender_number, integer number, string msg, key id)
    {
        if (number == 24)
        {
            llDialog(llGetOwner(), "Start/ Stop Following:", order_buttons(lstFollowMenu), channel);
            listener = llListen(channel, "", NULL_KEY, "");
            clonetype=msg;
            npc= id;
            
        }
        else
        {            osNpcStopMoveToTarget(npc) ;
            llSetTimerEvent(0.0);}
        
    }

    listen(integer channel, string name, key id, string msg)
    {
        llListenRemove(listener);
        //
        //--------------------------------------
        // main menu results here
        //--------------------------------------
    if (msg == "Start")
    {
    llSetTimerEvent(1.0);
    }
        if (msg == "Stop")
            {
            osNpcStopMoveToTarget(npc) ;
            llSetTimerEvent(0.0);
            
        }

        
        //}

    }
    timer()
    {
        llSensor("",npc,AGENT,4,PI);
    }
    no_sensor()
    {
        list det = llGetObjectDetails(llGetOwner(),[OBJECT_POS,OBJECT_ROT]);
            // Get position and rotation
            vector pos = llList2Vector(det,0);
            rotation rot = (rotation)llList2String(det,1);
            // use whatever offset you want.
            vector worldOffset = offset;
            // Offset relative to owner needs a quaternion.
            vector avOffset = offset * rot;
            pos += avOffset; 
            osNpcMoveToTarget(npc,pos, OS_NPC_NO_FLY );
    }

}
