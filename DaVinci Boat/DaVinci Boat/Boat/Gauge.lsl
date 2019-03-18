// :CATEGORY:Boat
// :NAME:DaVinci Boat
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-08
// :EDITED:2013-09-18 15:38:51
// :ID:220
// :NUM:297
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// The gauge control script for steam power
// :CODE:
// Settable steam gauge
// Uses a 1X3 animated GIF, but displays one of three settings based on a link message



default
{
    state_entry()
    {
        llScaleTexture(0.333, 1.0, ALL_SIDES);            // adjust for a 1X3 GIF
        llOffsetTexture(-0.3333, 0.0, ALL_SIDES);        // First frame = COLD
    }

    on_rez(integer start)
    {
        llResetScript();
    }

    link_message(integer sender_number, integer number, string message, key id)
    {
        if (message == "spin" && number == 0) {
            llOffsetTexture(-0.3333, 0.0, ALL_SIDES);
        }
        else if (message == "spin" && number < 0) {
            llOffsetTexture(0.0, 0.0, ALL_SIDES);
        }
        else if (message == "spin" && number > 15) {
            llOffsetTexture(0.3333, 0.0, ALL_SIDES);
        }
    }
} 
