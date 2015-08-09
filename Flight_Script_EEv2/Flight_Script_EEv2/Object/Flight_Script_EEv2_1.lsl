// :CATEGORY:Vehicles
// :NAME:Flight_Script_EEv2
// :AUTHOR:Cubey Terra
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:320
// :NUM:428
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Flight Script EEv2.lsl
// :CODE:

// Modified from Cubey Terra DIY Plane 1.0 by Eoin Widget and Kerian Bunin
// which was originaly marked as September 10, 2005

// Distribute freely. Go ahead and modify it for your own uses. Improve it and share it around.
// Some portions based on the Linden airplane script originall posted in the forums.

// ** Last Modified by Eoin Widget on March 26, 2006 **
// Start up of the plane is now controled by typing the word "start" and shutting it down is is handled by typing stop
//It also taxies around on the ground or even on a elivated prim runway.
//It uses collision detection when on a prim runway and aswell as ground detection when on the ground.
//It uses a count down value in the timer to smooth out the transition between the two modes so that it doesn't switch back and forth while on the ground ebetween the times it detects a collision.  To change to ammount of time for this timer change the value of onGroundStartTime.
integer onGroundStartTime = 2; //Timer for switching between ground movement and airmovement originaly set to 2
vector pos;
vector objectPos;
integer onGround = FALSE;
integer onGroundNext = 0;
integer subGround = 0;


// llSitTarget parameters:
vector avPosition = <0.0,0.0,-0.6>;//<0.0,0.0,-0.6>; // position of avatar in plane, relative to parent
rotation avRotation = <0,-0.2,0,1>;//<0,-0.2,0,1>; // rotation of avatar, relative to parent

//distance threashhold above ground when the aircraft we turn like a car or bank like a plane, if below this distance it will turn like a car
float groundDistance = 5.0;

// Thrust variables:
// thrust = fwd * thrust_multiplier
// Edit the maxThrottle and thrustMultiplier to determine max speed.
integer fwd; // this changes when pilot uses throttle controls
integer maxThrottle = 10; // Number of "clicks" in throttle control. Arbitrary, really.
integer thrustMultiplier = 3; // Amount thrust increases per click.

// Lift and speed
float cruiseSpeed = 25.0; // speed at which plane achieves full lift
float lift;
float liftMax = 0.977; // Maximum allowable lift
float speed;

float timerFreq = 0.5;

integer fwdLast; 
integer sit;
key owner;

integer startUp = FALSE;
integer camon = FALSE;

// Defining the Parameters of the normal driving camera.
// This will let us follow behind with a loose camera.
list drive_cam =
[
        CAMERA_ACTIVE, TRUE,
        CAMERA_BEHINDNESS_ANGLE, 0.0,
        CAMERA_BEHINDNESS_LAG, 0.5,
        CAMERA_DISTANCE, 10.0,//3.0,
        CAMERA_PITCH, 10.0,

        // CAMERA_FOCUS,
        CAMERA_FOCUS_LAG, 0.05,
        CAMERA_FOCUS_LOCKED, FALSE,
        CAMERA_FOCUS_THRESHOLD, 0.0,

        // CAMERA_POSITION,
        CAMERA_POSITION_LAG, 0.3,
        CAMERA_POSITION_LOCKED, FALSE,
        CAMERA_POSITION_THRESHOLD, 0.0, 
        
        CAMERA_FOCUS_OFFSET,<0,0,1>//<0,0,1>
 
       
];

float vol = 1.0;

//key motorstart = "jet-startup";
//key sound = "Ambient Jet";

integer geardown = TRUE;

