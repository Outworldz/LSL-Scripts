// :SHOW:
// :CATEGORY:Scripting
// :NAME:Script Tests
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :CREATED:2019-03-18 23:44:22
// :EDITED:2019-03-18  22:44:22
// :ID:1116
// :NUM:1942
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// One of many tests for Opensim
// :CODE:

default
{
    state_entry()
    {
        llListen(42, "", llGetOwner(), "");
    }
    listen(integer chan, string name, key id, string msg)
    {
        float value = (float)msg;
        llAdjustSoundVolume(value);
        llOwnerSay("Volume set to: " + (string)value + " of 1.0");
    }
}
