// :CATEGORY:Invisibility
// :NAME:Invisibility_Prim_Refresh_v1
// :AUTHOR:Beatfox Xevious
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:404
// :NUM:560
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Invisibility Prim Refresh v1.lsl
// :CODE:

// Invisibility Prim Refresh v1.1a
// by Beatfox Xevious
// last updated Oct. 21, 2004

refresh()
{
    llSetTexture("38b86f85-2575-52a9-a531-23108d8da837", ALL_SIDES);
    llSleep(30);
    llSetTexture("e97cf410-8e61-7005-ec06-629eba4cd1fb", ALL_SIDES);
}

default
{
    state_entry()
    {
        llSetPrimitiveParams([PRIM_BUMP_SHINY, ALL_SIDES, PRIM_SHINY_NONE, PRIM_BUMP_BRIGHT]);
        llOffsetTexture(0.468, 0.0, ALL_SIDES);
        llScaleTexture(0.0, 0.0, ALL_SIDES);
        llSetAlpha(1.0, ALL_SIDES);
        llSetTimerEvent(5);
    }

    timer()
    {
        if ((integer)llGetWallclock() % 60 < 10)
        {
            refresh();
        }
    }
}
// END //
