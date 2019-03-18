// :CATEGORY:Bird
// :NAME:Roaming Owl
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:01
// :ID:707
// :NUM:963
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Owl wing
// :CODE:

// wing flap timer

default
{

    
    timer()
    {
        llMessageLinked(LINK_SET,0,"down","");     
        llSetTimerEvent(0);

    }    
     
    link_message(integer sender,integer num, string str, key id)
    {     
        
       if (str == "flap")
        {
            llMessageLinked(LINK_SET,0,"up","");
            llSetTimerEvent(0.5);
        }
        
    } 
    
}	
