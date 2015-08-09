// :CATEGORY:Flight Assist
// :NAME:Final_Flight_2
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:300
// :NUM:399
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Final Flight 2.lsl
// :CODE:

float speed=10000;

default
{ 
    attach(key on)
    {
        if (on != NULL_KEY)
        {
            llListen(0,"",llGetOwner(),"");
            integer perm = llGetPermissions();
            if (perm != (PERMISSION_TAKE_CONTROLS))
            {
                llRequestPermissions(on, PERMISSION_TAKE_CONTROLS);
            }
            else
            {
                llTakeControls(CONTROL_FWD , TRUE, TRUE);
            }
        }
    }
    
    listen(integer channel, string name, key id, string m)
    {
        list test = llCSV2List(m);
        if(llGetListLength(test)==2&&llList2String(test,0)=="speed")
            speed=llList2Float(test,1);
    }

    run_time_permissions(integer perm)
    {
        if (perm)
        {
            llTakeControls(CONTROL_FWD, TRUE, TRUE);
        }
    }
    
    control(key owner, integer level, integer edge)
    {
        if (!(level & CONTROL_FWD) || !(llGetAgentInfo(llGetOwner())&AGENT_FLYING))
        {
            llSetForce(<0,0,0>, FALSE);
        }
        else
        {
            vector fwd= llRot2Fwd(llGetRot());
            fwd = llVecNorm(fwd);
            fwd *= speed;
            llSetForce(fwd, FALSE);
        }
    }

}// END //
