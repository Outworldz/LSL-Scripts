// :CATEGORY:Fireplace
// :NAME:Fireplace
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:53
// :ID:303
// :NUM:402
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Blazing-Fireplace-Fire
// :CODE:

//*****************************************************************************//// Simple Touch-based particle script.
//
// Use: Touching the prim containing this script will turn the particle system
// on and off.
//
//*****************************************************************************

ParticleStart()
{
    llParticleSystem([
        PSYS_PART_FLAGS, 291,
        PSYS_SRC_PATTERN, 2,
        PSYS_PART_START_ALPHA, 1.00,
        PSYS_PART_END_ALPHA, 0.00,
        PSYS_PART_START_COLOR, <1.00,1.00,1.00>,
        PSYS_PART_END_COLOR, <1.00,1.00,1.00>,
        PSYS_PART_START_SCALE, <0.25,0.25,0.00>,
        PSYS_PART_END_SCALE, <1.00,1.00,0.00>,
        PSYS_PART_MAX_AGE, 0.80,
        PSYS_SRC_MAX_AGE, 0.00,
        PSYS_SRC_ACCEL, <0.00,0.00,2.00>,
        PSYS_SRC_ANGLE_BEGIN, 0.00,
        PSYS_SRC_ANGLE_END, 1.05,
        PSYS_SRC_BURST_PART_COUNT, 5,
        PSYS_SRC_BURST_RADIUS, 0.10,
        PSYS_SRC_BURST_RATE, 0.00,
        PSYS_SRC_BURST_SPEED_MIN, 0.00,
        PSYS_SRC_BURST_SPEED_MAX, 0.40,
        PSYS_SRC_OMEGA, <0.00,0.00,0.00>,
        PSYS_SRC_TEXTURE, "a96ecd50-96e1-28b4-51ec-96b3112210c0"
    ]);

}

ParticleStop()
{
    llParticleSystem([]);
}


//*****************************************************************************
//
// Default state: LSL will always start in this state.
//
// Immediately go to the 'Off' state.
//
//*****************************************************************************

default
{
    state_entry()
    {
        state Off;
    }
}


//*****************************************************************************
//
// On state: Starts the particle system when this state is entered.
//
// Transitions to the 'Off' state when this prim is touched.
//
//*****************************************************************************

state On
{
    state_entry()
    {
        ParticleStart();
    }

    touch_start(integer total_number)
    {
        state Off;
    }
}


//*****************************************************************************
//
// Off state: Stops the particle system when this state is entered.
//
// Transitions to the 'On' state when this prim is touched.
//
//*****************************************************************************

state Off
{
    state_entry()
    {
        ParticleStop();
    }

    touch_start(integer total_number)
    {
        state On;
    }
}     // end 
// CREATOR:

