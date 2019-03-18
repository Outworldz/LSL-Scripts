// :CATEGORY:Butterflies
// :NAME:Butterflies
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:49
// :ID:133
// :NUM:198
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Butterflies
// :CODE:

// flight

////////////////////////////////////////////
// Follow Me Script segment
//
// Written by Fred Beckhusen (Ferd Frederix)
///////////////////////////////////////// ///
float RADIUS = 2.0;

/////////////// CONSTANTS ///////////////////
string  FWD_DIRECTION   = "-x";

vector START;
float distance = 5;
float   MOVEfTO_INCREMENT    = 1;
float timerval  = .5;

float   gTau = .2;   // move
float rTau = 1;   // rotation
vector Pos; 
integer height = 1;
/////////// END GLOBAL VARIABLES /////////////


NewPos()
{   
    Pos.x  = START.x + llFrand(distance*2)- distance;
    Pos.y  = START.y + llFrand(distance*2)- distance;
    Pos.z  = START.z + llFrand(height); 
}

default 
{
    state_entry() 
    {
        llSetStatus(STATUS_PHYSICS, FALSE);
        llCollisionSound("",0.0);
    }
    
                    
    on_rez(integer startparam)
    {   
        llStopMoveToTarget();
        distance = (startparam >> 4) & 0xff;
        height = (startparam >> 16) & 0xff;
        
        llSetStatus(STATUS_PHYSICS, TRUE);
        
        START = llGetPos();
        Pos = START;
    
        NewPos();    
        llSetTimerEvent(timerval);
    }
    
    timer() 
    {   
        vector up = llRot2Up(  llGetRot() );
        llLookAt(Pos, gTau * 5.0, gTau);
        if (llVecDist(llGetPos(),Pos) < 0.5)
            NewPos();
        
        vector Dest = llGetPos() + llVecNorm(Pos - llGetPos()) * (llFrand(0.5) + .2);
        llMoveToTarget(Dest, gTau);
    }
}

