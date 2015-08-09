// :CATEGORY:Touch
// :NAME:Touch_Fire
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:07
// :ID:904
// :NUM:1280
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Touch Fire.lsl
// :CODE:

//This isn't a needed thing for most people, but it is handy for those touch scripts that you don't want just anyone stopping by and messing with. Only you can activate the touch event with this. Very handy for touch initiated experiments that you don't want anyone messing up.
default
{
    state_entry()
    {
    }

    touch_start(integer total_number)
    {
        if(llDetectedKey(0) == llGetOwner());
        {
        //Do Stuff here
        }
    }
}
// END //
