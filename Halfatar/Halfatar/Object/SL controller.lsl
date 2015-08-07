// :CATEGORY:Avatar
// :NAME:Halfatar
// :AUTHOR:Ferd Frederix
// :CREATED:2013-10-04 11:12:06
// :EDITED:2013-10-04 11:12:06
// :ID:999
// :NUM:1533
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Main Controller for animations - makes the rider grip the zombie or skeleton when moving
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
        if (newAnimationState == "Walking" || newAnimationState == "Running" ) 
        { 
          // llOwnerSay("changed");
           
            LastRunState = newAnimationState;
            
            LastAnimName = ("stranglehold");

            llStartAnimation("Walk: Power");
            llStartAnimation("stranglehold");


        }   else {
            
           // llOwnerSay("delta");
            if (LastAnimName == "stranglehold"){
              //  llOwnerSay("stop hold");
                llStopAnimation("stranglehold");
                llStopAnimation("Walk: Power");
            }
            LastRunState = newAnimationState;
        }                              
 
    }
}  


Initialize(key id) 
{
    LastAnimName = "stranglehold";
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
            llSetTimerEvent(0.5);
        }
    }
    
    timer()
    {
        newAnimationState = llGetAnimation(Owner);
        StartAnimation();
    }
    


   
    
    
}
