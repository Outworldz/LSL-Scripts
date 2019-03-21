// :CATEGORY:Prim
// :NAME:Prim_Animator_using_one_script
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2010-10-23 21:23:45.047
// :EDITED:2013-09-18 15:39:00
// :ID:649
// :NUM:882
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// A simple sensor to trigger your animated prims.// If an avatar gets within a settable distance, it plays back animation 'sit'.  When all avatars have left, it plays a 'stand' animation.
// :CODE:

// Sensor
integer sitting = FALSE;

default
{
    state_entry()
    {
        llMessageLinked(LINK_SET,1,"stand",""); // stand on all 4's
        llSensorRepeat("","",AGENT,5,PI,5.0);   // look for people
    }
    
    // found an avatar
    sensor(integer num_detected)
    {     
        if (sitting)
        {
            llMessageLinked(LINK_SET,1,"sit","");   // sit on rear
            sitting = FALSE;
        }
    }
    
    // no one detected?
    no_sensor()
    {
        if (! sitting)
        {
            llMessageLinked(LINK_SET,1,"stand","");     // stand on all 4's
            sitting = TRUE;
        }
    }
}
