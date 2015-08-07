// :CATEGORY:Particles
// :NAME:Make_Snow
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:57
// :ID:502
// :NUM:672
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Make_Snow
// :CODE:
// There are a few tweaks you can make to this commented below

integer flag = FALSE;

on()
{
    llParticleSystem( [
PSYS_PART_FLAGS, 0,
PSYS_PART_START_COLOR, <3.10000, 2.30000, 1.70000>,
PSYS_PART_END_COLOR, <-0.10000, -0.60000, -1.70000>,
PSYS_PART_START_SCALE, <0.050000, 0.05000, 0.00000>,
PSYS_PART_END_SCALE, <0.00000, 0.00000, 0.00000>,
PSYS_SRC_PATTERN, 8,
PSYS_SRC_BURST_RATE, 0.000000,
PSYS_SRC_ACCEL, <0.00000, 0.00000, -0.40000>,
PSYS_SRC_BURST_PART_COUNT, 10,                  // increase for more snow
PSYS_SRC_BURST_RADIUS, 0.000000,
PSYS_SRC_BURST_SPEED_MIN, 0.000000,
PSYS_SRC_BURST_SPEED_MAX, 0.300000,             // increase for longer distance
PSYS_SRC_TARGET_KEY, (key)"",
PSYS_SRC_ANGLE_BEGIN, 3.141593,
PSYS_SRC_ANGLE_END, 6.283185,
PSYS_SRC_OMEGA, <0.00000, 0.10000, 0.00000>,
PSYS_SRC_MAX_AGE, 0.00000,
PSYS_SRC_TEXTURE, "99214e66-0e50-f8b8-142b-9a0b82a480a3",  // change this to any texture name that is also in the prim, or use the UUID. If you use the UUID and want to gice it to others, make sure the texture in your inventory has copy on it.
PSYS_PART_START_ALPHA, 0.300000,        // increase for less transparent snow
PSYS_PART_END_ALPHA, 0.00000
                          ] );

}

default
{
    state_entry()
    {
        on();
    }

    
    on_rez(integer prim)
    {
        llResetScript();
    }
}

