// :CATEGORY:Vehicles
// :NAME:Copter_new_V1
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:205
// :NUM:279
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Copter (new) V1.lsl
// :CODE:

// change stitarget hight llSitTarget(<-0.5, 0.0, 0.8>, <0,0,0,1>);
//to fit av the Z axis or 0.8 is the hight

float speed=0;
float high=2400;
float turn=25;
float lift=0;
integer sit = FALSE;
integer vertoff = FALSE;
integer adecayoff = FALSE;
integer ldecayoff = FALSE;
string Vname;
key avatar;

help()
{
    llWhisper(0,"Key Actions:");
    llWhisper(0,"Right click and 'Fly' <-- Starts " + Vname);
    llWhisper(0,"Click STAND UP button <-- Stops " + Vname + " and returns contols");
    llWhisper(0,"W or Forward <-- Accelerates or goes faster forwards");
    llWhisper(0,"S or Backwards <-- Accelerates or goes faster backwards");
    llWhisper(0,"E or Page up <-- Gains Hieght");
    llWhisper(0,"C or Page down <-- Loses Hieght");
    llWhisper(0,"A or Left <-- Turns left");
    llWhisper(0,"D or Right <-- Turns right");
}

stuntparams()
{
    llSitTarget(<-0.5, 0.0, 0.6>, <0,0,0,1>); //change hight of av here to stand on
    llSetSitText("Fly");
    llSetCameraEyeOffset(<-10.0, 0.0, 3.0>);
    llSetCameraAtOffset(<0.0, 0.0, 0.0>);
    llSetVehicleType(VEHICLE_TYPE_AIRPLANE);
    llRemoveVehicleFlags(-1);
    // linear friction
    llSetVehicleVectorParam( VEHICLE_LINEAR_FRICTION_TIMESCALE, <1000, .1, 1000> ); // 1000,2,0.5
        
    //  angular friction
    llSetVehicleVectorParam( VEHICLE_ANGULAR_FRICTION_TIMESCALE, <.1, .1, .1> );
    
    // linear motor 
    llSetVehicleVectorParam( VEHICLE_LINEAR_MOTOR_DIRECTION, <0, 0, 0> );
    llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_TIMESCALE, 1.0 );
    llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 3 );
    
    // angular motor 
    llSetVehicleVectorParam( VEHICLE_ANGULAR_MOTOR_DIRECTION, <0, 0, 0> );
    llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, 2.5 );
    llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 6 );
    
    // no hover 
    llSetVehicleFloatParam( VEHICLE_HOVER_HEIGHT, 1 );
    llSetVehicleFloatParam( VEHICLE_HOVER_EFFICIENCY, 0.1 );
    llSetVehicleFloatParam( VEHICLE_HOVER_TIMESCALE, 100 );
    llSetVehicleFloatParam( VEHICLE_BUOYANCY, 1 );
    
    //  linear deflection 
    llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 1 );
    llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 10 );
    
    //  angular deflection 
    llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 1 );
    llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 10 );
        
    //  vertical attractor
    llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, .1 );
    llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 2 );
    
    // banking
    llSetVehicleFloatParam( VEHICLE_BANKING_EFFICIENCY, .5 );//0
    llSetVehicleFloatParam( VEHICLE_BANKING_MIX, 0 );//0
    llSetVehicleFloatParam( VEHICLE_BANKING_TIMESCALE, .1 );//1000
    
    // default rotation of local frame
    llSetVehicleRotationParam( VEHICLE_REFERENCE_FRAME, <0, 0, 0, 1> );
    
    // remove these flags 
    llRemoveVehicleFlags( VEHICLE_FLAG_HOVER_WATER_ONLY 
                          | VEHICLE_FLAG_HOVER_TERRAIN_ONLY 
                          | VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT
                          | VEHICLE_FLAG_LIMIT_ROLL_ONLY
                          | VEHICLE_FLAG_HOVER_UP_ONLY 
                          | VEHICLE_FLAG_LIMIT_MOTOR_UP);    
}

