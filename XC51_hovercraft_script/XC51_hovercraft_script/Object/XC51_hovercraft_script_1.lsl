// :CATEGORY:Vehicles
// :NAME:XC51_hovercraft_script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:984
// :NUM:1408
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// XC5-1 hovercraft pose ball controller
// :CODE:


vector TARGET = <0,0,0.5>;
vector ROT = <0, 0,0>;



string seater;
key av;

DEBUG(string msg)
{
    if (debug)  llOwnerSay(llGetScriptName() + " :" + msg);
}



integer debug =0 ;

default
{
    state_entry()
    {
       
        rotation rot     = llEuler2Rot(ROT * DEG_TO_RAD);     // convert the degrees to radians, then convert that vector into a rotation, rot30x 
        llSitTarget(TARGET, rot); // where they sit
    }


       

    changed(integer change)
    {
         if (change & CHANGED_LINK) 
         { 
            av = llAvatarOnSitTarget();
            
            if (av) //evaluated as true if not NULL_KEY or invalid
            {
                llRequestPermissions(av, PERMISSION_TRIGGER_ANIMATION);     
            }
            else
            {
                llMessageLinked(LINK_SET,0,"pilot",NULL_KEY);    
                DEBUG("unsit");
            }
           
        }
        
        
    }   
          
    run_time_permissions(integer perm)
    {
        if(PERMISSION_TRIGGER_ANIMATION & perm)
        {
            llStopAnimation("sit");
            llStartAnimation("sit"); // replace this with your own animation

            llMessageLinked(LINK_SET,0,"pilot",av);
            DEBUG("sit");
//            llSleep(4);
        }
    }
    
    
    on_rez(integer p)
    {
        llResetScript();
    }
}
