// :CATEGORY:Bird
// :NAME:Roaming Owl
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:01
// :ID:707
// :NUM:966
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// main script
// :CODE:

// ______           _  ______            _           _
// |  ___|         | | |  ___|          | |         (_)
// | |_ ___ _ __ __| | | |_ _ __ ___  __| | ___ _ __ ___  __
// |  _/ _ \ '__/ _` | |  _| '__/ _ \/ _` |/ _ \ '__| \ \/ /
// | ||  __/ | | (_| | | | | | |  __/ (_| |  __/ |  | |>  <
// \_| \___|_|  \__,_| \_| |_|  \___|\__,_|\___|_|  |_/_/\_\
//
// fred@mitsi.com 
// owl bird script
//
//Revisions:
// 1/28/2010 initial release

string CRY = "Bubo-virginianus";
string SHORT = "Bubo-virginianus short";
string SURPRISE = "Scotopelia-peli";
string prey = "Squirrel and feeder";


// fly sit, catch land

integer debug = 0;
vector rezpoint;    // home point
rotation rezrot;
integer Flying;

integer listen_chan;
integer listener;
float i ;  //counter for timer moving
vector up_vel = <10,0,9>;       // speed and direction away
vector down_vel = <6,0,-8>;    // and to go home, small numbers for less speed and mass objects
float STRENGTH = 2.0;  // how hard to turn
float DAMPING = 0.2;    // and how soon
float MAX = 3.0;   // MAX strength ( slow turns)
float MIN = 1.0;        // fast turns

float timerate = 0.215;     
float roam_range = 10;          // default range
string flag ; // what menu item thay need integers for
 

 


vector direction;
vector Destination;
float atimer;
float INTERVAL = .050; // seconds to move
integer SeekingFish = FALSE;
 
Dialog() 
{
    listener = llListen(listen_chan,"","","");
    llDialog(llGetOwner(),"Flight Controls: Home: current place is the roost\nTime: How often to fly when no one is near\nRange: Distance to roam\nFlap: Flap wings\nHelp: get notecard",["Range","Flap","Help","Home","Time","Ferd"],listen_chan);
}
 
CheckDir()
{
    vector currPos = llGetPos();
    if (currPos.z > Destination.z)
    {
        direction = down_vel;
       // if (debug) llOwnerSay("D");
    }
    else
    {
        direction = up_vel;
        //if (debug) llOwnerSay("U");
    }
    
    if (! SeekingFish)
    {    
        // go no lower than the rez point plus some slop
        if (currPos.z < rezpoint.z )
        {
            //if (debug) llOwnerSay("U");
            Destination.z = rezpoint.z + 1.0;
            direction = up_vel;
        }   
    }
}

DoMove()
{
    
    
    llMessageLinked(LINK_SET,1,"flap","");       // hop up
    CheckDir();
    
    //llSetStatus(STATUS_PHYSICS, TRUE);
    //llStopLookAt();
    llRotLookAt(llRotBetween(<1,0,0>, Destination - llGetPos()), STRENGTH, DAMPING);
    llSleep(DAMPING*3);
    llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, 1 * direction);
    llSleep(.1);
    llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, ZERO_VECTOR);
    //llSetStatus(STATUS_PHYSICS, FALSE);
    
    
}


NewDest()
{
     // random direction
    Destination = llGetPos();
    Destination.x += llFrand(roam_range) - 0.5 * roam_range;
    Destination.y += llFrand(roam_range) - 0.5 * roam_range;
    Destination.z += (llFrand(1.0) -.5 ) + .5;
    
    if (Destination.z < rezpoint.z )
    {
        Destination.z = rezpoint.z + 4.0;
        direction = up_vel;
    }
}


Fly()
{
    if (debug ) llOwnerSay("Fly");
    
    Flying = 1;
    i = 50;
    STRENGTH = MAX;  // how hard to turn
    
    NewDest();
    
    llPlaySound(CRY,1.0);
     
    SeekingFish = FALSE;
    llSensorRepeat(prey,"", ACTIVE|PASSIVE|SCRIPTED, 96, PI, 10.0);
    
    llSetStatus(STATUS_PHYSICS, TRUE);        
    llMessageLinked(LINK_SET,1,"fly","");       // hop up

    llSetTimerEvent(.1);        // fast
}
           
