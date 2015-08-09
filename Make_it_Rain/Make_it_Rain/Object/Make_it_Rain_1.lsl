// :CATEGORY:Particles
// :NAME:Make_it_Rain
// :AUTHOR:Oddball Otoole
// :CREATED:2010-11-18 21:00:48.190
// :EDITED:2013-09-18 15:38:57
// :ID:501
// :NUM:670
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// First the actual rain script:
// :CODE:
//// "Rain" PARTICLE TEMPLATE v1 - by Jopsy Pendragon - 4/8/2008
//// You are free to use this script as you please, so long as you include this line:
//** The original 'free' version of this script came from THE PARTICLE LABORATORY. **//

// SETUP:  Drop one optional particle texture and this script into a prim.
// Particles should start automatically. (Reset) the script if you insert a
// particle texture later on.  Add one or more CONTROLLER TEMPLATES to any
// prims in the linked object to control when particles turn ON and OFF.

// Customize the particle_parameter values below to create your unique
// particle effect and click SAVE.  Values are explained along with their
// min/max and default values further down in this script.


string  CONTROLLER_ID = "A"; // See comments at end regarding CONTROLLERS.
integer AUTO_START = TRUE;   // Optionally FALSE only if using CONTROLLERS.

list particle_parameters=[]; // stores your custom particle effect, defined below.
list target_parameters=[]; // remembers targets found using TARGET TEMPLATE scripts.

default {
    state_entry() {
        particle_parameters = [  // start of particle settings
           // Texture Parameters:
           PSYS_SRC_TEXTURE, llGetInventoryName(INVENTORY_TEXTURE, 0),
           PSYS_PART_START_SCALE, <.1,.5, FALSE>,  PSYS_PART_END_SCALE, <.05,4.0, FALSE>,
           PSYS_PART_START_COLOR, <.3,.4,.5>,      PSYS_PART_END_COLOR, <.5,.6,.7>,
           PSYS_PART_START_ALPHA, (float).7,       PSYS_PART_END_ALPHA, (float).5,     
         
           // Production Parameters:
           PSYS_SRC_BURST_PART_COUNT, (integer)1,
           PSYS_SRC_BURST_RATE, (float) 0.05, 
           PSYS_PART_MAX_AGE, (float)1.0,
           PSYS_SRC_MAX_AGE,(float) 0.0, 
       
           // Placement Parameters:
           PSYS_SRC_PATTERN, (integer)8, // 1=DROP, 2=EXPLODE, 4=ANGLE, 8=ANGLE_CONE,
           
           // Placement Parameters (for any non-DROP pattern):
           PSYS_SRC_BURST_SPEED_MIN, (float)0.0,   PSYS_SRC_BURST_SPEED_MAX, (float)0.0,
           PSYS_SRC_BURST_RADIUS, 5.0,
       
           // Placement Parameters (only for ANGLE & CONE patterns):
           PSYS_SRC_ANGLE_BEGIN, (float) .25*PI,   PSYS_SRC_ANGLE_END, (float)0.0*PI, 
        // PSYS_SRC_OMEGA, <0,0,0>,
       
           // After-Effect & Influence Parameters:
           PSYS_SRC_ACCEL, <0.0,0.0,-10.5>, 
        // PSYS_SRC_TARGET_KEY,      llGetLinkKey(llGetLinkNum() + 1),       
             
           PSYS_PART_FLAGS, (integer)( 0         // Texture Options:     
                                | PSYS_PART_INTERP_COLOR_MASK   
                                | PSYS_PART_INTERP_SCALE_MASK   
                                | PSYS_PART_EMISSIVE_MASK   
                             // | PSYS_PART_FOLLOW_VELOCITY_MASK
                                                  // After-effect & Influence Options:
                                | PSYS_PART_WIND_MASK           
                                | PSYS_PART_BOUNCE_MASK         
                             // | PSYS_PART_FOLLOW_SRC_MASK     
                             // | PSYS_PART_TARGET_POS_MASK     
                             // | PSYS_PART_TARGET_LINEAR_MASK   
                            )
            //end of particle settings                     
        ];
       
        if ( AUTO_START ) llParticleSystem( particle_parameters );
       
    }
   
    link_message( integer sibling, integer num, string mesg, key target_key ) {
        if ( mesg != CONTROLLER_ID ) { // this message isn't for me.  Bail out.
            return;
        } else if ( num == 0 ) { // Message says to turn particles OFF:
            llParticleSystem( [ ] );
        } else if ( num == 1 ) { // Message says to turn particles ON:
            llParticleSystem( particle_parameters + target_parameters );
        } else if ( num == 2 ) { // Turn on, and remember and use the key sent us as a target:
            target_parameters = [ PSYS_SRC_TARGET_KEY, target_key ];
            llParticleSystem( particle_parameters + target_parameters );
        } else { // bad instruction number
            // do nothing.
        }           
    }
       
}


//============================= About Parameters =============================
// There are 22-ish NAMED attributes that affect a particle display.
// To customize a display you give each a VALUE.
// For example: PSYS_PART_START_COLOR is a named attribute,
// and <1.0, 0.5, 0.0> is a color VALUE (orange, in this case).
//
// As long as your 'names' and 'values' are paired up properly, they can
// be in any order!  Any you omit a pair, it reverts to a default value.

