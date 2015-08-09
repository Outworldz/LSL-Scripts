// :CATEGORY:Kites
// :NAME:L96kite
// :AUTHOR:Dana Moore
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:447
// :NUM:603
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// L9.06-kite.lsl
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

// Listing 9.6: The Flying Kite
string SPOOL = "KiteSpool";
string SPOOL_REZZED = "SpoolRezzed";
float  SENSOR_INTERVAL = 5.0;
float  MAX_SPOOL_DIST = 50.0;
float  MAX_WIND_STRENGTH = 0.75; // ratio of VecMag(wind) to string len

key      gSpoolID;
vector   gStartPos;
rotation gStartRot;
float    gSpoolDistance = 5.0; // could listen to Chat to change
integer  gInitialKitePosHandle;

default {
    state_entry() {
        llSetStatus(STATUS_PHYSICS, TRUE);
        llSleep(0.1);
        gStartPos = llGetPos();
        gStartRot = llGetRot();
        vector targetPos = gStartPos + <0,0,2>; // float in the air
        llMoveToTarget( targetPos, 2.0 );
        gInitialKitePosHandle = llTarget( targetPos, 1.0 );
    }
    on_rez(integer param) {
        llResetScript();
    }
    at_target( integer targetHandle, vector targPos, vector currPos ) {
        if (targetHandle == gInitialKitePosHandle) {
            llRezObject(SPOOL,gStartPos, ZERO_VECTOR,ZERO_ROTATION, 1);
            llTargetRemove( gInitialKitePosHandle );
        }
    }
    object_rez(key id) {
        // message to other script in same prim
        llMessageLinked(llGetLinkNumber(), 0, SPOOL_REZZED, id);
        gSpoolID = id;
        llSensorRepeat(SPOOL, id, PASSIVE|ACTIVE, MAX_SPOOL_DIST,
                       TWO_PI, SENSOR_INTERVAL);
    }

    no_sensor() {
        llSay(0,"The spool has vanished. Returning home.");
        llSetStatus(STATUS_PHYSICS, FALSE);
        llMessageLinked(llGetLinkNumber(), 0, "", NULL_KEY);
        llSetPos(gStartPos); // or use moveTo() from Listing 2.4
        llSetRot(gStartRot);
        llSensorRemove();
    }
    sensor(integer num) {
        vector spoolPos = llDetectedPos(0);
        vector windDir = llWind( spoolPos );
        windDir.z = 0;
        float windStrength = llVecMag(windDir);
        if (windStrength > (gSpoolDistance * MAX_WIND_STRENGTH)) {
            windStrength = gSpoolDistance * MAX_WIND_STRENGTH;
        }
        float theta = llAsin( windStrength / gSpoolDistance );
        float height = gSpoolDistance * llCos( theta );
        vector posOffset = <windDir.x, windDir.y, height>;

        llMoveToTarget( spoolPos+posOffset, SENSOR_INTERVAL );
        llLookAt ( spoolPos, 1.0, 1.0 );
    }
}
// END //
