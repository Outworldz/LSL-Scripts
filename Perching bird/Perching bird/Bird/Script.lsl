// :CATEGORY:Bird
// :NAME:Perching bird
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-11-19 16:49:08
// :EDITED:2013-11-19 16:49:08
// :ID:1002
// :NUM:1542
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// A free-flying bird that perches on your arm
// :CODE:
// ______           _  ______            _           _
// |  ___|         | | |  ___|          | |         (_)
// | |_ ___ _ __ __| | | |_ _ __ ___  __| | ___ _ __ ___  __
// |  _/ _ \ '__/ _` | |  _| '__/ _ \/ _` |/ _ \ '__| \ \/ /
// | ||  __/ | | (_| | | | | | |  __/ (_| |  __/ |  | |>  <
// \_| \___|_|  \__,_| \_| |_|  \___|\__,_|\___|_|  |_/_/\_\
//
// fred@mitsi.com 
// tour bird script
//
//Revisions:
// 1/28/2010 initial release
// 03/06/2010 added perching

integer debug = 0;
/////////////// CONSTANTS ///////////////////
string  FWD_DIRECTION   = "x";
vector  POSITION_OFFSET; // Local coords
float   SCAN_REFRESH    = 0.5;
float   MOVETO_INCREMENT    = 0.5;
key gOwner;
rotation gFwdRot;
float   gTau;
float   gMass;
integer count;
integer repeat;
integer flag2 = 0;
vector Pos;
float FORCE = 2;
float DAMPING2 = .2;    // and how soon
integer seek = TRUE;
integer movement = 0;
///////////// END PERCH CONSTANTS /////////////////

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
 
vector newpos;
 
vector dir;
float dist;
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
 

rotation GetRotation(rotation rot) 
{
    vector Fwd;
    Fwd = llRot2Fwd(rot);
    
    float Angle = llAtan2( Fwd.y, Fwd.x );
    return gFwdRot * llAxisAngle2Rot(<0, 0, 1>, Angle);
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

// Move to a position far away from the current one.
MoveTo(vector target) 
{
    vector Pos = llGetPos();
    
    while (llVecDist(Pos, target) > .1) 
    {
        Pos += llVecNorm(target - Pos) * MOVETO_INCREMENT;
        llSetPos(Pos);
    }
    llSetPos(target);    
}


DoMove()
{
    integer selected;
    
    CheckDir();
    
    llStopLookAt();
    llRotLookAt(llRotBetween(<1,0,0>, Destination - llGetPos()), STRENGTH, DAMPING);
    llSleep(DAMPING*3);
    llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, 1 * direction);
    llSleep(.1);
    llSetVehicleVectorParam(VEHICLE_LINEAR_MOTOR_DIRECTION, ZERO_VECTOR);
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
        
    SeekingFish = FALSE;
    llSensorRepeat("Rainbow Trout","", ACTIVE|PASSIVE|SCRIPTED, 96, PI, 10.0);
    
    llSetStatus(STATUS_PHYSICS, TRUE);        
    llMessageLinked(LINK_SET,0,"FLY","");       // hop up
    movement = 0;
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
        llSetStatus(STATUS_PHYSICS, FALSE);
        gOwner = llGetOwner();
        gFwdRot = GetFwdRot();
        gMass = llGetMass();
        gTau = 0.4;
        
        llMessageLinked(LINK_SET,0,"SIT","");       // hop up
        llSetStatus(STATUS_DIE_AT_EDGE,TRUE);
        llSetBuoyancy(0.8);
        rezpoint = llGetPos();
        rezrot = llGetRot();
        
        
        llSetVehicleFlags(-1);
        llSetVehicleType(VEHICLE_TYPE_CAR);
        llGroundRepel(2.0, TRUE, 0.2); 
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
        
        atimer = 60;
        llOwnerSay("Flight range is 10 meters. Timer is 1 minute. Click bird when it flies to change settings");
        llRequestPermissions(gOwner,PERMISSION_TRIGGER_ANIMATION);
        
    }
    
     run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION)
        {
            llStartAnimation("Perch");
            state Avatar;
        }
        else
        {
            state moving;
        }
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
    
    
        if (debug) llOwnerSay("Flying = " + (string) Flying);

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
            }
        }     
        
        
        if (SeekingFish && llVecDist(Destination,llGetPos()) < 2)
        {
            if (debug ) llOwnerSay("Caught Fish");
            llPlaySound("Bald Eagle Cry",1.0);
            llWhisper(2222,"fish");
            
            llMessageLinked(LINK_SET,0,"SIT","");       // grab the fish
            llMessageLinked(LINK_SET,0,"FISH","");       // grab the fish
            SeekingFish = FALSE;
            Flying = 8;
            i=50;                           // need some time to get home
        }
            
        if (Flying == 9)
        {
            Flying = FALSE;

            state Avatar;
        }        
        
    }
        
    state_entry()
    {        
        Fly();      // Fly at startup
    }
    
    
    sensor(integer total_number)
    {
        if (debug ) llOwnerSay("Found Fish");
        llPlaySound("Bald Eagle Call",1.0);
        Destination = llDetectedPos(0);
        Destination.z += 2.0;
        SeekingFish = TRUE;
        llSensorRemove();
        STRENGTH = 1.0;  // how hard to turn
        i = 50;         // need time to catch a fish        
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
            llDialog(llGetOwner(),"Range from Avatar in meters",["10","15","20","25","30","35","40","45","50"],listen_chan);
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
            llMessageLinked(LINK_SET,0,"FLAP","");       // hop up
            llPlaySound("Bald Eagle Cry",1.0);
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
            llLoadURL(llGetOwner(),"More Info about Fred Beckhusen (Ferd Frederix)","http://secondlife.mitsi.com");

        llOwnerSay("Flight range is " + (string) roam_range + " meters. ");
        if (atimer)
            llOwnerSay("The bird will fly every " + (string) atimer + " seconds");
        else
            llOwnerSay("The bird will fly only when you touch it");
        
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
            llMessageLinked(LINK_SET,0,"SIT","");       // hop up
            state moving;
        }

    }
    state_exit()
    {
        llSetTimerEvent(0);
    }
       
}


