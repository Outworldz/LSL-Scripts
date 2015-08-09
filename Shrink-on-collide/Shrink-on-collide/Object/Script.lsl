// :CATEGORY:Collision
// :NAME:Shrink-on-collide
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2014-07-15 10:24:02
// :EDITED:2014-07-15
// :ID:1037
// :NUM:1619
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Makes a plant or other object shrink when collided with, like Pandora plants
// :CODE:


// tunable numbers
float time = 10.0; // stay small 1`0 seconds
float small = 0.1;  // small scale is 10%
vector large;



shrink()
{
    vector smallsize = large * small;
    llSetScale(smallsize);
    llSetTimerEvent(time);
}


default
{
    state_entry()
    {
        large = llGetScale();    // remember the initial size
        llVolumeDetect(TRUE);    // makes it phantom and collidable 
    }
    
    touch_start(integer total_number)
    {
        shrink();
    }
    
    collision_start(integer total_number)
    {
        shrink();
    }
    timer()
    {
        llSetScale(large);
        llSetTimerEvent(0);
    }
}