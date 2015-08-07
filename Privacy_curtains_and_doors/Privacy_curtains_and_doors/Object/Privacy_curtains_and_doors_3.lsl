// :CATEGORY:Privacy
// :NAME:Privacy_curtains_and_doors
// :AUTHOR:Avatar42 Farspire
// :CREATED:2010-07-01 12:18:49.510
// :EDITED:2013-09-18 15:39:00
// :ID:659
// :NUM:898
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The window script
// :CODE:

integer debug = 0; //1=on 0=off
integer channel2 = 1234;
// all debug messages should be sent through here
dprint(string msg) 
{
    if (debug)
    {
        llOwnerSay(llGetScriptName( ) + ":" + msg);
    }
}

default
{
    state_entry()
    {
        llSay(0, "drape online");
        llListen(0, "", llGetOwner(), "");
        llListen(channel2, "", "", "");
    }

    touch_start(integer total_number)
    {
        llSay(0, "Touched.");
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
dprint("privacy:on");
            llSetTexture("drape", ALL_SIDES);
        }
        else
        if( message == "privacy:off" )
        {
dprint("privacy:off");
            llSetTexture("clear", ALL_SIDES);
        }
    }        

}
