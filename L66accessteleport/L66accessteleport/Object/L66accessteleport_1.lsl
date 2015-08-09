// :CATEGORY:Water
// :NAME:L66accessteleport
// :AUTHOR:Dana Moore
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:432
// :NUM:588
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// L6.06-access-teleport.lsl
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

// Listing 6.6: Access-Controlled Teleport


// Read the access List on entry / reset.
// Whenever you add a new name to the access list,
// manually reset the script to force a full re-read
string gAccessCard;    // name of a notecard in the object's inventory
integer gLine = 0;     // current line number
key gQueryID;          // id used to identify dataserver queries
list gAccessList = [];

vector targetPos = <12.5, 250.0, 120.50>; //The x, y, z coordinates to teleport.
string fltText = "1st Floor"; //label that floats above Teleport

integer onTheList(string name) {
    return (llListFindList(gAccessList, [name]) > -1);
}

reset() {
    vector target;
    target = (targetPos- llGetPos()) * (ZERO_ROTATION / llGetRot()); 
    llSitTarget(target, ZERO_ROTATION);
}

default {
    state_entry() {
        llSetText(fltText, <1.0, 1.0, 1.0>,1.0);
        llSetSitText(fltText);
        // select the first notecard in the object's inventory
        gAccessCard = llGetInventoryName(INVENTORY_NOTECARD, 0);
        // force full read by asking for first line
        gQueryID = llGetNotecardLine(gAccessCard, gLine);
    }
    dataserver(key query_id, string data) {
        if (query_id == gQueryID) {
            if (data != EOF) {    // not at the end of the notecard
                gAccessList += data;
                ++gLine;          // increase line count
                gQueryID = llGetNotecardLine(gAccessCard, gLine);  // get next line
            } else {
                llOwnerSay("Access List: " +(string)llGetListLength(gAccessList));
            }
        }
    }
    changed(integer change) {
        key avatarKey = llAvatarOnSitTarget();
        if ((avatarKey != NULL_KEY) && (change & CHANGED_LINK)) {
            if (onTheList(llKey2Name(avatarKey))){
                llSleep(0.15);
                llUnSit(avatarKey); // will be at destination
                reset();
            } else {
                llWhisper(0, "Access denied. Ejecting you!");

                // llTeleportAgentHome(avatarKey);
                //    llTeleportAgentHome without warning is not polite;
                //    either add a warning & delay, or use one of the
                //    other methods in SYW chapter 6, such as:

                llAddToLandBanList(avatarKey, 7*24);
            }
        }
    }
}
// END //
