// :CATEGORY:Light
// :NAME:Simple_Light_1
// :AUTHOR:Malaer Sunchaser
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:02
// :ID:762
// :NUM:1049
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Simple Light 1.lsl
// :CODE:

// Simple Voice Controlled Light
// By: Malaer Sunchaser
// Say on and off, to turn the light on and off. On is white light, off turns the light black
// and produces no light!  Light only turns on for the owner of it!

vector on = <1.0,1.0,1.0>;
vector off = <0.0,0.0,0.0>;

key owner;

default
{
    state_entry()
    {
        llWhisper(0, "Light Activated");
        owner = llGetOwner();
        llListen(0,"",owner,"on");
        llListen(0,"",owner,"off");
    }

    listen(integer channel, string name, key id, string m)
    {
        if (m == "on")
        {
            llSetColor(on,ALL_SIDES);
        }
        if (m == "off")
        {
            llSetColor(off,ALL_SIDES);
        }
    }
}// END //