//============================= Texture Parameters =============================
//
// TEXTURE, can be an "Asset UUID" key copied from a texture
//          that you have full permissions to, or the name of
//          a texture in the prim's inventory.
//
// SCALE, (size) 0.0 to 4.0 meters wide, by 0.0 to 4.0 meters tall. (default 1x1)
//          Textures are FLAT, so the 'z' part of the vector is ignored.
//          Values smaller than 0.04x0.04 may not get rendered at all.
//          Tiny particles vanish if the viewer is not near them.
//
// BEGIN_SCALE sets particle start size. 
// END_SCALE (end size) is ignored, if the INTERP_SCALE_MASK option is disabled.
//
// COLOR, < RED, GREEN, BLUE > from <0.00,0.00,0.00> (black) to <1.00,1.00,1.00> (white/default)
// ALPHA, 1.0 = 100% visible(default), 0.0 = invisible.  Less than 0.1 might not get seen.
// START_COLOR and START_ALPHA set the color and transparency of newly created particles.
// END_COLOR and END_ALPHA are ignored, if the INTERP_COLOR_MASK option is disabled.
         
         
//============================= Production Parameters =============================
//
// BURST_PART_COUNT: quantity of particles per burst, 1 to 4096 (default 1),
//
// BURST_RATE: seconds to delay between particle bursts. 0.0 to 30.0 (default 0.1)
//
// PART_MAX_AGE: particle lifespan in seconds, 0.00 to 30.0 (default=10.0)
//               PART_MAX_AGE less than 0.5 might not be visible.
//
// The default total number of particles that can be seen is 4096, if one or more
// emitters try to create more than that, many will not be seen, and it may cause
// viewer lag.  Use as few particles as you can for your effect:
// AGE/RATE * COUNT will tell you approximately how many particles your emitter creates.
//
// SRC_MAX_AGE: emitter auto shut-off timer. 1.0 to 60.0 seconds. 0.0 = never stop. (default)


//============================= Placement Parameters =============================
//               
// PATTERN:   
//      DROP, ignores all other placement settings.
//      EXPLODE, spray particles in all directions
//      ANGLE, sprays a flat "fan" shape defined by ANGLE_BEGIN and END values
//      CONE, sprays "ring" or "cone" shapes defined by ANGLE_BEGIN and END values
//
// RADIUS:  0.0 to 50.0?  distance from emitter to create new particles
//      (RADIUS is disabled with DROP pattern and the FOLLOW_SRC & TARGET_LINEAR options)
//       
// SPEED: 0.00 to 50.0?  Sets min/max starting velocities for non-drop patterns. (default: 1.0)
//       
// ANGLE_BEGIN & END:  0.00*PI (up) to 1.00*PI (down),  (Only for ANGLE & CONE patterns)
//       (Values work much like the Sphere-prim's DIMPLE attributes.) (defaults: 0.0)
//
// OMEGA: <x,y,z> Sets how much to rotate angle/cone spray direction after
//                every burst. 0.0 to PI?  (default: <0,0,0>)

//======================== After-Effects & Influence Parameters ================
//
// ACCEL, x,y,z 0.0 to 50.0?  sets a constant force, (affects all patterns)
//          Causes particles to drift up/down or in a compass direction.
//          Use ACCEL to create the illusion of (anti-)gravity or a directional wind.
//          (ineffective with TARGET_LINEAR option)
//       
// TARGET_KEY,  "key", (requires the TARGET option be enabled). 
//       "key" can be a variety of many different things:
         // llGetOwner()
         // llGetKey() target self
         // llGetLinkKey(1) target parent prim
         // llGetLinkKey(llGetLinkNum() + 1) target next prim in link set
         //
         // WARNING: New copies of objects get new keys, you can't simply paste
         // a prim's key into your script and expect it to always work.  Visit
         // the Particle Laboratory's section on TARGETS for a variety of ways
         // to dynamically find your target's key. There are different 'best ways'
         // depending on if your target is linked to your emitter or not.


//============================= About Options =============================
//   
// Each option may be ON/ENABLED (no leading // )
// or OFF/DISABLED (by putting a // in front of it.)
// Options are combined together in a special way, (using the | symbol).
// This creates one single Parameter for PSYS_PART_FLAGS.

             
//============================= Texture Options =============================
//
// EMISSIVE: identical to "full bright" setting on prims     
//   
// FOLLOW_VELOCITY: particle texture 'tilts' towards the direction it's moving
//
// INTERP_COLOR: causes particle COLOR and ALPHA(transparency) to change over it's lifespan
//
// INTERP_SCALE: causes particle SCALE(size) to change over it's lifespan


//======================== After-Effects & Influences Options ================
//
// BOUNCE:  particles bounce up from the z-altitude of emitter, and cannot fall below it.
//
// WIND: the sim's wind will push particles around
//
// FOLLOW_SRC: makes particles move (but not rotate) if their emitter moves, (disables RADIUS)
//
// TARGET_POS: causes particles to arrive at a some target at end of of their lifespan.
//
// TARGET_LINEAR: forces particles to form into an even line from emitter to target
//                and forces a DROP-like pattern and disables effects of WIND and ACCEL



//========================================================================
//======================== USING CONTROL TEMPLATES =======================
//
// Want to control when your particles turn ON and OFF?   You can!
//
// Drop one (or more) of the CONTROL TEMPLATES from the particle laboratory
// into your object containing this script.  That's it!

// Your controls should be effective immediately.  (Some controllers can be
// adjusted and tuned, open them and read the USAGE notes to see.)
//
// One control template can control several particle templates in the
// same object.   (keep in mind that each prim can only have ONE
// particle effect active at a time).
//
// The 'particle_effect_name' value must be the same in both the control
// and particle template to work.  You can change that value and have
// a controller for one effect, and a different controller for a different
// effect in the same object.
//
