// :CATEGORY:Weapons
// :NAME:Popgun
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:00
// :ID:637
// :NUM:866
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Popgun.lsl
// :CODE:

//
//  Popgun
// 

float RECHARGE_TIME = 1.5;
float BASE_POWER = 25.0;

float last_time = 0.0;
vector fwd;
vector pos;
quaternion rot;  
float power = 1.0;
key holder;             //  Key of avatar holding gun 
integer hListen = 0;

integer permissions = FALSE;
integer attached = FALSE;

fire_ball()
{
    //  
    //  Actually fires the ball 
    //  
    rot = llGetRot();
    fwd = llRot2Fwd(rot);
    pos = llGetPos();
    pos = pos + fwd;
    pos.z += 0.75;                  //  Correct to eye point
    fwd = fwd * BASE_POWER*power;
   // llTriggerSound("tube", 1.0);
   // llSay(0, "Boom!");
    llRezObject("webshot", pos, fwd, <0,0,0,1>, 2); 
    last_time = llGetTime();
    llSetTimerEvent(0.1);    
}
hover()
{
    //  
    //  Spin at current position
    // 
    //llTargetOmega(<0,0,1>, 1.0, 0.5);   
}

no_hover()
{
    //llTargetOmega(<0,0,1>, 0.0, 0.5);
}

default
{
    state_entry()
    {
        //llSay(0, "Popgun, v1.0");
        hover();            
    }
    run_time_permissions(integer permissions)
    {
        if (permissions > 0)
        {
  //          llSay(0, "Enter Mouselook to shoot me!");
  
            llSetLinkColor(3, <1,1,0>, -1);
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            permissions = TRUE;
        }
    }
    touch_start(integer total_number)
    {
        if (!attached)
        {
            // 
            //  If clicked and not attached, ask to attach to avatar
            //
            key avatar = llDetectedKey(0);
            key owner = llGetOwner();
            if (owner == avatar)
            {
  //              llSetText("Attach me to your right hand to use", <0,1,0>, 0.5);
                llSleep(1.0);
                llSetText("", <1,1,1>, 1.0);
            }
            else
            {
//                llSetText("$ Buy Me! $", <0,1,0>, 0.5);
                llSleep(1.0);
                llSetText("", <1,1,1>, 1.0);
            }
            return;
        }
        
        llReleaseControls();
        llDetachFromAvatar();   
    }

    attach(key attachedAgent)
    {
        //
        //  If attached/detached from agent, change behavior 
        // 
        if (attachedAgent != NULL_KEY)
        {
          //  llTriggerSound("switch", 1.0);
            if (!permissions)
            {
                llRequestPermissions(attachedAgent, PERMISSION_TAKE_CONTROLS);  
            }
            attached = TRUE;
            no_hover();
        }
        else
        {
//            llTriggerSound("switch", 1.0);
            attached = FALSE;
            llReleaseControls();
            hover();

        }
    }

    control(key name, integer levels, integer edges) 
    {
        if (  ((edges & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON)
            &&((levels & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON) )
        {
            fire_ball();
        }
    }
    timer()
    {
        float current_time = llGetTime();
        if ((current_time - last_time) < RECHARGE_TIME)
        {
            power = (current_time - last_time)/RECHARGE_TIME;
         //   llSetLinkColor(3, <power,power,0>, -1);
        }
        else
        {
            power = 1.0; 
         //   llSetLinkColor(3, <1,1,1>, -1);
            llSetTimerEvent(0.0);
          //  llTriggerSound("splat3",1.0);       // Play sound to indicate 'fully charged'
        }
    }    
}
 // END //
