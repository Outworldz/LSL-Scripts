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
        float r = llFrand(2) - 1.0;
        llOwnerSay("The arccosine of " + (string)r + " is " + llAcos(r));
    }
}
