// :CATEGORY:Particles
// :NAME:Lazer_Beam
// :AUTHOR:Jopsy Pendragon
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:462
// :NUM:623
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Lazer Beam.lsl
// :CODE:

// No frills particle script -- Jopsy Pendragon

default
{
    state_entry() {
        llParticleSystem( [  
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE, 
            PSYS_SRC_BURST_PART_COUNT,(integer) 4,   // adjust for beam strength,
            PSYS_SRC_BURST_RATE,(float) .05,          
            PSYS_PART_MAX_AGE,(float)  .6,            
            PSYS_SRC_BURST_SPEED_MIN,(float)1,        
            PSYS_SRC_BURST_SPEED_MAX,(float) 7.0,      
            PSYS_PART_START_SCALE,(vector) <0,.1,0>, 
            PSYS_PART_END_SCALE,(vector) <.04,.5,0>,   
            PSYS_PART_START_COLOR,(vector) <1,0,0>,  
            PSYS_PART_END_COLOR,(vector) <.2,0,0>,   
            PSYS_PART_START_ALPHA,(float)0.5,          
            PSYS_PART_END_ALPHA,(float)0.00,          
            PSYS_PART_FLAGS,
                 PSYS_PART_EMISSIVE_MASK |     
                 PSYS_PART_FOLLOW_VELOCITY_MASK |
                 PSYS_PART_FOLLOW_SRC_MASK |   
                 PSYS_PART_INTERP_SCALE_MASK                  
        ] );
    }
} 
 // END //
