// :CATEGORY:Scripting
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
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

