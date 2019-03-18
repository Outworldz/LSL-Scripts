// :CATEGORY:Scripting
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// One of many tests for Opensim
// :CODE:integer allow;

default
{
    touch_start(integer num)
    {
        llAllowInventoryDrop(allow = !allow);
        llOwnerSay("llAllowInventoryDrop == "+llList2String(["FALSE","TRUE"],allow));
    }
    changed(integer change)
    {
        if (change & CHANGED_ALLOWED_DROP) //note that it's & and not &&... it's bitwise!
        {
            llOwnerSay("The inventory has changed as a result of a user without mod permissions dropping an item on the prim and it being allowed by the script.");
        }
    }
}
