// :CATEGORY:Halloween
// :NAME:Broomsticks
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:49
// :ID:119
// :NUM:181
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Particles
// :CODE:



integer seated = FALSE;
integer particles_on = FALSE;



default
{
     
     on_rez(integer num)
     {
         llSetTimerEvent(0);
     }
     
     
     timer()
     {
     
             // Speed
             integer speed = (integer)(llVecMag(llGetVel()) * 1.94384449 + 0.5);         
             
             if(speed > 5)
             {
                 if(!particles_on)
                 {
                     llMessageLinked(LINK_SET, 0, "particles on", "");
                     particles_on = TRUE;
                  }
             }
             else
             {
                 if(particles_on)
                 {
                     llMessageLinked(LINK_SET, 0, "particles off", "");
                     particles_on = FALSE;
                 }
                 
             }
            
 
     }


          
     
     link_message(integer sender_number, integer number, string message, key id)
     {
    
         
        if (message == "seated")
        {
            seated = TRUE;
            llSetTimerEvent(0.5);
        }
        
        else if (message == "unseated")
        {
            seated = FALSE;
            llSetTimerEvent(0.0);
            llMessageLinked(LINK_SET, 0, "particles off", "");
            particles_on = FALSE;
        }
        
 
         
     }
        
        
} 
 
 
