// :CATEGORY:Vehicles
// :NAME:Boat
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:49
// :ID:108
// :NUM:149
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Boat
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

float forward_power = 25; //Power used to go forward (1 to 30)
float reverse_power = -15; //Power ued to go reverse (-1 to -30)
float turning_ratio = 5.0; //How sharply the vehicle turns. Less is more sharply. (.1 to 10)
string sit_message = "Ride"; //Sit message
string not_owner_message = "You are not the owner of this vehicle ..."; //Not owner message

//Anything past this point should only be modfied if you know what you are doing

default
{
    state_entry()
    {
        llSetSitText(sit_message);
        // forward-back,left-right,updown
        llSitTarget(<0.2,0,0.45>, ZERO_ROTATION );
        
        llSetCameraEyeOffset(<-12, 0.0, 5.0>);
        llSetCameraAtOffset(<1.0, 0.0, 2.0>);
        
        llPreloadSound("boat_start");
        llPreloadSound("boat_run");
            llSetVehicleFlags(0);
        llSetVehicleType(VEHICLE_TYPE_BOAT);
        llSetVehicleFlags(VEHICLE_FLAG_HOVER_UP_ONLY | VEHICLE_FLAG_HOVER_WATER_ONLY);
        llSetVehicleVectorParam( VEHICLE_LINEAR_FRICTION_TIMESCALE, <1, 1, 1> );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_FRICTION_TIMESCALE, 2 );

        
        
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0, 0, 0>);
    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 1);
    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 0.05);
        
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, 1 );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 5 );
        llSetVehicleFloatParam( VEHICLE_HOVER_HEIGHT, 0.15);
        llSetVehicleFloatParam( VEHICLE_HOVER_EFFICIENCY,.5 );
        llSetVehicleFloatParam( VEHICLE_HOVER_TIMESCALE, 2.0 );
        llSetVehicleFloatParam( VEHICLE_BUOYANCY, 1 );
        llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.5 );
        llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 3 );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.5 );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 10 );
        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.5 );
        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 2 );
        llSetVehicleFloatParam( VEHICLE_BANKING_EFFICIENCY, 1 );
        llSetVehicleFloatParam( VEHICLE_BANKING_MIX, 0.1 );
        llSetVehicleFloatParam( VEHICLE_BANKING_TIMESCALE, .5 );
        llSetVehicleRotationParam( VEHICLE_REFERENCE_FRAME, ZERO_ROTATION );
    }
    
    changed(integer change)
    {
        
        
        if (change & CHANGED_LINK)
        {
            
            key agent = llAvatarOnSitTarget();
            if (agent)
            {                
                if (agent != llGetOwner())
                {
                    llSay(0, not_owner_message);
                    llUnSit(agent);
                    llPushObject(agent, <0,0,50>, ZERO_VECTOR, FALSE);
                }
                else
                {
                    llTriggerSound("boat_start",1);
                    
                    
                    llMessageLinked(LINK_ALL_CHILDREN , 0, "start", NULL_KEY);
                    llSleep(.4);
                    llSetStatus(STATUS_PHYSICS, TRUE);
                    llSleep(.1);
                    llRequestPermissions(agent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);

                    llLoopSound("boat_run",1);
                }
            }
            else
            {
                llStopSound();
                
                llSetStatus(STATUS_PHYSICS, FALSE);
                llSleep(.1);
                llMessageLinked(LINK_ALL_CHILDREN , 0, "stop", NULL_KEY);
                llSleep(.4);
                llReleaseControls();
                llTargetOmega(<0,0,0>,PI,0);
                
                llResetScript();
            }
        }
        
    }
    
    run_time_permissions(integer perm)
    {
        if (perm)
        {
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_DOWN | CONTROL_UP | CONTROL_RIGHT | 
                            CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);
        }
    }
    
    control(key id, integer level, integer edge)
    {
        integer reverse=1;
        vector angular_motor;
        
        //get current speed
        vector vel = llGetVel();
        float speed = llVecMag(vel);

        //car controls
        if(level & CONTROL_FWD)
        {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <forward_power,0,0>);
            reverse=1;
        }
        if(level & CONTROL_BACK)
        {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <reverse_power,0,0>);
            reverse = -1;
        }

        if(level & (CONTROL_RIGHT|CONTROL_ROT_RIGHT))
        {
            angular_motor.z -= speed / turning_ratio * reverse;
            angular_motor.x += 15;
        }
        
        if(level & (CONTROL_LEFT|CONTROL_ROT_LEFT))
        {
            angular_motor.z += speed / turning_ratio * reverse;
            angular_motor.x -= 15;
        }

        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);

    } //end control   
    
    
} //end default
