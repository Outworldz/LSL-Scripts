// :CATEGORY:Tour
// :NAME:TourCopter
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:08
// :ID:909
// :NUM:1304
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tour
// :CODE:

﻿// ______           _  ______            _           _
// |  ___|         | | |  ___|          | |         (_)
// | |_ ___ _ __ __| | | |_ _ __ ___  __| | ___ _ __ ___  __
// |  _/ _ \ '__/ _` | |  _| '__/ _ \/ _` |/ _ \ '__| \ \/ /
// | ||  __/ | | (_| | | | | | |  __/ (_| |  __/ |  | |>  <
// \_| \___|_|  \__,_| \_| |_|  \___|\__,_|\___|_|  |_/_/\_\
//
// fred@mitsi.com
// tour copter script
//
//Revisions:
// 1/28/2010 initial release


integer _debug = 0;

integer ShoutChannel = 5;

integer falling = 0; // flag to let us know in final state we are falling in free-fall

// notecard readers
key RequestStops;
key GetIndexLines;

// The database read from the note card
list Line = [];
list lCoordinate = [];
list lDescriptions = [];
list lSounds = [];
list lCommands = [];
list lLinks = [];

integer IndexLines;
integer i = 0;
integer gCurrentRecord = 0;        // the current record in the notecard

integer locationLength;
integer InitPerCent;        // how far we have read in the notecard
integer timeout = 0;        // global timeout.. if the pysicas gets hosed from running into a solid object, this takes over and moves us no-physically.


vector TargetLocation;


float INTERVAL = .20; // seconds to move
float DAMPING = .1;   // .3

string SpeakThis;  // what is to be said
string PlayThis;  // what is to be said
string ChatThis;  // what is to be said
string LinkThis;  // what is to be said

// Particle Script 0.5
// Created by Ama Omega
// 3-26-2004

integer keystate = 0 ;

// Life in seconds for the system to make particles


integer flags;
list sys;


Look( vector target)
{
    float mass = llGetMass()/2;
    float damp = mass/5;
    llLookAt(target, mass, damp);        // 2,1, the damp could be smaller

}
// see if the pointer is past tghe end of memory
integer EndCard()
{
    return gCurrentRecord > (llGetListLength(lCoordinate) - 1);
}

// remove white space at begiinign and end
string trim(string input)
{
    //return llDumpList2String(llParseString2List(input, [" "], []), " ");
    return llStringTrim( input, STRING_TRIM  );
}

// fetch next notecard entry
GetNextRecord()
{
    gCurrentRecord++;
    TargetLocation = (vector) llList2String(lCoordinate, gCurrentRecord);
    if (_debug) llOwnerSay("Moving: " + (string) TargetLocation);
}

updateParticles()
{
    // Mask Flags - set to TRUE to enable
    integer glow = FALSE;            // Make the particles glow
    integer bounce = FALSE;          // Make particles bounce on Z plane of object
    integer interpColor = TRUE;     // Go from start to end color
    integer interpSize = TRUE;      // Go from start to end size
    integer wind = TRUE;           // Particles effected by wind
    integer followSource = FALSE;    // Particles follow the source
    integer followVel = FALSE;       // Particles turn to velocity direction

    // Choose a pattern from the following:
    // PSYS_SRC_PATTERN_EXPLODE
    // PSYS_SRC_PATTERN_DROP
    // PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY
    // PSYS_SRC_PATTERN_ANGLE_CONE
    // PSYS_SRC_PATTERN_ANGLE
    integer pattern = PSYS_SRC_PATTERN_EXPLODE;


    key target = "";

    // Particle paramaters
    float age = 5;                  // Life of each particle
    float maxSpeed = 1;            // Max speed each particle is spit out at
    float minSpeed = 0.8;            // Min speed each particle is spit out at
    string texture = "4f714019-c1cf-6b16-994f-44b217022f1a";                 // Texture used for particles, default used if blank
    float startAlpha = 0.8;           // Start alpha (transparency) value
    float endAlpha = 0.0;           // End alpha (transparency) value
    vector startColor = <0.5,0.5,0.5>;    // Start color of particles <R,G,B>
    vector endColor = <0,0,0>;      // End color of particles <R,G,B> (if interpColor == TRUE)
    vector startSize = <1.01,1.01,5.0>;     // Start size of particles
    vector endSize = <5.0,5.0,10.0>;       // End size of particles (if interpSize == TRUE)
    vector push = <.2,0,3>;          // Force pushed on particles

    // System paramaters
    float rate = 1;            // How fast (rate) to emit particles
    float radius = 0.0;          // Radius to emit particles for BURST pattern
    integer count = 40;        // How many particles to emit per BURST
    float outerAngle = 0;    // Outer angle for all ANGLE patterns
    float innerAngle = 0.1;    // Inner angle for all ANGLE patterns
    vector omega = <0,0,0>;    // Rotation of ANGLE patterns around the source
    float life = 0;

    flags = 0;

    if (glow) flags = flags | PSYS_PART_EMISSIVE_MASK;
    if (bounce) flags = flags | PSYS_PART_BOUNCE_MASK;
    if (interpColor) flags = flags | PSYS_PART_INTERP_COLOR_MASK;
    if (interpSize) flags = flags | PSYS_PART_INTERP_SCALE_MASK;
    if (wind) flags = flags | PSYS_PART_WIND_MASK;
    if (followSource) flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
    if (followVel) flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target != "") flags = flags | PSYS_PART_TARGET_POS_MASK;
    sys = [  PSYS_PART_MAX_AGE,age,
        PSYS_PART_FLAGS,flags,
        PSYS_PART_START_COLOR, startColor,
        PSYS_PART_END_COLOR, endColor,
        PSYS_PART_START_SCALE,startSize,
        PSYS_PART_END_SCALE,endSize,
        PSYS_SRC_PATTERN, pattern,
        PSYS_SRC_BURST_RATE,rate,
        PSYS_SRC_ACCEL, push,
        PSYS_SRC_BURST_PART_COUNT,count,
        PSYS_SRC_BURST_RADIUS,radius,
        PSYS_SRC_BURST_SPEED_MIN,minSpeed,
        PSYS_SRC_BURST_SPEED_MAX,maxSpeed,
        PSYS_SRC_TARGET_KEY,target,
        PSYS_SRC_INNERANGLE,innerAngle,
        PSYS_SRC_OUTERANGLE,outerAngle,
        PSYS_SRC_OMEGA, omega,
        PSYS_SRC_MAX_AGE, life,
        PSYS_SRC_TEXTURE, texture,
        PSYS_PART_START_ALPHA, startAlpha,
        PSYS_PART_END_ALPHA, endAlpha
            ];

    llParticleSystem(sys);
}

