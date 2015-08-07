// :CATEGORY:Vehicle
// :NAME:OpenSim Car
// :AUTHOR:Sarge Misfit
// :KEYWORDS:
// :CREATED:2014-02-08
// :EDITED:2014-02-08 08:13:30
// :ID:1021
// :NUM:1585
// :REV:1
// :WORLD:OpenSim
// :DESCRIPTION:
// This script allows a car to hover over water as well as run on land. It has ten power settings. 
// :CODE:
// This script allows a car to hover over water as well as run on land. It has ten power settings. I have not yet been able to get it to allow a flight mode. It is ODE Physics based.

integer Private = 1;    // Change to 1 to prevent others riding.
integer tt;
integer Gear = 1;
integer Run;
integer oldn;

vector Sitpos = <.8,0,.8>;
vector SitrotV = <0,0,0>;

rotation Sitrot;

key oldagent;
key agent;

float forward_power = 3; //Power used to go forward (1 to 30)
float forward_normal = 3;
float crash_power_forward = 3;
float reverse_power = -3; //Power ued to go reverse (-1 to -30)
float turning_ratio = 5; //How sharply the vehicle turns. Less is more sharply. (.1 to 10)
float Speed;

string sit_message = "Ride"; //Sit message
string not_owner_message = "You are not the owner of this vehicle."; //Not owner message
string DrivingAnim = "driving generic"; //Animation to use when owner sits

///////////////////////////////

go_up()
{
    llSetStatus(STATUS_PHYSICS, FALSE);
    llSetRot(<0,0,0,0>);
    llSetStatus(STATUS_PHYSICS, TRUE);
}

setCamera(float degrees) 
{
    rotation sitRot = llAxisAngle2Rot(<0, 0, 1>, degrees * PI);
    llSetCameraEyeOffset(<-10, 0, 3> * sitRot);
    llSetCameraAtOffset(<4, 0, 3> * sitRot);
    llForceMouselook(FALSE);
}

setVehicle()
{
    llSetVehicleType(VEHICLE_TYPE_CAR);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.1);
    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.2);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 0.2);
    llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 0.10);
    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 0.2);
    llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 0.2);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.1);
    llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 0.5);

}

Init()
{
    Run = 0;
    llSetVehicleType(VEHICLE_TYPE_NONE);
    llSetStatus(STATUS_PHYSICS, FALSE);
    Sound(0);
    vector rotv = llRot2Euler(llGetRot());
    rotation rot = llEuler2Rot(<0,0,rotv.z>);
    llSetRot(rot);
    Sitrot = llEuler2Rot(DEG_TO_RAD * SitrotV);
}

Reset()
{
    Run = 0;
    vector rotv = llRot2Euler(llGetRot());
    rotation rot = llEuler2Rot(<0,0,rotv.z>);
    llSetRot(rot);
    llSetPos(llGetPos() + <0,0,0.5>);
}

integer LastSetMaterial = FALSE;
SetMaterial()
{
    if(LastSetMaterial == FALSE)
    {
        LastSetMaterial = TRUE;
    }
}

