// :SHOW:1
// :CATEGORY:Bird
// :NAME:llLookAtBird
// :AUTHOR:Dahlia Trimble
// :KEYWORDS:
// :CREATED:2015-02-24 16:06:24
// :EDITED:2015-02-25  20:59:17
// :ID:1067
// :NUM:1716
// :REV:1
// :WORLD:OpenSim
// :DESCRIPTION:
// A simple Bird follower script using llLookAt and llMoveToTarget
// :CODE:
// llLookAt code original by Dahlia Trimble  02/8/2015
// mods by Ferd Frederix 02-24-2015
// More mods by Ferd for finding anyone and staying in front.

vector gOffset = <2.0, 0.0, 0>;
key gTargetKey = NULL_KEY;

MoveToAndLookAt()
{
    
    float x = llFrand(1) - 1;  // not too close - must be less than gOffset .z
    float y = llFrand(3) - 1.5; // l-r
    float z = llFrand(2);     // up/down, lets not go too low or we bumnp the avi
    
    vector newgOffset = gOffset + <x,y,z>;  // Our new place to move to
    
    list avatars = llGetAgentList(AGENT_LIST_REGION,[]);
    integer N = llGetListLength(avatars);
    
    // anybody home?
    if (! N)
        return;
    
    integer i;
    list avatarList;
    
    for (i=0; i< N; i++) {
        gTargetKey = llList2Key(avatars,i);
        if (! osIsNpc(gTargetKey)) {
            list where = llGetObjectDetails(gTargetKey,[OBJECT_POS]);
            avatarList += llVecDist(llGetPos(),llList2Vector(where,0));
            avatarList += gTargetKey;
        }             
    } 
     
    avatarList = llListSort(avatarList, 2,TRUE);    
    gTargetKey = llList2Key(avatarList,1);

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

