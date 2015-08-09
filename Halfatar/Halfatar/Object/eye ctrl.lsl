// :CATEGORY:Avatar
// :NAME:Halfatar
// :AUTHOR:Ferd Frederix
// :CREATED:2013-10-04 11:11:08
// :EDITED:2013-10-04 11:11:08
// :ID:999
// :NUM:1531
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Makes the eyes wiggle randomly
// :CODE:
// script to control the eyes randomly
// requires the texture be in the eye
// Use in half-atars
// :Author: Ferd Frederix


default
{
    state_entry()
    {
        llSetTimerEvent(1.0);
    }
    timer()
    {
        llMessageLinked(LINK_SET,2,(string) llFrand(.10),"");
        llSetTimerEvent(llFrand(1.0));   
    }
}
