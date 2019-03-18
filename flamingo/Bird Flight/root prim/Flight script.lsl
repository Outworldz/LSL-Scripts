// :CATEGORY:Bird
// :NAME:flamingo
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2013-09-06
// :EDITED:2014-09-24
// :ID:314
// :NUM:418
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Flying script
// :CODE:

// Bird flock flight script
// Author: Fred Beckhusen (Ferd Frederix)
// This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
// This means that this script itself is not for sale, that the script must be full Mod at all time, and that modifications to it MUST be provided to anyone upon request. Pets made with this script may be sold. ~ Fred Beckhusen (Ferd Frederix)
// 5-26-2013 


// requires the following animations, use the names on the right
string sLand = "land";      // land is when the legs are down
string sFly = "fly";         // fly is legs up
string sPeck = "peck";      // peck is actual pecking at the ground
string sPeckL = "peckL";    // peckL is left side pecking at the ground
string sPeckR = "peckR";    // peckR is right side pecking at the ground
string sLegFlop = "legs";   // legs is heads up
string sLookAround = "look";// looking around, with a wing flap
string sLanding = "landing";// landing positions

integer _debug = FALSE;        // to see what happens, set to FALSE for normal operation
float FUDGE = 0.0;            // random delay in flight speed each span travlled
float SPEED = 2.0;            // how fast to fly, large = faster, in meters per second.
float RANGE = 10;             // how far to sense avatars before flying
float TIMEOUT = 5;            // how long  to stay on ground after flight, and to scan for avatars
float MIN = 3;                // minimum time between animations
float MAX = 7;                // MAX + MIN (3+7=10) is the maximum pause between animations
integer channel = -325238;    // Change this only if you want flocks to not fly unless a sensor in this species detects a human. Otherwise any species will set off flight in 100 meter distance.

string PECK = "pecking";            // peck sound
string FLAP = "flying-dragon";      // flying wing sound, used here when the wings flap idly
string IDLE = "flamingo";           // a sound of a bunch of flamingos
string FLYING = "flamingo honking"; // used randomly in flight

// Link message numbers to/from the main bird menu
integer fromRoot = -3500;
integer toRoot = -3501;
integer toFlight = -3502;


float totalTime;        // the total time it takes to fly around once.
list lCoordinate;       // a list of coordinates, rotations, and times from the recorder

// boolean flags
integer iStopMoving;          // we need to stop moving
integer iAmFlying = FALSE;    // true if we are flying.
integer iStartTimer = FALSE;  // true once the timer is set up
integer iStarted = FALSE;    // true once someone has clicked Start

// movement

integer iAmMaster ;            // true if we are the controlling bird
vector startPos;            // Home pos
vector vLastRelPos;             // last position we read
rotation lastRot;           // last rotation
rotation startRot;          // initial rotation
integer listener;           // listener int

rotation NormRot(rotation Q)
{
    float MagQ = llSqrt(Q.x*Q.x + Q.y*Q.y +Q.z*Q.z + Q.s*Q.s);
    return <Q.x/MagQ, Q.y/MagQ, Q.z/MagQ, Q.s/MagQ>;
}
 
DEBUG(string msg)
{
    if (_debug)
        llOwnerSay(msg);
}

restart()
{
    SetupListens();

    vLastRelPos = ZERO_VECTOR;
    startRot = llGetRot();
    
    iAmFlying = FALSE;
    
    if (iStarted)
    {
        llSetTimerEvent(llFrand(MAX)+MIN);    // movement channel        
    }
}

menu()
{
    llDialog(llGetOwner(),"Bird Controls:",["Start","-","Stop","Set Home","-","Setup"],channel);
}


startFlight()
{  

    DEBUG("flying");

    // tell the others to boot up
    if (iAmMaster)
        llShout(channel,"Start");
    
    llMessageLinked(LINK_SET,1,sFly,"");
    iStartTimer = TRUE;
    llSetTimerEvent (0.1);
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
        llResetScript();    // only if not recrded
    }
       
    state_entry()
    {
        startPos = llGetPos();
         startRot = llGetRot();
        
        llStopSound();
        
        llSetKeyframedMotion([],[KFM_COMMAND,KFM_CMD_STOP]);
        
        llMessageLinked(LINK_SET,1,sLand,"");

        llSetLinkPrimitiveParamsFast(LINK_THIS, [PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_CONVEX]); // needed for older clients
        vLastRelPos = ZERO_VECTOR;    
        llMessageLinked(LINK_SET,0,"Setup","");
        totalTime = 0;
    }

    
    link_message(integer sender_number, integer number, string message, key id)
    {
        DEBUG("Bird herd:" +(string) number + ":" +  message );
        if (number == toFlight)        // coordinates
        {
            list lLine = llParseString2List(message, ["|"], []);
            DEBUG(llDumpList2String(lLine,","));
            
            vector pos = (vector) llList2String(lLine,0);
            
            if (pos != ZERO_VECTOR)
            {
                rotation rot = (rotation) llList2String(lLine,1);
                float distance = llVecDist(pos,vLastRelPos);
                DEBUG("Dist:" + (string) distance);
                
                float time = distance / SPEED;
                
                DEBUG("T1:" + (string) time);
                time += llFrand(FUDGE);

                // there is a minimum time
                if (time < .2)
                    time = 0.2;
              
                //time = (float) ((integer) (time * 45) /45); // round off to nearest frame time to stop drift
                DEBUG("T2:" + (string) time);
                
                lCoordinate += pos ; //* newRot;
                lCoordinate += NormRot(rot);
                lCoordinate += time;
                totalTime += time;

                // update the position so we can tell the difference for time calcs
                vLastRelPos = pos;
                lastRot = rot;
            }
        }
        else if (message == "Playback")
        {
             llSetPos(startPos);
             llSetRot(startRot);
             llOwnerSay("Route saved");
             llOwnerSay("Flight time is " + (string) totalTime + " seconds.");

             state movement;
        }
    }  
}