default 
{
    
    state_entry() 
    {
        key owner = llGetOwner();
        llListen(0,"",owner,""); // Listen to owner
                
        llSitTarget(avPosition, avRotation); // Position and rotation of pilot's avatar.
        
        llSetCameraEyeOffset(<-12, 0, 2>);//<-7, 0, 1.5>); // Position of camera, relative to parent. 
         llSetCameraAtOffset(<0, 0, 1.9>);   // Point to look at, relative to parent.
        

        llSetSitText("Fly!"); // Text that appears in pie menu when you sit

        llCollisionSound("", 0.0); // Remove the annoying thump sound from collisions  
 
        //SET VEHICLE PARAMETERS -- See www.secondlife.com/badgeo for an explanation
        llSetVehicleType(VEHICLE_TYPE_AIRPLANE);
             
        // uniform angular friction 
        llSetVehicleFloatParam( VEHICLE_ANGULAR_FRICTION_TIMESCALE, 2 );
        
        // linear motor
        llSetVehicleVectorParam( VEHICLE_LINEAR_FRICTION_TIMESCALE, <200, 20, 20> );
        llSetVehicleVectorParam( VEHICLE_LINEAR_MOTOR_DIRECTION, <0, 0, 0> );
        llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_TIMESCALE, 2 );
        llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 120 );
        
        // agular motor
        llSetVehicleVectorParam( VEHICLE_ANGULAR_MOTOR_DIRECTION, <0, 0, 0> );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0 ); 
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 0.4);
        
        // hover 
        llSetVehicleFloatParam( VEHICLE_HOVER_HEIGHT, 0 );
        llSetVehicleFloatParam( VEHICLE_HOVER_EFFICIENCY, 0 ); 
        llSetVehicleFloatParam( VEHICLE_HOVER_TIMESCALE, 10 );
        llSetVehicleFloatParam( VEHICLE_BUOYANCY, .977 );
        
        // no linear deflection 
        llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.2 );
        llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 0.5 ); 
        
        // no angular deflection 
        llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 1);
        llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 0.6);
            
        // no vertical attractor 
        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.8 );
        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 2 );
        
        /// banking
        llSetVehicleFloatParam( VEHICLE_BANKING_EFFICIENCY, 1);
        llSetVehicleFloatParam( VEHICLE_BANKING_MIX, .85);
        llSetVehicleFloatParam( VEHICLE_BANKING_TIMESCALE, 0.01);
        
        
        // default rotation of local frame
        llSetVehicleRotationParam( VEHICLE_REFERENCE_FRAME, <0,0,0,1>);
        
        // remove these flags 
        llRemoveVehicleFlags( VEHICLE_FLAG_NO_DEFLECTION_UP 
                              | VEHICLE_FLAG_HOVER_WATER_ONLY 
                              | VEHICLE_FLAG_HOVER_TERRAIN_ONLY 
                              | VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT 
                              | VEHICLE_FLAG_HOVER_UP_ONLY 
                              | VEHICLE_FLAG_LIMIT_MOTOR_UP
                              | VEHICLE_FLAG_CAMERA_DECOUPLED );

        // set these flags 
        llSetVehicleFlags( VEHICLE_FLAG_LIMIT_ROLL_ONLY ); 

    }
    
    on_rez(integer num) 
    {
        llResetScript();
    } 

    // DETECT AV SITTING/UNSITTING AND TAKE CONTROLS
    changed(integer change)
    {
       if(change & CHANGED_LINK)
       {
            key agent = llAvatarOnSitTarget();
           
            // Pilot gets off vehicle
            if((agent == NULL_KEY) && (sit))
            {
                llSetStatus(STATUS_PHYSICS, FALSE);
                llSetTimerEvent(0.0);
                llMessageLinked(LINK_SET, 0, "unseated", "");
                llReleaseControls();
                llStopSound();
                sit = FALSE;
                startUp = FALSE;
                llClearCameraParams();
            }
            
            // Pilot sits on vehicle
            else if((agent == llGetOwner()) && (!sit))
            {
                llRequestPermissions(agent, PERMISSION_TAKE_CONTROLS | PERMISSION_TRIGGER_ANIMATION | PERMISSION_CONTROL_CAMERA);
               
                llSetTimerEvent(timerFreq);
                llMessageLinked(LINK_SET, 0, "seated", "");
                sit = TRUE;
                llSetStatus(STATUS_PHYSICS, TRUE);
            }
        }
    }

    //CHECK PERMISSIONS AND TAKE CONTROLS
    run_time_permissions(integer perm) 
    {
        if (perm & (PERMISSION_TAKE_CONTROLS)) 
        {            
            llTakeControls(CONTROL_UP | CONTROL_DOWN | CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT | CONTROL_ML_LBUTTON | CONTROL_LBUTTON, TRUE, FALSE);
        }
    }
    
    listen( integer channel, string name, key id, string message )
    {

        if((message=="c")&&(camon==FALSE)&&(sit==TRUE))
        {
             llSetCameraParams(drive_cam);
             camon=TRUE;
             llOwnerSay("Dynamic Camera on");
            }
        
        else if((message=="c")&&(camon==TRUE)&&(sit==TRUE))
        {
             llClearCameraParams();
             camon=FALSE;
             llOwnerSay("Dynamic Camera off");
        }    
        else if(( message == "g" ) && (geardown == FALSE)&&(sit==TRUE))
        {
            llMessageLinked(LINK_SET, 0, "gear down", NULL_KEY);
            geardown = TRUE;
        }
        else if(( message == "g" ) && (geardown == TRUE)&&(sit==TRUE))
        {
            llMessageLinked(LINK_SET, 0, "gear up", NULL_KEY);
            geardown = FALSE;
        }
    }
    
    collision_start(integer num_detected) {
        //pos = llDetectedPos(0);
        onGround = TRUE;
        //llOwnerSay((string)pos);
    }
    collision(integer num_detected) {
        //pos = llDetectedPos(0);
        onGround = TRUE;
        //llOwnerSay((string)pos);   
    } 
    collision_end(integer num_detected) {
        //pos = <0,0,0>;
        onGround = FALSE;
        //llOwnerSay((string)pos);
    }                   
                                    
    //FLIGHT CONTROLS     
    control(key id, integer level, integer edge) 
    {

            integer throttle_up = CONTROL_UP;
            integer throttle_down = CONTROL_DOWN;
            integer yoke_fwd = CONTROL_FWD;
            integer yoke_back = CONTROL_BACK;

            vector angular_motor; 

        if ( ( level & CONTROL_LBUTTON ) && ( edge & CONTROL_LBUTTON ) )
        {
            llMessageLinked(LINK_SET, 0, "fire", "");
        }
        else if ( !( level & CONTROL_LBUTTON ) && ( edge & CONTROL_LBUTTON ) )
        {
            llMessageLinked(LINK_SET, 0, "cease fire", "");
            }               
            
            // THROTTLE CONTROL--------------
            if (level & throttle_up) 
            {
                if (fwd < maxThrottle)
                {
                    fwd += 1;
                }
            }
            else if (level & throttle_down) 
            {
                if (fwd > 0)
                {
                    fwd -= 1;
                }
            }
            
            if (fwd != fwdLast)
            {
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <(fwd * thrustMultiplier),0,0>);
                
                // calculate percent of max throttle and send to child prims as link message
                float thrustPercent = (((float)fwd/(float)maxThrottle) * 100);
                llMessageLinked(LINK_SET, (integer)thrustPercent, "throttle", "");
                llOwnerSay("Throttle at "+(string)((integer)thrustPercent)+"%");
                
                fwdLast = fwd;
                llSleep(0.10); // crappy kludge :P
            }

            
            // PITCH CONTROL ----------------
            if (level & yoke_fwd) 
            {
                angular_motor.y = 3.0;
            }
            else if (level & yoke_back) 
            {
                angular_motor.y = -3.0;
            }
            else
            {
                angular_motor.y = 0;
            }
            

            // BANKING CONTROL----------------
            // Eoin Widget modified this part to switch between turning on the z axis for ground movement and turning on the x axis for flight

            if ((level & CONTROL_RIGHT) || (level & CONTROL_ROT_RIGHT)) 
            {
                pos = llGetPos();
                //if (((objectPos.z - pos.z) < groundDistance) && ((objectPos.z - pos.z) > 0)) 
                if ((onGround) || (( pos.z - llGround(ZERO_VECTOR) ) < groundDistance))
                    {
                        angular_motor.z = -(PI / 4);
                        onGroundNext = onGroundStartTime; //currently set to 2
                        subGround = 0;
                    }
                else
                    {
                        if (onGroundNext == 0)
                        {
                            subGround = 0;
                            angular_motor.x = TWO_PI;
                        }
                        else if (onGroundNext > 0)
                        {
                            angular_motor.z = -(PI / 4);
                            subGround = 1;
                        }
                    }
            }   
            else if ((level & CONTROL_LEFT) || (level & CONTROL_ROT_LEFT)) 
            {
                pos = llGetPos();
                //if (((objectPos.z - pos.z) < groundDistance) && ((objectPos.z - pos.z) > 0)) 
                if ((onGround) || (( pos.z - llGround(ZERO_VECTOR) ) < groundDistance))
                    {
                        angular_motor.z = (PI / 4);
                        onGroundNext = onGroundStartTime; //currently set to 2
                        subGround = 0;
                    }
                else
                    {
                        if (onGroundNext == 0)
                        {
                            subGround = 0;
                            angular_motor.x = -TWO_PI;
                        }
                        else if (onGroundNext > 0)
                        {
                            angular_motor.z = (PI / 4);
                            subGround = 1;
                        }
                    }
                }

            llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);         
    } 
    
    timer()
    {
        if (startUp) llSetCameraParams(drive_cam);
        // Calculate speed in knots
        speed = (integer)(llVecMag(llGetVel()) * 1.94384449 + 0.5);
        
        // Provide lift proportionally to speed
        cruiseSpeed = 25.0; // speed at which you achieve full lift
        lift = (speed/cruiseSpeed); //Lift is varied proportionally to the speed
        if (lift > liftMax) lift = liftMax;
        llSetVehicleFloatParam( VEHICLE_BUOYANCY, lift );
        
        if((onGroundNext > 0) && (subGround == 1)) onGroundNext -= subGround; //Eoin Widget - part of ground movement calculations, a timer to make ground movements smoother, won't switch over flight rotation untill onGroundNext is 0
    }

}// END //
