// :CATEGORY:Signs
// :NAME:Particle_Sign
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:611
// :NUM:835
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Particle_Sign
// :CODE:
key texture = "Texture key here";
default
{
    state_entry()
    {
        llParticleSystem([ PSYS_PART_FLAGS, PSYS_PART_EMISSIVE_MASK| PSYS_PART_INTERP_COLOR_MASK|PSYS_PART_INTERP_SCALE_MASK|PSYS_PART_FOLLOW_SRC_MASK,
                  PSYS_PART_START_COLOR, <1,1,1>,
                  PSYS_PART_END_COLOR, <1,1,1>,
                  PSYS_SRC_BURST_RATE, 0.1,
                  PSYS_SRC_TEXTURE,texture,
                  PSYS_SRC_BURST_RADIUS, 1.0,
                  PSYS_SRC_BURST_PART_COUNT, 1,
                  PSYS_PART_START_ALPHA, 1.0,
                  PSYS_PART_START_SCALE, <2,2,2>,
                  PSYS_PART_END_SCALE, <2,2,2>,
                  PSYS_PART_END_ALPHA, 1.0,
                  PSYS_SRC_ACCEL, <0,0,0>,
                  PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_DROP,
                  PSYS_PART_MAX_AGE, 3.0
                  ]);
    }
}
