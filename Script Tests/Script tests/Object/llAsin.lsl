// :SHOW:
// :CATEGORY:Scripting
// :NAME:Script Tests
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :CREATED:2019-04-04 20:49:51
// :EDITED:2019-04-04  19:49:51
// :ID:1124
// :NUM:1999
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// One of many tests for Opensim
// :CODE:

// Touch the object with this script in it to see the arcsine of random numbers!
default
{
    touch_start(integer num)
    {
        float r = llFrand(2) - 1.0;
        llOwnerSay("The arcsine of " + (string)r + " is " + llAsin(r));
    }
}
