// :CATEGORY:Underwater
// :NAME:Swimming_Fish_Rezzer
// :AUTHOR:Anonymous
// :CREATED:2011-08-11 08:04:23.097
// :EDITED:2013-09-18 15:39:06
// :ID:858
// :NUM:1195
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Fish script
// :CODE:
// swimming swim script for use with the FISH-O-Matic

integer chanFish = 10; // fish listen on this channel
vector dest;

default
{
    state_entry()
    {
        llListen(chanFish, "", "", "" );
    }

    listen(integer channel, string name, key id, string message)
    {
        
        list cmds  = llParseString2List( message, [","], [""] );
        string cmd = llList2String(cmds,0);
        if (cmd == "die")
            llDie();
        else if (cmd == "target")
        {
            string name = llList2String(cmds,1);
            
            if ( name != llGetObjectName() )
                return;
            
            string X= llList2String(cmds,2);
            string Y= llList2String(cmds,3);
            string Z= llList2String(cmds,4);
    
            dest = <(float) X,(float) Y,(float) Z>;
    
            llSetTimerEvent(0.5);    // swim every half second.   The slower this is, the more fish-like
            llSetStatus(STATUS_PHYSICS,TRUE);
        }
    }

    timer()
    {
        llLookAt(dest,0.5,0.2);
        llMoveToTarget(dest,5);   // go there in 5 seconds
    }
    
    on_rez(integer start_num)
    {
        llResetScript();
    }
}
