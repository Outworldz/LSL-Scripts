// :CATEGORY:Door
// :NAME:A_Door_Hinge
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:46
// :ID:7
// :NUM:11
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The script
// :CODE:
// Swinging door LSL script #1
// Handles the touch event.
// Handles the collision event.
// Handles closing the door automatically via a timer event.
// Triggers sounds when the door opens or closes.
 
// Parameters you might want to change
 
float  delay = 3.0;                         // time to wait before 
                                            // automatically closing door
 
float  direction = 1.0;                     // set to 1.0 or -1.0 to control 
                                            // direction the door swings
 
float  volume = 0.5;                        // 0.0 is off, 1.0 is loudest
 
// Variables you will most likely leave the same
 
key    open_sound  = "cb340647-9680-dd5e-49c0-86edfa01b3ac";
key    close_sound = "e7ff1054-003d-d134-66be-207573f2b535";
 
// Processing for the script when it first starts up
 
default {
    // What we do when we first enter this state
 
    state_entry() {
        state open;                         // Move to the open state
    }
}
 
// Processing for the script when it is in the closed state
 
state closed {
    // What we do when we first enter this state
 
    state_entry() {
        llTriggerSound(close_sound, volume); // Trigger the sound of the door closing
        llSetRot(llEuler2Rot(&lt;0, 0, direction * PI_BY_TWO&gt;) * llGetRot());
 
    }
 
    // What we do when the door is clicked ("touched") with the mouse
 
    touch_start(integer total_number) {
        state open;                         // Move to the open state
    }
 
    // What to do when something hits the door 
 
    collision_start(integer total_number)
    {
        state open;                         // Move to the open state
    }
 
    // What to do when the timer goes off
 
    timer()
    {
        llSetTimerEvent(0.0);               // Set the timer to 0.0 to turn it off
    }
}
 
// Processing for the script when it is in the open state
 
state open {
    // What we do when we first enter this state
 
    state_entry() {
        llTriggerSound(open_sound, volume);// Trigger the sound of the door opening
        llSetRot(llEuler2Rot(&lt;0, 0, -direction * PI_BY_TWO&gt;) * llGetRot());
 
        llSetTimerEvent(delay);             // Set the timer to automatically close it
    }
 
    // What do do when pulling the door from Inventory if it was saved while open
 
    on_rez(integer start_param) {
        state closed;
    }
 
    // What we do when the door is clicked ("touched") with the mouse
 
    touch_start(integer total_number) {
        state closed;                       // Move to the closed state
    }
 
    // What to do when something hits the door 
 
    collision_start(integer total_number)
    {
        // Do nothing, the door is already open
    }
 
    // What to do when the timer goes off
 
    timer()
    {
        llSetTimerEvent(0.0);               // Set the timer to 0.0 to turn it off
        state closed;                       // Move to the closed state
    }
}
