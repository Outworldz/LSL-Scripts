// :CATEGORY:Tour Guide
// :NAME:Tour Airplane
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2014-12-04 12:26:04
// :EDITED:2014-12-04
// :ID:1060
// :NUM:1692
// :REV:1.2
// :WORLD:OpenSim
// :DESCRIPTION:
// Tour controller for airplane
// :CODE:
// Revision:
// 0.1 8-17-2014 Initial Porting
// 0.2 8-22-2014 SL version 
// 0.3 8-23-2014 Opensim Bulletsim



integer debug = FALSE;
integer LSLEDITOR = FALSE;
integer DEATH = FALSE;
 
float SPEED = 10.0;        // tunable airplane speed

integer LINK_CMD = 0;
integer LINK_ANIMATE = 1;
integer LINK_POSITION   = 2;
integer LINK_RL = 3;
integer LINK_UP = 4;
integer LINK_DOWN = 5;
integer LINK_SPEED = 6;
float TIMER = 0.2;
vector lastPos;
vector DestPos;
integer timerOn;

// sounds
string sDoorClose = "";
string sEngineStart = "";  
string sThrottleUp = "sThrottleUp";
string sEngineOn = "sEngineOn";

DEBUG(string msg) {
    if (debug) llSay(0,llGetScriptName() + ":" + msg);
}

// Positive to the left, negative to the right, from 0 to PI which is behind you

//Returns angle the left or right of the baseline vector
float left_or_right(vector baseline, vector target)
{
    rotation rot_between = llRotBetween(baseline,target);
    vector euler_rot = llRot2Euler(rot_between);
    float z_rot = euler_rot.z;
    return z_rot;
}



default
{
    on_rez(integer start_param)
    {
        llResetScript();                
    }
    state_entry()
    {
        
        // the sit and camera placement is very shape dependent
        // so modify these to suit your vehicle
        llSitTarget(<0.6, 0.05, 0.20>, ZERO_ROTATION);
        llSetCameraEyeOffset(<-40.0, 0.0, 10.0> );
        llSetCameraAtOffset(<3.0, 0.0, 1.0> );
        
        
        llSetTimerEvent(0);
        DEBUG("MyPos:" + (string) llGetPos());
    }

    link_message(integer sender_number, integer number, string message, key id)
    {
      //  DEBUG("N:" + (string) number + ":" + message);
        
        if (LINK_POSITION == number && (vector) message != ZERO_VECTOR) {
            DEBUG("Set New Position:" + message);
            DestPos = (vector) message;
           llSetTimerEvent(.01);    // get moooving
            
        }  else if (LINK_CMD == number && message == "cStop") {
            DEBUG("UNSIT");
            llSetTimerEvent(0);

        }else if (LINK_CMD == number && message == "cStart") {
            // the plane just started in mid air
            DEBUG("START");
            llMessageLinked(LINK_THIS,LINK_SPEED,(string) SPEED,"");

              
        } else if (LINK_CMD == number && message == "Die") {
            DEBUG("Die");
            llSetTimerEvent(0);
            if (DEATH) 
                llDie();
            
        }  else if (LINK_CMD == number && message == "cShutdown") {
            timerOn = FALSE;
            llSetTimerEvent(0);

            DEBUG("Plane position set to " + message);
            llSetStatus(STATUS_PHYSICS,FALSE);
            llSleep(0.1);    // time to settle down
            if (DestPos != ZERO_VECTOR)
                llSetRegionPos(DestPos);
            
        } else if (LINK_CMD == number && message == "cDoorOpen") {
            DEBUG("Door Open");
            llMessageLinked(LINK_THIS,LINK_ANIMATE,"AllDoorsOpen","");
            
        } else if (LINK_CMD == number && message == "cDoorClose") {
            DEBUG("Door Close");
            llMessageLinked(LINK_THIS,LINK_ANIMATE,"AllDoorsClosed","");
            
        } else if (LINK_CMD == number && (llGetInventoryType(message) == INVENTORY_SOUND) ) {
            DEBUG("Playing sound:" + message);
            llLoopSound(message,1.0);

            if ( message == "sEngineStart")
                llPreloadSound(sThrottleUp);
            else if ( message == "sThrottleUp")
                llPreloadSound(sEngineOn);
            
        }
    }
        
    timer()
    {
        vector Pos = DestPos - llGetPos();
//        DEBUG("Pos:" + (string) Pos);

        float dist = llVecDist(llGetPos(),lastPos);
       /// DEBUG("Distance:" + (string) dist);
        
        lastPos = llGetPos();


        if (DestPos.z > lastPos.z)
            llMessageLinked(LINK_THIS,LINK_UP,"","");
        else
            llMessageLinked(LINK_THIS,LINK_DOWN,"","");

        
        if (dist <  SPEED)
            DEBUG("Go faster:"  + (string) (SPEED - dist));
            llMessageLinked(LINK_THIS,LINK_SPEED,(string) (SPEED - dist),"");
        if (dist > SPEED) {
            DEBUG("Go slower");
            llMessageLinked(LINK_THIS,LINK_SPEED,"-0.1","");
        }
        
        //Is the detected position  to the left or the right of this object's current heading?
        float target_L_or_R = left_or_right(llRot2Fwd(llGetRot()),Pos);
        
        llMessageLinked(LINK_THIS,LINK_RL,(string) target_L_or_R,"");
        if (LSLEDITOR)
            llSetTimerEvent(15);
        else
            llSetTimerEvent(TIMER);
    }



}
