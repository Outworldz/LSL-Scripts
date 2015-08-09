// :CATEGORY:Animation
// :NAME:Ground_Collision_Protector
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:364
// :NUM:497
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Ground_Collision_Protector
// :CODE:
default
{
    state_entry()
    {
        llSetTimerEvent(0.05);
    }
    timer()
    {
        llSetText("",<0,0,0>,0.0);
        vector halfourheight = (llGetAgentSize(llGetOwner()) / 2);
        vector ourpos = llGetPos();
        vector v;
         vector velocity = llGetVel();
        if(ourpos.z <= llGround(v) + halfourheight.z + 2.5 && ourpos.z > llGround(v) + halfourheight.z + 1 && 

velocity.z < (-10) && llGetAgentInfo(llGetOwner()) & AGENT_IN_AIR)
        {
            llApplyImpulse(<0,0,velocity.z * -1.0>,FALSE);
            llSleep(3.0);
        }
    }
}
