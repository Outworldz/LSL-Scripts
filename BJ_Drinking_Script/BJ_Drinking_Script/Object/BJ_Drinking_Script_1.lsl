// :CATEGORY:Animation
// :NAME:BJ_Drinking_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:90
// :NUM:125
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// BJ Drinking Script.lsl
// :CODE:

string anim ="drink";
string anim2 ="hold_R_handgun";
string falldown = "drunkfall";
integer cntr = 0;
integer checkit = 3;
default
{
    attach(key victim)
    {
    if(victim == NULL_KEY)
    {
          llStopAnimation(anim);
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
        llStartAnimation(anim);
        llStartAnimation(anim2);
        llWhisper(0,"watch that third sip");
        
        llSetTimerEvent(15);
        }
    }

   timer()
   {
        llStopAnimation(falldown);
        llStartAnimation(anim2);
        llStartAnimation(anim);
        ++cntr;
        if (cntr > 2) {
            cntr = 0;
            llStartAnimation(falldown);
        }    
    
    } 

}

// END //
