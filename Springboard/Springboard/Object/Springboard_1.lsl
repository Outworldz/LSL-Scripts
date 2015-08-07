// :CATEGORY:Trampoline
// :NAME:Springboard
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:828
// :NUM:1156
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Springboard.lsl
// :CODE:

1// remove this number for the script to work.

default
{
    collision_start(integer total_number)
    {
        llPushObject(llDetectedKey(0), <0,100,0>, <0,0,0>, FALSE);
    }
}
// END //
