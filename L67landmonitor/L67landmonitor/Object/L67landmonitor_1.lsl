// :CATEGORY:Land
// :NAME:L67landmonitor
// :AUTHOR:Dana Moore
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:433
// :NUM:589
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// L6.07-land-monitor.lsl
// :CODE:

// Copyright (c) 2008, Scripting Your World
// All rights reserved.
//
// Scripting Your World
// By Dana Moore, Michael Thome, and Dr. Karen Zita Haigh
// http://syw.fabulo.us
// http://www.amazon.com/Scripting-Your-World-Official-Second/dp/0470339837/
//
// You are permitted to use, share, and adapt this code under the 
// terms of the Creative Commons Public License described in full
// at http://creativecommons.org/licenses/by/3.0/legalcode.
// That means you must keep the credits, do nothing to damage our
// reputation, and do not suggest that we endorse you or your work.

// Listing 6.7: Land Monitor and Ejector

// uses delay before ejecting intruder
// see SYW chapter 6 for methods that are more polite than "ejecting"
//   to control land access

float EJECT_DELAY = 10.0;   // seconds
float SENSOR_REPEAT = 30.0; // seconds
list  gIntruders;
default {
    state_entry() {
        llSensorRepeat( "", NULL_KEY, AGENT, 20, PI, SENSOR_REPEAT );
    }
    sensor( integer vIntFound ){
        integer vIntCounter = 0;
        do {
            string vStrName = llDetectedName( vIntCounter );
            if (llOverMyLand( llDetectedKey( vIntCounter ) )) {
                //if (llSameGroup( llDetectedKey( vIntCounter )))
                if (llDetectedGroup( vIntCounter )) {
                    //llWhisper(0, vStrName + " is in the same group");
                } else {
                    llSay(0, vStrName+", this is a private estate. Please leave.");
                    llSetTimerEvent(EJECT_DELAY);
                    gIntruders += llDetectedKey( vIntCounter );
                }
            }
        } while (++vIntCounter < vIntFound);
    }
    timer() {
        integer i;
        integer len = llGetListLength( gIntruders );
        for (i=0; i<len; i++) {
            key intruder = llList2Key( gIntruders, i );
            if (llOverMyLand( intruder )) {
                llEjectFromLand(intruder);
            }
        }
        gIntruders = [];
        llSetTimerEvent(0);
    }
}
// END //
