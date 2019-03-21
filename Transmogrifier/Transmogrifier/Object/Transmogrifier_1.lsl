// :CATEGORY:Transmogrify
// :NAME:Transmogrifier
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-08-15 10:29:47.683
// :EDITED:2014-01-01 12:18:57
// :ID:920
// :NUM:1318
// :REV:1.1
// :WORLD:Second Life
// :DESCRIPTION:
// Transmogrify script. Goes in a large prim and covers up your avatar. Wear the prim on your pelvis for best results.
// :CODE:
// License: CC-BY. Please do not remove the copyright or this notice

// Author: Fred Beckhusen (Ferd Frederix)
// Put in a large prim, and wear it.

integer type = -1;
integer ownerchannel;
integer listener;
integer person = TRUE;

switch(string what)
{
    if (what == "avatar" && ! person)
    {
	llSay(ownerchannel,"avatar");
	person = TRUE;
	llSetAlpha(0.0,ALL_SIDES);  // invisible
    }
    else  if (what == "pet" && person)
    {
	llSay(ownerchannel,"pet");
	person = FALSE;
	 // Make this prim an invisiprim.
       ownerchannel = (integer)("0xF" + llGetSubString( (string)llGetOwner(), 0, 6 ));
	    llSetPrimitiveParams([PRIM_TEXTURE, ALL_SIDES, "e97cf410-8e61-7005-ec06-629eba4cd1fb", ZERO_VECTOR, ZERO_VECTOR, 0.0]);
    }

}

default
{

    on_rez(integer p)
    {
	llResetScript();
    } 

    state_entry()
    {
       // Make this prim an invisiprim.
       ownerchannel = (integer)("0xF" + llGetSubString( (string)llGetOwner(), 0, 6 ));
	llSetPrimitiveParams([PRIM_TEXTURE, ALL_SIDES, "e97cf410-8e61-7005-ec06-629eba4cd1fb", ZERO_VECTOR, ZERO_VECTOR, 0.0]);
    
	llSetStatus(STATUS_PHANTOM,TRUE);
	llSetTimerEvent(0.5);
    }

    timer()
    {
	integer flight = llGetAgentInfo(llGetOwner());
	if (flight & AGENT_IN_AIR)
	{
	    switch("pet");
	}
	else
	{
	    switch("avatar");
	}
    }


    touch_start(integer total_number)
    {
	if (listener) 
	    llListenRemove(listener);
	integer channel = llCeil(llFrand(10000) +10000);
	listener = llListen(channel,"","","");
	llDialog(llGetOwner(),"Choose",["Switch", "Help", "Auto"], channel);
    }

    listen( integer channel, string name, key id, string message ) { 
	if (message =="Switch")
	{
	    if (type) {
		switch("avatar");
		llSetTimerEvent(0);
	    } else {
		switch("pet");
		llSetTimerEvent(0);
	    }
		
	    type= ~ type;
	} else if (message == "Auto"){
	    llSetTimerEvent(0.5);
	} else if (message == "Help") {
	    llLoadURL(llGetOwner(),"Get Help","http://www.outworldz.com/opensim/posts/transmogrifier/");
	}
	
    }

}
