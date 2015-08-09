// :CATEGORY:Avatar
// :NAME:Halfatar
// :AUTHOR:Ferd Frederix
// :CREATED:2013-10-04 11:10:45
// :EDITED:2013-10-04 11:10:45
// :ID:999
// :NUM:1530
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// For a half-avatar such as my Zombie and skeleton. 
// :CODE:
// script to play an animation while walking or running only.
// requires animation named "stranglehold"
// Use in half-avatars
// :Author: Ferd Frederix



string LastAnimName;
string newAnimationState;
string LastRunState;  //SL or Opensim Animate State
key Owner;

StartAnimation()
{
    if (LastRunState  != newAnimationState)    
    { 
        if (newAnimationState == "Walking" || newAnimationState == "Running" || newAnimationState == "Turning Left" || newAnimationState == "Turning Right") 
        { 
           //llOwnerSay("changed");
            llStopAnimation(LastAnimName);
            LastRunState = newAnimationState;
            
            LastAnimName = ("stranglehold");

            llStartAnimation("stranglehold");

            llSetTimerEvent(0);

        }   else {
            if (LastAnimName == "stranglehold"){
                llStopAnimation(LastAnimName);
            }
            LastRunState = newAnimationState;
        }                              
 
    }
}  


Initialize(key id) 
{
    if (id == NULL_KEY)                         // detaching
    { 
        llStopAnimation(LastAnimName);
    }
    else                                        // attached, or reset while worn
    { 
        llRequestPermissions(id, PERMISSION_TRIGGER_ANIMATION);
        Owner = id;

    }
}

default
{
    state_entry()
    {
        // script was reset while already attached
        if (llGetAttached() != 0) {
            Initialize(llGetOwner());
        }
    }
    
    attach(key id) {
        Initialize(id);
    }
   
    
    run_time_permissions(integer perm) 
    {
        if (perm & PERMISSION_TRIGGER_ANIMATION) {
            llOwnerSay("Zombie-ride active"); 
        }
    }


    changed(integer change)    //  Reset on region restart
    {

        if (change & CHANGED_ANIMATION)
        {
            newAnimationState = llGetAnimation(Owner);
            
            // llOwnerSay((string) newAnimationState);
            StartAnimation();
        }            
    }
    
    
}
