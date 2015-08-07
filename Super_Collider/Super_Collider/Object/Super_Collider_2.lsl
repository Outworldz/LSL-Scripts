// :CATEGORY:Collider
// :NAME:Super_Collider
// :AUTHOR:Rickard Roentgen
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:845
// :NUM:1174
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Status Script
// :CODE:
integer online;

default
{
    on_rez(integer sparam)
    {
        llWhisper(0, "Super Collider commands: collide on, collide off");
    }
    
    state_entry()
    {
        online = FALSE;
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "status") {
            if (online) {
                llMessageLinked(sender, 0, "online", NULL_KEY);
            } else {
                llMessageLinked(sender, 0, "offline", NULL_KEY);
            }
        } else if (str == "set status") {
            online = num;
        }
    }
}
