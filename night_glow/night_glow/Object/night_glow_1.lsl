// :CATEGORY:Light
// :NAME:night_glow
// :AUTHOR:Jopsy Pendragon
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:554
// :NUM:758
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// night glow.lsl
// :CODE:

// No Frills Particle Script & customizations- by Jopsy Pendragon

default
{
    state_entry() {
        llSetTimerEvent(1);
    }
    
    timer() { 
        llSetTimerEvent(360);
        vector pos = llGetSunDirection();
        if ( pos.z > 0 ) llParticleSystem( [ ] );
        else llParticleSystem( [
                PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_DROP,   // _PATTERN can be: *_EXPLODE, *_DROP
                PSYS_SRC_BURST_PART_COUNT,(integer) 1, // define above
                PSYS_SRC_BURST_RATE,(float) 1,          // define above
                PSYS_PART_MAX_AGE,(float) 20,             // define above
                PSYS_SRC_ACCEL,(vector) <0,0,0>,           // aka gravity or push, ie <0,0,-1.0> = down
                PSYS_SRC_BURST_SPEED_MIN,(float) 0.0,      // Minimum velocity for new particles
                PSYS_SRC_BURST_SPEED_MAX,(float) 0.0,      // Maximum velocity for new particles
                PSYS_PART_START_SCALE,(vector) <.75,.75,.75>,  // Start Size, (minimum .04, max 10.0?)
                PSYS_PART_END_SCALE,(vector) <.75,.75,.75>,  // Start Size, (minimum .04, max 10.0?)
                PSYS_PART_START_COLOR,(vector) <1,1,.85>,    // Start Color, (RGB, 0 to 1)
                PSYS_PART_START_ALPHA, (float) 0.1,
                PSYS_PART_END_ALPHA,(float) 0.001,
                PSYS_SRC_MAX_AGE,(float) 0,             // turns emitter off after 5 minutes. (0.0 = never)
                PSYS_PART_FLAGS,                    
                  PSYS_PART_EMISSIVE_MASK |             // particles glow
                  //PSYS_PART_BOUNCE_MASK |             // particles bounce up from emitter's 'Z' altitude
                  //PSYS_PART_WIND_MASK |               // particles get blown around by wind
                  PSYS_PART_INTERP_SCALE_MASK |
                     0
            ] );
    }    
}
// END //
