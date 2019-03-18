// :CATEGORY:Music
// :NAME:Music Player
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:58
// :ID:548
// :NUM:746
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Sensor
// :CODE:

// general purpose avatar sensor for the music playert
// When someone gets in range, this starts the music sequence if a HUD or if the player is in the same prim
// 10-09-2012 by Fred Beckhusen (Ferd Frederix)

// This work is licensed under a Creative Commons Attribution 3.0 Unported License.
// http://creativecommons.org/licenses/by/3.0/deed.en_US


// Tuneable thing:
float range = 5.0;     // how far a avatar has to be before sound plays, in meters
float howoften = 5.0;  // how often we look for avatars.  Average time before it detects is half this. The longer you make this, the less lag it causes.
integer debugflag = FALSE;

// best to leave these bits alone

integer someoneIsListening = FALSE;    // if TRUE, the player is running in PRIM mode

DEBUG (string msg)
{
    if (debugflag) llOwnerSay(msg);
}


default
{
    state_entry()
    {
        llSensorRepeat("","",AGENT,range, PI, howoften);
    }

    sensor(integer total_number)
    {
        if (!someoneIsListening)
        {
            someoneIsListening = TRUE;
            llMessageLinked(LINK_SET,0,"play","");
        }

    }

    no_sensor()
    {
        if (someoneIsListening)
        {
            someoneIsListening = FALSE;
            llMessageLinked(LINK_SET,0,"stop","");
            return;
        }

    }

    on_rez(integer p)
    {
        llResetScript();
    }
}
