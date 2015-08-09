// :CATEGORY:Sit
// :NAME:Magic Sit System
// :AUTHOR:Whidou Bienstock
// :KEYWORDS:
// :CREATED:2014-12-04 12:26:01
// :EDITED:2014-12-04
// :ID:1059
// :NUM:1691
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// DESCRIPTION: []::Magic Sit System for no poseballs
// :CODE:
// :AUTHOR: Whidou Bienstock


string animation;
string SIT_TEXT="";
 
default 
 
{
    state_entry() 
 
    {
    if
        (llStringLength(SIT_TEXT)>0)llSetSitText(SIT_TEXT);
 
    }
 
    changed(integer change) 
 
            {
        if (change & CHANGED_LINK)
                {
        if (llAvatarOnSitTarget() != NULL_KEY)
                    {
        llRequestPermissions(llAvatarOnSitTarget(), PERMISSION_TRIGGER_ANIMATION);
                    }
        else
                        {
        integer perm=llGetPermissions();
        if ((perm & PERMISSION_TRIGGER_ANIMATION) && llStringLength(animation)>0)
        llStopAnimation(animation);
        animation="";
                        }
                }
            }
 
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION)
        {
                llStopAnimation("sit");
                animation=llGetInventoryName(INVENTORY_ANIMATION,0);
                llStartAnimation(animation);
        }
    }
}