default
{
    state_entry()
    {
        stuntparams();
        Vname=llGetObjectName();
        llSetTimerEvent(0.0);
        llStopSound();
        llSetStatus(STATUS_PHYSICS, FALSE);
        llMessageLinked(LINK_ALL_CHILDREN, 0, "stop", NULL_KEY);
        llWhisper(0,Vname + " is ready for use");
        llWhisper(0,"change sittarget to stand on for diffrent hight avs");
    }
    on_rez(integer start_param)
    {
        llResetScript();
    } 
    touch(integer total_number)
    {
        key owner=llGetOwner();
        if (llDetectedKey(0)==owner)
        {
            help();
        }
        else
        {
            llWhisper(0,llDetectedName(0) + ", Please step away from the " + Vname);
        } 
    }
    changed(integer change)
    {
        avatar = llAvatarOnSitTarget();
        string name=llKey2Name(avatar);
        if(change & CHANGED_LINK)
        {
            if(avatar == NULL_KEY)
            {
                //  You have gotten off
                llSetTimerEvent(0.0);
                llStopSound();
                llMessageLinked(LINK_ALL_CHILDREN, 0, "stop",  NULL_KEY);
                llSetStatus(STATUS_ROTATE_X | STATUS_ROTATE_Y | STATUS_ROTATE_Z, FALSE);
                llReleaseControls();
                llStopAnimation("surf");
                sit = FALSE;
                llPushObject(llGetOwner(), <0, 2, 7>, <0,0,0>, TRUE);
                llSetStatus(STATUS_PHYSICS, FALSE);
                llResetScript();
            }
            else if(avatar == llGetOwner())
            {
                // You have gotten on
                llSetStatus(STATUS_PHYSICS, TRUE);
                llSetStatus(STATUS_ROTATE_X | STATUS_ROTATE_Y | STATUS_ROTATE_Z, TRUE);
                sit = TRUE;
                llRequestPermissions(avatar,PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);
            }
            else
            {
                llWhisper(0,name + ", Please step away from the " + Vname);
                llUnSit(avatar);
            }
        }
    }
    run_time_permissions(integer perms)
    {
        if(perms & (PERMISSION_TAKE_CONTROLS))
        {
            llStopAnimation("sit");
            llStartAnimation("surf");
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT | CONTROL_UP | CONTROL_DOWN, TRUE, FALSE);
            llMessageLinked(LINK_ALL_CHILDREN, 0, "rotor",  NULL_KEY);
            llLoopSound("jet0",0.7);
            llSetTimerEvent(0.2);
        }
        else
        {
            llUnSit(avatar);
        }
    }
    control(key id, integer level, integer edge)
    {
        vertoff = FALSE;
        adecayoff = FALSE;
        ldecayoff = FALSE;
        
        if ((level & CONTROL_FWD) && (level & CONTROL_BACK))
        {
            ldecayoff = TRUE;
            speed=0;
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <speed,0,lift>);       
        }
        
        if (level & CONTROL_FWD)
        {
            ldecayoff = TRUE;
            if(speed > 30) { speed = 30; }
            else { speed += 1; }
            lift= speed * 0.25;
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <speed,0,lift>);       
        }
        
        if (level & CONTROL_BACK)
        {
            ldecayoff = TRUE;
            if(speed < -10) { speed = -10; }
            else { speed -= 1; }
            lift= speed * 0.25;
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <speed,0,lift>);
        }
        
        if (level & CONTROL_ROT_RIGHT)
        {
            adecayoff = TRUE;
            llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <turn,0,0>); 
        }
        
        if (level & CONTROL_ROT_LEFT)
        {
            adecayoff = TRUE;
            llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <-turn,0,0>); 
        }
        
        if (level & CONTROL_RIGHT)
        {
            vertoff = TRUE;
            adecayoff = TRUE; 
            llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <(turn/2),0,0>);    
        }
        
        if (level & CONTROL_LEFT)
        {
            vertoff = TRUE;
            adecayoff = TRUE; 
            llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, <-(turn/2),0,0>); 
        }
        
        if (level & CONTROL_UP)
        {
            ldecayoff = TRUE;
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,0,high>);           
        }
        
        if (level & CONTROL_DOWN)
        {
            
            ldecayoff = TRUE; 
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,0,-(high/3)>);
        }
        
        if (vertoff)
        {
            llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0 );
            llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 1000 );
            llSetVehicleFloatParam( VEHICLE_BANKING_EFFICIENCY, 0 );//0
            llSetVehicleFloatParam( VEHICLE_BANKING_MIX, 0 );//0
            llSetVehicleFloatParam( VEHICLE_BANKING_TIMESCALE, 1000 );//1000
        }
        
        if (!vertoff)
        {
            llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, .1 );
            llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 2 );
            llSetVehicleFloatParam( VEHICLE_BANKING_EFFICIENCY, .5 );//0
            llSetVehicleFloatParam( VEHICLE_BANKING_MIX, 0 );//0
            llSetVehicleFloatParam( VEHICLE_BANKING_TIMESCALE, .1 );//1000
        }
        
        if (adecayoff)
        {
            llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 300 );
            llSetVehicleVectorParam( VEHICLE_ANGULAR_FRICTION_TIMESCALE, <6,6,6> );
        }
        
        if (!adecayoff)
        {
            llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, .2 );
            llSetVehicleVectorParam( VEHICLE_ANGULAR_FRICTION_TIMESCALE, <.1, .1, .1> );
        }
        
        if (ldecayoff)
        {
            llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 30 );
            llSetVehicleVectorParam( VEHICLE_LINEAR_FRICTION_TIMESCALE, <1, 6, 6> );
        }
        
        if (!ldecayoff)
        {
            llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 3 );
            llSetVehicleVectorParam( VEHICLE_LINEAR_FRICTION_TIMESCALE, <1, 2, .05> );
        }

    }
    timer()
    {
        llSetStatus(STATUS_PHYSICS, TRUE);
    }
}// END //
