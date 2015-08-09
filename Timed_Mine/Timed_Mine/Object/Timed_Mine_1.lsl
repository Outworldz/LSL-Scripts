// :CATEGORY:Weapons
// :NAME:Timed_Mine
// :AUTHOR:Davy Maltz
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:07
// :ID:892
// :NUM:1268
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Timed_Mine
// :CODE:
list sounds = ["888d5e97-7ca3-618a-9061-3afb85ea2e97","9dfb4ca9-52a7-e6b4-70b0-bc1d416eef74","b64b4bc4-0c66-bcb1-fbfb-d58ac09a09d3"];
integer collided;
p()
{
    llParticleSystem([  PSYS_PART_MAX_AGE,0.3,
        PSYS_PART_FLAGS, PSYS_PART_EMISSIVE_MASK|PSYS_PART_INTERP_COLOR_MASK | PSYS_PART_FOLLOW_VELOCITY_MASK,
        PSYS_PART_START_COLOR, <1.0, 1.0, 1.0>,
        PSYS_PART_END_COLOR, <1.0, 1.0, 1.0>,
        PSYS_PART_START_SCALE,<10.0, 10.0, 10.0>,
        PSYS_PART_END_SCALE,<9.0, 9.0, 9.0>, 
        PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
        PSYS_SRC_BURST_RATE, 0.01,
        PSYS_SRC_ACCEL, ZERO_VECTOR,
        PSYS_SRC_BURST_PART_COUNT,3,
        PSYS_SRC_BURST_RADIUS, 2.0,
        PSYS_SRC_BURST_SPEED_MIN, 1.0,
        PSYS_SRC_BURST_SPEED_MAX, 1.0,
        PSYS_SRC_INNERANGLE, 0.0, 
        PSYS_SRC_OUTERANGLE, 0.0,
        PSYS_SRC_OMEGA, ZERO_VECTOR,
        PSYS_SRC_MAX_AGE, 0.0,
        PSYS_SRC_TEXTURE, "e958dfac-b000-1ebb-5724-4d889b780dbb",
        PSYS_PART_START_ALPHA, 1.0,
        PSYS_PART_END_ALPHA, 0.0]);
}
triggerSounds()
{
    integer i;
    for(i=0;i<6;i++)
    {
        llTriggerSound("519bbe3a-b085-e7e1-8bdb-ca3d74171f72",1.0);
        llSleep(1.0);
    }
    integer sound = llRound(llFrand(llGetListLength(sounds)));
    if(sound == 0)
        sound = 1;
    for(i=0;i<5;i++)
        llTriggerSound(llList2String(sounds,sound),1.0);
}
default
{
    on_rez(integer start_param)
    {
        llResetScript();
    }
    state_entry()
    {
        llSetStatus(STATUS_DIE_AT_EDGE|STATUS_PHYSICS,TRUE);
    }
    collision_start(integer num_detected)
    {
        if(collided == 0)
        {
            collided = 1;
            triggerSounds();
            p();
            llSleep(1.7);
            llDie();
        }
    }
    land_collision_start(vector pos)
    {
        if(collided == 0)
        {
            collided = 1;
            triggerSounds();
            p();
            llSleep(1.7);
            llDie();
        }
    }
}
