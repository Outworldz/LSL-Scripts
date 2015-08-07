// :CATEGORY:Follower
// :NAME:Sensorless_Pet_follower_script
// :AUTHOR:anonymous
// :CREATED:2011-01-22 12:31:31.260
// :EDITED:2013-09-18 15:39:02
// :ID:739
// :NUM:1022
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Sensorless_Pet_follower_script
// :CODE:
vector offset = < -1, 0, 1>;  //1 meter behind and 1 meter above owner's center.
 
default
{
    state_entry()
    {
        llSetStatus(STATUS_PHYSICS, TRUE);
        // Little pause to allow server to make potentially large linked object physical.
        llSleep(0.1);
        llSetTimerEvent(1.0);
    }
    timer()
    {
        list det = llGetObjectDetails(llGetOwner(),[OBJECT_POS,OBJECT_ROT]);//this will never fail less owner is not in the same sim
        // Owner detected...
        // Get position and rotation
        vector pos   = llList2Vector(det,0);
        rotation rot = (rotation)llList2String(det,1);
        // Offset back one metre in X and up one metre in Z based on world coordinates.
        // use whatever offset you want.
        vector worldOffset = offset;
        // Offset relative to owner needs a quaternion.
        vector avOffset = offset * rot;
 
        pos += avOffset;       // use the one you want, world or relative to AV.
 
        llMoveToTarget(pos,0.4);
    }
}
