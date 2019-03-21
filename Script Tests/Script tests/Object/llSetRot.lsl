// :SHOW:
// :CATEGORY:Scripting
// :NAME:Script Tests
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :CREATED:2019-03-18 23:44:22
// :EDITED:2019-03-18  22:44:22
// :ID:1116
// :NUM:1956
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// One of many tests for Opensim
// :CODE:

default
{
    state_entry()
    {
        llOwnerSay("Touch me");
    }
    touch_start(integer total_number)
    {
        rotation Y_10 = llEuler2Rot( < 0, 0, 30 * DEG_TO_RAD > );
        rotation newRotation = llGetRot() * Y_10;
        llSetRot( newRotation );             
    }
}
