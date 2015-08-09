// :CATEGORY:Sound
// :NAME:Frog_timer
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:341
// :NUM:459
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Frog timer.lsl
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
       llSetTimerEvent( 10.0);
    }
    
    timer()
    {
        play();
    }

    touch(integer num_detected)
    {
        play();
    }

}
// END //
