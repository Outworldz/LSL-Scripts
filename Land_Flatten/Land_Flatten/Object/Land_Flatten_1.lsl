// :CATEGORY:Land
// :NAME:Land_Flatten
// :AUTHOR:Guzar Fonzarelli
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:453
// :NUM:609
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Land Flatten.lsl
// :CODE:

// Copyright 2004 Guzar Fonzarelli
// Please keep this copyright notice attached to this script.

default
{
    state_entry()
    {
        llSetTimerEvent(0.1);
    }

    timer()
    {
        llModifyLand(LAND_LEVEL, LAND_MEDIUM_BRUSH);
    }
}
// END //
