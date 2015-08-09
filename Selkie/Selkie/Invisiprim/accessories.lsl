// :CATEGORY:Transmogrify
// :NAME:Selkie
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:02
// :ID:737
// :NUM:1014
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// invisiprim
// :CODE:

// License: CC-BY. Please do not remove the copyright or this notice
// Author: Ferd Frederix

// For all yoru worn accessories (not the pet)
// makes accessories like shoes and hair disappear when you fly.

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

        llSetLinkPrimitiveParamsFast(i,[ PRIM_COLOR, ALL_SIDES,<1,1,1>,alpha]);
    }
    
}

default
{
    state_entry()
    {
        ownerchannel = (integer)("0xF" + llGetSubString( (string)llGetOwner(), 0, 6 ));
        hide_show(0);    // 0 = invisible
        setlisten();
    }
    
    on_rez(integer param)
    {
        hide_show(1); // 1= visible
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
            hide_show(0);
        } else if (msg == "avatar") {
            hide_show(1);
        }
    }
}
