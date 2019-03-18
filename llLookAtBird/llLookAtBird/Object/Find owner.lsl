// :SHOW:
// :CATEGORY:Bird
// :NAME:llLookAtBird
// :AUTHOR:Dahlia Trimble
// :KEYWORDS:
// :CREATED:2015-02-24 16:06:24
// :EDITED:2015-02-24  15:06:29
// :ID:1067
// :NUM:1715
// :REV:1
// :WORLD:OpenSim
// :DESCRIPTION:
// A simple Bird follower script using llLookAt and llMoveToTarget to find anyone in a sim
// :CODE:
// llLookAt code original by Dahlia Trimble  02/8/2015
// mods by Fred Beckhusen (Ferd Frederix) 02-24-2015


vector gOffset = <-2.0, 0.0, 0>;  //behind the owner
key gTargetKey = NULL_KEY;

MoveToAndLookAt()
{
    
    float x = llFrand(1) - 1;  // not too close - must be less than gOffset .z
    float y = llFrand(3) - 1.5; // l-r
    float z = llFrand(2);     // up/down, lets not go too low or we bumnp the avi
    
    vector newgOffset = gOffset + <x,y,z>;  // Our new place to move to
    
    list details = llGetObjectDetails(gTargetKey, [OBJECT_POS, OBJECT_ROT]);


    vector pos = llList2Vector(details, 0);
    
    if (pos == ZERO_VECTOR)
    {
        return;
    }
    
    rotation rot = llList2Rot(details, 1);
    
    vector movePos = pos + newgOffset * rot;    

    float dist = llVecDist(movePos,llGetPos());
    
    float tau = dist / (llFrand(5)+1);  // D / 1-5 = from 1 to 6 meters/sec
    if (tau < 0.5) tau = 0.5;
    
    float turn = llFrand(2) + .2;       // from .2 to 2.2 turns/sec
        
    llLookAt(pos + <x,y,z>,  turn, 0.1); 
    llMoveToTarget(movePos, tau);
}

default
{
    state_entry()
    {

        integer i = llGetNumberOfPrims();
        integer j;
        for (j=1; j < i; j++)
        {
            llSetLinkPrimitiveParamsFast(j,[PRIM_PHYSICS_SHAPE_TYPE,PRIM_PHYSICS_SHAPE_NONE]);
        }
    
        llSetStatus(STATUS_PHYSICS, TRUE);
        
        gTargetKey = llGetOwner();
        llSetTimerEvent(3);
        MoveToAndLookAt();
    }
    
    timer()
    {
        MoveToAndLookAt();
    }
    
}

