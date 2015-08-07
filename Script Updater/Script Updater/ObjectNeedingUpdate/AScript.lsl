// :CATEGORY:Updater
// :NAME:Script Updater
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2014-01-30 12:17:13
// :EDITED:2014-01-31 15:40:15
// :ID:1017
// :NUM:1579
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Test script for the updater - announces Rev 1.  Click the server prim and this should change to Rev 2
// :CODE:
integer Rev = 1;


default
{
    state_entry()
    {
        llSay(0, "Hello, Avatar, my rev is " + (string) Rev);
    }
    touch_start(integer total_number)
    {
        llSay(0, "Hello, Avatar, my rev is " + (string) Rev);
    }
}
