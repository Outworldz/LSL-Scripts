// :CATEGORY:Signs
// :NAME:Parasol
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:609
// :NUM:833
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Parasol.lsl
// :CODE:

string anim ="drink";
string anim2 ="hold_R_handgun";

default
{
    attach(key victim)
    {
    if(victim == NULL_KEY)
    {
          llStopAnimation(anim2);
          llStopAnimation(anim2);
          llSetTimerEvent(0);
          
        }
        else
        {
         llRequestPermissions(victim,PERMISSION_TRIGGER_ANIMATION);
    }
}

   run_time_permissions(integer permissions)
    {
        if (PERMISSION_TRIGGER_ANIMATION & permissions)
        {
        llStartAnimation(anim2);
         llStartAnimation(anim2);
        
        llSetTimerEvent(15);
        }
    }

   timer()
   {
    llStartAnimation(anim2);
    llStartAnimation(anim2);
    }

}

// END //
