// :SHOW:
// :CATEGORY:Scripting
// :NAME:Script Tests
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :CREATED:2019-03-18 23:44:22
// :EDITED:2019-03-18  22:44:22
// :ID:1116
// :NUM:1943
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// One of many tests for Opensim
// :CODE:

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
