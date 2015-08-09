// :CATEGORY:Special Effects
// :NAME:Avatar_Magnet
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:73
// :NUM:100
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Avatar Magnet.lsl
// :CODE:

// Avatar Magnet Script 0.1 
// a simple avatar magnet with some "nice" features built in 
// if you turn these features off *please* 
// don't use it outside of a combat area 
// even if you leave them on this script uses push to simulate a 
// magnet effect it *will* register as PvP outside combat areas 
// 
// if you turn OBJECTS on it will attract physical objects too 
// but it doesn't work very well 
// especially with small objects as they usually end up flying off world 
// 
// this script is mostly untested 
// if you have problems let me know and i'll try to fix them 


// whether the object asks permission to attract or not 
// be nice and ask ;) 
integer REQUIRE_PERMISSION = TRUE; 

// if we are requiring permissions set this based on whether 
// you want it to prompt nearby users for permissions 
// or require them to touch this object to be asked permission 
// TRUE means it will ask without touching 
// FALSE means they must touch it to be asked 
integer UNSOLICITED = TRUE; 

// how far to look around for targets 
// this is highly dependant on the mass of this object 
// and the mass of the target 
// small objects might not have enough energy to attract far away targets 
// maximum of 96.0 meters 
float RADIUS = 30.0; 

// how forceful you want to the magnet to be 
// if you set this too high it's hard for the magnet to keep up 
// with the velocity of the target so you get a lot of "ping-pong" effect 
// if you set it too low then the target can break away easily 
// if it has the ability to apply its own impulse 
// (an avatar can fly away from the magnet if it's set too low ... 
// but this may be a good thing) 
// the maximum amount is effectively 2147483647 
// but really > 100 is too much 
float FORCE = 20.0; 

// attract avatars 
integer AVATARS = TRUE; 

// attract physical objects 
// this really doesn't work very well, especially for small objects 
integer OBJECTS = FALSE; 

// if we're asking permission we need to keep a list of people 
// who have accepted and people who have declined 
// unfortunately due to memory constraints these lists will be capped 
// i haven't tested this! 
// if you get stack-heap errors you will need to lower the cap 
integer CAP = 50; 
list declined; 
list accepted; 

// listener handle 
integer listener; 

askPermission(key avatar) { 
    // build the message based on the settings 
    string message = "May this magnet attract "; 
    if (AVATARS) message += "you"; 
    if (OBJECTS && AVATARS) message += " and "; 
    if (OBJECTS) message += "your objects"; 
    message += "?"; 

    // build dialog button list 
    // based on whether or not this is the owner         
    list buttons = ["Accept", "Decline"]; 
    if (avatar == llGetOwner()) buttons += ["Turn Off"]; 
     
    llDialog(avatar, message, buttons, -38739454); 
} 

default { 
    state_entry() { 
        // turn of collision effects 
        llCollisionSprite(""); 
        llCollisionSound("", 0.0); 
         
        llSetText("Magnet Off", <1.0, 1.0, 1.0>, 1.0); 
         
        llOwnerSay("Magnet Off"); 
    } 
     
    touch_start(integer touches) { 
        // turn the magnet on 
        if (llDetectedKey(0) == llGetOwner()) state magnetized; 
    } 
} 

