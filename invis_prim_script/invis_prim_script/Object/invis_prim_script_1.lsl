// :CATEGORY:Texture
// :NAME:invis_prim_script
// :AUTHOR:Chris Knox
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:402
// :NUM:558
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// invis prim script.lsl
// :CODE:

//The Better Invisibility Script 
//from Chris Knox
refresh()
{
    llSetTexture("38b86f85-2575-52a9-a531-23108d8da837", ALL_SIDES);
    llOffsetTexture(0.468, 0, ALL_SIDES);
    llScaleTexture(0, 0, ALL_SIDES);
    llSleep(30);
    llSetTexture("e97cf410-8e61-7005-ec06-629eba4cd1fb", ALL_SIDES);
    llOffsetTexture(0.468, 0, ALL_SIDES);
    llScaleTexture(0, 0, ALL_SIDES);
}

default
{
    state_entry()
    {
        refresh();
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
