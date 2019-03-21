// :CATEGORY:vehicle
// :NAME:Vehicle
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2014-09-08 19:11:15
// :EDITED:2014-09-08
// :ID:1044
// :NUM:1653
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// 
// :CODE:
default
{
    state_entry()
    {
        llSitTarget(<0.45, 0.0, 0.25>, <0.00000, 0.08716, 0.00000, 0.99619>); 
    }

    touch_start(integer total_number)
    {
        llSay(0, "Right click me and choose 'Sit Here' to sit down");
    }
}
 
