// :CATEGORY:Building
// :NAME:Falling_Prims_Script
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2011-08-27 15:38:13.600
// :EDITED:2013-09-18 15:38:52
// :ID:297
// :NUM:396
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Falling_Prims_Script
// :CODE:
vector PUSH = <0,50,0>;     // bigger numbers make it fall over and further away, Pushes in the Y axis < X ,Y, Z>
                            // you may have to change this to <50,0,0> or even <0,0,50> depending upon how your object is rotated
                            // if you set this to <0,0,0> it will not fall over except by gravity and any force from the collision itself

vector myPos;   // place to store the initial position
rotation myRot; // place to store the initial rotation


default
{
    
    state_entry()
    {
        llSetStatus(STATUS_PHYSICS, FALSE);          // make it Non-physical
        myPos = llGetPos(); // save the initial position and rotation so we can set it back upright when reset
        myRot = llGetRot();
    }
    
    collision_start(integer num)
    {
        llSetStatus(STATUS_PHYSICS, TRUE);          // make it physical
        llSleep(0.1);  // give time for the physics engine to kick in.
        llPushObject(llGetKey(), PUSH, PUSH, TRUE);       // push it over                  
    }
    
    collision_end(integer num)
    {
        llSetTimerEvent( 10 );  // wait 10 seconds to tilt back up after no more collisions happen
    }
    
    
    timer()
    {
        llSetStatus(STATUS_PHYSICS, FALSE);          // make it Non-physical
        llSleep(0.1);  // give time for the physics engine to kick in.
        llSetPos(myPos);  // stand it back upright
        llSetRot(myRot);  // at the original rotation
    }
    
    
    on_rez(integer start_p)
    {
        llResetScript();
    }
}


