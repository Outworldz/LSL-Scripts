// :CATEGORY:Teleport
// :NAME:Elven Door Teleport System
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2014-12-04 12:10:43
// :EDITED:2014-12-04
// :ID:1056
// :NUM:1677
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// DESCRIPTION: []::Elven Door teleport System
// :CODE:
// door swing script

integer open = 0;


opendoor()
{
    if (open == TRUE)
        return;
    llSetLocalRot( llEuler2Rot(<0,0,120> * DEG_TO_RAD)  );
    open = TRUE;
    llSetTimerEvent(30.0);
}

closedoor()
{
    llSetLocalRot( llEuler2Rot(<0,0,-90> * DEG_TO_RAD)  );
    open = FALSE;
}  
 
default
{
    state_entry()
    {
       closedoor();
    }

    touch_start(integer total_number)
    {
        if (open)
        {
            llSetTimerEvent(0.1);      //close door
        } 
        else
        {
            opendoor();
            llMessageLinked(LINK_ALL_OTHERS, 0,"rez","");
            
        }
    }
     
    timer()
    {
        closedoor();   
        llSetTimerEvent(0.0);
    }
    
    link_message(integer sender_num,integer num, string str, key id)
    {
        //llOwnerSay("Heard:" + str);
        if (str =="open")
        {
            llSetTimerEvent(30.0);
            opendoor();  
        }
        else if (str =="close")
        {
            llSetTimerEvent(0.0);
            closedoor();   
        }
        
    }
    
    on_rez(integer p)
    {
        llResetScript();
    }
}
