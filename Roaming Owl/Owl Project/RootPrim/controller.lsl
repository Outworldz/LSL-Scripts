// :CATEGORY:Bird
// :NAME:Roaming Owl
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:01
// :ID:707
// :NUM:965
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Controller
// :CODE:

// ______           _  ______            _           _
// |  ___|         | | |  ___|          | |         (_)
// | |_ ___ _ __ __| | | |_ _ __ ___  __| | ___ _ __ ___  __
// |  _/ _ \ '__/ _` | |  _| '__/ _ \/ _` |/ _ \ '__| \ \/ /
// | ||  __/ | | (_| | | | | | |  __/ (_| |  __/ |  | |>  <
// \_| \___|_|  \__,_| \_| |_|  \___|\__,_|\___|_|  |_/_/\_\
//
// fred@mitsi.com 
// owl bird script
//


integer tick;
integer count;

default
{
    state_entry()
    {
        llMessageLinked(LINK_SET,0,"sit","");
    }
    
    timer()
    {
        if (tick++ %2 )
             llMessageLinked(LINK_SET,0,"up","");
        else
             llMessageLinked(LINK_SET,0,"down","");

    }    
     
    link_message(integer sender,integer num, string str, key id)
    {
        if (str == "fly")
        {
            llSetTimerEvent(1.0);
        }
        else if (str == "land")
        {
            llSetTimerEvent(0);
        }
        else if (str == "sit")
        {
            llSetTimerEvent(0);
        }
        
    } 
    
    touch_start(integer many)
    {

            
        if (count == 0) {
            llMessageLinked(LINK_SET,1,"sit","");
           // llSay(0,"sit");
        } else if (count == 1) {
            llMessageLinked(LINK_SET,1,"fly","");
            //llSay(0,"fly");
        } else if (count == 2) {
            llMessageLinked(LINK_SET,1,"land","");
           // llSay(0,"land");
        }

        
        count++;
        if (count > 2)
            count = 0;
                    
    }
}
