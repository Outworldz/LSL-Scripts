// :CATEGORY:Animal
// :NAME:Flexible_tentacles
// :AUTHOR:PN Scripts Collection
// :CREATED:2011-06-13 12:00:52.680
// :EDITED:2013-09-18 15:38:53
// :ID:317
// :NUM:425
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Flexible_tentacles
// :CODE:
default
{
    state_entry()
    {
        llSensorRepeat("", "", AGENT, 96, PI, .5);
    }
 
    sensor(integer detected)
    {
        vector avatarspos = llDetectedPos(0);
        vector inclination = avatarspos - llGetPos();
        llSetPrimitiveParams([PRIM_FLEXIBLE, TRUE, 1, 0, .5, 0, 10, inclination]);
    }
}
