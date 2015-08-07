// :SHOW:
// :CATEGORY:Music
// :NAME:42_minute_Music_Box
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2012-10-09 15:37:27.430
// :EDITED:2015-04-27  12:31:53
// :ID:5
// :NUM:8
// :REV:1.3
// :WORLD:Second Life
// :DESCRIPTION:
// Sensor Script - Put this in a prim along with the Music script and as many 10 second sound clips as you want.   This will detect any avatar coming nearby and trigger the music from the beginning.   You can leave this script out and just use the music player. Start the music by touching the prim
// :CODE:
// general purpose avatar sensor for the music playert
// When someone gets in range, this starts the music sequence if a HUD or if the player is in the same prim
// 10-09-2012 by Ferd Frederix
// Rev 1.3 - made it send the Play and Stop only once and not use a sensor.

// This work is licensed under a Creative Commons Attribution 3.0 Unported License.
// http://creativecommons.org/licenses/by/3.0/deed.en_US


// Tuneable thing:
float range = 5.0;     // how far a avatar has to be before sound plays, in meters
float howoften = 5.0;  // how often we look for avatars.  Average time before it detects is half this. The longer you make this, the less lag it causes.
integer debugflag = FALSE;

// best to leave these bits alone


DEBUG (string msg)
{
    if (debugflag) llOwnerSay(msg);
}

integer someoneWasListening = FALSE;

default
{
    state_entry()
    {
        llSetTimerEvent(howoften );
    }

    timer()
    {
        integer someoneIsListening = llGetRegionAgentCount();
            
        if (!someoneWasListening && someoneIsListening) {
            someoneWasListening = TRUE;
            llMessageLinked(LINK_SET,0,"play","");
            return ;
        }

        if (someoneWasListening && !someoneIsListening) {
            someoneWasListening = FALSE;
            llMessageLinked(LINK_SET,0,"stop","");
        }
    }

    changed(integer what)
    {
        if (what & CHANGED_REGION_START) {
            llResetScript();
        }
    }
    
    on_rez(integer p)
    {
        llResetScript();
    }
}
