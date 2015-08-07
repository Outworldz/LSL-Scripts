// :CATEGORY:Boat
// :NAME:DaVinci Boat
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-08
// :EDITED:2013-09-18 15:38:51
// :ID:220
// :NUM:304
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// The Davinci boat main script
// :CODE:
string ENGINE = "ab1d0aab-6370-7f04-43df-d981c6051c1d";

float last_speed;
float speed;
vector angular_motor;

default
{
    state_entry()
    {   
        llMessageLinked(LINK_ALL_CHILDREN, 0, "spin", NULL_KEY);
        llSetSitText("Board");
        llStopSound();
        llSetTimerEvent(0.0);
        speed=0;
        
        llSetVehicleType(VEHICLE_TYPE_BOAT);
        llSetVehicleFlags(VEHICLE_FLAG_HOVER_UP_ONLY | VEHICLE_FLAG_HOVER_WATER_ONLY);
        // remove these flags
        llRemoveVehicleFlags( VEHICLE_FLAG_HOVER_TERRAIN_ONLY
            | VEHICLE_FLAG_LIMIT_ROLL_ONLY
            | VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT);

        // least for forward-back, most friction for up-down
        llSetVehicleVectorParam( VEHICLE_LINEAR_FRICTION_TIMESCALE, <2, 3, 2> );

        // uniform angular friction (setting it as a scalar rather than a vector)
        llSetVehicleFloatParam( VEHICLE_ANGULAR_FRICTION_TIMESCALE, 2 );

        // linear motor wins after about five seconds, decays after about a minute
        llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_TIMESCALE, 5 );
        llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 60 );

        // agular motor wins after four seconds, decays in same amount of time
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, 2 );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 5 );

        // hover / float
        llSetVehicleFloatParam( VEHICLE_HOVER_HEIGHT, 0.3);
        llSetVehicleFloatParam( VEHICLE_HOVER_EFFICIENCY,.5 );
        llSetVehicleFloatParam( VEHICLE_HOVER_TIMESCALE, 2.0 );
        llSetVehicleFloatParam( VEHICLE_BUOYANCY, 0.5 );

        // halfway linear deflection with timescale of 3 seconds
        llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.5 );
        llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 3 );

        // angular deflection
        llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.5 );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 10 );

        // somewhat bounscy vertical attractor
        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.5 );
        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 2 );

        // weak negative damped banking
        llSetVehicleFloatParam( VEHICLE_BANKING_EFFICIENCY, 1 );
        llSetVehicleFloatParam( VEHICLE_BANKING_MIX, 0.1 );
        llSetVehicleFloatParam( VEHICLE_BANKING_TIMESCALE, .75 );

        // default rotation of local frame
        llSetVehicleRotationParam( VEHICLE_REFERENCE_FRAME, <0, 0, 0, 1> );
        
        llSetStatus(STATUS_ROTATE_X | STATUS_ROTATE_Y | STATUS_ROTATE_Z, TRUE);
    }

   
   
   
   link_message(integer  sender, integer num, string str, key id)
   {
       if (str == "start")
       {
            llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS);
            
        } else if (str == "stop")  {
            llSetStatus(STATUS_PHYSICS, FALSE);
            llSetTimerEvent(0);
            llReleaseControls();
            llStopSound();
        }
    }
   
   

    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TAKE_CONTROLS)
        {
            // You sit and are owner so get controls
            llSetStatus(STATUS_PHYSICS, TRUE);
            
            // Take these controls and lets go
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT | CONTROL_UP | CONTROL_DOWN, TRUE, FALSE);
            llMessageLinked(LINK_ALL_CHILDREN, 10, "spin", NULL_KEY);
            llLoopSound(ENGINE,0.3);
            llSleep(1);
            llMessageLinked(LINK_ALL_CHILDREN, 0, "spin", NULL_KEY);
            llSetTimerEvent(0.3);
        }
    }
    
    
    control(key id, integer level, integer edge)
    {

        if(level & CONTROL_FWD)
        {
            // Set cruising speed faster
            if(speed < 20)
            {
                speed +=1;
            }
        }
        if(level & CONTROL_BACK)
        {
            // Set cruising speed slower
            if(speed > -8)
            {
                speed -=1;
            }
        }
        if(level & (CONTROL_RIGHT|CONTROL_ROT_RIGHT))
        {
            // Turn right
            angular_motor.x += 5;
            angular_motor.z -= 1;
        }
        if(level & (CONTROL_LEFT|CONTROL_ROT_LEFT))
        {
            // Turn left
            angular_motor.x -= 5;
            angular_motor.z += 1;
        }
        if(level & CONTROL_UP)
        {
            // add features for when you press up
        }
        if(level & CONTROL_DOWN)
        {
            // Added feature for when you press down
            // Stops boat when down is pressed
            speed=0;
        }

    }

    timer()
    {
        // the timer actually moves vehicle
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <speed,0,0>);
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);
        // reset turning angle or you would go around in circles
        angular_motor=<0,0,0>;
        
        
        if (speed > 0 && last_speed <= 0)
            llPlaySound("681fb929-fa78-cd47-52ca-cafb4d43836a",1.0);
        else if (speed <= 0 && last_speed >= 0)
            llPlaySound("7f42f4ba-0786-e0a0-855a-1d4db140621e",1.0);
        
        last_speed = speed;
        
        llMessageLinked(LINK_ALL_CHILDREN, (integer) speed, "spin", NULL_KEY);
        
        
    }
}
