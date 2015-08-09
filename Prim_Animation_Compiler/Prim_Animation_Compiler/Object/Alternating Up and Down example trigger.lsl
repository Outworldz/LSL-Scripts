// :SHOW:
// :CATEGORY:Prim
// :NAME:Prim_Animation_Compiler
// :AUTHOR:Ferd Frederix
// :KEYWORDS: Animation, Puppeteer
// :CREATED:2013-02-25 10:47:09.853
// :EDITED:2015-08-07  14:27:52
// :ID:648
// :NUM:1821
// :REV:1.1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// This script  starts a timer each  one second.
// Each second, it changes a -1 to a zero, or a zero to a -1.   (x= ~x)
// So each second, this will be TRUE ( -1) or FALSE (0)
// It then sends a link message with the required Number 1 and an UP or a DOWN.
// :CODE:


integer x = -1; // this toggles between -1 and 0

default
{
    state_entry()
    {
        llSetTimerEvent(1); // once a second
    }
    
    timer()
    {
        if (x = ~x)
            llMessageLinked(LINK_SET,1,"UP","");
        else
            llMessageLinked(LINK_SET,1,"DOWN","");
    }
}
