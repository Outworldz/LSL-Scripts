// :SHOW:
// :CATEGORY:Scripting
// :NAME:Script Tests
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :CREATED:2019-03-18 23:44:22
// :EDITED:2019-03-18  22:44:22
// :ID:1116
// :NUM:1944
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
