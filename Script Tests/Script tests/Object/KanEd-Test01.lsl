// :SHOW:
// :CATEGORY:Scripting
// :NAME:Script Tests
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :CREATED:2019-03-18 23:44:21
// :EDITED:2019-03-18  22:44:21
// :ID:1116
// :NUM:1922
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// One of many tests for Opensim
// :CODE:

default
{
    state_entry()
    {
        llSay( 0, "Hello, Avatar!");
    }

    touch_start(integer total_number)
    {
        llSay( 0, "Touched.");
    }
}