DoEffects()
{

    SpeakThis =  llList2String(lDescriptions, gCurrentRecord);
    PlayThis =  llList2String(lSounds, gCurrentRecord);
    ChatThis =  llList2String(lCommands, gCurrentRecord);
    LinkThis =  llList2String(lLinks, gCurrentRecord);


    if (llStringLength(SpeakThis) > 1)
        llSay(0,SpeakThis);

    if (llStringLength(PlayThis) > 1)
        llPlaySound(PlayThis,1.0);

    if (llStringLength(ChatThis) > 1)
    {
        if (_debug)    llWhisper(0,"Shouting on channel " + (string) ShoutChannel + " the message:" + LinkThis);
        llShout(ShoutChannel,"Shout message:" + ChatThis);
    }

    if (llStringLength(LinkThis) > 1)
    {
        if (_debug)    llWhisper(0,"Link message:" + LinkThis);
        llMessageLinked(LINK_SET,0,LinkThis,NULL_KEY);
    }

}

string Getline(list Input, integer line)
{

    return trim(llList2String(Input, line));
}



default_cam()
{
    if (_debug) llOwnerSay("default_cam"); // say function name for debugging
    llClearCameraParams(); // reset camera to default
}



driving_cam()
{


    llOwnerSay("driving_cam"); // say function name for debugging
    default_cam();

    llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 45.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.5, // (0 to 3) seconds
        CAMERA_DISTANCE, 10.0, // ( 0.5 to 10) meters
        //CAMERA_FOCUS, <0.0,0.0,5.0>, // region relative position
        CAMERA_FOCUS_LAG, 1.0 , // (0 to 3) seconds
        CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_PITCH, 20.0, // (-45 to 80) degrees
        //CAMERA_POSITION, <0.0,0.0,0.0>, // region relative position
        CAMERA_POSITION_LAG, 0.1, // (0 to 3) seconds
        CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, <00.0,0.0,10.0> // <-10,-10,-10> to <10,10,10> meters
            ]);
}



spin_cam()
{

    if (_debug) llOwnerSay("spin_cam"); // say function name for debugging
    llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 180.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.5, // (0 to 3) seconds
        //CAMERA_DISTANCE, 10.0, // ( 0.5 to 10) meters
        //CAMERA_FOCUS, <0.0,0.0,5.0>, // region relative position
        CAMERA_FOCUS_LAG, 0.05 , // (0 to 3) seconds
        CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_PITCH, 30.0, // (-45 to 80) degrees
        //CAMERA_POSITION, <0.0,0.0,0.0>, // region relative position
        CAMERA_POSITION_LAG, 0.0, // (0 to 3) seconds
        CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, <0.0,0.0,0.0> // <-10,-10,-10> to <10,10,10> meters
            ]);

    float i;
    vector camera_position;
    for (i=0; i< TWO_PI; i+=.05)
    {
        camera_position = llGetPos() + <0.0, 10.0, 0.0> * llEuler2Rot(<0.0, 0.0, i>);
        llSetCameraParams([CAMERA_POSITION, camera_position]);
    }
    default_cam();
}


