// :CATEGORY:Blue Whale
// :NAME:BlueWhale
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:49
// :ID:107
// :NUM:146
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// water splash
// :CODE:

    float maxsysage = 0.0;
    float maxspeed = 0.3;
    float minspeed = 0.15;
    float burstrad = 0.0;
    integer burstcount = 20;
    float burstrate = 0.01;
    float outangle = 0.075;
    float inangle = 0;
    vector omega = <0.0,0.0,0.0>;
    float startalph = 0.75;
    float endalph = 0.015;
    vector startscale = <2.0,2.0,2.0>;
    vector endscale = <4.0,4.0,4.0>;
    float maxage = 1.7;
    vector accel = <0.0, 0.0, 1.0>;
    string texture = "";

vector pos;
vector vel;
vector up;
float ground = 0.0;
float water = 0.0;
float height = 0.0;
float occilation = 1.25;
float start_mult = 0.1;
float rad;
integer occilate = TRUE;
integer started = FALSE;

Particles(integer part_on)
{
    maxage = 0.001;
    if (!part_on) jump particles;
    vel = llGetVel() * 0.2;
    ground = llGround(vel);
    water = llWater(vel);
    if (ground < water) {
        maxspeed = 2.5;
        minspeed = 1.25;
        occilation = 2.0;
        endscale = <3.0,3.0,3.0>;
        maxage = 2.0;
        ground = water;
        texture = "7f70a931-6300-8dbc-caca-8b09a9c2cf11";
    } else {
        maxspeed = 1.75;
        minspeed = 0.875;
        occilation = 1.25;
        endscale = <4.0,4.0,4.0>;
        maxage = 1.75;
        texture = "Water Particle - Mist";
    }
    pos = llGetPos() + vel;
    up = llRot2Up(llGetRot());
    height = pos.z - ground - 0.5;
    height += (1.0 - up.z) * height;
    if (height < 6.0 && height > -1.0) {
        rad = 1.5 + (occilate * occilation);
        outangle = PI - llAtan2(rad, height);
        inangle = outangle + 0.15;
        burstrad = rad / llSin(outangle);
        startalph = ((llFabs(height) / -8.57) + 0.8 - (!occilate * 0.15)) * start_mult;
        endalph = ((llFabs(height) / -200.0) + 0.04) * start_mult;
        maxsysage = 0.0;
        part_on = TRUE;
    } else {
        maxsysage = 0.01;
        part_on = FALSE;
    }
    
    @particles;
    //llParticleSystem([]);
    llParticleSystem([PSYS_PART_FLAGS,
            PSYS_PART_INTERP_COLOR_MASK |
            PSYS_PART_INTERP_SCALE_MASK |
            //PSYS_PART_FOLLOW_VELOCITY_MASK |
            PSYS_PART_WIND_MASK,
            PSYS_SRC_PATTERN,
            PSYS_SRC_PATTERN_ANGLE_CONE,
            PSYS_PART_START_COLOR, <1.0, 1.0, 1.0>,
            PSYS_PART_START_ALPHA, startalph,
            PSYS_PART_END_COLOR, <1.0, 1.0, 1.0>,
            PSYS_PART_END_ALPHA, endalph,
            PSYS_PART_START_SCALE, startscale,
            PSYS_PART_END_SCALE, endscale,
            PSYS_PART_MAX_AGE, maxage,
            PSYS_SRC_ACCEL, accel,
            PSYS_SRC_TEXTURE, texture,
            PSYS_SRC_BURST_RATE, burstrate,
            PSYS_SRC_ANGLE_BEGIN, inangle,
            PSYS_SRC_ANGLE_END, outangle,
            PSYS_SRC_BURST_PART_COUNT, burstcount,
            PSYS_SRC_BURST_RADIUS, burstrad,
            PSYS_SRC_BURST_SPEED_MIN, minspeed,
            PSYS_SRC_BURST_SPEED_MAX, maxspeed,
            PSYS_SRC_MAX_AGE, maxsysage,
            PSYS_SRC_OMEGA, omega
            ]);
    
    if (!part_on) {
        llParticleSystem([]);
    } else {
        if (started) {
            if (start_mult < 1.0) {
                start_mult += 0.075;
            }
        } else {
            if (start_mult > 0.0) {
                start_mult -= 0.05;
            } else {
                llSetTimerEvent(0.0);
                llParticleSystem([]);
            }
        }
        occilate = !occilate;
    }
}

default
{
    state_entry()
    {
        
        llSetTimerEvent(0.0);
        Particles(FALSE);
    }
    
    touch_start(integer n)
    {
        started = TRUE;
        start_mult = 0.1;
        llSetTimerEvent(0.01);
        
    }
    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "on") {
            started = TRUE;
            start_mult = 0.1;
            llSetTimerEvent(0.01);
        } else if (str == "off") {
            started = FALSE;
            llParticleSystem([]);
            Particles(FALSE);
        }
    }

    timer()
    {
        Particles(TRUE);
    }
}


