// :SHOW:
// :CATEGORY:Scripting
// :NAME:Script Tests
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :CREATED:2019-03-18 23:44:22
// :EDITED:2019-03-18  22:44:22
// :ID:1116
// :NUM:1945
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// One of many tests for Opensim
// :CODE:

//Rez an object, and drop this script in it.
//This will launch it at the owner.
default
{
    state_entry()
    {
        list p = llGetObjectDetails(llGetOwner(), [OBJECT_POS]);
        if(p != [])
        {
            llSetStatus(STATUS_PHYSICS, TRUE);
            vector pos = llList2Vector(p, 0);
            vector direction = llVecNorm(pos - llGetPos());
            llApplyImpulse(direction * 100, 0);
        }
    }
}
