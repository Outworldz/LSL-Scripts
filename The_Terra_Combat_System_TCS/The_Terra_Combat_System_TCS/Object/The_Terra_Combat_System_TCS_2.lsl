// :CATEGORY:Combat
// :NAME:The_Terra_Combat_System_TCS
// :AUTHOR:Cubey Terra
// :CREATED:2010-07-01 15:11:14.270
// :EDITED:2013-09-18 15:39:07
// :ID:887
// :NUM:1257
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Sit Target
// :CODE:
// TERRA COMBAT SYSTEM V2.5 - SEAT SCRIPT
// This script goes in the same prim as the pilot's sit target.
// Revised June 2007 to allow agents other than the owner to use TCS. -Cubey

integer sit;
integer crashed;

key pilot;


default
{
    on_rez(integer num)
    {
        llResetScript();
    }

    // DETECT AV SITTING/UNSITTING 
    changed(integer change)
    {
       key agent = llAvatarOnSitTarget();
       if (change & CHANGED_LINK)
       {
           if ((agent == NULL_KEY) && sit) //  Avatar gets off vehicle 
           {
               sit = FALSE;
               llMessageLinked(LINK_SET, 0, "tc unseated", "");
           }
           else if (!sit) // Avatar gets on vehicle
           {
               pilot = agent;
               if (!crashed)
               {
                    sit = TRUE;
                    // Send agent ID to TCS sensor. This will be considered the TCS operator.
                    llMessageLinked(LINK_SET, 0, "tc seated", pilot); 
                }
                else
                {
                    llUnSit(pilot);
                    llSay(0,"This vehicle has been destroyed in combat. Please wait until it has regenerated before trying again.");
                }
           }
        }
    }
    
    
    
    // LINK MESSAGES ====================================================================
    link_message(integer sender_number, integer number, string message, key id)
    {
        if (message == "tc crash")
        {
            crashed = TRUE;
            llUnSit(llAvatarOnSitTarget());
        }
        else if (message == "tc uncrash")
        {
            crashed = FALSE;
        }
    }

    
    
    
    
    
}

