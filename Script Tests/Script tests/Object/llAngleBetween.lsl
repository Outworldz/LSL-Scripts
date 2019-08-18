// :SHOW:
// :CATEGORY:Scripting
// :NAME:Script Tests
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :CREATED:2019-04-04 20:49:51
// :EDITED:2019-04-04  19:49:51
// :ID:1124
// :NUM:1997
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// One of many tests for Opensim
// :CODE:
default
{
    state_entry()
    {
        rotation aRot = ZERO_ROTATION;
        rotation bRot = llGetRot();
        float aBetween = llAngleBetween( aRot, bRot );
        llOwnerSay((string)aBetween);
        //llGetRot() being < 0, 0, 90 > this should report 1.570796
    }
}
