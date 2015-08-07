// :CATEGORY:Vehicles
// :NAME:Chen_Engine
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:173
// :NUM:244
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Chen Engine.lsl
// :CODE:

integer speedfoward = 25;
integer speedback = -15;
integer handleleft = 3;
integer handleright = 3;
float attract = .5;
string preset = "Manual";

default
{    

    
    state_entry()
    {
        llPreloadSound("tricyclealarm");
        llPreloadSound("arm");
        llListen(0,"","","");
        llPassCollisions(TRUE);
        llPassTouches(TRUE);
         
        
        llSetSitText("Drive");
        
       
        llSitTarget(<0.6, 0.03, 0.20>, ZERO_ROTATION);
      
        llSetCameraEyeOffset(<-15.0, -0.00, 3.0>);
        llSetCameraAtOffset(<3.0, 0.0, 3.0>);
    
        
        
        llSetVehicleType(VEHICLE_TYPE_CAR);
        
        
        
        llSetVehicleFlags (VEHICLE_FLAG_LIMIT_ROLL_ONLY);
        
        
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.2);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.80);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, 0.10);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, 0.10);
        
        
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, 1.0);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, 0.2);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, 0.1);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, 0.5);
       
        llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <10.0, 0.5, 1000.0>);
        llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <10.0, 10.0, 0.5>);
        
       
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, attract);
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, 0.20);
        
        
        llSetVehicleFloatParam(VEHICLE_BANKING_EFFICIENCY, .75);
        llSetVehicleFloatParam(VEHICLE_BANKING_TIMESCALE, 0.01);
        llSetVehicleFloatParam(VEHICLE_BANKING_MIX, 1.0);
        
        
        
        
        llCollisionSound("", 0.0);
    
  
}

   
    listen(integer channel, string name, key id, string message)
    {
        if(message == "speed +" && id == llGetOwner()){
            speedfoward = speedfoward + 10;
            speedback = speedback - 5;
            preset = "Manual";
            llSay(0, "Foward Speed is Now " +(string)speedfoward +" Meters/s. The Reverse Speed is now " +(string)speedback  +" Meters/s");
}if(message == "speed -" && id == llGetOwner()){
            speedfoward = speedfoward - 10;
            speedback =speedback +5 ;
            preset = "Manual";
            llSay(0, "Foward Speed is Now " +(string)speedfoward +" Meters/s. The Reverse Speed is now " +(string)speedback +" Meters/s");
}
if(message == "speed" && id == llGetOwner()){
            
            llSay(0, "Foward Speed is Currently " +(string)speedfoward +" Meters/s. The Reverse Speed is Currently " +(string)speedback +" Meters/s");
}
  if(speedback >=0)
    {
        speedback = -15;
        llSay(0, "The Reverse Speed Has Reached The Slowest Speed of 5 Meters/s..Setting Speed To -15 Meters/s");
}
 if(speedfoward <=0)
    {
        speedfoward = 10;
        llSay(0, "The Foward Speed Has Reached The Slowest Speed of 10 Meters/s");
}
if(speedback >=60)
    {
        speedback = -59;
        llSay(0, "The Reverse Speed Has Reached The Fastest Speed of -60 Meters/s");
}
 if(speedfoward >=60)
    {
        speedfoward = 59;
        llSay(0, "The Foward Speed Has Reached The Fastest Speed of 60 Meters/s");
}
 if(handleleft <=1)
    {
        handleleft = 1;
        handleright = 1;
        llSay(0, "The Handling Has Reached The Loosest Turn at 1 Out Of 12");
    }
    if(handleleft >=12)
    {
        handleleft = 12;
        handleright = 12;
        llSay(0, "The Handling Has Reached The Tightest Turn at 12 Out Of 12");
    }
if(message == "handling +" && id == llGetOwner()){
            handleleft = handleleft + 1;
            handleright =handleright + 1 ;
            preset = "Manual";
            
            llSay(0, "The Handling on the cycle is now " +(string)handleleft +" Out Of 12.");
}
if(message == "handling -" && id == llGetOwner()){
            handleleft = handleleft - 1;
            handleright =handleright - 1 ;
            preset = "Manual";
            
            llSay(0, "The Handling on the cycle is now " +(string)handleleft +" Out Of 12.");
}
if(message == "handling" && id == llGetOwner()){
            
            
            llSay(0, "The Handling on the cycle is now " +(string)handleleft +" Out Of 12.");
}
if(message == "stats" && id == llGetOwner()){
                        
            llSay(0, "Speed: Foward = " +(string)speedfoward +" Meters/s. Reverse = " +(string) speedback +" Meters/s");
 llSay(0, "Handling: " +(string)handleleft +" Out Of 12");
 llSay(0, "Gravity: " +(string)attract +" Out Of 1, Where 1 = Heavy and 0 = Light");

llSay(0, "Current Preset: " +preset);
}
if(preset != "Flat Land" && preset != "Hills" && preset !="Mountains" && preset != "Trick"){
    preset = "Manual";
}


if(message == "preset flat land" && id == llGetOwner()){
    speedfoward = 50;
    speedback = -45;
    handleleft = 4;
    handleright = 4;
    attract = .75;
    preset = "Flat Land";
   
                        
            llSay(0, "Adjusting For Flat Terrian...");
            llSleep(3);
            llSay(0, "Ole' Betsy Now Adjusted To Flat Land!");
}
if(message == "preset hills" && id == llGetOwner()){
    speedfoward = 30;
    speedback = -25;
    handleleft = 3;
    handleright = 3;
    attract = .9;
    preset = "Hills";
                           
            llSay(0, "Adjusting For Hilly Terrian...");
            llSleep(3);
            llSay(0, "Ole' Betsy Now Adjusted To Hilly Land!");
}
if(message == "preset mountains" && id == llGetOwner()){
    speedfoward = 25;
    speedback = -15;
    handleleft = 2;
    handleright = 2;
    attract = .4;
    

                        
            llSay(0, "Adjusting For Rough Terrian...");
            llSleep(3);
            llSay(0, "Ole Betsy Now Adjusted To Bumpy Land!");
}
if(message == "preset trick" && id == llGetOwner()){
    speedfoward = 59;
    speedback = -25;
    handleleft = 7;
    handleright = 7;
    attract = .5;
    preset = "Trick";
   
                        
            llSay(0, "Adjusting For Stunts & Tricks...");
            llSleep(3);
            llSay(0, "Ole' Betsy Now Adjusted To Stunts & Tricks!");
}

if(attract <0)
{
    attract =0;
    llSay(0, "The Cars Gravity Has Reached The Lightest Weight it Can of 0!");
}
if(attract >1)
{
    attract =1;
    llSay(0, "The Cars Gravity Has Reached The Heviest Weight it Can of 1!");
}
if(message == "gravity -" && id == llGetOwner())
{
    attract =attract -.1;
    llSay(0, "The Cars Gravity is Now Set To " +(string)attract +" Out of 1 Where 1 Was the Heaviest.");
}
if(message == "gravity +" && id == llGetOwner())
{
    attract =attract -.1;
    llSay(0, "The Cars Gravity is Now Set To " +(string)attract +" Out of 1 Where 1 Was the Heaviest.");
}
    
   
}touch(integer detected)
    {
       if(llDetectedKey(0) ==  llGetOwner())
       {
            llWhisper(0, "Hello, " +llKey2Name(llDetectedKey(0)) +", Right click me and choose 'Drive' from the pie menu to Ride.");
        }
        else
        {
            llWhisper(0, "Hello, " +llKey2Name(llDetectedKey(0)) +", wanna buy this hot ride? Visit Busy Ben's In Oak Grove To Buy Your Own!!");
llGiveInventory(llDetectedKey(0),"Busy Ben's Vehicle Lot");
        }
    
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
                    llSay(0, "Burgular Alarm activated ....BEEEEEEP!!!!");
                    llLoopSound("tricyclealarm", 1.0);
                                llUnSit(agent);
                  
                    llSleep(15);
                    llStopSound();
                    
                    
                    
                    
                }
                
                else
                {
                    
                    llSetStatus(STATUS_PHYSICS, TRUE);
                    
                    llRequestPermissions(agent, PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
                    
                    llPlaySound("SUZ_start (2).wav", 0.7);
                    
                    llMessageLinked(LINK_SET, 0, "get_on", "");
                }
            }
            
            else
            {
                
                llSetStatus(STATUS_PHYSICS, FALSE);
                llReleaseControls();
                              llPlaySound("arm",1.0);
                
                 llSay(23,"idle");
            }
        }
        
    }
    
    
    run_time_permissions(integer perm)
    {
        if (perm)
        {
            
            llTakeControls(CONTROL_FWD | CONTROL_BACK | CONTROL_RIGHT | CONTROL_LEFT | CONTROL_ROT_RIGHT | CONTROL_ROT_LEFT, TRUE, FALSE);
        }
    }
    
     
    control(key id, integer level, integer edge)
    {
        
        vector angular_motor;

        if(level & CONTROL_FWD)
        {   
         llSay(23,"drive");
            
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <speedfoward,0,0>);
            
        }
        if(level & CONTROL_BACK)
        {
            llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, <speedback,0,0>);
        }
        if(level & (CONTROL_RIGHT|CONTROL_ROT_RIGHT))
        {
            
            angular_motor.x += handleright;
            angular_motor.z -= handleright;
        }
        if(level & (CONTROL_LEFT|CONTROL_ROT_LEFT))
        {
            angular_motor.x -= handleleft;
            angular_motor.z += handleleft;
        }
        if(level & (CONTROL_UP))
        {
            angular_motor.y -= 50;
        }
        
        if((edge & CONTROL_FWD) && (level & CONTROL_FWD))
        {
            
            llMessageLinked(LINK_SET, 0, "burst", "");
        }
        if((edge & CONTROL_FWD) && !(level & CONTROL_FWD))
        {
            llMessageLinked(LINK_SET, 0, "stop", "");
        }
        
        
        llSetVehicleVectorParam(VEHICLE_ANGULAR_MOTOR_DIRECTION, angular_motor);
    }
    
}
// END //
