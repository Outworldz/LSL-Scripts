//:AUTHOR: Ferd Frederix
//:DESCRIPTION: Two Or more people sit on two or more pose balls.  The pose balls play a series of animation in sync
//:CODE:
// To use this, just put several dances in a prim and add this script.
// Shift-copy the prim.  Anyone who touches it will dance in sync with anyone else who touches it.


float RATE = 10.0;  // rate to play animations

string lastDance;  // the last dance played on the slave script
string animation ; // the currwent animation name we must play
integer index;     // the num,ber of that animation found in inventory
key avatarK;       // the key of tjhe seated avatar
integer channel = -12134;    // some random number
integer granted = FALSE;

default
{
    state_entry()
    {
        llSetClickAction(CLICK_ACTION_SIT);
        llListen(channel,"","","");
    }

    on_rez(integer p)
    {
        llResetScript();
    }


    changed (integer detected)
    {
        if (detected & CHANGED_LINK)
        {
            avatarK = llAvatarOnSitTarget();
            if (avatarK != NULL_KEY)
            {
                index = 0;
                llRequestPermissions(avatarK, PERMISSION_TRIGGER_ANIMATION);
            } else {
                granted = FALSE;
                llSetTimerEvent(0);
            }
        }
    
    }


    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION)
        {
            granted = TRUE;
            animation = llGetInventoryName(INVENTORY_ANIMATION, index);    // first animation
            llSay(channel,animation); // tell another poseball to let them dance.
            llStartAnimation(animation);
            llSetTimerEvent(RATE);
        }
    }

    timer()
    {
        integer newindex = index;     // We must stop old animation
        newindex++;                    // and play new one

        // test to see if we are past the end
        if (newindex >= llGetInventoryNumber(INVENTORY_ANIMATION))
            newindex = 0;

        llSay(channel,llGetInventoryName(INVENTORY_ANIMATION, newindex)); // tell another poseball to let them dance.
        llStartAnimation(llGetInventoryName(INVENTORY_ANIMATION, newindex));
        llStopAnimation(llGetInventoryName(INVENTORY_ANIMATION, index));
        
        index = newindex; // get ready for the next animation
    }

    listen(integer channel, string name, key id, string message) 
    {
        llSetTimerEvent(0);        // last one to send a message wins control
        
        if (granted)
        {
            llStartAnimation(message);
            if (llStringLength(lastDance))
                llStopAnimation(lastDance);
            lastDance = message;
        }
    }
}
