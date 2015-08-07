// :CATEGORY:Weapons
// :NAME:Shoot
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:02
// :ID:746
// :NUM:1029
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Shoot.lsl
// :CODE:

vector fwd;
vector pos;
rotation rot;  
float power = 1.0;
key holder;
float bulletspeed = 100;

vector centerpos;             //  Key of avatar holding gun 

integer attached = FALSE;  
integer permissions = FALSE;

fire_ball()
{
    //  
    //  Actually fires the ball 
    //  
    rot = llGetRot();
    fwd = llRot2Fwd(rot);
    pos = llGetPos();
    pos = pos + fwd;
    //pos.z += 0.75;                  //  Correct to eye point
    pos.z += 0.85;
    fwd = fwd * bulletspeed;
    llRezObject("Bullet", pos, fwd, rot, 0);
}

default
{
   state_entry()
   {
        llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS | PERMISSION_ATTACH); 
    }
     on_rez(integer param)
    {
        //to deal with stack heap collision on re-rez
        llResetScript();
         
    }
    
    run_time_permissions(integer permissions)
    {
        if (permissions > 0)
        {
            //llSay(0, "KILL KILL KILL!");

            if (!attached)
            {
                llAttachToAvatar(ATTACH_RHAND);
            }
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            llStartAnimation("hold_R_handgun");
            attached = TRUE;
            permissions = TRUE;
        }
    }

    attach(key attachedAgent)
    {
        //
        //  If attached/detached from agent, change behavior 
        // 
        if (attachedAgent != NULL_KEY)
        {
            attached = TRUE;
            
            if (!permissions)
            {
                llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS | PERMISSION_ATTACH);   
            }
            
        }
        else
        {
           
            attached = FALSE;
            llStopAnimation("hold_R_handgun");
            llReleaseControls();
           

        }
    }

    control(key name, integer levels, integer edges) 
    {
        if (  ((edges & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON)
            &&((levels & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON) )
        {
            {
                fire_ball();
            }
         
        }
    }
  
}// END //
