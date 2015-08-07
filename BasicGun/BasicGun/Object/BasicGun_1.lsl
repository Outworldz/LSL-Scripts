// :CATEGORY:Weapons
// :NAME:BasicGun
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:83
// :NUM:110
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// BasicGun
// :CODE:
// From the book:
//
// Scripting Recipes for Second Life
// by Jeff Heaton (Encog Dod in SL)
// ISBN: 160439000X
// Copyright 2007 by Heaton Research, Inc.
//
// This script may be freely copied and modified so long as this header
// remains unmodified.
//
// For more information about this book visit the following web site:
//
// http://www.heatonresearch.com/articles/series/22/

float SPEED         = 80.0;         
integer LIFETIME    = 7;                                               
float DELAY         = 0.2;          
vector vel;                         
vector pos;                         
rotation rot;                       
integer have_permissions = FALSE;                                                                            
integer armed = TRUE;               

string bulletName = "bullet";
                                    

fire()
{
    if (armed)
    {
        armed = FALSE;
        rot = llGetRot();               
        vel = llRot2Fwd(rot);           
        pos = llGetPos();               
        pos = pos + vel;                
        pos.z += 0.75;                  
                                        
        vel = vel * SPEED;               
        
        llTriggerSound("shoot", 1.0); 
        llRezObject(bulletName, pos, vel, rot, LIFETIME); 
                    
        llSetTimerEvent(DELAY);         
    }
}

default
{
    state_entry()
    {
        if (!have_permissions) 
        {
            llRequestPermissions(llGetOwner(),  
                PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS);   
        }
    }
    on_rez(integer param)
    {
        llPreloadSound("shoot");       
    }

     run_time_permissions(integer permissions)
    {
        if (permissions == PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS)
        {
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            llStartAnimation("hold_R_handgun");
            have_permissions = TRUE;
        }
    }

    attach(key attachedAgent)
    { 
        if (attachedAgent != NULL_KEY)
        {
            llRequestPermissions(llGetOwner(),  
                PERMISSION_TRIGGER_ANIMATION| PERMISSION_TAKE_CONTROLS);   
        }
        else
        {
            if (have_permissions)
            {
                llStopAnimation("hold_R_handgun");
                llStopAnimation("aim_R_handgun");
                llReleaseControls();
                llSetRot(<0,0,0,1>);
                have_permissions = FALSE;
            }
        }
    }

    control(key name, integer levels, integer edges) 
    {
        if (  ((edges & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON)
            &&((levels & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON) )
        {
            fire();
        }
    }
    
    timer()
    {
        llSetTimerEvent(0.0);
        armed = TRUE;
    }
  
}
 
