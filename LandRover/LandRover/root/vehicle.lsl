// :CATEGORY:Vehicle
// :NAME:LandRover
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:56
// :ID:459
// :NUM:619
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Opensim vehicle control
// :CODE:

// http://opensimulator.org/wiki/Vehicles

// Very simple vehicle script, mod for OpenSimulator & ODE & VEHICLE code
// By Kitto Flora September 2009


// SOUND
string RUNNING = "run";
string IDLE = "idle";
string START = "start";
// link messages

// S = Stop wheels
// WC wheels centered
// F = Rotate forward
// R = Rotate backwards
// WR = Wheels right
// WL = Wheels left
// LO = Left door open
// LC = Left Door closed
// RO = Right door open
// RC = Right door closed
// RESET = all prims standard, doors clozed

    
integer Private = 1; // Change to 1 to prevent others riding.
 
integer tt;
key oldagent;
key agent;


float forward_power = 5; //Power used to go forward (1 to 30)
float reverse_power = -2; //Power ued to go reverse (-1 to -30)
float turning_ratio = 0.5; //How sharply the vehicle turns. Less is more sharply. (.1 to 10)



integer turncount;
string Wheeldir = "WC";
string NewWheeldir = "WC";
string Wheelrot = "S";
string NewWheelrot = "S";


integer scount;
integer Speed;
integer Run;
 
 
 

setVehicle()
{
    //car
        llSetVehicleType(VEHICLE_TYPE_CAR);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.2);     // was 0.2
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.80);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 0.10);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 0.10);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 1.0);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 0.1);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.1);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 0.1);
        llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <10.0, 2.0, 1000.0>);
        llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <0.1, 0.1, 0.1>);
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.50);
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 0.50);
 
}
Init()
{
    Sound(0);
    llSetStatus(STATUS_PHYSICS, FALSE);
    vector here = llGetPos();
    
    
    vector height = llGetScale();
    float h = height.z;
    
    float h1 = llGround(<0,0,0>) + h;
    
    
    vector rotv = llRot2Euler(llGetRot());
    rotation rot = llEuler2Rot(<0,0,rotv.z>);
    
    llSetPos(<here.x, here.y,h1>);
    llSetRot(rot);
        
    llSetVehicleType(VEHICLE_TYPE_NONE);
    llMessageLinked(LINK_ALL_OTHERS, 0, "S", NULL_KEY);     // wheels stop
    llMessageLinked(LINK_ALL_OTHERS, 0, "WC", NULL_KEY);     // wheels straight
    Run = 0;
}
 
SetMaterial()
{
    llSetPrimitiveParams([PRIM_MATERIAL, PRIM_MATERIAL_GLASS]);

}
 
Sound(integer n)
{
    integer oldn;
    if(n != oldn)
    {
        oldn = n;
        
        //llOwnerSay("Sound:" + (string) n);
        
        if(n == 3)
        {
            llPlaySound(START,1);
        }
        else if(n == 2)
        {
            llLoopSound(RUNNING,1);
        }
        else if(n == 1)
        {
            llLoopSound(IDLE,1);
        }
        else
        {
             llStopSound();
        }
    }
} 
 
default
{
    state_entry()
    {
        Init();
        llStopSound();
    }
 
    on_rez(integer rn){
        llResetScript();
    }
 

 
    link_message(integer n, integer channel, string msg, key id)
    {
        
       // llOwnerSay(msg);
        if (msg == "sit")
        {
            agent = id;
            setVehicle();
            SetMaterial();
            llSleep(.4);
            llSetStatus(STATUS_PHYSICS, TRUE);
            llSleep(.1);
            Run = 1;
            //Sensor is to make a crude Timer as TimerEvent fails on vehicles
            llSensor("Non-Entity",NULL_KEY,PASSIVE,1.0, PI_BY_TWO); 

            llRequestPermissions(agent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
            Sound(3);   // start
            llSleep(2);
            Sound(1);   // idle
        }
        else if (msg == "unsit")
        {
            Init();
            llSleep(.4);
            llReleaseControls();
            llMessageLinked(LINK_ALL_OTHERS, 0, "S", NULL_KEY);
            Run = 0;
            llStopSound();
        }
        
    }
 
    touch_start(integer tn){
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
            llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <10.0, 2.0, 1000.0>);
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <forward_power,0,0>);
            reverse=1;
            NewWheelrot = "F";
            Speed = 20;
        }
        if(level & CONTROL_BACK)
        {
            llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <10.0, 2.0, 1000.0>);
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <reverse_power,0,0>);
            reverse = -1;
            NewWheelrot = "R";
            Speed = 10;
        }
 
        if(level & (CONTROL_RIGHT|CONTROL_ROT_RIGHT))
        {
            angular_motor.z -= speed / turning_ratio * reverse;
            NewWheeldir = "WR";
            turncount = 10;
        }
 
        if(level & (CONTROL_LEFT|CONTROL_ROT_LEFT))
        {
            angular_motor.z += speed / turning_ratio * reverse;
            NewWheeldir = "WL";
            turncount = 10;
        }
 
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);
        if(turncount > 0)
        {
            turncount--;
        }
        if(turncount == 1)
        {
            NewWheeldir = "WC";
        }
        if(Wheeldir != NewWheeldir){
            Wheeldir = NewWheeldir;
            llMessageLinked(LINK_ALL_OTHERS, 0, Wheeldir, NULL_KEY);
        }
        if(Wheelrot != NewWheelrot){
            Wheelrot = NewWheelrot;
            llMessageLinked(LINK_ALL_OTHERS, 0, Wheelrot, NULL_KEY);
        }
    } //end control   
 
    //Sensor is to make a crude Timer as TimerEvent fails on vehicles
    no_sensor()
    {
        if(scount < 1000)
        {
            scount++;
        }
        else
        {
            scount = 0;
            // This happens about once per second
            if(Speed > 0) Speed--;
 
            if(Speed > 2)  Sound(2);
 
            if(Speed == 1) {
                llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1.0, 2.0, 1000.0>);
                llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,0,0>);
                llMessageLinked(LINK_ALL_OTHERS, 0, "S", NULL_KEY);
                Sound(1);
                Wheelrot = "S";
            }
 
        }
 
        if(Run == 1)
            llSensor("Non-Entity",NULL_KEY,PASSIVE,1.0, PI_BY_TWO); 
    }
 
} //end default
