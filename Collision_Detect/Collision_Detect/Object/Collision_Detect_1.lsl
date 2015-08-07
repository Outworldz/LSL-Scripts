// :CATEGORY:Collider
// :NAME:Collision_Detect
// :AUTHOR:Fred Kinsei
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:187
// :NUM:260
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Collision_Detect
// :CODE:
//Made By Fred Kinsei

default
{
    collision_start(integer num)
    {
        integer type = llDetectedType(0);
        if(llDetectedOwner(0) != llGetOwner() && !(type&AGENT) && (type & ACTIVE ||  (type & PASSIVE && type & SCRIPTED) || (type & ACTIVE && type & SCRIPTED)))
        {
            if(!(!(type&ACTIVE) && type&PASSIVE && type&SCRIPTED))
                llOwnerSay(llKey2Name(llDetectedOwner(0)) + " has hit you with physical object: '" + llDetectedName(0)+"'");
        }
        if(type&AGENT)
        {
            if(llGetVel() == ZERO_VECTOR)
                llOwnerSay(llKey2Name(llDetectedKey(0)) + " has bumped you.");
            if(llGetVel() != ZERO_VECTOR)
                llOwnerSay("You bumped " + llKey2Name(llDetectedKey(0)));
        }
    }
}
