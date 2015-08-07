
default
{
    state_entry()
    {
        llListen(9898,"","","scream");
        llSetAlpha(0.0, ALL_SIDES);
    }

    listen(integer channel, string name, key id, string message)
    {
        llSetAlpha(1.0, ALL_SIDES);
        llSleep(3);
        llSetAlpha(0.0, ALL_SIDES);
    }

    on_rez(integer wtf)
    {
        llResetScript();
    }

}