// :CATEGORY:Halloween
// :NAME:Broomsticks
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:49
// :ID:119
// :NUM:180
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// flight script
// :CODE:

// Cubey Terra Helicopter Style Flight script

// Do not delete these script credits! If you modify this script, *add* your name and date and make your work available in Public Domain.

// * Portions based on a public-domain flight script from Jack Digeridoo.
// * Portions based on hoverboard script by Linden Lab.
// * Nov 30, 2003 - Significant modifications and additions by Cubey Terra... (apologies for the crappy indenting). -CT
// * Jan 11, 2004 - Fixed listen bug. Thanks to Trimming Hedges for the solution. -TH
// * March 27, 2004 - Adapted to work as helicopter-style vehicle -CT
// * April 8, 2004 - Adapted to work as U-Fly Taxi -CT
// * April 15, 2004 - Adapted to work as DIY helicopter script -CT
// * ???, 2004 - Adapted to work as magic carpet. -CT
// * April 10, 2006 - Released to public. Tidied some code. Added beacon. Allowed anyone to pilot, no longer keyed to owner. -CT
// modified to be a borrom - Fred Beckhusen (Ferd Frederix)

integer sit = FALSE;

integer brake = TRUE;


float X_THRUST = 20;
float Z_THRUST = 15;

float xMotor;
float zMotor;

key agent;
key pilot;

vector SIT_POS = <0.25, 0.0, 0.65>; 
vector CAM_OFFSET = <-5.0, 0.0, 2.0>;
vector CAM_ANG = <0.0, 0.0, 2.0>;


