// :CATEGORY:Camping
// :NAME:CampDance
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:148
// :NUM:216
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// CampDance
// :CODE:
key avataronsittarget;

default
{
    state_entry()
    {
        llSetTextureAnim(ANIM_ON | ROTATE | LOOP | SMOOTH, ALL_SIDES, 0, 0, 0, 100, 1);
        llSitTarget(<0,0,1>,<0,0,0,1>);
        llSetSitText("Camp");
        llSetTimerEvent(3);
    }

    changed(integer change)
    {
        if(change & CHANGED_LINK) 
        {
            avataronsittarget = llAvatarOnSitTarget();
            if( avataronsittarget != NULL_KEY )
            {
                if ((llGetPermissions() & PERMISSION_TRIGGER_ANIMATION) && llGetPermissionsKey() == avataronsittarget) 
                {
                    llStopAnimation("sit");
                    llStartAnimation("dance1");
                } 
                else 
                {
                    llRequestPermissions(avataronsittarget, PERMISSION_TRIGGER_ANIMATION);
                }
            }
        }
    }
    
    timer()
    {
        if ((llGetPermissions() & PERMISSION_TRIGGER_ANIMATION) && llGetPermissionsKey() == avataronsittarget) 
        {
            llStartAnimation("dance1");
        }
    }

    run_time_permissions(integer perm)
    {
        if(perm)
        {
            llStopAnimation("sit");
            llStartAnimation("stand");
        }
    }


}
