// :CATEGORY:Scripting
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
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
