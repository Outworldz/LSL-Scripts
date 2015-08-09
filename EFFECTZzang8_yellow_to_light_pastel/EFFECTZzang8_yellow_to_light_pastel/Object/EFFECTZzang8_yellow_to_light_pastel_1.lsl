// :CATEGORY:Fireworks
// :NAME:EFFECTZzang8_yellow_to_light_pastel
// :AUTHOR:Ama Omega
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:273
// :NUM:365
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// [EFFECT]Zzang8 yellow to light pastel orange.lsl
// :CODE:

1// Particle Script 0.3
// Created by Ama Omega
// 10-10-2003

integer glow = TRUE;
integer bounce = FALSE;
integer interpColor = TRUE;
integer interpSize = TRUE;
integer wind = FALSE;
integer followSource = FALSE;
integer followVel = TRUE;

integer pattern = PSYS_SRC_PATTERN_EXPLODE;

key target = "";

float age = 1;
float maxSpeed = 0.1;
float minSpeed = 0.1;
string texture;
float startAlpha = 10.6;
float endAlpha = 0.05;
vector startColor = <.66,4,.22>;
vector endColor = <.66,.4,.22>;
vector startSize = <.1,.1,0>;
vector endSize = <.4,.4,0>;
vector push = <0,0,1>;

float rate = 0.0;
float radius = 0.01;
integer count = 20; 
float outerAngle = 0;
float innerAngle = 1.55;
vector omega = <0,0,0>;
float life = 0;

integer flags;

updateParticles() {
    flags = 0;
    if (target == "owner") target = llGetOwner();
    if (target == "self") target = llGetKey();
    if (glow) flags = flags | PSYS_PART_EMISSIVE_MASK;
    if (bounce) flags = flags | PSYS_PART_BOUNCE_MASK;
    if (interpColor) flags = flags | PSYS_PART_INTERP_COLOR_MASK;
    if (interpSize) flags = flags | PSYS_PART_INTERP_SCALE_MASK;
    if (wind) flags = flags | PSYS_PART_WIND_MASK;
    if (followSource) flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
    if (followVel) flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target != "") flags = flags | PSYS_PART_TARGET_POS_MASK;

    llParticleSystem([  PSYS_PART_MAX_AGE,age,
                        PSYS_PART_FLAGS,flags,
                        PSYS_PART_START_COLOR, startColor,
                        PSYS_PART_END_COLOR, endColor,
                        PSYS_PART_START_SCALE,startSize,
                        PSYS_PART_END_SCALE,endSize, 
                        PSYS_SRC_PATTERN, pattern,
                        PSYS_SRC_BURST_RATE,rate,
                        PSYS_SRC_ACCEL, push,
                        PSYS_SRC_BURST_PART_COUNT,count,
                        PSYS_SRC_BURST_RADIUS,radius,
                        PSYS_SRC_BURST_SPEED_MIN,minSpeed,
                        PSYS_SRC_BURST_SPEED_MAX,maxSpeed,
                        PSYS_SRC_TARGET_KEY,target,
                        PSYS_SRC_INNERANGLE,innerAngle, 
                        PSYS_SRC_OUTERANGLE,outerAngle,
                        PSYS_SRC_OMEGA, omega,
                        PSYS_SRC_MAX_AGE, life,
                        PSYS_SRC_TEXTURE, texture,
                        PSYS_PART_START_ALPHA, startAlpha,
                        PSYS_PART_END_ALPHA, endAlpha
                            ]);
}

default {
    state_entry() {
        updateParticles();
    }
}// END //
