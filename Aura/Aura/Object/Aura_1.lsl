// :CATEGORY:Particles
// :NAME:Aura
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:59
// :NUM:86
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Aura.lsl
// :CODE:

start_effect()
{
    list params = llGetPrimitiveParams([PRIM_POINT_LIGHT]);
    vector color;
    
    integer lit = llList2Integer(params, 0);
    if(lit) {
        color = (vector) llList2String(params, 1);
    } else {
        params = llGetPrimitiveParams([PRIM_COLOR, 0]);
        color = (vector) llList2String(params, 0);
    }
    
    llTargetOmega(<0.0,0.0,1.0>, 1.0, 1.0);
llParticleSystem([PSYS_PART_FLAGS, PSYS_PART_BOUNCE_MASK | PSYS_PART_EMISSIVE_MASK | PSYS_PART_INTERP_COLOR_MASK | PSYS_PART_INTERP_SCALE_MASK,
    PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE,
    PSYS_PART_START_COLOR, color,
    PSYS_PART_START_ALPHA, 1.0,
    PSYS_PART_END_ALPHA, 0.0,
    PSYS_PART_END_COLOR, <1.0,1.0,1.0>,
    PSYS_PART_START_SCALE, <.24,.25,.21>,
    PSYS_PART_END_SCALE, <.03,.25,.1>,
    PSYS_SRC_BURST_PART_COUNT, 100,
    PSYS_PART_MAX_AGE, 2.5,
    PSYS_SRC_BURST_RATE, 0.0,
    PSYS_SRC_ACCEL, <0.0, 0.0, 0.98>,
    PSYS_SRC_BURST_SPEED_MIN, 0.0,
    PSYS_SRC_BURST_SPEED_MAX, 0.0,
    PSYS_SRC_OMEGA, <0.0, 0.0, 1.0>,
    PSYS_SRC_BURST_RADIUS, 1.0,
    PSYS_SRC_ANGLE_BEGIN, PI/2 - 0.01,
    PSYS_SRC_ANGLE_END, PI/2]);    
}

default
{
    state_entry()
    {
        start_effect();
    }
    
    on_rez(integer start_param)
    {        
        if(start_param != 0) {
            llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
            llSetPrimitiveParams([PRIM_TEMP_ON_REZ, TRUE]);
            llSetTimerEvent(10.0);
        } else {
            llSetStatus(STATUS_DIE_AT_EDGE, FALSE);
            llSetPrimitiveParams([PRIM_TEMP_ON_REZ, FALSE]);
            llSetTimerEvent(0.0);
            llWhisper(0, "Edit mode. Change the light color and touch me to change the particle color.");
        }
        start_effect();
    }    
    
    touch_start(integer param)
    {
        start_effect();
    }
    
    timer()
    {
        llDie();
    }
}
// END //
