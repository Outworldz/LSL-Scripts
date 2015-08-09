// :CATEGORY:Particles
// :NAME:Make_it_Rain
// :AUTHOR:Oddball Otoole
// :CREATED:2010-11-18 21:00:48.190
// :EDITED:2013-09-18 15:38:57
// :ID:501
// :NUM:671
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// And a script to toggle rain on/off on touch.
// :CODE:
//// "Touch Toggle" CONTROLLER TEMPLATE v1 - by Jopsy Pendragon - 4/8/2008
//// You are free to use this script as you please, so long as you include this line:
//** The original 'free' version of this script came from THE PARTICLE LABORATORY. **//

// EFFECT: 'Touching' this prim will ACTIVATE or DEACTIVE particles.

// SETUP:  Drop this CONTROLLER TEMPLATE script into any prim of the same
// linked object as your PARTICLE TEMPLATE. It should be responsive immediately.

integer PLAY_SOUND = TRUE; // TRUE for a click-sound, FALSE for silent.
string  SOUND = "64319812-dab1-4e89-b1ca-5fc937b8d94a"; // a click sound

string  CONTROLLER_ID = "A"; // see more about CONTROL TEMPLATES at end.

integer mode = 0; // keep track of whether particles are ON(1) or OFF(0).

default {
   
    touch_start(integer total_number) {
   
        if ( PLAY_SOUND ) llPlaySound( SOUND, 1.0 ); 
       
        mode = ! mode; // flip on to off, (or off to on).
       
        llMessageLinked( LINK_SET, mode, CONTROLLER_ID, NULL_KEY ); // send command
    }
   
    // Listen for other controllers sending ON/OFF commands and remember changes:
    link_message( integer sibling, integer num, string controller_id, key ignore ) {
       
        if ( controller_id != CONTROLLER_ID ) return; // this message is not for us.
       
        mode = num;
    }
}


//========================================================================
//======================== USING CONTROL TEMPLATES =======================
//
// By default one CONTROLLER TEMPLATE will activate and deactivate all the
// PARTICLE TEMPLATES that are in the same linked object.
//
// However, the templates will only obey or affect each other if they share
// identical CONTROLLER_ID's.
//
// If you want templates to operate independently, change the value for
// CONTROLLER_ID so that it is the same for all templates that work together.
// (and different from all the templates that it should ignore or be ignored by)
