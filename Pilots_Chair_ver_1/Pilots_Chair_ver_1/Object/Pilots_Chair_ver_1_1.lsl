// :CATEGORY:Vehicles
// :NAME:Pilots_Chair_ver_1
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:631
// :NUM:858
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Pilot's Chair ver. 1.lsl
// :CODE:



key avatar;
vector pos = <0.4,0.0,0.4>;  //adjust the position to fit object -must be 
//nonzero in at least one direction or script will not work!
rotation rot = ZERO_ROTATION; //adjust rotation (1 in any vector gives 90 deg)

default
{
    state_entry()
    {
        llSitTarget(pos, rot);
    }
    changed(integer change)
    {
        avatar = llAvatarOnSitTarget();
       if(change & CHANGED_LINK)
       {
           if(avatar == NULL_KEY)
           {
                //  You have gotten off
                llStopAnimation("sit");
                llReleaseControls();
                llResetScript();
           }
           else if(avatar == llAvatarOnSitTarget())
           {
                // You have gotten on
                llRequestPermissions(avatar,PERMISSION_TRIGGER_ANIMATION );
           }
        }
    }
        run_time_permissions(integer perms)
        {
        if(perms)
        {
            llStopAnimation("sit");
            llStartAnimation("sit");
        }
        else
        {
            llUnSit(avatar);
        }
    }
}
// END //
