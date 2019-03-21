// :SHOW:
// :CATEGORY:Scripting
// :NAME:Script Tests
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :CREATED:2019-03-18 23:44:22
// :EDITED:2019-03-18  22:44:22
// :ID:1116
// :NUM:1947
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// One of many tests for Opensim
// :CODE:

default
{
    state_entry()
    {
        float num1 = llFrand(100.0);
        float num2 = llFrand(100.0);
        llOwnerSay("y = " + (string)num1);
        llOwnerSay("x = " + (string)num2);
        llOwnerSay("The tangent of y divided by x is " + (string)llAtan2(num1, num2));
  }
}
