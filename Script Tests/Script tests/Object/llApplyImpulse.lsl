// :SHOW:
// :CATEGORY:Scripting
// :NAME:Script Tests
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :CREATED:2019-04-04 20:49:51
// :EDITED:2019-04-04  19:49:51
// :ID:1124
// :NUM:1998
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
