// :CATEGORY:Pose Balls
// :NAME:Poseball_just_owner
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:00
// :ID:645
// :NUM:875
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Poseball just owner.lsl
// :CODE:

init()
{
    llSitTarget(<0.2,0.0,.5>, ZERO_ROTATION);

    if(llAvatarOnSitTarget() != NULL_KEY)   // if someone is sitting
        llUnSit(llAvatarOnSitTarget()); // unsit him
}

default
{
    state_entry()
    {
        init();
        llSetText("Sit on me", <1.0, 1.0, 4.0>, 3.0);
    }


    changed(integer change)
    {
        if (change & CHANGED_LINK)  // if a link change occurs (sit or unsit)
        {
            
            key owner = llGetOwner();
            key agent = llAvatarOnSitTarget();
            if  (agent != NULL_KEY)  // and there is someone sitting now
            {
                if (agent != owner)       
                {
                    llSay(0, "You are not allowed to sit here");
                    llUnSit(llAvatarOnSitTarget());
                }
            }
        }
    }
}// END //
