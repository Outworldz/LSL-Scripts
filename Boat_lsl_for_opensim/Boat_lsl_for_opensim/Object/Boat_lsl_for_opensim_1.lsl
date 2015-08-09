// :CATEGORY:Vehicles
// :NAME:Boat_lsl_for_opensim
// :AUTHOR:Jules
// :CREATED:2010-09-12 12:54:23.257
// :EDITED:2013-09-18 15:38:49
// :ID:109
// :NUM:150
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// added a listener on ch 8000 to message back the boat's position.// added "up" and "down"  flight commands processing to straighten boat.// added "touch" processing to straighten boat.// fixed llsit targets for opensim prim sitting
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
//
// additional fixes for opensim by Renmiri Writer @ Second Life on 9/12/2010

float forward_power = 25; //Power used to go forward (1 to 30)
float reverse_power = -15; //Power ued to go reverse (-1 to -30)
float turning_ratio = 5.0; //How sharply the vehicle turns. Less is more sharply. (.1 to 10)
string sit_message = "Ride"; //Sit message
vector green = <0,1,0>;
string not_owner_message = "You are not the owner of this vehicle ..."; //Not owner message

//Anything past this point should only be modfied if you know what you are doing

default
{
    state_entry()
    {
        llSetSitText(sit_message);
        llListen(8000, "","", "" );
        // forward-back,left-right,updown
        llSitTarget(<0.25,0,0.25>, ZERO_ROTATION );
        llSetText(".message ch 8000 to find me. \n use Pageup, Pagedown if you get stuck \n touch me to straighten the boat",green,1.0);
        
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
        
        if(level & (CONTROL_UP|CONTROL_DOWN))
        {
            if (level & (CONTROL_UP)) 
            llSay(0,"UP");
            if (level & (CONTROL_DOWN)) 
            llSay(0,"DOWN");
             vector position = llGetPos();
        llSay(0, (string)position);
            vector vRadBase = llRot2Euler( llGetRot() );
     //-- round the z-axis to the nearest 90deg (PI_BY_TWO = 90deg in radians)
    llSetRot( llEuler2Rot( <0.0, 0.0, llRound( vRadBase.z / PI_BY_TWO ) * PI_BY_TWO > ) );
        }

        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);

    } //end control   
listen( integer channel, string name, key id, string message )
    {

            integer c = llStringLength(message);
            vector position = llGetPos();
            string newmessage = "" ; 
        llSay(0,"messsage "+message+" heard by boat at "+ (string)position);
} //end listen
  touch_start( integer vIntTouches )
  {
     //-- convert our rotation to x/y/z radians
    vector vRadBase = llRot2Euler( llGetRot() );
     //-- round the z-axis to the nearest 90deg (PI_BY_TWO = 90deg in radians)
    llSetRot( llEuler2Rot( <0.0, 0.0, llRound( vRadBase.z / PI_BY_TWO ) * PI_BY_TWO > ) );
  } //end touch


} //end default


// Look for updates at : http://www.outworldz.com/freescripts.plx?ID=1511
// __END__
