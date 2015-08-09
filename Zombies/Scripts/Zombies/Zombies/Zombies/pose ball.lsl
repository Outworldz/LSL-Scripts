    
    // Send a link message to another script when sat on or unsat
    // will play back the first animation it finds in inventory
    
    // position to sit on the ball e.g <0.0, 0.0, 0.43>
    // sit  1.7 metes above the base., slight backwards 
    vector POSITION=<0.6, 0.0,1.7>;
    
    // Just code below here
    
    string animation;
    
    default
    {
        state_entry()
        {
            llSetSitText("Ride Me");
            llSitTarget(POSITION, ZERO_ROTATION);
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
                    llMessageLinked(LINK_SET,2,"unsit",llAvatarOnSitTarget()); 
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
                llMessageLinked(LINK_SET,2,"sit",llAvatarOnSitTarget()); // left foot forward
    
            }
        }
    
    }
