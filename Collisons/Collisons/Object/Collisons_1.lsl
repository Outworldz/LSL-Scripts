// :CATEGORY:Weapons
// :NAME:Collisons
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:188
// :NUM:261
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Collisons.lsl
// :CODE:

default
{
    on_rez(integer param)
    {
        
    }
    collision_start(integer num)
    {
        vector vel = llGetVel() * 99999;
        llPushObject(llDetectedKey(0), vel, ZERO_VECTOR, FALSE);
    }
    collision_end(integer num_detected)
    {
        vector vel = llGetVel() * 99999;
        llPushObject(llDetectedKey(0), vel, ZERO_VECTOR, FALSE);
    }
    land_collision_start(vector pos)
    {
        vector vel = llGetVel() * 99999;
        llPushObject(llDetectedKey(0), vel, ZERO_VECTOR, FALSE);
    }
    timer()
    {
        llDie();
    }
}
// END //