state Avatar 
{
    state_entry() 
    {
        seek = TRUE;
        llSetStatus(STATUS_PHANTOM, TRUE);
        llSetTimerEvent(atimer);
        llSetStatus(STATUS_PHYSICS, TRUE);
        llSensorRepeat("", gOwner, AGENT, 20.0, PI, SCAN_REFRESH);
        llMoveToTarget(llGetPos(), gTau);
    }
    
    
    timer()
    {
        state moving;
    }
    
    touch_start(integer num_detected)
    {
        
        state moving;
    }
    
    state_exit()
    {
        rezpoint = llGetPos();
        llSensorRemove();
        llStopLookAt();
        llStopMoveToTarget();
        llStopAnimation("Perch");
    }
    
    sensor(integer num_detected) 
    {

        rotation TargetRot;
        Pos = llDetectedPos(0);

        rotation Rot = llDetectedRot(0);
        vector size = llGetAgentSize(llDetectedKey(0));
        //llSetStatus(STATUS_PHYSICS, TRUE);
        string anim =  llGetAnimation(gOwner);
           
        list anims = llGetAnimationList(llGetOwner());

                
        if((anim != "Standing") || llListFindList(anims,[(key)("c541c47f-e0c0-058b-ad1a-d6ae3a4584d9")]) != -1)
        {
            llStopAnimation("Perch");
            POSITION_OFFSET  = <0.0, -.4, (size.z /2) + 1>;
            if (flag2++ % 2 == 0) {
                llSetPos(llGetPos() + <0,0,.1>);
                llMessageLinked(LINK_SET,0,"FLY","");       // grab the fish
            }
            else
            {
                llSetPos(llGetPos() + <0,0,-.1>);
                llMessageLinked(LINK_SET,0,"FLAP","");       // grab the fish
            }

            
        }
        else 
        { 
            POSITION_OFFSET  = <0, -.4, (size.z /2) +.3>;        
            //POSITION_OFFSET  = <0, 0, 0>;        
            llMessageLinked(LINK_SET,0,"SIT","");       // grab the fish
            llStartAnimation("Perch");
        }
        
        TargetRot = GetRotation(Rot); 
        vector Offset = POSITION_OFFSET * Rot;
        Pos += Offset;
        
        if (llVecDist(Pos,llGetPos()) > .5)
        {   
            llSetStatus(STATUS_PHYSICS, TRUE);
            llMoveToTarget(Pos,0.2);
            llRotLookAt(TargetRot, 0.2 , 0.050);
            movement++;
        }         
        else
        {
            if (movement)
            {
                llStopMoveToTarget();
                //llStopLookAt();
                llSetStatus(STATUS_PHYSICS, FALSE);
                //rotation xyz_angles = llEuler2Rot(<0,0,0> * DEG_TO_RAD); 
                //llSetRot(llGetRot()*xyz_angles); //Do the Rotation...
                llSetPos(Pos);
                movement = 0;
            }        
    
        }
        count=0;
        repeat=0;
    }
    
    
    
    no_sensor()
    {
        llMessageLinked(LINK_SET,0,"FLY","");       // grab the fish
        
        count += 1;
        if(count > 150)
        {
            repeat += 1;
            string name = llKey2Name(llGetOwner());
            string pos = (string)llGetPos();
            string simName=llGetRegionName();
            if(repeat < 2) 
            { 
                llInstantMessage(llGetOwner(),name + ", I am lost at:" + simName + pos + ". Please come and get me !");
            }
            else
            {
                llInstantMessage(llGetOwner(),name + ", This one will go to bed !");
                llDie();
            }
            count=0;
        }
    }
    
    
    on_rez(integer start_param)
    {
        llResetScript();
    } 
}