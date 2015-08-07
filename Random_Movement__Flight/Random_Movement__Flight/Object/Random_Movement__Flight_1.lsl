// :CATEGORY:Movement
// :NAME:Random_Movement__Flight
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:00
// :ID:678
// :NUM:921
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Random_Movement__Flight
// :CODE:
float distanceallowance = 5; //How many meters to let the butterfly wander away from the owner.


FetchTarget()
{
    num = llRound(llFrand(1));
    if(num == 0) { num = 2;}
    posneg = (integer)llList2String(mult,num);
    targetdist = <llFrand(distanceallowance)*posneg,0,0>;
    num = llRound(llFrand(1));
    if(num == 0) { num = 2;}
    posneg = (integer)llList2String(mult,num);
    targetdist = <targetdist.x,llFrand(distanceallowance)*posneg,0>;
    targetdist = <targetdist.x,targetdist.y,llFrand(distanceallowance)>;
    oursize = llGetAgentSize(llGetOwner());
    halfourheight = oursize.z / 2;
    targetpos = <ownerpos.x,ownerpos.y,ownerpos.z - halfourheight> + targetdist;
    if(targetpos.z < llGround(v))
    {
        targetpos.z = targetpos.z*-1;
    }
    target = llTarget(targetpos,1.0);
    llMoveToTarget(targetpos,2.0);
}
vector v;
vector oursize;
float halfourheight;
integer onlyabove;
list mult = [1,-1];
integer num;    
integer posneg;
vector targetdist;
integer target;
vector ownerpos;
vector targetpos;
default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    state_entry()
    {
        llSetBuoyancy(1.0);
        llVolumeDetect(TRUE);
        llSensorRepeat(llKey2Name(llGetOwner()),llGetOwner(),AGENT,96,PI,0.01);
        FetchTarget();
    }
    sensor(integer num_detected)
    {
        if(llVecDist(llGetPos(),targetpos) > distanceallowance)
        {
            FetchTarget();
        }
        if(ownerpos.z - llGround(v) <= 5)
        {
            onlyabove = TRUE;
        }
        if(ownerpos.z - llGround(v) > 5)
        {
            onlyabove = FALSE;
        }
        ownerpos = llDetectedPos(0);
        llLookAt(targetpos,0.1,1.0);
    }
    collision_start(integer num_detected)
    {
        FetchTarget();
    }
    land_collision_start(vector pos)
    {
        FetchTarget();
    }
    at_target(integer tnum,vector targetpos,vector ourpos)
    {
        FetchTarget();
    }
}
