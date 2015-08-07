// :CATEGORY:Transmogrify
// :NAME:Selkie
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:02
// :ID:737
// :NUM:1009
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// A Transmogrifying seal
// :CODE:

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
        llSetPrimitiveParams([PRIM_BUMP_SHINY, ALL_SIDES, PRIM_SHINY_NONE, PRIM_BUMP_NONE,
            PRIM_COLOR, ALL_SIDES, <1.0, 1.0, 1.0>, 1.0, PRIM_TEXGEN, ALL_SIDES, PRIM_TEXGEN_DEFAULT,
            PRIM_TEXTURE, ALL_SIDES, "e97cf410-8e61-7005-ec06-629eba4cd1fb", ZERO_VECTOR, ZERO_VECTOR, 0.0]);
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
        llSetPrimitiveParams([PRIM_BUMP_SHINY, ALL_SIDES, PRIM_SHINY_NONE, PRIM_BUMP_NONE,
            PRIM_COLOR, ALL_SIDES, <1.0, 1.0, 1.0>, 1.0, PRIM_TEXGEN, ALL_SIDES, PRIM_TEXGEN_DEFAULT,
            PRIM_TEXTURE, ALL_SIDES, "e97cf410-8e61-7005-ec06-629eba4cd1fb", ZERO_VECTOR, ZERO_VECTOR, 0.0]);
            
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
        llDialog(llGetOwner(),"Choose",["Switch"], channel);
    }
    
    listen( integer channel, string name, key id, string message ) { 
        if (message =="Switch")
        {
            if (type)
                switch("avatar");
            else
                switch("pet");
                
            type= ~ type;
        }
    }
    
    
    
}

