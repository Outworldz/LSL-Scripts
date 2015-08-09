// :CATEGORY:Weapons
// :NAME:turret
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:08
// :ID:923
// :NUM:1327
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// turret.lsl
// :CODE:

key toucher;
string toucherS;
float SPEED         = 40.0;         
integer LIFETIME    = 7;            
float DELAY         = 0.2;          
vector vel;                          
vector pos;                         
rotation rot;                       
integer in_use;
integer have_permissions = FALSE;   
integer armed = TRUE;               
fire()
{
    
        rot = llGetRot();               
        vel = llRot2Fwd(rot);           
        pos = llGetPos();               
        pos = pos + vel;                
        pos.z += 0.0;                   
        vel = vel * SPEED;              
        llTriggerSound("shoot", 1.0);
        llRezObject("bullet", pos, vel, rot, 1); 
}
default
{
    state_entry()
    {
       in_use = FALSE;        
    }
    touch_start(integer total_number)
    {
        if(in_use == FALSE)
        {
            toucher = llDetectedKey(0);
            llRequestPermissions(toucher, PERMISSION_TAKE_CONTROLS|PERMISSION_TRIGGER_ANIMATION);   
            llSetText("Requesting Permissions", <1,1,1>, 1); 
        }
        if(in_use == TRUE) 
        {
            if(llDetectedKey(0) == toucher)
            {
            llReleaseControls();
            llSensorRemove();
            llSetRot(<-0.00000, -0.00000, 0.70711, 0.70711>);
            llSetText("", <1,1,1>, 1); 
            in_use = FALSE;
            }
        }              
    }
    sensor(integer sense)
    {
        rotation k = llDetectedRot(0);
        llRotLookAt(k, .1, .1);
    }
    no_sensor()
    {
        llReleaseControls();
        llSensorRemove();
        llSetRot(<-0.00000, -0.00000, 0.70711, 0.70711>);
        llSetText("", <1,1,1>, 1); 
        in_use = FALSE;
    }
    run_time_permissions(integer perm)
    {
        if(perm)
        {
            llSetText("", <1,1,1>, 1);
            llTakeControls(CONTROL_ML_LBUTTON, TRUE, FALSE);
            llSensorRepeat("", toucher, AGENT, 20, TWO_PI, .1);
            llSetText("Current User: "+llKey2Name(toucher), <1,1,1>, 1);
            in_use = TRUE;
        }
        else
        {
            in_use = FALSE;
            llSetText("", <1,3,1>, 1);
        }
    }
    control(key name, integer levels, integer edges) 
    {
        if ((levels & CONTROL_ML_LBUTTON) == CONTROL_ML_LBUTTON) 
        {
            fire();
        }
    }
    
}
    
// END //
