// :CATEGORY:Boat
// :NAME:DaVinci Boat
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-08
// :EDITED:2013-09-18 15:38:51
// :ID:220
// :NUM:301
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// starts the boat when sat on
// :CODE:
default
{
    state_entry()
    {
        
        vector input = <-90.0, 0.0, -90.0> * DEG_TO_RAD;
        rotation rot = llEuler2Rot(input);
        
        llSitTarget(<.25, 0.75, 0>, rot);        // z = fwd, x = side to side, Y = hight
        llSetCameraEyeOffset(<0.0,2.0, -5.0>);
        llSetCameraAtOffset(<0.0, 0.0, 2.0>);
    }


    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {
            key agent = llAvatarOnSitTarget();
            if (agent)
            {
                if (agent != llGetOwner())
                {
                    llSay(0, "You aren't the owner");
                    llUnSit(agent);
                    llPushObject(agent, <0,0,100>, ZERO_VECTOR, FALSE);
                }
                else
                {
                    llMessageLinked(LINK_SET, 0, "start", NULL_KEY);
                }
            }
            else
            {
                // You stand so boat stops
                llMessageLinked(LINK_SET, 0, "stop", NULL_KEY);
                llMessageLinked(LINK_SET, 0, "spin", NULL_KEY);
            }
        }

    }

}
