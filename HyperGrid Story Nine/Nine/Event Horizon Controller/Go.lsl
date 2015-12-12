// :SHOW:
// :CATEGORY:NPC
// :NAME:HyperGrid Story Nine
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2015-11-24 20:25:33
// :EDITED:2015-11-24  19:25:33
// :ID:1087
// :NUM:1841
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Button Script for console
// :CODE:

// The Go button at the center

default
{
    touch_start(integer total_number)
    {
        llSetLinkPrimitiveParamsFast(llGetLinkNumber(),[PRIM_FULLBRIGHT, ALL_SIDES,TRUE]);
        llMessageLinked(LINK_SET,2,"Red","");
        llSetTimerEvent(0.5);
    }
    timer()
    {
        llSetLinkPrimitiveParamsFast(llGetLinkNumber(),[PRIM_FULLBRIGHT,ALL_SIDES, FALSE]);
        llSetTimerEvent(0);
    }

}
