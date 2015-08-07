// :CATEGORY:Sound
// :NAME:Frog_sensor
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:340
// :NUM:458
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Frog sensor.lsl
// :CODE:

// Frog player
// Written by Ferd Frederix
// Scans every 10 seconds for visitors within 5 meters.
// then it croaks

play ()
{
       string sound = "frog";
       float value = llFrand(4.0) ;
       integer file = (integer) value + 1;       
       llPlaySound( sound + (string) file, 1.0);
}
 
default
{
    state_entry()
    {
        // arc=PI is a sphere, you could look more narrowly in the direction object is facing with PI/2, PI/4 etc.
        // don't repeat this too often to avoid lag.
        llSensorRepeat("", "", AGENT, 5.0, PI, 10.0);
    }
    
    sensor(integer num_detected)
    {
        play();
    }

    touch(integer num_detected)
    {
        play();
    }

}
// END //
