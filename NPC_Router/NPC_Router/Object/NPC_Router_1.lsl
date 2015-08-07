// :CATEGORY:OpenSim NPC
// :NAME:NPC_Router
// :AUTHOR:DZ
// :CREATED:2013-08-02 12:55:45.110
// :EDITED:2013-09-18 15:38:58
// :ID:574
// :NUM:787
// :REV:1.0
// :WORLD:OpenSim
// :DESCRIPTION:
// This script re-directs any NPC that collides with the object to a random destination selected from an internal list.// Once the routers are placed, a text label display can be toggled by touching it. This makes it easy to collect locations// Routers should be placed to facilitate collisions with the avatar capsules.// The real trick of this router design is the rotate calculations. These prevents the NPCs from walking backwards when assigned new targets "behind" them.// // License:
// You are free:
// to Share — to copy, distribute and transmit the work
// to Remix — to adapt the work
// to make commercial use of the work
// 
See http://creativecommons.org/licenses/by-sa/2.5/
// :CODE:
// OpenSimian NPC router
//  Douglas Osborn  MOSES version 2013May06
 
// Assign random destination to a NPC that collides with volume detect object
// Drop the script in a prim, resize and position the prim to facilitate collision with NPC av capsules
 
// Modify the list of destination vectors to reflect your layout. 
// Router position text labels can be toggled by touching the prim.  This also triggers the setpos()
 
// This design imlements rotation calculations to prevent NPC avatars from walking backwards
//  Permissions and information about the rotation functions was here..
//     http://wiki.secondlife.com/wiki/User:Pedro_Oval/Calculate_rotation_for_pointing_in_a_direction
//  Due credit is here ...    Written by Pedro Oval, 2011-01-11
 
rotation PointAtHoriz2Rot(vector target)
{
    return llRotBetween(<1., 0., 0.>, <target.x, target.y, 0.>);
}
 
rotation PointAt2Rot(vector target)
{
    rotation r = PointAtHoriz2Rot(target);
    return llRotBetween(<1., 0., 0.>, target/r) * r;
}
//   end of Pedros' rotation magic
 
list DestinationList = [<70.0,70.0,30.0>,<97.0,100.0,37.0>,<70.0,190.0,33.0>];
 
//  Modify DestinationList..  Keep the list of vectors small to minimize processing
//  Be VERY careful about assigning destinations outside of the region.
//  NPC's will move in a direct line, design your "paths" to be as free of obstacles as possible
 
integer numDests = 0;
integer showPos = 0;
 
default
{
    state_entry()
    {
       llVolumeDetect(TRUE); // Starts llVolumeDetect
        numDests = llGetListLength(DestinationList);
 
    }
 
    touch_start (integer numtouches)
    {
        while (numtouches)
        {
            if(showPos)
            {
                llSetText("", ZERO_VECTOR, 0.0);
                showPos=0;
 
                // Comment out the following 2 lines if you do NOT want your targets to "snap" to integer value locations
                vector newpos = llGetPos();
                llSetPos(<llFloor(newpos.x),llFloor(newpos.y), llFloor(newpos.z)>);
            }
            else
            {
                showPos = 1;
                llSetText((string) llGetPos(), ZERO_VECTOR, 1.0);
                llSay(0,(string) llGetPos());
            }
            numtouches--;
        }
    }                
 
    collision_start(integer num)
    {
       integer i = 0;
       do
       {
           integer DestOffset = llFloor(llFrand(numDests));
           vector NewDest = llList2Vector(DestinationList,DestOffset) ;
           osNpcSetRot(llDetectedKey(i), PointAt2Rot(NewDest - llGetPos()));
           osNpcMoveToTarget(llDetectedKey(i), NewDest, OS_NPC_NO_FLY);
       }
       while(num > ++i);
    }
 
    changed(integer change)
    {
       if (change & CHANGED_REGION_RESTART)
       {
           llResetScript();
       }
    }
}
