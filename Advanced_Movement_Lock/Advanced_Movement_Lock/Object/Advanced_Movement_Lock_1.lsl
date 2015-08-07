// :CATEGORY:Defense
// :NAME:Advanced_Movement_Lock
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:15
// :NUM:20
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Stop people from pushing you around
// :CODE:
integer locked;
integer mode;
default
{
    state_entry() 
    { 
        locked = (integer)llGetObjectDesc();
        llListen(0,"",llGetOwner(),"");
        if(llGetObjectDesc() == "on")
        {
            state on;
        }
    } 
    listen(integer channel, string name, key id, string message)
    {
        if(message == ".lon")
        {
            llSetObjectDesc("on");
            state on;
        }    
    }  
}  

state on
{
    on_rez(integer start_param)
    {
        llResetScript();   
    }
    state_entry()
    {
        mode = (integer)llGetObjectDesc();
        llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS);
        llListen(0,"",llGetOwner(),"");
    }
    listen(integer channel, string name, key id, string message)
    {
        if(message == ".loff")
        {
            llStopMoveToTarget();
            llSetObjectDesc("off");
            state default;
        }   
    }
    collision_start(integer num_detected)
    {
        if(locked == 1)
        {
            llApplyImpulse(llGetVel() * -2,FALSE); 
            llPushObject(llDetectedKey(0),llDetectedVel(0) * -5,ZERO_VECTOR,FALSE);         llPushObject(llDetectedKey(0),llDetectedVel(0) * -5,ZERO_VECTOR,FALSE);
        }
    }
    run_time_permissions(integer perm)
    {
        if(perm) 
        { 
            llTakeControls(CONTROL_LEFT | CONTROL_RIGHT | CONTROL_FWD| CONTROL_BACK|CONTROL_UP|CONTROL_DOWN,TRUE,TRUE);
            locked = 1;
            llMoveToTarget(llGetPos(),0.05);  
        }
    }
    control(key id, integer levels, integer edge)
    {
        if(llGetAgentInfo(llGetOwner()) != (AGENT_FLYING|AGENT_IN_AIR))
        {
            if(((levels & CONTROL_FWD) == CONTROL_FWD))
            {
                locked = 0;
                llStopMoveToTarget();
            } 
            else if ( ((levels & CONTROL_RIGHT) == CONTROL_RIGHT)) 
            {
                locked = 0;
                llStopMoveToTarget();
            }
            else if ( ((levels & CONTROL_UP) == CONTROL_UP)) 
            {
                locked = 0;
                llStopMoveToTarget();
                llSleep(4);
            }
            else if ( ((levels & CONTROL_DOWN) == CONTROL_DOWN)) 
            {
                locked = 0;
                llStopMoveToTarget();
            }
            else if ( ((levels & CONTROL_FWD) == CONTROL_FWD)) 
            {
                locked = 0;
                llStopMoveToTarget();
            }
            else if ( ((levels & CONTROL_BACK) == CONTROL_BACK)) 
            {
                locked = 0;
                llStopMoveToTarget();
            }
            else
            {
                locked = 1;
                llMoveToTarget(llGetPos(),0.05);   
            }
        }
    }
}
