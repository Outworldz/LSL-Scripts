// :CATEGORY:Greeter
// :NAME:VERY_SIMPLE_GREETING_Script
// :AUTHOR:Jester Knox
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:954
// :NUM:1375
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// VERY SIMPLE GREETING Script by Jester Knox.lsl
// :CODE:

//VERY SIMPLE GREETING Script by Jester Knox

//rez a prim, dont make it phantom or anything, put it across the door of your shop or
//cover the shop flooe with a cube, make the texture one that is only alpha so it cant be
//seen. whenever someone walks through it it will trigger the say and greet them

default
{
    state_entry()
    {
   llVolumeDetect(TRUE);
    }
   collision_start(integer num_detected) {
        llSay(0, llDetectedName(0) + " welcome to this prim ;-p"); // put whatever you want the greeting to be in here
    }
}// END //