state movement
{
    state_entry()
    {
        llSetSoundQueueing(TRUE);
        restart();
        menu();
    }

     link_message(integer sender_number, integer number, string message, key id)
    {
        DEBUG("Bird herd:" +(string) number + ":" +  message );
    }
    

    sensor(integer number)
    {
        if (iAmMaster  && ! iAmFlying)
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
        if (iStartTimer)
        {
            llMessageLinked(LINK_SET,1,sFly,"");
            llSleep(1);            // time for the prims to move into place
            iAmFlying  = TRUE;
            iStartTimer = FALSE;

            llSetKeyframedMotion(lCoordinate, [KFM_DATA, KFM_TRANSLATION|KFM_ROTATION, KFM_MODE, KFM_FORWARD]);
            llSetTimerEvent(totalTime);    // wake us up at end of the trip.
            DEBUG("Started flying");
        }
        else if (iAmFlying)
        {
            DEBUG("Stopping");
                        
            llSetKeyframedMotion([],[KFM_COMMAND,KFM_CMD_STOP]);
            llMessageLinked(LINK_SET,1,sLanding,"");
            llSleep(1);     // time to land, flapping motion
            llMessageLinked(LINK_SET,1,sLand,"");
            llSetPos(startPos);
            llSetRot(startRot);
            llStopSound();
            
            iAmFlying = FALSE;
            
           
            DEBUG("stopped");
            llSetTimerEvent(llFrand(MAX)+MIN);

            llSensorRepeat("", "", AGENT, RANGE, PI, TIMEOUT);
            
        }
        else
        {
            DEBUG("peck");
            
            float rand = llFrand(10);
            if (rand < 1.0) // 10 % chance of peck right
            {
                llMessageLinked(LINK_ROOT,1,sPeckR,"");
                llPlaySound(PECK,1);
            }
            else if (rand < 2.0)     // 10 % chance of a peck to the left             {
            {
                llMessageLinked(LINK_ROOT,1,sPeckL,"");
                llPlaySound(PECK,1);
            }
            else  if (rand < 4.0) // 20% chance of a peck 
            {
                llMessageLinked(LINK_SET,1,sPeck,""); 
                llPlaySound(PECK,1);
            }
            else  if (rand < 6.0) // 20% chance of a leg swap
            {
                llMessageLinked(LINK_SET,1,sLegFlop,"");
            }
            else if (rand < 8.0) // 20 % chance of a look around && flap
            {
                llMessageLinked(LINK_ROOT,1,sFly,"");    // wings out, flapping
                llMessageLinked(LINK_ROOT,1,sLookAround,"");    // heads up
                llPlaySound(IDLE,1);                      // make honking sounds
                llSleep(2);
                llMessageLinked(LINK_ROOT,1,sLand,"");   // back to idle
            }
            else        // 20%
            {
                if (iAmMaster)        // only the lead bird loops the honking
                {
                    llPlaySound(IDLE,1);
                }
            }
            llSetTimerEvent(llFrand(MAX)+MIN);  
        }

        // they clicked stop, but we were flying, so we shut down here
        if (iStopMoving)
        {
            llSensorRemove();
            llSetTimerEvent(0.0);    
            iStopMoving = FALSE;
        }
        
    } // timer


    listen(integer channel, string name, key id, string message)
    {
        if (message == "sensor")
        {
            iAmMaster = FALSE;
            llSensorRemove();
        }
        else if ( message == "Setup")
        {
            state default;
        }
        else if (message == "Stop")
        {
            if (iAmFlying)
                iStopMoving = TRUE;    // cannot stop timer when flying, so we signal instead
            else
                llSetTimerEvent(0);
            llSensorRemove();
        }
        else if (message == "Start")
        {
            if (iAmFlying)
                return;
            
            iStarted = TRUE;       
            llSleep(llFrand(1.0));            
            startFlight();
        }
        else if (message == "Set Home")
        {
            if (iAmFlying)
                return;

            startPos = llGetPos();
            startRot = llGetRot();
            llOwnerSay("Position set");
        }
    }


    on_rez(integer p)
    {
        llShout(channel,"sensor");
        iAmMaster = TRUE;
        restart();        
    }

    
}




 



