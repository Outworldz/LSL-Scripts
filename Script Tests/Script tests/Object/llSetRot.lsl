// :SHOW:
// :CATEGORY:Scripting
// :NAME:Script Tests
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :CREATED:2019-04-04 20:49:51
// :EDITED:2019-04-04  19:49:51
// :ID:1124
// :NUM:2009
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
