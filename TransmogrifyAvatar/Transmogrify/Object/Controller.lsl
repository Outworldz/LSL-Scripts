// :CATEGORY:Transmogrify
// :NAME:TransmogrifyAvatar
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2013-09-08
// :EDITED:2014-09-24
// :ID:921
// :NUM:1323
// :REV:1.1
// :WORLD:Second Life
// :DESCRIPTION:
// FOr the head of the avatar
// :CODE:
// Transmogrifyer script
// License: CC-BY. Please do not remove the copyright or this notice
// Author: Fred Beckhusen (Ferd Frederix)
// 8-25-2013
 // Controller goes in the root prim of the body.

// V 1.1 Edited on 9/22/2014 to fix "in air" bug to be "Flying"

integer type = -1;
integer ownerchannel;

integer person = TRUE;

hide_show( float alpha)
{
    integer j = llGetNumberOfPrims();
    integer k = 2; // do it twice to get rid of lost packets
    while (k--)
    {       
        integer i;
        for ( i = 0; i <= j; i++) {
            llSetLinkAlpha(i,alpha, ALL_SIDES);
        }
    }
}

// flop and send a link message for particle effects
switch(string what)
{
    if (what == "avatar" && ! person)
    {
        llMessageLinked(LINK_SET,0,"switch","");
        llSay(ownerchannel,"avatar");
        person = TRUE;
        hide_show(1.0);  // invisible
     
    }
    else  if (what == "pet" && person)
    {
        llMessageLinked(LINK_SET,0,"switch","");
        llSay(ownerchannel,"pet");
        person = FALSE;
        hide_show(0.0);
    }
     
} 
default
{
    on_rez(integer p)
    {
        llResetScript();        // so we can change owner
    }
    
    state_entry()
    {
       // Make this prim an invisiprim.
       ownerchannel = (integer)("0xF" + llGetSubString( (string)llGetOwner(), 0, 6 ));
       hide_show(1.0);    
       llSetTimerEvent(0.5);
    }   

    timer()
    {
        integer flight = llGetAgentInfo(llGetOwner());
        if (flight & AGENT_FLYING)    // V 1.1
        {
            switch("pet");
        }
        else
        {
            switch("avatar");
        }
    } 
}
