// :CATEGORY:Animal
// :NAME:Low_lag_Follower_script_for_animals
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2011-08-04 16:17:15.970
// :EDITED:2013-09-18 15:38:56
// :ID:496
// :NUM:663
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Script several linked prim sets to fly (loosely) as in a "flock" around a pre-set course. Low lag Follower script for birds, horse and other things that flock.// // You put a vector offset in the description of each "bird". They will follow that spot as an offset from a prim named 'Chaser'.  The speed is controlled by a single variable in the notecard line.  It can move very quickly.// // When the birds lead or follow the chaser prim,  they swing wildly out.  If you route has many zig zags, they would fly like a flock.// 
See http://phazedemesnes.blogspot.com/2011/02/herding-behaviour-in-animals-in-second.html for a description of this behavior using this script.
// 
// This is the Follower script. It goes in multiple birds or other animal
// :CODE:
// Author Fred Beckhusen (Ferd Frederix)
// Low lag Follower script for birds, horse and other things that flock
// see http://phazedemesnes.blogspot.com/2011/02/herding-behaviour-in-animals-in-second.html
// for  this works on herds of horses.
//
// 
// Chases after a prim named "CHaser" at a offset
// You must have an offset vector in this objects description like this:
// <1.5,2,3>   follow 1.5 meters to one side, 2 in front of, and 3 meters above the Chaser ( negative numbers are behind, positive in front of)

// Copyright 2011.   Licensed under the GNU open source license at
// http://www.gnu.org/copyleft/gpl.html
// Open source, you must make this script copy/tranfer AND mod and leave the headers, including this license and other attributions intact.
// 


integer _debug = 0;
vector priorpos;
float INTERVAL = .050; // seconds to move
vector offset = < -1, 0, 1>;  //1 meter behind and 1 meter above owner's center.
key Follower;


// movement

float DAMPING = .7;   // .3

// rotation
float STRENGTH = 1;
float DAMP = .2;

/////////////// CONSTANTS ///////////////////
string  FWD_DIRECTION   = "-x";
vector POSITION_OFFSET  ;
float   SCAN_REFRESH    = 0.2;
string FOLLOW   = "/follow";
string STAY     = "/stay";
integer FOLLOW_STOP     = 5000;
integer FOLLOW_START    = 5001;
float   MOVETO_INCREMENT    = 6.0;
///////////// END CONSTANTS /////////////////

///////////// GLOBAL VARIABLES ///////////////

rotation gFwdRot = <0,0,0,1>;
float   gTau = .2;


/////////// END GLOBAL VARIABLES /////////////

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
        llSensor("Chaser","",SCRIPTED|ACTIVE,96,PI);
        llSetVehicleType(VEHICLE_TYPE_CAR);

        // set to a 1 if you want to crawl sideways.  
        if (FALSE)
        {
            // rotate the vehicle frame -PI/2 about the local y-axis (left-axis)
            rotation rot =llEuler2Rot(<PI/2, 0,0>);
            llSetVehicleRotationParam(VEHICLE_REFERENCE_FRAME, rot);
        }

        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_TIMESCALE, .5);
        llSetVehicleFloatParam(VEHICLE_VERTICAL_ATTRACTION_EFFICIENCY, 1);

    }
    
    sensor(integer num_detected)
    {
        if (_debug) llOwnerSay("C0unt:" + (string) num_detected);
        Follower = llDetectedKey(0);
        if (_debug) llOwnerSay("Dest:" + (string) Follower);
        llSetStatus(STATUS_PHYSICS, TRUE);
        // Little pause to allow server to make potentially large linked object physical.
        llSleep(0.1);
        llSetTimerEvent(.5);
        //llGroundRepel(0.5, TRUE, 0.2);
        priorpos = llGetPos();
         
    }
    
    no_sensor()
    {
        llOwnerSay("No Chaser! Quitting");
    }
    
    timer()
    {
        vector myPos = llGetPos();
        
                // Get position and rotation
        list det = llGetObjectDetails(Follower,[OBJECT_POS,OBJECT_ROT]);
        vector Pos   = llList2Vector(det,0);
        rotation Rot = llList2Rot(det,1);
        
        rotation TargetRot = GetRotation(Rot); 
        POSITION_OFFSET  = (vector) llGetObjectDesc();
        
        vector Offset = POSITION_OFFSET * Rot;
        Pos += Offset;
        
        float howfar = llVecMag(myPos - Pos);
        
        if (_debug) llOwnerSay("Delta: " + (string) howfar);
        
        if (howfar > 0.5)
        {
            llLookAt(Pos, STRENGTH , DAMP );
            llMoveToTarget((llVecNorm(Pos - myPos) * howfar) + myPos, DAMPING);
        }

    }
}
