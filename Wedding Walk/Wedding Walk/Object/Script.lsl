// :CATEGORY:Wedding
// :NAME:Wedding Walk
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:09
// :ID:971
// :NUM:1393
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// A walker for two people at a wedding
// :CODE:



////////////////////////////////////////////
// Wedding walk Script
//
////////////////////////////////////////////
float forward_power = 1; //Power used to go forward (1 to 30)
float reverse_power = -1; //Power used to go reverse (-1 to -30)
float turning_ratio = .1; //How sharply the vehicle turns. Less is more sharply. (.1 to 10)
/////////////// CONSTANTS ///////////////////
string  FWD_DIRECTION   = "x";
vector  POSITION_OFFSET  = <0.0, 0.0, 0.0>; // Local coords
float   SCAN_REFRESH    =.2;

///////////// END CONSTANTS /////////////////

///////////// GLOBAL VARIABLES ///////////////
key gOwner;
rotation gFwdRot;
float last_dist = 9999;   // store the last distance to the sensor
/////////// END GLOBAL VARIABLES /////////////

turn(string direction)
{

    //llSetText("Turning " + direction, <2,2,2>, 5);
    //llSleep(1);
    vector angular_motor;
    integer reverse=1;
    //get current speed
    vector vel = llGetVel();
    float speed = llVecMag(vel);

    //car controls
    if(direction == "Forward")
    {
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <forward_power,0,0>);
        reverse=1;
    }
    if(direction == "Back")
    {
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <reverse_power,0,0>);
        reverse = -1;
    }

    if(direction == "Right")
    {
        angular_motor.z -= speed / turning_ratio * reverse;
    }
    
    if(direction == "Left")
    { 
        angular_motor.z += speed / turning_ratio * reverse;
    }
 
    llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);

} //end control   
    
help()
{
    llWhisper(0,"You can say the following commands:");
    llWhisper(0,"/start <-- I will walk down the path");
    llWhisper(0,"/stop <-- I will stay where I am.");
    llWhisper(0,"/help <-- I will repeat this message.");
}

StartScanning() 
{

    llSetStatus(STATUS_PHYSICS, TRUE);
    llTriggerSound("whistle2",1);
    
    llSensorRepeat("End", "",PASSIVE, 50, PI, SCAN_REFRESH);
//    llSensorRepeat("RRail-B Right Gravel", "",PASSIVE, 10, PI/2, SCAN_REFRESH);
    llSetText("Starting", <2,2,2>, 5);
}
 
StopScanning() 
{
    llSetStatus(STATUS_PHYSICS, FALSE);
    llSetTimerEvent(0);
    llSensorRemove( );
    llSetText("Stopped", <2,2,2>, 5);
    llTargetOmega(<0,0,0>,PI,0); //keep it from wobbling
}


rotation GetFwdRot() 
{
    // Special case... 180 degrees gives a math error
    if (FWD_DIRECTION == "-x") 
    {
        return llAxisAngle2Rot(<0, 0, 1>, PI);
    }
    
    string Direction = llGetSubString(FWD_DIRECTION, 0, 0);
    string Axis = llToLower(llGetSubString(FWD_DIRECTION, 1, 1));
    
    vector Fwd;
    if (Axis == "x")
        Fwd = <1, 0, 0>;
    else if (Axis == "y")
        Fwd = <0, 1, 0>;
    else
        Fwd = <0, 0, 1>;
        
    if (Direction == "-")
        Fwd *= -1;
       
    return llRotBetween(Fwd, <1, 0, 0>); 
}

rotation GetRotation(rotation rot) 
{
    vector Fwd;
    Fwd = llRot2Fwd(rot);
    
    float Angle = llAtan2( Fwd.y, Fwd.x );
    return gFwdRot * llAxisAngle2Rot(<0, 0, 1>, Angle);
}


default
{
    
    state_entry() 
    {
        llSetStatus(STATUS_PHANTOM, TRUE);
        gOwner = llGetOwner();
//        gFwdRot = GetFwdRot();
       
        llSetVehicleType(VEHICLE_TYPE_CAR);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.2);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.80);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 0.10);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 0.10);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 1.0);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 0.2);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.1);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 0.5);
        llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1000.0, 2.0, 1000.0>);
        llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <10.0, 10.0, 1000.0>);
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 0.50);
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 0.50);
        llSetStatus(STATUS_PHYSICS, TRUE);
       
        llSetText("Ready", <2,2,2>, 5);
       
        llListen(0, "", "", "");
    }
    



    touch_start(integer total_number)
    {
        llSetText("Touched", <2,2,2>, 5);
        last_dist = 9999;
        StartScanning();
    }
    
    listen(integer channel, string name, key id, string mesg) 
    {
        mesg = llToLower(mesg);
        if ((id == gOwner) && ( mesg == "/start" )) 
        {
            StartScanning();
        }
        else if ((id == gOwner) && (mesg == "/stop" )) 
        {
            StopScanning();
        }
        
        else if ((id == gOwner) && (mesg == "/help")) 
        {
            help();
        }
    }
    
        

    on_rez(integer start_param)
    {
        llResetScript();
    } 

       
    
    sensor(integer num_detected)
    {
        
         vector Pos = llDetectedPos(0);
         vector Myself = llGetPos();
         float dist = llVecDist(Myself, Pos);
        
        //llOwnerSay("The distance between " + (string) Myself +
        //    " and " + (string) Pos + " is: "+(string) dist + " last time was " + (string) last_dist);


        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <forward_power,0,0>);
            
        
        
        if (dist > last_dist)
        {
            //llOwnerSay("Made it");
            StopScanning();
        }
        else
        {
            //llOwnerSay("Closer");
            last_dist = dist;
        }
        //llSleep(1);    
            
    }


}
