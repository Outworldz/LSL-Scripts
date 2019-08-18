// :SHOW:
// :CATEGORY:Scripting
// :NAME:Script Tests
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :CREATED:2019-04-04 20:49:50
// :EDITED:2019-04-04  19:49:50
// :ID:1124
// :NUM:1975
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