state magnetized { 
    on_rez(integer start) { 
        llResetScript(); 
    } 
     
    state_entry() { 
        // clear out the accepted list 
        accepted = []; 
         
        llSetText("Magnet On", <1.0, 1.0, 1.0>, 1.0); 
         
        llOwnerSay("Magnet On"); 
         
        // the magnet shouldn't be phantom or you get weird results 
        llSetStatus(STATUS_PHANTOM, FALSE); 

        // figure out which types of targets we're attracting     
        integer types; 
        if (AVATARS) types = types | AGENT; 
        if (OBJECTS) types = types | ACTIVE; 

        // set our sensor         
        llSensorRepeat("", "", types, RADIUS, TWO_PI, 0.1); 
                  
        // listen for dialog responses if we're asking permission 
        if (REQUIRE_PERMISSION) 
            listener = llListen(-38739454, "", "", ""); 
    }     
     
    listen(integer channel, string name, key id, string message) { 
        // only listen to avatars 
        if (llGetOwnerKey(id) == id) { 
            if (message == "Accept") { 
                // if they were already on the accepted list 
                // remove their earlier entry 
                integer index = llListFindList(accepted, [id]); 
                 
                if (index > -1) 
                    accepted = llDeleteSubList(accepted, index, index); 
                 
                // add to the end of the accepted list 
                accepted += [id]; 
                 
                // make sure our list isn't bigger than the cap 
                if (llGetListLength(accepted) > CAP) 
                    accepted = llDeleteSubList(accepted, 0, 0); 
                 
                // remove from the declined list if they're on it 
                index = llListFindList(declined, [id]); 
                 
                if (index > -1) 
                    declined = llDeleteSubList(declined, index, index); 
            } else if (message == "Decline") { 
                // remove from the accepted list if they're on it 
                integer index = llListFindList(accepted, [id]); 
                 
                if (index > -1) 
                    accepted = llDeleteSubList(accepted, index, index); 
                 
                // if they were already on the declined list 
                // remove their earlier entry 
                index = llListFindList(declined, [id]); 
                 
                if (index > -1) 
                    declined = llDeleteSubList(declined, index, index); 
                 
                // add to the end of the declined list 
                declined += [id]; 
                 
                // make sure our list isn't bigger than the cap 
                if (llGetListLength(declined) > CAP) 
                    declined = llDeleteSubList(declined, 0, 0); 
            } else if (message == "Turn Off" && id == llGetOwner()) { 
                state default; 
            } 
        } 
    } 
     
    touch_start(integer touches) { 
        key toucher = llDetectedKey(0); 
         
        if (REQUIRE_PERMISSION)  { 
            askPermission(toucher); 
             
            return; 
        } 

        if (toucher == llGetOwner()) state default;         
    } 
     
    sensor(integer sensed) { 
        integer i; 
         
        for (i = 0; i < sensed; i ++) { 
            key target_key = llDetectedKey(i); 
             
            // if we're getting permission 
            // we need to see if we've alreay bothered this person 
            if (REQUIRE_PERMISSION) { 
                // since we may be attracting objects too 
                // we need to make sure we're asking the owner 
                key owner_key = llDetectedOwner(i); 
                 
                // if this person has not already accepted 
                // don't attract them 
                if (llListFindList(accepted, [owner_key]) == -1) { 
                    // but if we haven't already bothered them 
                    // we need to ask them 
                    if (llListFindList(declined, [owner_key]) == -1) { 
                        // put their name on the denied list 
                        declined += [owner_key]; 
                         
                        // make sure our list isn't bigger than the cap 
                        if (llGetListLength(declined) > CAP) 
                            declined = llDeleteSubList(declined, 0, 0); 
                         
                        if (UNSOLICITED) askPermission(owner_key); 
                    } 
                     
                    return; 
                } 
            } 
             
            // the position of our target 
            vector target_pos = llDetectedPos(i); 
             
            vector my_pos = llGetPos(); 
             
            // normalized vector describing the direction 
            // from our target to us 
            // this is a negative vector 
            // which will draw the object towards us 
            vector direction = llVecNorm(my_pos - target_pos); 

            // apply set amount of force 
            // in the direction from the target to this object 
            vector impulse = FORCE * direction; 

            // equalize for the targets mass so pull is consistent 
            impulse *= llGetObjectMass(target_key); 

            // equalize for the distance of the target 
            // so pull is consistent 
            impulse *= llPow(llVecDist(my_pos, target_pos), 3.0); 

            // negate the targets current velocity 
            impulse -= llDetectedVel(i); 
             
            llPushObject(target_key, impulse, ZERO_VECTOR, FALSE); 
        } 
    } 
     
    state_exit() { 
        // we don't actually need to do this any more because 
        // listeners are cleaned up on state change but we might as well 
        if (REQUIRE_PERMISSION) llListenRemove(listener); 
    } 
} 


// END //
