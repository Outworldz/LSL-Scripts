// :CATEGORY:Sound
// :NAME:No_Noise
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:559
// :NUM:763
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// No Noise!.lsl
// :CODE:

1// remove this number for the script to work.

//If you play with anything that goes bump, moves, etc this script needs to be in it. It allows for peace among other users.

//The function of this, is that when an object with this script hits something, there isn't any collision noise, or if so it's very little.
default
{
    state_entry()
    {
        llCollisionSound("", 0.0);
    }
}
// END //