default
{
    
    on_rez(integer a)
    {     
        llResetScript();
    }

    state_entry()
    {
        llMessageLinked(LINK_SET,1,"sit","");       // hop up
        llSetStatus(STATUS_DIE_AT_EDGE,TRUE);
        llSetBuoyancy(0.8);
        rezpoint = llGetPos();
        rezrot = llGetRot();
        
        llSetStatus(STATUS_PHYSICS, FALSE);
        llSetVehicleFlags(-1);
        llSetVehicleType(VEHICLE_TYPE_CAR);

        llRemoveVehicleFlags(VEHICLE_FLAG_LIMIT_MOTOR_UP | VEHICLE_FLAG_LIMIT_ROLL_ONLY);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_EFFICIENCY, 0.8);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_EFFICIENCY, 0.8);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_DEFLECTION_TIMESCALE, .1);
        llSetVehicleFloatParam(VEHICLE_LINEAR_DEFLECTION_TIMESCALE, .1);
        llSetVehicleFloatParam(VEHICLE_HOVER_EFFICIENCY, 0.8);  // hover 
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_TIMESCALE, .1);
        llSetVehicleFloatParam(VEHICLE_LINEAR_MOTOR_DECAY_TIMESCALE, .1);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_TIMESCALE, .1);
        llSetVehicleFloatParam(VEHICLE_ANGULAR_MOTOR_DECAY_TIMESCALE, .1);
        
        llSetVehicleVectorParam(VEHICLE_LINEAR_FRICTION_TIMESCALE, <1.0, .1, 1000.0>);
        llSetVehicleVectorParam(VEHICLE_ANGULAR_FRICTION_TIMESCALE, <.1, .1, .1>);
        
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, .8);
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, .1);

        llSetVehicleFloatParam(VEHICLE_BANKING_EFFICIENCY, 0.25);
        llSetVehicleFloatParam(VEHICLE_BANKING_TIMESCALE, 0.1);
        llGroundRepel(2.0, TRUE, 0.2);
            
            
        
        atimer = 60;
        llOwnerSay("Flight range is 10 meters. Timer is 1 minute. Click bird to change settings");
        state moving;
    }
}


