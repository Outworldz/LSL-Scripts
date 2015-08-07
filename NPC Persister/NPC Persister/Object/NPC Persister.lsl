// :CATEGORY:NPC
// :NAME:NPC Persister
// :AUTHOR:Marcus Llewellyn
// :CREATED:2014-01-17 11:07:27
// :EDITED:2014-01-17 11:07:27
// :ID:1010
// :NUM:1563
// :REV:1
// :WORLD:OpenSim
// :DESCRIPTION:
// When a simulator is restarted, any NPCs on that sim's regions will not automatically reappear.
// Much like dynamic textures, NPCs are a transient and non-persistant asset that is not stored in any database.
// So any scripts that controls an NPC will need to have a mechanism in place to detect wether an NPC is currently instantiated, and recreate it if it is not.

// :CODE:
// Implementing NPC Persistence

// The llKey2Name function placed in a timer event is the tool I use to check whether an NPC is still present in-world. If this function returns an empty string, it can be assumed that the NPC is no longer rezzed, and must be recreated.
// The following script is an example of the mechanism I make use of to accomplish this task. It has been kept to the bare minimum necessary to demonstrate the concept, and to manage the NPC it creates.
// NPC Persistance Example created by Marcus Llewellyn.
// This script is in the Public Domain.
 
key npc = NULL_KEY;
string firstname = "Dwight";
string lastname = "Smith";
integer dead = FALSE;
 
default
{
    state_entry() {
        // Setup and rez the NPC.
        key temp = (key)llGetObjectDesc();
        if (llKey2Name(temp) != "") {
            // An NPC matching the UUID stored in the object description
            // already exists, so just retrieve the UUID.
            npc = temp;
        } else if (dead == FALSE) {
            // Create a new instance of the NPC, record the UUID in the
            // object's description, and set starting rotation. NPC
            // rotation and location are inherited from the controlling
            // object with an offset.
            npc = osNpcCreate(firstname, lastname, llGetPos() + <1.0,0.0,0.0>, llGetOwner());
            llSetObjectDesc((string)npc);
            osNpcSetRot(npc, llGetRot() * (llEuler2Rot(<0, 0, 90> * DEG_TO_RAD)));
        }
        // Have the NPC say a greeting, and set up persistance timer and
        // listen for commands.
        osNpcSay(npc, firstname + " " + lastname + ", at your service.");
        llSetTimerEvent(10);
        llListen(0, "", NULL_KEY, "");
 
    }
 
    timer() {
        // Our NPC UUID stored in the object description should match the
        // UUID of our existing NPC. If it does not, we presume an untimely
        // demise, and initiate resurrection by simply reseting our script.
        key temp = (key)llGetObjectDesc();
        if (llKey2Name(temp) == "" && dead == FALSE) {
            llResetScript();
        }          
    }
 
    listen(integer channel, string name, key id, string msg) {
        if (llToLower(msg) == "kill") {
            // Kill the NPC, set a flag so it stays dead, and misquote
            // John Donne.
            osNpcSay(npc, "Send not to know for whom the bell tolls, it tolls for me!");
            osNpcRemove(npc);
            dead = TRUE;
        } else if (llToLower(msg) == "start" && dead == TRUE) {
            // Create a new instance of our NPC, and set flag for
            // persistance checks.
            npc = osNpcCreate(firstname, lastname, llGetPos() + <1.0,0.0,0.0>, llGetOwner());
            llSetObjectDesc((string)npc);
            osNpcSetRot(npc, llGetRot() * (llEuler2Rot(<0, 0, 90> * DEG_TO_RAD)));
            osNpcSay(npc, firstname + " " + lastname + ", at your service.");
            dead = FALSE;
        } else if (llToLower(msg) == "start" && dead == FALSE) {
            // Don't do anything significant if the NPC is still incarnate.
            osNpcSay(npc, "I'm already alive, boss.");
        }
    }
}