Sound(integer n)
{
    if(n != oldn)
    {
        oldn = n;
        if(n == 2)
        {
            llStopSound();
        }
        
        else if(n == 1)
        {
            llLoopSound("plane",1);
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
        llSetSitText(sit_message);
        llSitTarget(Sitpos, Sitrot);
        setCamera(0);
    }

on_rez(integer rn)
{
    llResetScript();
    llSetPos(llGetPos() + <0,0,.5>); 
}

link_message(integer sender, integer num, string message, key id)
{
    if(message=="reset")
    {
        Reset();
    }
}

changed(integer change)
{
    if ((change & CHANGED_LINK) == CHANGED_LINK)
    {
        agent = llAvatarOnSitTarget();
        
        if (agent != NULL_KEY)
        {
            if( (agent != llGetOwner()))
            {
                llSay(0, not_owner_message);
                llUnSit(agent);
                llPlaySound("car alarm",1.0);
                llPushObject(agent, <0,0,50>, ZERO_VECTOR, FALSE);
            }
            
            else
            {
                llSetStatus(STATUS_PHYSICS, TRUE);
                llSleep(.4);
                oldagent = agent;
                setVehicle();
                SetMaterial();
                llSetTimerEvent(0.3);
                llMessageLinked(LINK_SET, 0, "shift", "2");
                llRequestPermissions(agent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
                Sound(1);
                Run = 1;
            }
        }
        
        else
        {
            Run = 0;
            llReleaseControls();
            llStopAnimation(DrivingAnim);
            Init();
            llSetPos(llGetPos() + <0,0,0>);
            Sound(0);
        }
    }
}
    
run_time_permissions(integer perm)
{
    if (perm)
    {
        forward_power = forward_normal;
        reverse_power = -2; 
        turning_ratio = 5; 
        Gear = 2;
        llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_DOWN | CONTROL_UP | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);
        llPlaySound("start",1.0);
        llMessageLinked(LINK_SET, 0, "shift", "2");
        llSetPos(llGetPos() + <0,0,0.5>);
        llStartAnimation(DrivingAnim);
        llWhisper(0,"Hit M for mouselook, page up and down for thrust control. If you flip, Stand Up to flip the vehicle right-side up.");
    }
}

control(key id, integer level, integer edge)
{
    if(Run == 0)
    {
        return;
    }
    integer reverse=1;
    vector angular_motor;
    vector vel = llGetVel();
    Speed = llVecMag(vel);

    if ((level & edge & CONTROL_UP) || ((Gear >= 7) && (level & CONTROL_UP)))
    {
        Gear=Gear+1;
      
        if(Gear == 2) 
        {
            llSay(0,"Thrust at 10%");
            llLoopSound("gear1",1);
            llMessageLinked(LINK_SET, 0, "shift", "2");
        }
    
        if(Gear == 3) 
        {
            llSay(0,"Thrust at 20%");
            llLoopSound("gear2",1);
            llMessageLinked(LINK_SET, 0, "shift", "3");
        }                          
    
        if(Gear == 4) 
        {
            llSay(0,"Thrust at 30%");
            llLoopSound("gear3",1);
            llMessageLinked(LINK_SET, 0, "shift", "4");
        }                                
    
        if(Gear == 5) 
        {
            llSay(0,"Thrust at 40%");
            llLoopSound("gear4",1);
            llMessageLinked(LINK_SET, 0, "shift", "5");
        }                                
    
        if(Gear == 6) 
        {
            llSay(0,"Thrust at 50%");
            llLoopSound("gear5",1);
            llMessageLinked(LINK_SET, 0, "shift", "6");
        }
    
        if(Gear == 7) 
        {
            llSay(0,"Thrust at 60%");
            llLoopSound("gear6",1);
            llMessageLinked(LINK_SET, 0, "shift", "7");
        }
        
        if(Gear == 8) 
        {
            llSay(0,"Thrust at 70%");
            llLoopSound("gear6",1);
            llMessageLinked(LINK_SET, 0, "shift", "8");
        }
        
        if(Gear == 9) 
        {
            llSay(0,"Thrust at 80%");
            llLoopSound("gear6",1);
            llMessageLinked(LINK_SET, 0, "shift", "9");
        }
        
        if(Gear == 10) 
        {
            llSay(0,"Thrust at 90%");
            llLoopSound("gear6",1);
            llMessageLinked(LINK_SET, 0, "shift", "10");
        }
        
        if(Gear == 11) 
        {
            llSay(0,"Thrust at 100%");
            llLoopSound("gear6",1);
            llMessageLinked(LINK_SET, 0, "shift", "11");
        }
    
        if (Gear < 1) Gear = 1;
        if (Gear > 11) Gear = 11;
    }

    if ((level & edge & CONTROL_DOWN) || ((Gear >= 7) && (level & CONTROL_DOWN)))
    {
        Gear=Gear-1;
    
        if(Gear == 2) 
        {
            llSay(0,"Power at 10%");
            llLoopSound("gear1",1);
            llMessageLinked(LINK_SET, 0, "shift", "2");
        }
    
        if(Gear == 3) 
        {
            llSay(0,"Power at 20%");
            llLoopSound("gear2",1);
            llMessageLinked(LINK_SET, 0, "shift", "3");
        }
    
        if(Gear == 4)
        {
            llSay(0,"Power at 30%");
            llLoopSound("gear3",1);
            llMessageLinked(LINK_SET, 0, "shift", "4");
        }                                
    
        if(Gear == 5) 
        {
            llSay(0,"Power at 40%");
            llLoopSound("gear4",1);
            llMessageLinked(LINK_SET, 0, "shift", "5");
        }                                
    
        if(Gear == 6) 
        {
            llSay(0,"Power at 50%");
            llLoopSound("gear5",1);
            llMessageLinked(LINK_SET, 0, "shift", "6");
        }      
    
        if(Gear == 7) 
        {
            llSay(0,"Power at 60%");
            llLoopSound("gear6",1);
            llMessageLinked(LINK_SET, 0, "shift", "7");
        }  
        
        if(Gear == 8) 
        {
            llSay(0,"Thrust at 70%");
            llLoopSound("gear6",1);
            llMessageLinked(LINK_SET, 0, "shift", "8");
        }
        
        if(Gear == 9) 
        {
            llSay(0,"Thrust at 80%");
            llLoopSound("gear6",1);
            llMessageLinked(LINK_SET, 0, "shift", "9");
        }
        
        if(Gear == 10) 
        {
            llSay(0,"Thrust at 90%");
            llLoopSound("gear6",1);
            llMessageLinked(LINK_SET, 0, "shift", "10");
        }
        
        if(Gear == 11) 
        {
            llSay(0,"Thrust at 100%");
            llLoopSound("gear6",1);
            llMessageLinked(LINK_SET, 0, "shift", "11");
        }
                                  
        if (Gear < 1) Gear = 1;
        if (Gear > 11) Gear = 11;
    }
        
    if(level & CONTROL_FWD)
    {
        turning_ratio = 5;
        llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <10.0, 2.0, 1000.0>);
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <Gear*forward_power,0,0>);
        reverse=1;
    }

    if(level & CONTROL_BACK)
    {
        llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <10.0, 2.0, 1000.0>);
        llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <Gear*reverse_power,0,0>);
        turning_ratio = -5;
        reverse = -1;
    }

    if(level & (CONTROL_RIGHT|CONTROL_ROT_RIGHT))
    {
        angular_motor.z -= Speed / (turning_ratio*Gear);
    }
                        
    if(level & (CONTROL_LEFT|CONTROL_ROT_LEFT))
    {
        angular_motor.z += Speed / (turning_ratio*Gear);
    }
        
    llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);
        
}       

timer()
{

    if(Run == 1)
    {
        vector pos = llGetPos();
        float Z = pos.z;
            
        if(Z < 20)
        {
            llSetVehicleFlags(VEHICLE_FLAG_HOVER_WATER_ONLY);
            llSetVehicleFloatParam(VEHICLE_BUOYANCY, 1 );
            llSetVehicleFloatParam(VEHICLE_HOVER_HEIGHT, 20);
        }
            
        else
        {
            llRemoveVehicleFlags(VEHICLE_FLAG_HOVER_WATER_ONLY);
            llSetVehicleFloatParam(VEHICLE_BUOYANCY, 0 );
        }
        vector vel = llGetVel();
        Speed = llVecMag(vel);

        if(Speed > 2.0)
        {
            Sound(2);
        }

        else if(Speed > 0.0)
        {
            llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1.0, 2.0, 1000.0>);
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <0,0,0>);
            Sound(1);
        }
        llSetTimerEvent(0.3);  
    }
        
    else
    {
        llSetTimerEvent(0.0);
    }
}
    
} //end default