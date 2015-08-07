// :CATEGORY:Animation
// :NAME:swimming_fish
// :AUTHOR:Cubey Terra
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:06
// :ID:857
// :NUM:1193
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// swimming fish.lsl
// :CODE:

 // SWIMMING AROUND SCRIPT
// Cubey Terra
// May 27 2006 - First verion of Linerunner script.
// June 19 2006 - Adapted to torpedo from Linerunner script.
// July 16 2006 - Adapted for a virtual life experiment.
// Aug 27 2006 - Adapted for simple swarming prims.
// April 19 2007 - Adapted for non-swarming fish




// CONSTANTS
float BLARG = 2.0; // provides a bit of randomness to fish targeting

string targetName;
integer swarming = FALSE;

vector START_SIZE = <0.1,0.1,0.1>;
float BUOY_NEUTRAL = 0.98; // vehicle buoyancy parameter.
float THRUST_FACTOR = 0.5; // xLinearMotor = throttle * THRUST_FACTOR * energy
integer THROTTLE_MAX = 2;
float TIMER_INT = 0.25;
string SND_DIE = "2cf64119-69e6-48e1-8d43-7e66f24f38d7";
rotation REF_FRAME = <0.00000, -0.70711, 0.00000, 0.70711>; // vehicle reference frame
float ANG_MOTOR = 2;

//integer TURN_SEC = 2; //# seconds between turns
float RANGE = 96;
integer CHAT_CHANNEL = 10;



// VARIABLES
integer running;
float maxAlt = 16;
integer throttle;
float xLinearMotor;
float zLinearMotor;
vector pos;
vector targetPos = <128,128,128>;
float mass;
integer listentrack;
float buoyancy;



setVehicleParams()
{
        llSetVehicleType(VEHICLE_TYPE_AIRPLANE);
        llSetVehicleVectorParam( VEHICLE_LINEAR_FRICTION_TIMESCALE, <10, 10, 1> );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_FRICTION_TIMESCALE, 2 );
        llSetVehicleVectorParam( VEHICLE_LINEAR_MOTOR_DIRECTION, <0, 0, 0> );
        llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_TIMESCALE, 0.5 );
        llSetVehicleFloatParam( VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 20 );
        llSetVehicleVectorParam( VEHICLE_ANGULAR_MOTOR_DIRECTION, <0, 0, 0> );
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_TIMESCALE, 10 ); 
        llSetVehicleFloatParam( VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 5);
        llSetVehicleFloatParam( VEHICLE_HOVER_HEIGHT, 0 );
        llSetVehicleFloatParam( VEHICLE_HOVER_EFFICIENCY, 0 ); 
        llSetVehicleFloatParam( VEHICLE_HOVER_TIMESCALE, 1000 );
        llSetVehicleFloatParam( VEHICLE_BUOYANCY, BUOY_NEUTRAL );
        llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0 );
        llSetVehicleFloatParam( VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 5 ); 
        llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0);
        llSetVehicleFloatParam( VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 5);
        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0 );
        llSetVehicleFloatParam( VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 1000 );
        llSetVehicleFloatParam( VEHICLE_BANKING_EFFICIENCY, 1);
        llSetVehicleFloatParam( VEHICLE_BANKING_MIX, .2);
        llSetVehicleFloatParam( VEHICLE_BANKING_TIMESCALE, 0.01);
        llSetVehicleRotationParam(VEHICLE_REFERENCE_FRAME, REF_FRAME);
        llRemoveVehicleFlags( VEHICLE_FLAG_NO_DEFLECTION_UP 
                              | VEHICLE_FLAG_HOVER_WATER_ONLY
                              //| VEHICLE_FLAG_LIMIT_ROLL_ONLY 
                              | VEHICLE_FLAG_HOVER_TERRAIN_ONLY 
                              | VEHICLE_FLAG_HOVER_GLOBAL_HEIGHT 
                              //| VEHICLE_FLAG_HOVER_UP_ONLY 
                              //| VEHICLE_FLAG_LIMIT_MOTOR_UP
                               );
}



startListen()
{
    if (listentrack)
    {
        llListenRemove(listentrack);
        listentrack = 0;
    }
    llListen(CHAT_CHANNEL, "", "", "");
}



init()
{
    llSitTarget(<0,0,0.1>, REF_FRAME); // while not a vehicle, it might be fun to ride :)
    llSetStatus(STATUS_PHYSICS, FALSE);
    llSetStatus(STATUS_DIE_AT_EDGE | STATUS_PHANTOM, TRUE);
    setVehicleParams(); 

    targetName = llGetObjectName(); // swarm after others of my type, if present
    buoyancy = BUOY_NEUTRAL;
    startListen();
    mass = llGetMass();
    throttle = 1;
    targetPos = llGetPos();
    llSetTimerEvent(TIMER_INT);
}

setMotor()
{
    throttle = (integer)(llRound(llFrand(THROTTLE_MAX)) + 1);
    
    // calculate current thrust based on amount of available steam.
    xLinearMotor = throttle * THRUST_FACTOR; 
    llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <xLinearMotor,0,0>);
}

setBuoyancy()
{
    if (pos.z > maxAlt) // if above maxAlt
    {
        buoyancy = BUOY_NEUTRAL/(pos.z - maxAlt); // buoyancy is reduced proportionally to height above max alt
    }
    else
    {
        buoyancy = BUOY_NEUTRAL;
    }
    llSetVehicleFloatParam( VEHICLE_BUOYANCY, buoyancy );
}

lookAt()
{
    mass = llGetMass();
    float strength = mass;
    float damping = strength/3;
    llLookAt(targetPos, strength, damping);
    //llSetText("Target: "+(string)targetPos,<1,1,1>,1);
}


 
default 
{
    listen(integer sender, string name, key id, string message)
    {
        if (message == "die")
        {
            llTriggerSound(SND_DIE,1);
            llDie();
        }
        else if (llSubStringIndex(message, "target") == 0)
        {
            // target,<fish name>,x,y,z
            list data = llCSV2List(message);
            string dataname = llList2String(data,1);
            vector datapos;
            //llOwnerSay(llList2CSV(data));
            if (dataname == llGetObjectName())
            {
                datapos.x = llList2Float(data,2);
                datapos.y = llList2Float(data,3);
                datapos.z = llList2Float(data,4);
                maxAlt = datapos.z;
                
                vector offset;
                offset.x = llFrand(BLARG);
                offset.y = llFrand(BLARG);

                targetPos = datapos + offset;
                running = TRUE;
            }
        }

    }
        
    state_entry() 
    {
        init();
    }
    
    on_rez(integer num) 
    {
        llResetScript();
    } 
    
    
    timer()
    {
        if (running)
        {
            llSetStatus(STATUS_PHYSICS, TRUE);
            pos = llGetPos();
            setMotor();
            setBuoyancy();
            lookAt();
        }
        else llSetStatus(STATUS_PHYSICS, FALSE);
        
    } 
}
// END //
