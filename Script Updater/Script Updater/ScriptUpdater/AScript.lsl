// :CATEGORY:Updater
// :NAME:Script Updater
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2014-01-30 12:17:30
// :EDITED:2014-01-31 15:40:15
// :ID:1017
// :NUM:1580
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Test script for the updater - rev two will go into the remote prim and announce itself when this works
// :CODE:
integer Rev = 2;


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
