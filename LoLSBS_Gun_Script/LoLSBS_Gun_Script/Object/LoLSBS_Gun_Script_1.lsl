// :CATEGORY:Weapons
// :NAME:LoLSBS_Gun_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:491
// :NUM:658
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// LoLSBS Gun Script.lsl
// :CODE:

//This is a free script designed to be used with the Lance of Longinus Shield Breaker System.

//SETUP:
string firesound = ""; //Type the name of the sound you would like to use when firing between the "".
integer customanimation = FALSE; //Change to true to use a custom animation.
string customname = ""; //Type the name of the animation between the "".
integer handgun = TRUE; //If you are not using a custom animation, set to TRUE to use a default handgun animation. Set to FALSE to use a default rifle animation.
float firingpause = 1.0; //The pause in seconds between firing bullets.
integer fullauto = TRUE; //Set true to if you want the gun to fire as long as the button is held down, or set to false if you want the user to click for each shot.
integer multibullet = FALSE; //Set to TRUE to enable multi bullet. This allows the user to put in multiple bullets, and change them by clicking on the gun. The user must name the bullets Bullet1, Bullet2, Bullet3 and so on for all of the bullets.
//END SETUP



integer attached = FALSE;  
integer permissions = FALSE;
float pausetimer = 0.0;
vector  eye = <0.0, 0.0, 0.84>;
integer bullet = 1;



fire()
{
    rotation rot = llGetRot();
    vector fwd = llRot2Fwd(rot);
    vector pos = llGetPos() + eye;
    fwd *= 5;
    llTriggerSound(firesound, 1.0);
    if (multibullet)
    {
        llRezObject("Bullet" + (string)bullet, pos, fwd, rot, 0);
    }
    else
    {
        llRezObject("Bullet", pos, fwd, rot, 0);
    }
    pausetimer = llGetTime() + firingpause;
}


default
{
    state_entry()
    {
        llRequestPermissions(llGetOwner(),  PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS | PERMISSION_ATTACH); 
        llPreloadSound(firesound);
        vector size = llGetAgentSize(llGetOwner());
        eye.z = eye.z * (size.z / 2.0);
        if (multibullet)
        {
            if (llGetInventoryType("Bullet1") == -1)
            {
                llSay(0, "ERROR! Bullet1 not found! Turning off Multi bullet support!");
                multibullet = FALSE;
            }
        }
            
    }

    on_rez(integer param)
    {
        llResetScript();
    }
    
     run_time_permissions(integer permissions)
    {
        if (permissions > 0)
        {

            if (!attached)
            {
                llAttachToAvatar(ATTACH_RHAND);
            }
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            if (customanimation)
            {
                llStartAnimation(customname);
            }
            else if (handgun)
            {
                llStartAnimation("hold_R_handgun");
            }
            else
            {
                llStartAnimation("hold_R_rifle");
            }
            
            attached = TRUE;
            permissions = TRUE;
        }
    }
    
    attach(key attachedAgent)
    {

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
            if (customanimation)
            {
                llStopAnimation(customname);
            }
            else if (handgun)
            {
                llStopAnimation("hold_R_handgun");
            }
            else
            {
                llStopAnimation("hold_R_rifle");
            }
            llReleaseControls();
           

        }
    }

    control(key name, integer levels, integer edges) 
    {
        if (  ((levels & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON))
        {
            if (fullauto)
            {
                {
                    if (llGetTime() > pausetimer)
                    {
                        fire();
                    }
                }
            }
            else if ((levels & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON)
            {
                {
                    if (llGetTime() > pausetimer)
                    {
                        fire();
                    }
                }
            }
        }
    }
    
    touch_start(integer num_detected)
    {
        if (multibullet)
        {
            if (llGetInventoryType("Bullet" + (string)(bullet +1)) != -1)
            {
                bullet = bullet + 1;
            }
            else
            {
                bullet = 1;
            }
            llSay(0, "Now using bullet number " + (string)bullet);
        }
    }         
}
// END //