////////////////////
default
{
    on_rez(integer param)
    {
        llResetScript();
    }
    changed( integer change )
    {
        if (change & CHANGED_INVENTORY)
        {
            llResetScript();
        }
    }

    state_entry()
    {
        llParticleSystem([]);
        llSitTarget(ZERO_VECTOR,ZERO_ROTATION);        // remove the sit, the pilot seat takes care of that
        llSetStatus(STATUS_DIE_AT_EDGE | STATUS_PHYSICS, FALSE);

        llMessageLinked(LINK_SET,0,"stop",NULL_KEY);
        llMessageLinked(LINK_SET,0,"off",NULL_KEY);

        llSetSoundQueueing(TRUE);
        llSetBuoyancy(1);
        RequestStops = llGetNumberOfNotecardLines("Initialize");
        GetIndexLines = llGetNotecardLine("Initialize",0);

        llSay (0, "Tour controller is initializing. Please wait.");

        if(llAvatarOnSitTarget() != NULL_KEY)   // if someone is sitting
            llUnSit(llAvatarOnSitTarget()); // unsit him
    }

    dataserver(key queryid, string data)
    {
        if (queryid == RequestStops)
        {
            IndexLines = (integer) data;
        }

        if (queryid == GetIndexLines)
        {
            if (data != EOF)
            {
                queryid = llGetNotecardLine("Initialize", i);
                Line = (llParseString2List(data, ["|"], []));
                // if (_debug )    llOwnerSay("Line = " + llDumpList2String(Line,":"));
                //string sComment = Getline(Line,0);
                float X             = (float)Getline(Line,1);
                float Y             = (float)Getline(Line,2);
                float Z             = (float)Getline(Line,3);
                string Msg             = Getline(Line,4);
                string sUUID         = Getline(Line,5);
                string sCommand     = Getline(Line,6);
                string sLink         = Getline(Line,7);

                vector TempLocation;

                TempLocation.x = X;
                TempLocation.y = Y;
                TempLocation.z = Z;

                lCoordinate = lCoordinate + [TempLocation];
                lDescriptions = lDescriptions + [Msg];
                lSounds +=  [sUUID];
                lCommands += [sCommand];
                lLinks += [sLink];

                locationLength = (llGetListLength(lCoordinate));
                InitPerCent = (integer) llRound(((float) locationLength / (float) IndexLines) * 100);
                llSetText("Initializing... \n" + (string) InitPerCent + "%" , <1,1,1>, 1.0);
                if (InitPerCent == 100)
                {
                    state Paused;
                }
                i++;
            }
            GetIndexLines = llGetNotecardLine("Initialize",i);
            //if (_debug ) llOwnerSay("Got " + (string) i);
        }
    }

    touch_start(integer total_number)
    {
        integer check = llGetListLength(lCoordinate);

        if (_debug) llOwnerSay("List is " + (string) check + " destinations long");

        if (check >= IndexLines)
            state Paused;

        if (check < IndexLines)
            llSay(0, "Waiting for the tour pilot, please wait a moment...");
    }

    state_exit()
    {
        llSetText("", <1,1,1>, 1.0);

        if (_debug)
            llOwnerSay("First Target Location = " + (string) TargetLocation);

    }
}


state Paused
{
    state_entry()
    {
        llSay(0,"Ready for the next passenger.");
    }

    link_message(integer sender, integer num, string str, key id)
    {
        if (str =="pilot" and key != NULL_KEY)
        {
            llTriggerSound("7Clearedfortakeoff",1.0);
            llSleep(3.0);        // time for it to start playing cause next line gets loud!
            llMessageLinked(LINK_SET,0,"start",NULL_KEY);
            llMessageLinked(LINK_SET,0,"on",NULL_KEY);
            llMessageLinked(LINK_SET, (integer) 100, "throttle", NULL_KEY);
            llSleep(10.0);

            llMessageLinked(LINK_SET,0,"displayon",NULL_KEY);
            llSleep(5.0);

            TargetLocation = (vector) llList2String(lCoordinate, 0);  // Look at 0th vector
            state MoveToTarget;
        }
    }
}




