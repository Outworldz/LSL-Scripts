// :CATEGORY:Egret
// :NAME:Gwenette
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:54
// :ID:370
// :NUM:510
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// test
// :CODE:

integer counter;

default
{

    state_entry()
    {
        
    }
    
    touch_start(integer p)
    {
        llMessageLinked(LINK_SET,0,"fly","");
        llSetTimerEvent(2);
    }
    
            
    timer()
    {
        llMessageLinked(LINK_SET,0,"flapup","");
        llSleep(1);
        llMessageLinked(LINK_SET,0,"flapdown","");
        
        if (counter++ > 5) {
            llMessageLinked(LINK_SET,0,"land","");
            llSetTimerEvent(0);
        }
        
    }
    
    
}

