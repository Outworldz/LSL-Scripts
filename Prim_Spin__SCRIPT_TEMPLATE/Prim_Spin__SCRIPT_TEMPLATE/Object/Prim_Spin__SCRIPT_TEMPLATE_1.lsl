// :CATEGORY:Movement
// :NAME:Prim_Spin__SCRIPT_TEMPLATE
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:00
// :ID:655
// :NUM:892
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Prim Spin  SCRIPT TEMPLATE.lsl
// :CODE:

//// "llTargetOmega()" SCRIPT TEMPLATE v1 - by Jopsy Pendragon - 4/8/2008
//// You are free to use this script as you please, so long as you include this line:
//** The original 'free' version of this script came from THE PARTICLE LABORATORY. **//

// SETUP:  Use with CONTROLLER TEMPLATES to turn on/off spin effect.

// PURPOSE:  This script will start a client side "spin" effect on any prim it's
// added to.  (the whole object will spin if added to root prim).
// This is an 'illusionary' effect  (not a physical one!)

float spin_rate = -1.00;  // revolutions per second around vertical axis
float roll_rate = 0.00;  // revs per sec around east/west axis
float yaw_rate  = 0.00;  // revs per second around north/south axis

integer LOCAL_AXIS = TRUE; // set to true to adjust spin around prim's axis instead of global.
    // (NOTE: LOCAL_AXIS doesn't update when the prim is rotated by other methods!
    // only when this effect is restarted.)
    // May or may not reset to original position when turned off.


string  CONTROLLER_ID = "A"; // See comments at end regarding CONTROLLERS.
integer AUTO_START = TRUE;   // Optionally FALSE only if using CONTROLLERS.

rotation adjustment = ZERO_ROTATION;

default {
    state_entry() {
        
        if ( LOCAL_AXIS ) adjustment = llGetRot();
        
        if ( AUTO_START ) llTargetOmega( <roll_rate, yaw_rate, spin_rate>*adjustment, 2.0, 2.0 );
        
    }
    
    link_message( integer sibling, integer num, string mesg, key target_key ) {
        if ( mesg != CONTROLLER_ID ) { // this message isn't for me.  Bail out.
            return;
        } else if ( num == 0 ) { // Message says to turn particles OFF:
            llTargetOmega( <0, 0, 0>, 1.0, 1.0 );
            llSetLocalRot( llGetLocalRot() );
        } else if ( num == 1 ) { // Message says to turn particles ON:
            llTargetOmega( <roll_rate, yaw_rate, spin_rate>*adjustment, 2.0, 2.0 );
        } else { // bad instruction number
            // do nothing.
        }            
    }
        
}

// for more visit:

// http://rpgstats.com/wiki/index.php?title=LlTargetOmega
// http://wiki.secondlife.com/wiki/LlTargetOmega
// http://lslwiki.net/lslwiki/wakka.php?wakka=llTargetOmega

// (each is different!)// END //
