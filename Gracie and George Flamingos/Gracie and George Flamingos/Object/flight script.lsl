// :CATEGORY:Birds
// :NAME:Gracie and George Flamingos
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2014-12-04 12:12:20
// :EDITED:2014-12-04
// :ID:1057
// :NUM:1680
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Free-flight bird system without physics main script
// :CODE:
// Bird flock flight script
// Author: Fred Beckhusen (Ferd Frederix)
// This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
//  This means that this script itself is not for sale and that modifications to it must be provided to anyone upon request. Pets made with this script may be sold. ~ Fred Beckhusen (Ferd Frederix)

// requires the following animations:
// land, fly, peck, walk1, walk2, walk3 

integer _debug = FALSE;
float SPACE = 1;    // twice the amount of slop in flight
float SPEED = 2.0;        // how fast to fly, large = faster, in meters per second.
float RANGE = 8;        // how far to sense avatars
float TIMEOUT = 2;        // how long  to stay on ground after flight, and to scan for avatars
float MIN = 2;            // walk timers
float MAX = 7;            // MAX + MIN is the random time for actions

string WINGSOUND = "silence";    // UUID of a sound of wings flapping
string PECK = "pecking";            // peck sound
string FLY = "silence";          // flying sound

float totalTime;        // the total time it takes to fly around once.
list lCoordinate;        // a list of coordinates, rotations, and times from the notecard

integer moving = FALSE;    // true if we are flying.
integer starting = FALSE;   // true once the timer is set up

// notecard reading
integer iIndexLines;        // the current line
string NOTECARD = "Route";  // the notecard for configuring
integer initted;            // set TRUE when notecard is read.
key kNoteCardLines;        // the key of the notecard
key kGetIndexLines;        // the key of the current line
integer linecounter;


// movement
integer started = FALSE;    // true once someone has clicked Start
integer sensorON ;            // true if we are the controlling bird
vector startPos;            // Home pos
vector lastPos;             // last position we read
rotation lastRot;           // last rotation
rotation startRot;          // initial rotation

integer first;              // first time flag
integer channel = -32523874;    // the only listener
integer listener;           // listener int

rotation NormRot(rotation Q)
{
    float MagQ = llSqrt(Q.x*Q.x + Q.y*Q.y +Q.z*Q.z + Q.s*Q.s);
    return <Q.x/MagQ, Q.y/MagQ, Q.z/MagQ, Q.s/MagQ>;
}
 
 
restart()
{
    SetupListens();
   // llSetRot(ZERO_ROTATION);
    startPos = llGetPos();
    startRot = llGetRot();
    
    moving = FALSE;
    
    if (started)
    {
        llSensorRepeat("", "", AGENT, RANGE, PI, TIMEOUT);
        llSetTimerEvent(llFrand(MAX)+MIN);    // movement channel        
    }
}

menu()
{
    llDialog(llGetOwner(),"Bird Controls:",["Start","Reset","Stop","Set Pos"],channel);
}

string strip( string str)
{
    string out;
    integer i;

    for (; i < llStringLength(str); i++)
    {
        out += llGetSubString(str,i,i);
        out = llStringTrim(out, STRING_TRIM);
    }
    return out;

}

string Getline(list Input, integer line) 
{
    return strip(llList2String(Input, line));
}

startFlight()
{  

    if (_debug) llOwnerSay("flying");
    // tell the others
    if (sensorON)
        llSay(channel,"Start");
    llMessageLinked(LINK_SET,1,"land","");
    llMessageLinked(LINK_SET,1,"fly","");
    
   // llLoopSound(FLY,1.0);
    starting = TRUE;
    llSetTimerEvent (0.1);
}

init()
{
    kNoteCardLines = llGetNumberOfNotecardLines(NOTECARD);
    kGetIndexLines = llGetNotecardLine(NOTECARD,0);
}

SetupListens()
{
    if (listener)
        llListenRemove(listener);
    
    listener = llListen(channel,"","","");
}

