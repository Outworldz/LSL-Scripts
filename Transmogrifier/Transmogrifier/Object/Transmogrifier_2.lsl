// :CATEGORY:Transmogrify
// :NAME:Transmogrifier
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-08-15 10:29:47.683
// :EDITED:2014-01-01 12:18:57
// :ID:920
// :NUM:1319
// :REV:1.1
// :WORLD:Second Life
// :DESCRIPTION:
// Accessories Script.  Goes in any prim attached to your avatar, such as hair.
// :CODE:
// License: CC-BY. Please do not remove the copyright or this notice

// Author: Fred Beckhusen (Ferd Frederix)
// For all your worn accessories (not the pet)
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
    integer j = llGetNumberOfPrims()
    integer i;
    for ( i = 0; i <= j; i++) {
        llSetLinkAlpha(i,alpha]);
        llSetLinkAlpha(i,alpha]);   // do it twice as this is UDP and packets get lost
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
