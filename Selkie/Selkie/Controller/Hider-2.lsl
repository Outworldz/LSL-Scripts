// :CATEGORY:Transmogrify
// :NAME:Selkie
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:02
// :ID:737
// :NUM:1011
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Prim hider
// :CODE:




integer ownerchannel;
integer listener;

// This sets up a listener on the Owner-only channel.
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

    // TRIPLE PLAY
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
        //When this script runs, it starts to listen on a channel that matches just for your avatar.   This is the last 7 digits of your avatars UUID. 
        // It converts that string of numbers and letters into a channel and waits for the script in the avatar to chat on it.

        ownerchannel = (integer)("0xF" + llGetSubString( (string)llGetOwner(), 0, 6 ));
        hide_show(0);    // 0 = invisible
        setlisten();
    }
   
    on_rez(integer param)
    {
        hide_show(1); // 1= visible
        setlisten();
    }
   

    // If we change regions, re-establish a listener.   Region crossings are buggy in Opensim.
   
    changed(integer what)
    {
        if (what & CHANGED_REGION)
            setlisten();
        if(what & CHANGED_OWNER)
            llResetScript();
    }
   
    listen(integer channel, string name, key id, string msg)
    {   
        // UNCOMMENT THIS NEXT LINE TO HEAR CHAT
       //   llOwnerSay(msg);



        if (msg == "pet") {
            hide_show(0);
        } else if (msg == "avatar") {
            hide_show(1);
        }
    }
}