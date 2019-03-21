// :CATEGORY:Birds
// :NAME:Gracie and George Flamingos
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2014-12-04 12:13:00
// :EDITED:2014-12-04
// :ID:1057
// :NUM:1682
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// DESCRIPTION: []::Free-flight bird system wing flap script - makes flex wings flap 
// :CODE:
default
{
    state_entry()
    {
        llSetTimerEvent(1);
    }

    timer()
    {
        
        llMessageLinked(LINK_SET,10,"flap","");
        llSleep(.5);
        llMessageLinked(LINK_SET,-10,"flap","");


    }
}
