// :CATEGORY:Transmogrify
// :NAME:TransmogrifyAvatar
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-08
// :EDITED:2014-01-01 12:18:57
// :ID:921
// :NUM:1325
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// For any attached pet that is to appear when you Transmogrify
// :CODE:
// Transmogrifyer script
// License: CC-BY. Please do not remove the copyright or this notice
// Author: Fred Beckhusen (Ferd Frederix)

// For your pet
// makes the pet appear when you fly

integer ownerchannel;
integer listener;

setlisten()
{
    if (listener)  {
        llListenRemove(listener);
    }
    listener = llListen(ownerchannel,"","","");
}



hide_show( float alpha)
{
    integer j = llGetNumberOfPrims();

    integer i;
    for ( i = 0; i <= j; i++) {

        llSetLinkAlpha(i,alpha,ALL_SIDES);
    }
    
}

default
{
    state_entry()
    {
        ownerchannel = (integer)("0xF" + llGetSubString( (string)llGetOwner(), 0, 6 ));
        hide_show(1);    // 1 = visible
        setlisten();
    }

    on_rez(integer param)
    {
        hide_show(0); // 0= invisible
        setlisten();
    }
    
    changed(integer what)
    {
        if (what & CHANGED_REGION) 
            setlisten();
        if(what & CHANGED_OWNER)
            llResetScript();
    }
    
    listen(integer channel, string name, key id, string msg)
    {    
        if (msg == "pet") {
            hide_show(1);
        } else if (msg == "avatar") {
            hide_show(0);
        }
    }
}
