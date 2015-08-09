// :CATEGORY:Particles
// :NAME:Fairy_Lights
// :AUTHOR:oddball.otoole
// :CREATED:2011-03-23 17:44:02.887
// :EDITED:2013-09-18 15:38:52
// :ID:296
// :NUM:395
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Fairy_Lights
// :CODE:
startParticles()
{
    llParticleSystem([PSYS_PART_FLAGS, 0| PSYS_PART_EMISSIVE_MASK| PSYS_PART_INTERP_COLOR_MASK,
        PSYS_SRC_BURST_RATE, 0.1,
        PSYS_SRC_BURST_RADIUS, 10.0,
        PSYS_SRC_BURST_PART_COUNT, 18,
        PSYS_SRC_ANGLE_BEGIN, 0.0,
        PSYS_SRC_ANGLE_END, 3.1416,
        PSYS_SRC_OMEGA, <0.0,0.0,1.0>,
        PSYS_PART_MAX_AGE, 50.0,
        PSYS_SRC_MAX_AGE, 0.0,
        PSYS_SRC_BURST_SPEED_MIN, 0.0,
        PSYS_SRC_BURST_SPEED_MAX, 0.01,
        PSYS_SRC_TEXTURE,"",
        PSYS_PART_START_ALPHA, 1.0,
        PSYS_PART_END_ALPHA, 0.0,
        PSYS_PART_START_COLOR, <0.76,1.00,1.00>,
        PSYS_PART_END_COLOR, <0.98,0.96,0.62>,
        PSYS_PART_START_SCALE, <0.04,0.04,0.0>,
        PSYS_PART_END_SCALE, <0.3,0.3,0.3>,
        PSYS_SRC_ACCEL, <0.0,0.0,-0.01>,
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE
    ]);
}
default
{
state_entry()
    {
    
    }
    on_rez(integer start_param)
    {
    llResetScript();
    }
    touch_start(integer total_number)
    {
    startParticles();
    }
}
