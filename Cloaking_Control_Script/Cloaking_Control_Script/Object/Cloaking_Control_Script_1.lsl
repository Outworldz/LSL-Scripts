// :CATEGORY:Cloaking
// :NAME:Cloaking_Control_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:179
// :NUM:250
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Cloaking Control Script.lsl
// :CODE:

init()
{
    // Set up a listen callback for whoever owns this object.
    key owner = llGetOwner();
    llWhisper(0, "Cloaking device installed");
    llListen(0, "", owner, "");
}

default
{
    state_entry()
    {
        init();
    }
    
    on_rez(integer start_param)
    {
        init();
    }
    
    listen( integer channel, string name, key id, string message )
    {
        if( message == "wear katana" )
        {
            llMessageLinked(LINK_ALL_CHILDREN, 0, "cloak", id);
            llSetStatus(STATUS_PHANTOM, TRUE);
            llSetAlpha(0,ALL_SIDES);
        }
        if( message == "drop katana" )
        {
            llMessageLinked(LINK_ALL_CHILDREN, 0, "decloak", id);
            llSetStatus(STATUS_PHANTOM, FALSE);
            llSetAlpha(1,ALL_SIDES);
        }
         if( message == "phantom" )
        {
            llMessageLinked(LINK_ALL_CHILDREN, 0, "phantom", id);
            llSetStatus(STATUS_PHANTOM, TRUE);
        }
        if( message == "solid" )
        {
            llMessageLinked(LINK_ALL_CHILDREN, 0, "solid", id);
            llSetStatus(STATUS_PHANTOM, FALSE);
        }
    }
}// END //
