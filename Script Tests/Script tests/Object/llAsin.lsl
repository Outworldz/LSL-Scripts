// :CATEGORY:Scripting
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
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
