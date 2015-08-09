string On = "TVOn";
string Off = "TVOff";

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

        llSetLinkAlpha(i,alpha, ALL_SIDES);
    }
    for ( i = 0; i <= j; i++) {

        llSetLinkAlpha(i,alpha, ALL_SIDES);
    }
    for ( i = 0; i <= j; i++) {

        llSetLinkAlpha(i,alpha, ALL_SIDES);
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
        if (msg == On) {
            hide_show(0);
        } else if (msg == Off) {
            hide_show(1);
        }
    }
}