state moving
{

    on_rez(integer a)
    {    
        llResetScript();
    }
    
    timer()
    {   

        if (! Flying)
        {
            if (debug ) llOwnerSay("Was not flying");
            Fly();
        }

        if (--i == 0)
        {
            if (debug ) llOwnerSay("Too long");
            SeekingFish = FALSE;
            i = 50;
            Flying ++; // force HOME
            Destination = rezpoint;
            llPlaySound(CRY,1.0);
            STRENGTH = MIN;  // turn sharply
        }
        
        
        DoMove();
        
        if (llVecDist(Destination,llGetPos()) < 2) 
        {    
            if (debug) llOwnerSay("At Dest");
            i = 50;
            Flying++;
       }
                
        if (! SeekingFish && Flying < 8)
        {
            if ((integer) i % 10 == 0)
            {
                NewDest();
                if (debug ) llOwnerSay("New dest");
            }
            
            if ((llVecDist(rezpoint,llGetPos()) > roam_range)  )
            {
                if (debug ) llOwnerSay("Too far");
                Destination = rezpoint;
                Flying++;
                STRENGTH = MIN;  // turn sharply
                 llPlaySound(CRY,1.0);
            }
        }     
        
        
        if (SeekingFish && llVecDist(Destination,llGetPos()) < 2)
        {
            if (debug ) llOwnerSay("Caught Fish");
            llPlaySound(SURPRISE,1.0);
            llWhisper(2222,"fish");
            
            //llMessageLinked(LINK_SET,1,"sit","");       // grab the fish
            llMessageLinked(LINK_SET,1,"catch","");       // grab the fish
            SeekingFish = FALSE;
            Flying = 8;
            i=50;                           // need some time to get home
        }
            
        if (Flying == 9)
        {
            // back on the ground
            Destination = rezpoint;
            i=50; 
             
            if (debug ) llOwnerSay("Heading Home");
        }
        
        if (Flying >= 10)
        {   
            
            float dist = llVecDist(rezpoint,llGetPos());
            
        //    if (dist < 2)  
        //    {
                llMessageLinked(LINK_SET,1,"land","");       // hop up 
        //    }
            llPlaySound(SHORT,1.0);
            
            llSleep(0.5);
            
            llSetStatus(STATUS_PHYSICS, FALSE);
            llMessageLinked(LINK_SET,1,"sit","");       // hop up
            
            llSetRot(rezrot);
            llSetPos(rezpoint);
            
            
            // we may not have made it home, could have run into something
            if (dist > 1) 
            {    
                if (debug) llOwnerSay("Forced Home");
                state setposition; //contingency
            }
            //if(debug) llOwnerSay("At Home");
            
            SeekingFish = FALSE;
            Flying = 0;
            llSetTimerEvent(atimer);
            
            llSensorRepeat("","",AGENT,roam_range,PI,5);
            
        }        
    }
        
    state_entry()
    {    
        llSensorRepeat("","",AGENT,roam_range,PI,5);
        SeekingFish = FALSE;
        Fly();      // Fly at startup
    }
    

    
    
    sensor(integer total_number)
    {
        if (Flying)
        {
            if (debug ) llOwnerSay("Found Fish");
            llPlaySound(SURPRISE,1.0);
            Destination = llDetectedPos(0);
            Destination.z += 2.0;
            SeekingFish = TRUE;
            llSensorRemove();
             STRENGTH = 1.0;  // how hard to turn
            i = 50;         // need time to catch a fish
        }
        else
        {
            if (atimer)
                Fly();
        }
    }

    touch_start(integer a)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            listen_chan=llCeil(llFrand(10000) + 10000);
            Dialog();
        }
        else
        {
            if (atimer)
                Fly();
        }
    }
    
    listen(integer channel,string name, key id, string msg)
    {
        if (msg == "Range")
        {
            llDialog(llGetOwner(),"Range from Home place in meters",["10","15","20","25","30","35","40","45","50"],listen_chan);
            flag = "R";
        }
        else if ((integer) msg >= 10 && flag == "R")
        {
            roam_range = (integer) msg;
            flag = "";
            Dialog();
        }

        else if (msg == "Help")
            llGiveInventory(llGetOwner(),"Help");
        else if (msg == "Flap")
        {
            llMessageLinked(LINK_SET,1,"land","");       // hop up
            llPlaySound(CRY,1.0);
            llSleep(1);         // time to see it
            llMessageLinked(LINK_SET,1,"sit","");       // hop up
            Dialog();
        }
        else if (msg == "Home")
        {
            rezpoint = llGetPos();
            llOwnerSay("Position is set to " + (string) rezpoint);
            Dialog();
        }
        else if (msg =="Time")
        {
            llDialog(llGetOwner(),"How often they auto fly in seconds",["Off","15s","30s","1min","2min","3min","5min","15min","hour"],listen_chan);
        }
        else if (msg =="Off")
        {
            atimer = 0;
        }
        else if (msg =="15s") 
            atimer = 15;
        else if (msg =="30s")
            atimer = 30;
        else if (msg =="1min")
            atimer = 60;
        else if (msg =="2min")
            atimer = 120;
        else if (msg =="5min")
            atimer = 300;
        else if (msg =="15min")
            atimer = 900;
        else if (msg =="hour")
            atimer = 3600;
        
        else if (msg =="Ferd")
            llLoadURL(llGetOwner(),"More Info at our web site","http://secondlife.mitsi.com");

        llOwnerSay("Flight range is " + (string) roam_range + " meters. ");
        if (atimer)
            llOwnerSay("The bird will fly every " + (string) atimer + " seconds");
        else
            llOwnerSay("The bird will fly only when someone is near");
        
        if (! Flying)
        {
            llSetTimerEvent(atimer);
        }
    }
}



state setposition //contingency
{
    state_entry()
    {
        if (debug)llOwnerSay("Oops, forcing home");
        llSetTimerEvent(INTERVAL);        
    }

    on_rez(integer a)
    {    
        llResetScript();
    }
    
    timer() 
    {
        if (llVecMag(llGetPos() - rezpoint) > 5)
        {                
            llSetPos((llVecNorm(Destination - llGetPos()) * 0.5) + llGetPos());
        }
        else
        {
            llSetRot(rezrot);
            llSetPos(rezpoint);
            if (debug)llOwnerSay("Homed");
            llMessageLinked(LINK_SET,1,"sit","");       // hop up
            state moving;
        }

    }
    state_exit()
    {
        llSetTimerEvent(0);
    }
       
}

