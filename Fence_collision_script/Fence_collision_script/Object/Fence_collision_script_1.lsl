// :CATEGORY:Collider
// :NAME:Fence_collision_script
// :AUTHOR:fred.beckhusen
// :CREATED:2011-07-19 20:55:45.660
// :EDITED:2013-09-18 15:38:52
// :ID:299
// :NUM:398
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Fence_collision_script
// :CODE:

// start of code - this next line may need modifications

vector PUSH = <0,50,0>;    
      // bigger numbers make it fall over and further away. How much push to use depends upon how massive your fence is
      // you can push on more than 1 axis, such as <50,50,0>
      // negative numbers will 'pull'
      // <0,50,0> pushes in the Y axis < X ,Y, Z>.  <0,-50,0> will pull in the Y axis.
      // you may have to change this to <50,0,0> or even <0,0,50> depending upon how your object is rotated
      // if you set this to <0,0,0> it will not fall over except by gravity and any force from the collision itself

// these two variable are located outside the 'default' so that all events can set and read them
vector myPos;   // place to store the initial position
rotation myRot; // place to store the initial rotation


default
{
   
    state_entry()
    {
        llSetStatus(STATUS_PHYSICS, FALSE);          // make it Non-physical when you rez it
        myPos = llGetPos(); // save the initial position and rotation so we can set it back upright when reset
        myRot = llGetRot();
    }
   
   // when something collides, this collision start will trigger
    collision_start(integer num)
    {
        llSetStatus(STATUS_PHYSICS, TRUE);          // make it physical
        llSleep(0.1);  // give time for the physics engine to kick in.
        llPushObject(llGetKey(), PUSH, PUSH, TRUE);       // push it over                 
    }
   
    // no more collisions
    collision_end(integer num)
    {
        llSetTimerEvent( 10 );  // wait 10 seconds to tilt back up after no more collisions happen
    }
   
    // 10 seconds is up
    timer()
    {
        llSetStatus(STATUS_PHYSICS, FALSE);          // make it Non-physical
        llSleep(0.1);  // give time for the physics engine to kick off.
        llSetPos(myPos);  // stand it back upright
        llSetRot(myRot);  // at the original rotation
    }
   
   
    on_rez(integer start_p)
    {
        llResetScript();
    }
}
