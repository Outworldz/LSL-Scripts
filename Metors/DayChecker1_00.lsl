//DayChecker 1.0

// Simple script for testing day/night time and give a shout if daytime changes

// GLOBALS

    integer Debug = FALSE ;
    integer time_check = 20 ;   // periode om nacht te checken    
    integer Gchannel = 10001 ;  // General channel for daycheck
    
default // default daytime state
{
     state_entry()
     {
        llRegionSay(Gchannel, "Day");
        llSetTimerEvent(time_check); // Checks default every 120 secs = 2 minutes
     }
     timer()  // If timer reached ...
     {
         vector sun = llGetSunDirection(); // Gets Sun Direction as a vector
         if (sun.z < 0) state nighttime; // If its night goes to state nighttime
         llOwnerSay("It's daytime " + (string)sun.z); // Says to Owner its daytime
     }
     touch_start(integer total_number) // If touched ...
     {
        key lAvatarKey    = llDetectedKey(0) ;
        string lAvatarName  = llKey2Name(llDetectedKey(0)) ;
        state nighttime;
     }
}

state nighttime // nighttime state

{
     state_entry()
     {
        llRegionSay(Gchannel, "Night");
        llSetTimerEvent(time_check); // Checks  default every 120 secs = 2 minutes

     }
     timer() // If timer reached ....
     {
         vector sun = llGetSunDirection(); // Gets Sun Direction as a vector
         if (sun.z > 0) state default; // If its day, change back to daytime state
         llOwnerSay("It's nighttime " + (string)sun.z); // Says to Owner its daytime
     }
     touch_start(integer total_number)  // If touched ...
     {
        llWhisper(0,"Nighttime"); // Says to Owner its nighttime
        state default;
     }
}