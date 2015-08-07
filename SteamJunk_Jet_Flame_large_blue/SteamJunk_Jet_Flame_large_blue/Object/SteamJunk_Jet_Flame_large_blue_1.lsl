// :CATEGORY:Particles
// :NAME:SteamJunk_Jet_Flame_large_blue
// :AUTHOR:anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:837
// :NUM:1165
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// SteamJunk_Jet_Flame_large_blue
// :CODE:
default {
    state_entry() {
        llParticleSystem(  [ 
           PSYS_SRC_TEXTURE, llGetInventoryName(INVENTORY_TEXTURE, 0), 
           PSYS_PART_START_SCALE, <15.5,15.5, 0>,  PSYS_PART_END_SCALE, <0,2.0, 0>, 
           PSYS_PART_START_COLOR, <.2,.2,1>,       PSYS_PART_END_COLOR, <.5,1,1>, 
           PSYS_PART_START_ALPHA, 1.0,            PSYS_PART_END_ALPHA, 0.0,     
         
           PSYS_SRC_BURST_PART_COUNT, 1, 
           PSYS_SRC_BURST_RATE,  0.01,  
           PSYS_PART_MAX_AGE, 3.4, 
           PSYS_SRC_MAX_AGE, 0.0,  
        
           PSYS_SRC_PATTERN, 8, // 1=DROP, 2=EXPLODE, 4=ANGLE, 8=ANGLE_CONE,
           PSYS_SRC_ACCEL, <0.0,0.0,0.0>,  
           
        // PSYS_SRC_BURST_RADIUS, 0.0,
           PSYS_SRC_BURST_SPEED_MIN, .01,   PSYS_SRC_BURST_SPEED_MAX, 3.01, 
        
           PSYS_SRC_ANGLE_BEGIN,  1*DEG_TO_RAD,        PSYS_SRC_ANGLE_END, 0*DEG_TO_RAD,  
           PSYS_SRC_OMEGA, <0,0,0>, 
        
        // PSYS_SRC_TARGET_KEY,      llGetLinkKey(llGetLinkNum() + 1),       
              
           PSYS_PART_FLAGS, ( 0      
                                | PSYS_PART_INTERP_COLOR_MASK   
                                | PSYS_PART_INTERP_SCALE_MASK   
                                | PSYS_PART_EMISSIVE_MASK   
                                | PSYS_PART_FOLLOW_VELOCITY_MASK
                             // | PSYS_PART_WIND_MASK            
                             // | PSYS_PART_BOUNCE_MASK          
                             // | PSYS_PART_FOLLOW_SRC_MASK     
                             // | PSYS_PART_TARGET_POS_MASK     
                             // | PSYS_PART_TARGET_LINEAR_MASK    
            ) ] );
    }
}


//                  (particle appearance settings)

// TEXTURE, can be an "Asset UUID" key copied from a modable texture, or the name of a texture in the prim's inventory.
// SCALE, vector's x and y can be 0.0 to 4.0.   z is ignored.  Values smaller than 0.04 might not get rendered. 
// END_SCALE requires the INTERP_SCALE_MASK
// COLOR, red,green,blue values from 0,0,0(black) to 1,1,1 (white)
// ALPHA, 0.0 = invisible, less than 0.1 may not get seen, 1.0 = solid/opaque  
// END_COLOR and END_ALPHA both require INTERP_COLOR_MASK
         
//                  (emitter controls)

// BURST_PART_COUNT  1 to 4096
// BURST_RATE 0.0 to 60.0?  # of seconds between bursts, smaller = faster  
// PART_MAX_AGE, 0.0 to 30.0, particle lifespan in seconds
// SRC_MAX_AGE - emitter auto-off interval 0.0 never times out. 1.0 to 60.0.

//                  (placement and movement settings)
                
// PATTERN,   
  //  DROP, no initial velocity, direction or distance from emitter
  //  EXPLODE, spray in all directions
  //  ANGLE, "fan" shape defined by ANGLE BEGIN and END values
  //  ANGLE_CONE, "ring" or "cone" shapes defined by ANGLE BEGIN and END values

// ACCEL, x,y,z 0.0 to 50.0?  sets a constant force, (affects all patterns)

// RADIUS  0.0 to 50.0?  distance from emitter to create new particles
        // (Useless with DROP pattern and FOLLOW_SRC option)
        
// SPEED, 0.01 to 50.0?  Sets range of starting velocities.  (Useless with DROP pattern.)
        
// ANGLE_BEGIN & END,  0.0 (up) to PI (down),  (Only useful with ANGLE patterns)

// OMEGA,  x,y,z  0.0 to PI?  Sets distance to rotate emitter nozzle between bursts
                              // (Only useful with ANGLE patterns)
        
// TARGET_KEY,  "key", (requires a TARGET option below) can be many things :
         // llGetOwner()
         // llGetKey() target self 
         // llGetLinkKey(1) target parent prim
         // llGetLinkKey(llGetLinkNum() + 1) target next prim in link set       
              
//              (on/off options that affect how particles look)

// EMISSIVE identical to "full bright" setting on prims        
// FOLLOW_VELOCITY particle texture 'tilts' towards the direction it's moving
// INTERP_COLOR causes color and alpha to change over time
// INTERP_SCALE causes particle size to change over time

//              (on/off options that affect how particles move)

// BOUNCE  particles can't go below altitude of emitter      
// WIND sim's wind will push particles around
// FOLLOW_SRC makes particles move (but not rotate) if their emitter moves, (disables RADIUS)
// TARGET_POS causes particles to home in on a target object
// TARGET_LINEAR forces a DROP pattern like behavior and disables wind.
