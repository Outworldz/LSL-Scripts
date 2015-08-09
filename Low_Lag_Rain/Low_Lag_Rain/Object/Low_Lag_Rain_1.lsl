// :CATEGORY:Particles
// :NAME:Low_Lag_Rain
// :AUTHOR:oddball.otoole
// :CREATED:2012-09-29 14:05:07.557
// :EDITED:2013-09-18 15:38:56
// :ID:497
// :NUM:665
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Copy and paste the following script in a new script. Put it in a prim.// // Set transparency of the prim to 100%, and make the prim phantom.// // After checking if the script works (It should rain), edit the prim again, and remove the script. The prim should continue to rain, even if you copy it.
// :CODE:
default
{
    state_entry()
    {
        llParticleSystem([
            PSYS_PART_FLAGS,( 0 
                |PSYS_PART_WIND_MASK

                |PSYS_PART_FOLLOW_VELOCITY_MASK ), 
            PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE ,
            PSYS_PART_START_ALPHA,0.8,
            PSYS_PART_END_ALPHA,1,
            PSYS_PART_START_COLOR,<0.8,0.8,0.8> ,
            PSYS_PART_END_COLOR,<1,1,1> ,
            PSYS_PART_START_SCALE,<4,4,0>,
            PSYS_PART_END_SCALE,<4,4,0>,
            PSYS_PART_MAX_AGE,4.0,
            PSYS_SRC_MAX_AGE,0,
            PSYS_SRC_ACCEL,<0.10,-0.5,-5>,
            PSYS_SRC_BURST_PART_COUNT,2,
            PSYS_SRC_BURST_RADIUS,10,
            PSYS_SRC_BURST_RATE,0.015,
            PSYS_SRC_BURST_SPEED_MIN,0,
            PSYS_SRC_BURST_SPEED_MAX,0.05,
            PSYS_SRC_ANGLE_BEGIN,0,
            PSYS_SRC_ANGLE_END,0,
            PSYS_SRC_OMEGA,<0,0,0>,
            PSYS_SRC_TEXTURE, (key)"58fdbb11-e8d4-acca-68a3-bbe8a4f27a23",
            PSYS_SRC_TARGET_KEY, (key)"00000000-0000-0000-0000-000000000000"
         ]);
    }
}
