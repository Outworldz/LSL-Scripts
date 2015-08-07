// :CATEGORY:Combat
// :NAME:The_Terra_Combat_System_TCS
// :AUTHOR:Cubey Terra
// :CREATED:2010-07-01 15:11:14.270
// :EDITED:2013-09-18 15:39:07
// :ID:887
// :NUM:1263
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// beacon
// :CODE:
// Cubey's (very) simple vehicle beacon - Help prevent vehicle litter!
//
// January 03 2005 - Cubey Terra
// rev 2.1 May 16 2006 - adapted to listen for TCS 2.1 messages
// This script is free to copy, modify, and distribute. Share and enjoy!
//
// This script simply sends an IM at regular intervals to the owner.
// Any lost vehicles can be found. This reduces the number of stray
// vehicles that tend to litter the world.

// It can be used as-is to "ping" the owner every x number of hours.
// Simply place it in your vehicle and set the change the "hours" variable
// below to the number of hours between beacon pings.

// It also listens for link messages from other scripts in the object, 
// with which you can turn the beacon on/off and set the beacon interval.
//
// To turn on the beacon, use this link message in another script:
// llMessageLinked(LINK_SET, 0, "tc beacon on", "");
// The beacon is on by default.
//
// Similarly, to turn off the beacon, use this link message in another script:
// llMessageLinked(LINK_SET, 0, "tc beacon off", "");
//
// To set the interval in hours, use this link message in another script:
// llMessageLinked(LINK_SET, numberOfHours, "tc beacon interval", "");
// where numberOfHours is an integer indicating the number of hours (of course) :).
// 
// To get a status message, use this link message in another script:
// llMessageLinked(LINK_SET, numberOfHours, "tc beacon status", "");


integer hours = 24; // Number of hours between beacon IMs. Change this to suit your needs.


//No need to change anything below this line (unless you really want to, that is)
// ---------------------------------------------------------------------------

integer active = TRUE;
integer currentHours;

beaconStatus()
{
    if (active)        
    {
        llInstantMessage(llGetOwner(),"Beacon is ON. Message interval set to " + (string)hours + ". Next message in less than "+ (string)(hours - currentHours) + " hours. Hours elapsed since last message: " + (string)currentHours + ".");
    }
    else
    {
        llInstantMessage(llGetOwner(),"Beacon is OFF. Message interval set to " + (string)hours + ". You will not be messaged.");
    }
}

init()
{
    currentHours = 0;
    if (active) {llSetTimerEvent(3600);}
}

default
{
    state_entry()
    {
        init();
    }
    
    on_rez(integer num)
    {
        init();
    }
    
    link_message(integer sender_num, integer num, string str, key id)
    {
        string message = llToLower(str);
        
        // Listening for message to turn on or off.
        if (message == "tc beacon off")
        {
            active = FALSE;
            llSetTimerEvent(0.0);
            beaconStatus();
        }
        else if (message == "tc beacon on")
        {
            active = TRUE;
            currentHours = 0;
            llSetTimerEvent(3600); // 1 hour timer?
            beaconStatus();
        }
        
        // To set the beacon interval from an external script, send the link message
        // "beacon interval" and send the number of hours as an integer.
        else if (message == "tc beacon interval") 
        {
            hours = num;
            currentHours = 0;
            beaconStatus();
        }
        
        else if (message == "tc beacon status")
        {
            beaconStatus();
        }
    }
    
    timer()
    {
        if (active)
        {
            currentHours += 1;
            if (currentHours == hours)
            {
                vector pos = llGetPos();
                llInstantMessage(llGetOwner(),"Locator beacon: Your vehicle is located at " +  llGetRegionName() + "(" + (string)llRound(pos.x)+","+(string)llRound(pos.y)+") at an altitude of " + (string)llRound(pos.z) + " meters.");
                currentHours = 0;
            }
        }
    }
}
