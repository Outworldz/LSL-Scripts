// :CATEGORY:Particles
// :NAME:ziphren_pixie_sparkles_blue
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:11
// :ID:991
// :NUM:1486
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// ziphren pixie sparkles blue.lsl
// :CODE:

particlesOn()
{
    integer flags = 0;
    flags = flags | PSYS_PART_EMISSIVE_MASK | PSYS_PART_INTERP_COLOR_MASK;
    flags = flags | PSYS_PART_WIND_MASK | PSYS_PART_FOLLOW_SRC_MASK;
    flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;

    llParticleSystem([  PSYS_PART_MAX_AGE, 10.5,
                        PSYS_PART_FLAGS, flags,
                        PSYS_PART_START_COLOR, <0.45,1,1>,
                        PSYS_PART_END_COLOR, <0.45,1,1>,
                        PSYS_PART_START_SCALE, <0.3,0.3,0.3>,
                        PSYS_PART_END_SCALE, <0.3,0.3,0.3>, 
                        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE,
                        PSYS_SRC_BURST_RATE, 2.6,
                        PSYS_SRC_ACCEL, <0,1.0,0>,
                        PSYS_SRC_BURST_PART_COUNT, 31,
                        PSYS_SRC_BURST_SPEED_MIN, 0.05,
                        PSYS_SRC_BURST_SPEED_MAX, 2.0,
                        PSYS_SRC_INNERANGLE, 0.5, 
                        PSYS_SRC_OUTERANGLE, 0.0,
                        PSYS_SRC_OMEGA, <0,0,0>,
                        PSYS_PART_START_ALPHA, 1.0,
                        PSYS_PART_END_ALPHA, 0.25
                        ]);
}

particlesOff()
{
    llParticleSystem([]);
}

default
{
    state_entry()
    {
        particlesOn();
    }
}// END //
