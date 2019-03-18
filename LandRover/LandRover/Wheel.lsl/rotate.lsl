// :CATEGORY:Vehicle
// :NAME:LandRover
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:56
// :ID:459
// :NUM:620
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// opensim wheel script
// :CODE:

default
{
    state_entry()
    {
        llSetPrimitiveParams([PRIM_MATERIAL, PRIM_MATERIAL_GLASS]);
        llTargetOmega(<0,0,0>,0.0,1);
    }
    
    on_rez(integer p)
    {
        llResetScript();
    }
    
    link_message(integer n, integer channel, string msg, key id)
    {
        //llOwnerSay(msg);
        if (msg == "F")
        {
            llTargetOmega(<0,1,0>,2.0,1);
        }
        else if (msg == "R")
        {
            llTargetOmega(<0,-1,0>,2.0,1);
        }
        else if (msg == "S")
        {
            llTargetOmega(<0,0,0>,0.0,1);
        }
    }
}
