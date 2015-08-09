// :CATEGORY:Teleport
// :NAME:Teleport-Region
// :AUTHOR:Vincent Nacon
// :CREATED:2013-10-14 12:01:28
// :EDITED:2013-10-14 12:01:28
// :ID:1001
// :NUM:1541
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Teleport witin a sim 
// :CODE:

////////////////////////////////////////////////////////
//             Written by Vincent Nacon
//          Released into the Public Domain
//   I'm sick and tired of WarpPos and <0,0,0> bug.
//                    Feb 26th 2012
////////////////////////////////////////////////////////
 
//What to do?
//
// Just place position (in vector form) where you want to drop avatar at in the prim's description.
 
default
{
    changed(integer change)
    {
        vector targetPosition = (vector)llGetObjectDesc();
 
        key sittingAvatar = llAvatarOnSitTarget();
 
        if(sittingAvatar)
        {
            vector positionToReturnTo = llGetPos();
 
            llSetRegionPos(targetPosition);
            llUnSit(sittingAvatar);
            llSetRegionPos(positionToReturnTo);
        }
    }
 
    state_entry()
    {
        llSitTarget(<0.0, 0.0, 0.1>, ZERO_ROTATION);
    }
}
