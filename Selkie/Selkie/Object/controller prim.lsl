// :CATEGORY:Transmogrify
// :NAME:Selkie
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:02
// :ID:737
// :NUM:1018
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Transmogrify
// :CODE:


default
{
    state_entry()
    {
        llSetTimerEvent(5);    
    }
    
    timer()
    {
        llMessageLinked(LINK_SET,0,"pet","");
        llSleep(2);
        llMessageLinked(LINK_SET,0,"avatar","");

    }
   
    on_rez(integer start_param)
    {
        llResetScript();
    }

}
