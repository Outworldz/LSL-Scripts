// :CATEGORY:ANimation
// :NAME:DrinkScript
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:263
// :NUM:354
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// DrinkScript.lsl
// :CODE:

integer flag = 0;


default
{
    state_entry()
    {
      llRequestPermissions(llGetOwner(),PERMISSION_TRIGGER_ANIMATION);
         
    }

    run_time_permissions(integer parm)
    {
    if(parm == PERMISSION_TRIGGER_ANIMATION)
        {
        llSetTimerEvent(15);
       
         llStartAnimation("hold_R_handgun");
         }
    
    }

    on_rez(integer st)
    {
    llResetScript();
    }

    attach(key id)
    {
    llStopAnimation("hold_R_handgun");
    }
    
    
    
    
   timer()
   {
   
    if(flag == 0)
    {
    llStartAnimation("drink");
    }
    
    
    
    if(flag == 1)
    {
    llStartAnimation("drink");
    }

    flag = flag + 1;
    
    if(flag == 4)
    {
    flag = 0;
    }    
    
    }
    
     
      
       
     listen(integer channel, string name, key id, string message)
    {
    }


}
// END //
