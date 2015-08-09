// :CATEGORY:Privacy
// :NAME:Privacy_curtains_and_doors
// :AUTHOR:Avatar42 Farspire
// :CREATED:2010-07-01 12:18:49.510
// :EDITED:2013-09-18 15:39:00
// :ID:659
// :NUM:897
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The door script
// :CODE:

integer debug = 0; //1=on 0=off
integer channel2 = 1234;
integer private = 1;
// all debug messages should be sent through here
dprint(string msg) 
{
    if (debug)
    {
        llOwnerSay(llGetScriptName( ) + ":" + msg);
    }
}

setPrivate(integer newP)
{
    if (newP != private)
    {
        if( private == 0 )
        {
dprint("privacy:on");
            llSetPos( llGetPos()+ <0,1.9,0>);
            llSetTexture("privateDoor", ALL_SIDES);
            llSetStatus( STATUS_PHANTOM, FALSE );
            private = 1;
        }
        else
        {
dprint("privacy:off");
            llSetTexture("clear", ALL_SIDES);
            llSetStatus( STATUS_PHANTOM, TRUE );
            llSetPos( llGetPos()+ <0,-1.9,0>);
            private = 0;
        }
    }
}
default
{
    state_entry()
    {
        llSay(0, "door online");
        llListen(0, "", llGetOwner(), "");
        llListen(channel2, "", "", "");
        setPrivate(1);
        
    }

    touch_start(integer total_number)
    {
        llSay(0, "Door is currently locked.");
    }
    
    listen( integer channel, string name, key id, string message )
    {
dprint("heard on:"+(string)channel+" by "+name+" key:"+(string)id + " msg:"+message);
        if( channel == 0 && id != llGetOwner() )
        {
            return;
        }
        
dprint("got perm");
        if( message == "privacy:on" )
        {
            setPrivate(1);
        }
        else
        if( message == "privacy:off" )
        {
            setPrivate(0);
        }
    }        

}
