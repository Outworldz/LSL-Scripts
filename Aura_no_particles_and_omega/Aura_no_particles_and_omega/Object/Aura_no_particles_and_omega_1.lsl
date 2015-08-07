// :CATEGORY:Particles
// :NAME:Aura_no_particles_and_omega
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:60
// :NUM:87
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Aura (no particles and omega).lsl
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
    
    // TODO: particles?
}

default
{
    state_entry()
    {
        start_effect();
    }
    
    on_rez(integer start_param)
    {        
        llSetStatus(STATUS_DIE_AT_EDGE, TRUE);
        if(start_param != 0) {
            llSetPrimitiveParams([PRIM_TEMP_ON_REZ, TRUE]);
            llSetTimerEvent(10.0);
        } else {
            llSetPrimitiveParams([PRIM_TEMP_ON_REZ, FALSE]);
            llSetTimerEvent(0.0);
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
