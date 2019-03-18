// :CATEGORY:Bird
// :NAME:flamingo
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:53
// :ID:314
// :NUM:415
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Wing control
// :CODE:

// Bird flock Wing controller script
// Author: Fred Beckhusen (Ferd Frederix)
// This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
// This means that this script itself is not for sale, that the script must be full Mod at all time, and that modifications to it MUST be provided to anyone upon request. Pets made with this script may be sold. ~ Fred Beckhusen (Ferd Frederix)
// 5-26-2013 

// Goes into the body of the pet with the SOUND file
// 1 ourt of 3 cycles pushes down

integer STROKE = 2;  //  bigger is a harder stroke, max is 10
float STROKETIME = 0.5;  // a wing cycle is twice a stroke
integer counter = -1;    // boolean for wing up/down
string SOUND = "flying-dragon";

default
{

    timer()
    {
        counter = ~counter;     // -1 = 0 = -1
        
        if (counter)
        {
            llMessageLinked(     LINK_SET,   -STROKE, "flap","");    // tell the wing to flup up/down
            llPlaySound(SOUND,1.0);
            
        }
        else
        {
             llMessageLinked(     LINK_SET,   STROKE, "flap","");    // tell the wing to flup up/down
        }
        
        
      
    }
    
    link_message(integer from, integer num, string str, key id)
    {
        
        llOwnerSay(str);
        
        if (str =="fly")
        {    
            llSetTimerEvent(STROKETIME);
        }
        else if (str =="land")
        {    
            llSetTimerEvent(0);
        }
        
        
    }
    on_rez(integer p)
    {
        llResetScript();
    }
}

