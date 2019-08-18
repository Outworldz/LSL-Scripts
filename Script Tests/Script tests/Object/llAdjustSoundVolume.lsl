// :SHOW:
// :CATEGORY:Scripting
// :NAME:Script Tests
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :CREATED:2019-04-04 20:49:51
// :EDITED:2019-04-04  19:49:51
// :ID:1124
// :NUM:1995
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
