// :CATEGORY:Particles
// :NAME:Dark_Footiesteps
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:218
// :NUM:294
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Dark Footiesteps.lsl
// :CODE:

//  To use this script, remove the // from the lines starting with PSYS_
//  for the options/effects you wish to use.

default
{
    state_entry() {
        
        // set your RATE, AGE and COUNT values here, for safety checking
        
        float   rate  =0.01 ;  // The delay between bursts of particles, in seconds
        float   age   =5.0 ;  // How long each particle lives, in seconds
        integer count =1 ;    // How many particles get created per burst
        
        if ( rate < .005 ) rate = .005; // prevents divide by 0 errors on next check
        if ( ((age/rate)*count) > 3000 ) 
        {
            llInstantMessage( llGetOwner(), "WARNING: Your (AGE/RATE)*COUNT is very high.");
            return;
        }  
                 
        llParticleSystem( [
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_DROP, 
            // _PATTERN can be: *_EXPLODE, *_DROP, *_ANGLE, *ANGLE_CONE or *_ANGLE_CONE_EMPTY
        PSYS_SRC_BURST_PART_COUNT,(integer) count, // defined above
        PSYS_SRC_BURST_RATE,(float) rate,          // defined above
        PSYS_PART_MAX_AGE,(float) age,             // defined above
        //PSYS_SRC_BURST_RADIUS,(float) 0.0,       // How far from emitter new particles start,
        //PSYS_SRC_INNERANGLE,(float) 0.0,         // aka 'spread' (0 to 2*PI), 
        //PSYS_SRC_OUTERANGLE,(float) 0.0,         // aka 'tilt' (0(up), PI(down) to 2*PI),
        //PSYS_SRC_OMEGA,(vector) <0,0,0>,         // how much to rotate around x,y,z per burst,
        //PSYS_SRC_ACCEL,(vector) <0,0,1>,         // aka gravity or push, ie <0,0,-1.0> = down
        PSYS_SRC_BURST_SPEED_MIN,(float) 0.1,    // Minimum velocity for new particles
        //PSYS_SRC_BURST_SPEED_MAX,(float) 1.0,    // Maximum velocity for new particles
        PSYS_PART_START_SCALE,(vector) <.63,.85,0>,// Start Size, (minimum .04, max 10.0?)
        PSYS_PART_END_SCALE,(vector) <.35,.41,0>,  // End Size,  requires *_INTERP_SCALE_MASK
        PSYS_PART_START_COLOR,(vector) <0,0,0>,  // Start Color, (RGB, 0 to 1)
        //PSYS_PART_END_COLOR,(vector) <.5,.5,0>,   // EndC olor, requires *_INTERP_COLOR_MASK
        PSYS_PART_START_ALPHA,(float) 1.0,         // startAlpha (0 to 1),
        //PSYS_PART_END_ALPHA,(float) 1.0,             // endAlpha (0 to 1)
        PSYS_SRC_TARGET_KEY,(key) llGetKey(),  // key of a target, requires *_TARGET_POS_MASK
            // for *_TARGET try llGetKey(), or llGetOwner(), or llDetectedKey(0) even. :)
        //PSYS_SRC_TEXTURE,(string) "",            // name of a 'texture' in emitters inventory
        PSYS_SRC_MAX_AGE,(float) 15.0*60.0,            // turns emitter off after 15 minutes. (0.0 = never)
        PSYS_PART_FLAGS,                    
             //PSYS_PART_EMISSIVE_MASK |           // particles glow
             //PSYS_PART_BOUNCE_MASK |             // particles bounce up from emitter's 'Z' altitude
             //PSYS_PART_WIND_MASK |               // particles get blown around by wind
             PSYS_PART_FOLLOW_VELOCITY_MASK |    // particles rotate towards where they're going
             //PSYS_PART_FOLLOW_SRC_MASK |         // particles move as the emitter moves
             //PSYS_PART_INTERP_COLOR_MASK |       // particles change color depending on *_END_COLOR 
             PSYS_PART_INTERP_SCALE_MASK |       // particles change size using *_END_SCALE
             PSYS_PART_TARGET_POS_MASK |         // particles home on *_TARGET key
         0
        ] );
    }
    
    touch_start(integer num) {
        llResetScript(); // touch prim to restart particles after they time out
    }
    
    
}
// END //
