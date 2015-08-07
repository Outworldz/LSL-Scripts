// :CATEGORY:Vehicles
// :NAME:Helicopter
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:376
// :NUM:520
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Helicopter
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

float forward_power = 15; //Power used to go forward (1 to 30)
float reverse_power = -15; //Power ued to go reverse (-1 to -30)
float turning_ratio = 2.0; //How sharply the vehicle turns. Less is more sharply. (.1 to 10)
string sit_message = "Ride"; //Sit message
string not_owner_message = "You are not the owner of this vehicle ..."; //Not owner message
float VERTICAL_THRUST = 7;
float ROTATION_RATE = 2.0;      //  Rate of turning  

resetY()
{
    rotation rot = llGetRot();
    llSetRot(rot);
}

default
{
    state_entry()
    {
        llSetSitText(sit_message);
        // forward-back,left-right,updown
        llSitTarget(<0.2,0,0.45>, ZERO_ROTATION );
        
        llSetCameraEyeOffset(<-8, 0.0, 5.0>);
        llSetCameraAtOffset(<1.0, 0.0, 2.0>);
        
        llPreloadSound("helicopter_run");
        
        //car
       llSetVehicleType(VEHICLE_TYPE_AIRPLANE);

       llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.1);
       llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.1);
       llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 10);
       llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 10);

       llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 0.2);
       llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 10);
       llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.2);
       llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 0.1);

       llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1,1,1>);
       llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <1,1000,1000>);

       llSetVehicleFloatParam(VEHICLE_BUOYANCY, 0.9);

        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 1 );
        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 2 );

        llSetVehicleFloatParam( VEHICLE_BANKING_EFFICIENCY, 1 );
        llSetVehicleFloatParam( VEHICLE_BANKING_MIX, 0.5 );
        llSetVehicleFloatParam( VEHICLE_BANKING_TIMESCALE, .5 );
        
        
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
                    llMessageLinked(LINK_ALL_CHILDREN , 0, "start", NULL_KEY);
                    
                    llSleep(.4);
                    llSetStatus(STATUS_PHYSICS, TRUE);
                    llSetStatus(STATUS_ROTATE_Y,TRUE);
                    llSleep(.1);
                    llRequestPermissions(agent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);

                    llLoopSound("helicopter_run",1);
                }
            }
            else
            {
                llStopSound();
                llMessageLinked(LINK_ALL_CHILDREN , 0, "stop", NULL_KEY);
                
                llSetStatus(STATUS_PHYSICS, FALSE);
                llSleep(.4);
                llReleaseControls();
                llTargetOmega(<0,0,0>,PI,0);
                
                llResetScript();
            }
        }
        
    }
    
    run_time_permissions(integer perm)
    {
        if (perm) {
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT | CONTROL_UP | CONTROL_DOWN, TRUE, FALSE);
        }
    }
    
    control(key id, integer level, integer edge)
    {
        vector angular_motor;
        

        // going forward, or stop going forward
        if(level & CONTROL_FWD)
        {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <forward_power,0,0>);
        } else if(edge & CONTROL_FWD)
        {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,0,0>);
        }
        
        
        // going back, or stop going back
        if(level & CONTROL_BACK)
        {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <reverse_power,0,0>);
        }
        else if(edge & CONTROL_BACK)
        {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,0,0>);
        }
        
        // turning
        if(level & (CONTROL_RIGHT|CONTROL_ROT_RIGHT))
        {
            angular_motor.x += 25;
        }
        
        if(level & (CONTROL_LEFT|CONTROL_ROT_LEFT))
        {
            angular_motor.x -= 25;
        }
        
        
        // going up or stop going up
        if(level & CONTROL_UP) {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,0,VERTICAL_THRUST>);
        } else if (edge & CONTROL_UP) {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,0,0>);
        }
        
        // going down or stop going down
        
        if(level & CONTROL_DOWN) {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,0,-VERTICAL_THRUST>);
        } else if (edge & CONTROL_DOWN) {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,0,0>);
        }

        angular_motor.y = 0;
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);
        


    } //end control   
    
    
    
} //end default
