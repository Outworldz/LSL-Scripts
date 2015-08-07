// :CATEGORY:HUD
// :NAME:Scrollable_ImageHUD
// :AUTHOR:Valect
// :CREATED:2012-07-22 10:17:05.477
// :EDITED:2013-09-18 15:39:01
// :ID:725
// :NUM:993
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This script goes in each direction control prim 
// :CODE:

default 
{ 
    touch_start(integer total_number) 
    { 
        //llSay(0, (string)llDetectedLinkNumber(0)); 
        llMessageLinked(1, 0, "blank", NULL_KEY); 
    } 
} 
