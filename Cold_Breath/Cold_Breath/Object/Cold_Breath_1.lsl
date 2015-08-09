// :CATEGORY:Particles
// :NAME:Cold_Breath
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:186
// :NUM:259
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Cold_Breath
// :CODE:
default
{
    state_entry()
    {
        llSetTimerEvent(2.7);
    }
    timer()
    {
        llParticleSystem([      PSYS_PART_MAX_AGE,0.8,
                        PSYS_PART_FLAGS,1,
                        PSYS_PART_START_COLOR, <1,1,1>,
                        PSYS_PART_END_COLOR, <1,1,1>,
                        PSYS_PART_START_SCALE,<0.1,0.1,0.1>,
                        PSYS_PART_END_SCALE,<0.2,0.2,0.2>,
                        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
                        PSYS_SRC_BURST_RATE,0.1,
                        PSYS_SRC_ACCEL, 0.8 * llRot2Fwd(llGetRot()),
                        PSYS_SRC_BURST_PART_COUNT,10,
                        PSYS_SRC_BURST_RADIUS,0.02,
                        PSYS_SRC_BURST_SPEED_MIN,0.0,
                        PSYS_SRC_BURST_SPEED_MAX,0.2,
                        PSYS_SRC_TARGET_KEY,llGetOwner(),
                        PSYS_SRC_ANGLE_BEGIN,0.0,
                        PSYS_SRC_ANGLE_END,0.0,
                        PSYS_SRC_OMEGA, <0.2,0.2,0.2>,
                        PSYS_SRC_MAX_AGE, 0.2,
                    PSYS_SRC_TEXTURE, "8146459e-47a2-47ce-93d6-bac9359afa84",
                        PSYS_PART_START_ALPHA, 0.3,
                        PSYS_PART_END_ALPHA, 0.1
                        ]);
    }
}
