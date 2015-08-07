// :CATEGORY:Lighting
// :NAME:lamptouch_very_slow_particle
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:452
// :NUM:608
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// lamptouch -very slow particle, will change prim to light_wood.lsl
// :CODE:

integer on=FALSE; 

default 
{ 
    touch_start(integer total_number) 
    { 
       if(on==TRUE) 
        {
             llParticleSystem([]);
             llSetPrimitiveParams([PRIM_MATERIAL, PRIM_MATERIAL_WOOD]); 
             on=FALSE; 
         } 

       else 
        { 
        llParticleSystem([]);
        llParticleSystem([
        PSYS_PART_FLAGS, PSYS_PART_INTERP_COLOR_MASK | PSYS_PART_INTERP_SCALE_MASK | PSYS_PART_FOLLOW_SRC_MASK | PSYS_PART_EMISSIVE_MASK,
    PSYS_SRC_ACCEL, <0,0,0>,
    PSYS_PART_START_SCALE, <2.0,2.0,2.0>,
    PSYS_PART_END_SCALE, <2.0,2.0,2.0>,
    PSYS_PART_START_COLOR, <255,255,0>,
    PSYS_PART_END_COLOR, <1,1,1>,
    PSYS_PART_START_ALPHA, 0.02,
    PSYS_PART_END_ALPHA, 0.02,
    PSYS_PART_MAX_AGE, 12.0,
    PSYS_SRC_BURST_RATE, 0.1,
    PSYS_SRC_BURST_PART_COUNT, 1,
    PSYS_SRC_BURST_RADIUS, 1.0,
    PSYS_SRC_BURST_SPEED_MAX, 0.01,
    PSYS_SRC_BURST_SPEED_MIN, 0.01,
    PSYS_SRC_INNERANGLE, 0.54,
    PSYS_SRC_OUTERANGLE, 0.54,
    PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE
    ]); 
             llSetPrimitiveParams([PRIM_MATERIAL, PRIM_MATERIAL_LIGHT]); 
             on=TRUE; 
         } 
       
    } 
} 
// END //
