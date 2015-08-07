// :CATEGORY:Lag Meter
// :NAME:Region_Idle_Prevention_and_Detectio
// :AUTHOR:Void
// :CREATED:2012-07-02 15:19:02.050
// :EDITED:2013-09-18 15:39:01
// :ID:688
// :NUM:937
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Script by KT Kingsley - Script to stop region idling
// :CODE:
default
{
    state_entry()
    {
        llSetTimerEvent(5.0);
    }
    timer()
    {
        llHTTPRequest("http://", [], "");
    }
}
