// :CATEGORY:Tour Guide
// :NAME:Tour Airplane
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2014-12-04 12:43:14
// :EDITED:2014-12-04
// :ID:1060
// :NUM:1697
// :REV:1.2
// :WORLD:OpenSim
// :DESCRIPTION:
// Airplane script for tour plane
// :CODE:

// originally edited by Andrew Linden on 12-08-2003 at 02:31 PM
// revisions
// Revision:
// 0.1 8-17-2014 Initial Porting
// 0.2 8-22-2014 SL version 
// 0.3 8-23-2014 Opensim Bulletsim




// assumes that the root primitive is oriented such that its
// local x-axis points toward the nose of the plane, and its
// local z-axis points toward the top

integer debug = FALSE;

DEBUG(string msg) {
    if (debug) llSay(0,llGetScriptName() + ":" + msg);
}

 
integer LINK_CMD = 0;
integer LINK_ANIMATE = 1;
integer LINK_POSITION   = 2;
integer LINK_RL = 3;
integer LINK_UD = 4;
integer LINK_SPEED = 5;

float LR = 10.0;    // mutiplier for Left/right

//if the root primitive of your airplane does not have the same orientation as the whole airplane 
//(i.e. local x-axis = forward, local y-axis = left, local z-axis = up) then the script will not push
//your airplane in the "correct" direction. 
//
//You need to either: 
//
//1. orient your root primitive to agree with the airplane's axes of motion 
//2. pick a different primitive to be the root (one whose local axes agree with those of the airplane's motion) 
//3. use the VEHICLE_REFERENCE_FRAME parameter (this is an advanced topic and is outside the scope of a _simple_ airplane script) 


// the linear motor uses an accumulator model rather than keeping track
// of the linear control level history
vector gLinearMotor = <0, 0, 0>;



default
{
    
    on_rez(integer p) {
        llResetScript();
    }
    
    state_entry()
    {
        llSetStatus(STATUS_PHYSICS, FALSE);
        llCollisionSound("", 0.0);

        llSetVehicleType(VEHICLE_TYPE_AIRPLANE);

        // weak angular deflection
         llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 1.0);
         llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 0.5);
         
        // somewhat responsive angular motor, but with 3 second decay timescale
         llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.5);  // 0.5
         llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 3);  // 3
         llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <1000.0, 1000.0, 1000.0> );

        // strong linear deflection
         llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 1.0);
         llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 1); // was 0.2

        // somewhat responsive linear motor
         llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 0.5); // VEHICLE_LINEAR_MOTOR_TIMESCALE is the time for motor to "win". Determines how long it takes for the motor to push the vehicle to full speed. Its minimum value is approximately 0.06 seconds.
         llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 20); // is the time for the motor's "effectiveness" to decay toward zero. The effectiveness of the motor will exponentially decay over this timescale, but the effectiveness will be reset whenever the motor's value is explicitly set. The maximum value of this decay timescale is 120 seconds, and this timescale is always in effect.
        // very weak friction
         llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1000.0, 1000.0,1000.0> );
         

         llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.1);  // almost wobbly
         llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 1.5);    // mediocre response

         //llSetVehicleFlags(VEHICLE_FLAG_LIMIT_ROLL_ONLY|VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT);    // to make a airplane you would probably want to unlock the attractor around the pitch axis by setting the VEHICLE_FLAG_LIMIT_ROLL_ONLY bit

            llSetVehicleFlags(VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT);    // to make a airplane you would probably want to unlock the attractor around the pitch axis by setting the VEHICLE_FLAG_LIMIT_ROLL_ONLY bit

         llSetVehicleFloatParam(VEHICLE_BANKING_EFFICIENCY, .8);    // medium strength = 0.4 
         llSetVehicleFloatParam(VEHICLE_BANKING_TIMESCALE, 1);     // very responsive
         llSetVehicleFloatParam(VEHICLE_BANKING_MIX, .05);          // more banking when moving
         

        // hover can be better than sliding along the ground during takeoff and landing
        // but it only works over the terrain (not objects)
        
        vector pos = llGetPos();
        float H = pos.z;
        
        llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, H);
        
        llSetVehicleFloatParam(VEHICLE_HOVER_EFFICIENCY, 0.5);
        llSetVehicleFloatParam(VEHICLE_HOVER_TIMESCALE, 10.0);          
        // llSetVehicleFlags(VEHICLE_FLAG_HOVER_UP_ONLY);

        // non-zero buoyancy helps the airplane stay up
        // set to zero if you don't want this crutch
        llSetVehicleFloatParam(VEHICLE_BUOYANCY, 1.0);

        
    }

   
      
    link_message(integer sender_number, integer number, string message, key id)
    {
        //DEBUG("N:" + (string) number + ":" + message);        
        vector motor;

        if (number  == LINK_CMD && message == "cStart") {
            
            llSetStatus(STATUS_PHYSICS, TRUE);
            llSleep(.01);
            // clear linear motor on successful sit
            gLinearMotor = <0, 0, 0>;
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, gLinearMotor);
            llSetVehicleFloatParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, 1000.0);
            llSetVehicleFloatParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, 1000.0);
        
        } else if (number  == LINK_CMD && message == "cStop") {
                // stop the motors
                gLinearMotor = <0, 0, 0>;
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, gLinearMotor);
                llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, gLinearMotor);

                // use friction to stop the vehicle rather than pinning it in place
                llSetStatus(STATUS_PHYSICS, FALSE);
                llSetVehicleFloatParam(VEHICLE_LINEAR_FRICTION_TIMESCALE,5.0);
                llSetVehicleFloatParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, 1.0);
            
        } else if (number == LINK_SPEED){
                       
            gLinearMotor.x += (float) message;
            
            if (gLinearMotor.x > 10)    // maximum of 10 from the wiki
                gLinearMotor.x  = 10;
            
            if (gLinearMotor.x < 0)
                 gLinearMotor.x = 0;       
            
           // DEBUG("SPEED:" + (string) gLinearMotor.x );
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, gLinearMotor);
            
        } else if (number == LINK_RL) {
                        
            //  from 0 to PI which is behind you
            float angle = (float) message; 
            DEBUG("Angle:" + (string) angle);
           
            if( angle >  0) {
                motor.x = -angle * LR;
                DEBUG("Left:" + (string) motor.x);
            } else  {
                motor.x = -angle * LR;
                DEBUG("Right:" + (string) motor.x);                
            }
            llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, motor);
                                
        } else if (number == LINK_UD) {
            float height = (float) message;
            DEBUG("Height:" + (string) height);
            llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, height);
        }
    }
}
