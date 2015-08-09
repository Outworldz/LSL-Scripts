// :CATEGORY:Particles
// :NAME:SnowGlobe_Script_2
// :AUTHOR:Jposy Pendragon
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:04
// :ID:809
// :NUM:1119
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// SnowGlobe Script 2.lsl
// :CODE:
// snow globe 

key mykey;
list twinkeys;
list twinpos;
integer numtwins;
vector mypos;

default
{    
    state_entry() {
        llSetTimerEvent(5.0);
    }
           
    timer() {  
        key target=llGetKey(); 
        vector mypos = llGetPos();
         
        float pink=llFrand(1.0); 
        vector up = <0,0,(1 - llFrand(2))   >;
        llLookAt( (vector)(mypos + up), 1.0, .1);
        llParticleSystem( [
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE, 
            // _PATTERN can be: *_EXPLODE, *_DROP, *_ANGLE, *ANGLE_CONE or *_ANGLE_CONE_EMPTY
        PSYS_SRC_BURST_PART_COUNT,(integer) 5, // defined above
        PSYS_SRC_BURST_RATE,(float) .01,          // defined above
        PSYS_PART_MAX_AGE,(float) 2.5,             // defined above
        PSYS_SRC_BURST_RADIUS,(float) .1,       // How far from emitter new particles start,
        PSYS_SRC_INNERANGLE,(float) PI/2,         // aka 'spread' (0 to 2*PI), 
        PSYS_SRC_OUTERANGLE,(float) 0.0,         // aka 'tilt' (0 to 2*PI),
        //PSYS_SRC_OMEGA,(vector)(offset*0.1),
        PSYS_SRC_ACCEL,(vector) (-up*.3),  
        PSYS_SRC_BURST_SPEED_MIN,(float)0.0,  
        PSYS_SRC_BURST_SPEED_MAX,(float) 0.2,  
        PSYS_PART_START_SCALE,(vector) <.05,.05,0.0>,// Start Size, (minimum .04, max 10.0?)
        PSYS_PART_END_SCALE,(vector) <.05,.05,0>,  // End Size,  requires *_INTERP_SCALE_MASK
        PSYS_PART_START_COLOR,(vector) <1,1,1>,
        PSYS_PART_END_COLOR,(vector) <1,1,1>,
        PSYS_PART_START_ALPHA,(float) 0.5,           // startAlpha (0 to 1),
        PSYS_PART_END_ALPHA,(float) .8,              // endAlpha (0 to 1)
        //PSYS_SRC_TARGET_KEY,(key)target,// ,
            // for *_TARGET try llGetKey(), or llGetOwner(), or llDetectedKey(0) even. :)
        PSYS_SRC_TEXTURE,(string) "60ec4bc9-1a36-d9c5-b469-0fe34a8983d4",            // name of a 'texture' in emitters inventory
        //PSYS_SRC_MAX_AGE,(float) 0.0,            // turns emitter off. (0.0 = never)
        PSYS_PART_FLAGS,                    
             PSYS_PART_EMISSIVE_MASK |           // particles glow
             //PSYS_PART_BOUNCE_MASK |             // particles bounce up from emitter's 'Z' altitude
             //PSYS_PART_WIND_MASK |               // particles get blown around by wind
             PSYS_PART_FOLLOW_VELOCITY_MASK |    // particles rotate towards where they're going
             //PSYS_PART_FOLLOW_SRC_MASK |         // particles move as the emitter moves
             PSYS_PART_INTERP_COLOR_MASK |       // particles change color depending on *_END_COLOR 
             PSYS_PART_INTERP_SCALE_MASK |       // particles change size using *_END_SCALE
             PSYS_PART_TARGET_POS_MASK 
        ] );
    }
}
// END //