help()
{
            llWhisper(0,"O Master of the broom, you may use these commands to fly me...");
            llWhisper(0,"  PgUp/PgDn or E/C = hover up/down");
            llWhisper(0,"  Arrow keys or WASD = forward, back, left, right");
            llWhisper(0,"  Say HELP to display help.");
}

 
default {
    state_entry() 
    {        
        llSetSitText("Fly");
        llSitTarget(SIT_POS, ZERO_ROTATION);
        llSetCameraEyeOffset(CAM_OFFSET);
        llSetCameraAtOffset(CAM_ANG);
        llCollisionSound("",0.0);        
        
        
        //SET VEHICLE PARAMETERS
        llSetVehicleType(VEHICLE_TYPE_AIRPLANE);
        
        llSetVehicleVectorParam( VEHICLE_LINEAR_FRICTION_TIMESCALE, <200, 20, 20> );
        
            
        // uniform angular friction 
        llSetVehicleFloatParam( VEHICLE_ANGULAR_FRICTION_TIMESCALE, 2 );
        
        // linear motor
        llSetVehicleVectorParam( VEHICLE_LINEAR_MOTOR_DIRECTION, <0, 0, 0> );
        llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_TIMESCALE, 2 );
        llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 120 );
        
        // agular motor
        llSetVehicleVectorParam( VEHICLE_ANGULAR_MOTOR_DIRECTION, <0, 0, 0> );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0 ); 
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, .4);
        
        // hover 
        llSetVehicleFloatParam( VEHICLE_HOVER_HEIGHT, 2 );
        llSetVehicleFloatParam( VEHICLE_HOVER_EFFICIENCY, 0 ); 
        llSetVehicleFloatParam( VEHICLE_HOVER_TIMESCALE, 10000 );
        llSetVehicleFloatParam( VEHICLE_BUOYANCY, 0.977 );
        
        // no linear deflection 
        llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0 );
        llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 5 ); 
        
        // no angular deflection 
        llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0);
        llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 5);
            
        // no vertical attractor 
        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 1 );
        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 1 );
        
        // banking
        llSetVehicleFloatParam( VEHICLE_BANKING_EFFICIENCY, 1);
        llSetVehicleFloatParam( VEHICLE_BANKING_MIX, .5);
        llSetVehicleFloatParam( VEHICLE_BANKING_TIMESCALE, 0.01);
        
        
        // default rotation of local frame
        llSetVehicleRotationParam( VEHICLE_REFERENCE_FRAME, <0,0,0,1>);
        
        // remove these flags 
        llRemoveVehicleFlags( VEHICLE_FLAG_NO_DEFLECTION_UP 
                              | VEHICLE_FLAG_HOVER_WATER_ONLY
                              | VEHICLE_FLAG_LIMIT_ROLL_ONLY 
                              | VEHICLE_FLAG_HOVER_TERRAIN_ONLY 
                              | VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT 
                              | VEHICLE_FLAG_HOVER_UP_ONLY 
                              | VEHICLE_FLAG_LIMIT_MOTOR_UP );

    }
    
    on_rez(integer num) 
    {
        llSetStatus(STATUS_PHYSICS, FALSE);
        pilot = llGetOwner();
        llSetTimerEvent(300); // death timer
    } 
    

  

    // DETECT AV SITTING/UNSITTING AND GIVE PERMISSIONS
    changed(integer change)
    {
       agent = llAvatarOnSitTarget();
       if(change & CHANGED_LINK)
       {
           if((agent == NULL_KEY) && (sit))
           {
               //
               //  Avatar gets off vehicle 
               // 
               llSetStatus(STATUS_PHYSICS, FALSE);
               llStopAnimation("broomsit2");
               llMessageLinked(LINK_SET, 0, "unseated", "");
               llStopSound();
               llReleaseControls();
               sit = FALSE;
           }
           else if ((agent == llGetOwner()) && (!sit))
           {
               //  
               // Avatar gets on vehicle
               //
               pilot = llAvatarOnSitTarget();
               sit = TRUE;
               llRequestPermissions(pilot, PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION);

               llWhisper(0,"O Master of the Broom, "+llKey2Name(pilot)+", command me as you will. Should you need assistance, please speak the word HELP.");           
               llMessageLinked(LINK_SET, 0, "seated", "");
           }
           
           
        }
    }



   //CHECK PERMISSIONS AND TAKE CONTROLS
    run_time_permissions(integer perm) 
    {
        if (perm & (PERMISSION_TAKE_CONTROLS)) 
        {            
            llTakeControls(CONTROL_UP | CONTROL_DOWN | CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);
        }
        if (perm & PERMISSION_TRIGGER_ANIMATION)
        {
            llStartAnimation("broomsit2");
            llStopAnimation("sit");
        }
    }
    
            
            

            
    //FLIGHT CONTROLS     
    control(key id, integer level, integer edge) 
    {

        vector angular_motor; 
            

        if ((level & CONTROL_FWD) || (level & CONTROL_BACK))
        {
            if (edge & CONTROL_FWD) xMotor = X_THRUST;
            if (edge & CONTROL_BACK) xMotor = -X_THRUST;
        } 
        else
        {                 
            xMotor = 0;
        }
        
        
        if ((level & CONTROL_UP) || (level & CONTROL_DOWN))
        {
            if (level & CONTROL_UP) 
            {                    
                zMotor = Z_THRUST;
            }   
            if (level & CONTROL_DOWN) 
            {
                zMotor = -Z_THRUST;
            }
        }
        else
        {
            zMotor = 0;
        }            
            
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <xMotor,0,zMotor>);


                
        if (level & CONTROL_RIGHT) {
            angular_motor.x = TWO_PI;
            angular_motor.y /= 8;
        }   
        if (level & CONTROL_LEFT) {
            angular_motor.x = -TWO_PI;
            angular_motor.y /= 8;
        }
        
        if (level & CONTROL_ROT_RIGHT) {            
            angular_motor.x = TWO_PI;
            angular_motor.y /= 8;
        }
        
        if (level & CONTROL_ROT_LEFT) {
            angular_motor.x = -TWO_PI;
            angular_motor.y /= 8;
        }
         
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);
    }    

    timer()
    {
        llDie();
    }
}