default
{
    
    on_rez(integer p)
    {
        llResetScript();
    }
    
    
    state_entry()
    {
        llStopSound();
        
        llSetKeyframedMotion([],[KFM_COMMAND,KFM_CMD_STOP]);
        //llSetRot(ZERO_ROTATION);
        llMessageLinked(LINK_SET,1,"land","");

        //if (_debug) llSetRegionPos(<114.332, 187.276, 20.8566>);
        
        if (initted == FALSE)
        {
            llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_CONVEX]); // needed for older clients
            init();
        }
    }


    changed(integer what)
    {
        if (what & CHANGED_INVENTORY)
        {
           llResetScript();
        }
    } 

    // read notecard on reset
    dataserver(key queryid, string data)
    {
        if (queryid == kNoteCardLines)
        {
            iIndexLines = (integer) data;
        }

        if (queryid == kGetIndexLines)
        {
            if (data != EOF)
            {
                queryid = llGetNotecardLine(NOTECARD, linecounter);
                list lLine = (llParseString2List(data, ["|"], []));

                float ctr = (float) Getline(lLine,1);
                if (ctr >= 0)
                {
                    vector pos = (vector)Getline(lLine,2);
                    
                    if (pos != ZERO_VECTOR)
                    {
                        rotation rot = (rotation) Getline(lLine,3);
                        float distance = llVecDist(pos,lastPos);
                        
                        float time = distance / SPEED;
                        time += llFrand(.2);
                        
                        if (time < .2)
                            time = 0.2;
                        
                        //rotation newRot = NormRot(rot );
                        
                        integer newtime = (integer) (time * 45);
                        
                        time = (float) newtime /45;
                        
                        lCoordinate += pos ; //* newRot;
                        //lCoordinate += newRot;
                        
                        lCoordinate += NormRot(rot);
                        lCoordinate += time;
                        totalTime += time;
                        
                        lastPos = pos;
                        lastRot = rot;
                    }
                    integer locationLength = (llGetListLength(lCoordinate))/3;     // 3 strided list

                    integer     InitPerCent = (integer) llRound(((float) locationLength / (float) iIndexLines) * 100);
                    llSetText("Initialising... \n" + (string) InitPerCent + "%" , <1,1,1>, 1.0);
                    
                }
                else
                {
                    llOwnerSay("Something is wrong in the notecard");
                }
                linecounter++;
            }
            else
            {
                llOwnerSay("Flight time is " + (string) totalTime + " seconds.");
                llSetText("", <1,1,1>, 1.0);
                initted = TRUE;
                state movement;
            }
            kGetIndexLines = llGetNotecardLine(NOTECARD,linecounter);
        }
    }
}



state movement
{
    state_entry()
    {
        restart();
    }

    changed(integer what)
    {
        if (what & CHANGED_INVENTORY)
        {
           llResetScript();
        }
    } 


    sensor(integer number)
    {
        llSensorRemove();    // an avatar is here, we will turn it on after we fly.
        if (sensorON  && ! moving)
        {
            startFlight();
        }
    }

    touch_start(integer p)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            menu();
        }
    }

    timer()
    {
        
        if (starting)
        {
            llSleep(1);
            llSetKeyframedMotion(lCoordinate, [KFM_DATA, KFM_TRANSLATION|KFM_ROTATION, KFM_MODE, KFM_FORWARD]);
            moving  = TRUE;
            starting = FALSE;
            sensorON = TRUE;        // start the sensing 
            llSetTimerEvent(totalTime);    // wake us up at end of the trip.
            if (_debug) llOwnerSay("start flying");
        }
        else if (moving )
        {
            if (_debug) llOwnerSay("stopping");
                        
            llSetKeyframedMotion([],[KFM_COMMAND,KFM_CMD_STOP]);
            llSleep(1);     // time to land, flapping motion
            llSetPos(startPos);
            llMessageLinked(LINK_SET,1,"land","");
            llSetRot(startRot);
            llStopSound();
            moving = FALSE;
            
            if( sensorON)
                llSensorRepeat("", "", AGENT, RANGE, PI, TIMEOUT);
            
            llSetTimerEvent(llFrand(MAX)+MIN);  
        }
        else
        {
            if (_debug) llOwnerSay("peck");
        
            
            llStopSound();
            float rand = llFrand(4);
            if (rand < 1.0) // 25 % chance of a peck
            {
                llMessageLinked(LINK_ROOT,1,"peck","");
                llPlaySound(PECK,1);
            }
            else if (rand < 2) // 25% chance of a flap
            {
                llPlaySound(FLY,1.0);
                llMessageLinked(LINK_SET,1,"peck","");
                llSleep(2);
                llMessageLinked(LINK_SET,1,"land","");
                llSleep(0.5);           
            }
            else        // 50% chance of a motion
            {
                integer walknum = llCeil(llFrand(2)) +1;        // from 1 to 3
                llMessageLinked(LINK_ROOT,1,"walk" + (string) walknum,"");
            }
            llSetTimerEvent(llFrand(MAX)+MIN);  
        }
        
    }


    listen(integer channel, string name, key id, string message)
    {
        if (message == "sensor")
        {
            sensorON = FALSE;
            llSensorRemove();
        }
        else if ( message == "Reset")
        {
            llResetScript();   
        }
        else if (message == "Stop")
        {
            moving = FALSE;
            llSetTimerEvent(0);
            llSensorRemove();
        }
        else if (message == "Start")
        {
            started = TRUE;
            if (moving)
                return;
                   
            llSleep(llFrand(1.0));            
            startFlight();
        }
        else if (message == "Set Pos")
        {
            startPos = llGetPos();
            startRot = llGetRot();
            llOwnerSay("Position set");
        }
    }
    
    
    on_rez(integer p)
    {
        llSay(channel,"sensor");
        sensorON = TRUE;

        restart();        
    }

    
}




 


