// :CATEGORY:Messaging
// :NAME:Broadcaster_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:49
// :ID:117
// :NUM:176
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Broadcaster Script.lsl
// :CODE:

integer inchan = 13 ; // Input channel
integer bchan = -123456 ; // "Secret" channel/frequency message is sent on.

default
{
    state_entry()
    {
        
        llListen(inchan,"","","");
        // listens for just the owner, on channel 0
    }

    listen(integer chan, string name, key id, string mess)
    {
        if (id == llGetOwner())
        {
        llShout(bchan,llKey2Name(llGetOwner())+"> "+mess);
        llOwnerSay(llKey2Name(llGetOwner())+"> "+mess);
        }
    }
}
// END //