state MoveToTarget
{
    state_entry()
    {
        if (_debug) llOwnerSay("State MoveToTarget entered, is pointing to target " + (string) TargetLocation );
        llSetStatus(STATUS_PHYSICS, TRUE);

        llSetTimerEvent(INTERVAL);
        Look(TargetLocation);

    }


    timer()
    {
        timeout = timeout + 1;
        if (timeout > 60/INTERVAL ) // Time Out to contingency in one minute, if we cannot get ther by then, we go non-physical
        {
            llOwnerSay("Copter is stuck at " + (string) llGetPos());
            state end;
        }
        if (llVecDist(TargetLocation, <0,0,0>) < 1)
        {
            llOwnerSay("wtf? Copter is headed for <0,0,0>!");
            state end;
        }

        float x = llVecMag(llGetPos() - TargetLocation);

        if (_debug)  llSetText("Timeout... \n" + (string) timeout + "\n" + (string) x, <1,1,1>, 1.0);

        vector vPos = llGetPos();
        vector vMoveBig = TargetLocation - vPos;
        float fDistance = llVecMag(vMoveBig);
        if (fDistance > 10)// distance is greater than llMoveToTarget can handle, so just 10m toward destination
        {
            vector vNewPos = vPos + llVecNorm(vMoveBig)*1;
            llMoveToTarget(vNewPos,DAMPING);
        }
        else
        {
            llMoveToTarget(TargetLocation,DAMPING);
            if (_debug) llOwnerSay("At destination: " + (string) llGetPos());
            DoEffects();
            GetNextRecord();
            if (EndCard())
                state end;

            Look(TargetLocation);    // Look at target
        }
    }

    state_exit()
    {


        llSetTimerEvent(0);
        //llSetStatus(STATUS_PHYSICS, FALSE);

        timeout = 0;
    }

}


state setposition //contingency
{
    state_entry()
    {
        llSetPrimitiveParams([PRIM_PHYSICS, FALSE]);
        llSetTimerEvent(INTERVAL);
    }

    changed( integer change )
    {
        if (change & CHANGED_INVENTORY)
        {
            llResetScript();
        }
    }

    timer()
    {
        if (llVecMag(llGetPos() - TargetLocation) > .49999)
        {
            if (_debug )  llOwnerSay("setposition llLookAt: " + (string) TargetLocation);

            llSetPos((llVecNorm(TargetLocation - llGetPos()) * 0.5) + llGetPos());
            Look(TargetLocation);    // Look at targe
        }

        if (llVecMag(llGetPos() - TargetLocation) < .49999)
        {
            if (_debug)
                llOwnerSay("At location: " + (string) llGetPos());
            llSetPrimitiveParams([PRIM_PHYSICS, TRUE]);
            GetNextRecord();
            if (EndCard())
                state end;

        }
    }
    state_exit()
    {
        llSetTimerEvent(0);
    }

}

state end
{
    state_entry()
    {

        updateParticles();        // smoke on
        spin_cam();

        if (_debug) llOwnerSay("State MoveToTarget entered, is pointing to target " + (string) TargetLocation );

        // jerk the copter around by pointing nose down at 45 degree angle
        vector mypos = llGetPos();

        mypos.z -=10;
        mypos.y -=10;
        mypos.x -=10;

        Look(mypos);
        timeout = 0;

        llSetTimerEvent(INTERVAL);
    }

    timer()
    {
        timeout = timeout + 1;

        if (llVecMag(llGetPos() - TargetLocation) > .49999)
        {
            if (timeout > 30/INTERVAL) // Time Out to contingency
            {
                llSetTimerEvent(0);
                spin_cam();
                if(llAvatarOnSitTarget() != NULL_KEY)   // if someone is sitting
                    llUnSit(llAvatarOnSitTarget()); // unsit him

                llSetPrimitiveParams([PRIM_TEMP_ON_REZ,TRUE]);
            }
            llMoveToTarget((llVecNorm(TargetLocation - llGetPos()) * 1) + llGetPos(), DAMPING);
        }

        if (llVecMag(llGetPos() - TargetLocation) < .49999)
        {
            falling ++;
            llMessageLinked(LINK_SET,0,"bomb",NULL_KEY);      // bombs away
        }

        if (falling)
        {
            llStopLookAt();
            llStopMoveToTarget();
            llSetBuoyancy(0.8);         // blades are spinning, so we float a bit

            if (timeout % 51 == 0) // 10 seconds
            {
                spin_cam();
                llMessageLinked(LINK_SET,0,"fire",NULL_KEY);
                llMessageLinked(LINK_SET,0,"stop",NULL_KEY);
            }

            if (timeout > 100)        // 20 seconds
            {

                llSetTimerEvent(0);
                llMessageLinked(LINK_SET,0,"bomb",NULL_KEY);
                spin_cam();
                if(llAvatarOnSitTarget() != NULL_KEY)   // if someone is sitting
                    llUnSit(llAvatarOnSitTarget()); // unsit him

                llSetPrimitiveParams([PRIM_TEMP_ON_REZ,TRUE]);
                llSetBuoyancy(0.8);         // blades are spinning
            }
        }
    }
}



