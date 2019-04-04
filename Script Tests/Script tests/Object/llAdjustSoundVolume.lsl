// :CATEGORY:Scripting
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
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
