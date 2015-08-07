// :CATEGORY:Vehicles
// :NAME:seat_script_bumper_car
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:01
// :ID:730
// :NUM:998
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// seat script bumper car.lsl
// :CODE:

default
{
    state_entry()
    {
        llSetSitText("Sit");
        llSitTarget(<0.04,-0.3,0.45>, <0,0,180,-180>);
        llSetCameraEyeOffset(<-8.0, 0.0, 3.0>);
        llSetCameraAtOffset(<4.0, 0.0, 2.0>);
    }
    changed(integer change)
    {
        if (CHANGED_LINK)
        {
            key agent = llAvatarOnSitTarget();
            if (agent)
            {
            }
            else
            {
                llPushObject(agent, <0,0,10>, ZERO_VECTOR, FALSE);
            }
        }
        
    }
}
// END //
