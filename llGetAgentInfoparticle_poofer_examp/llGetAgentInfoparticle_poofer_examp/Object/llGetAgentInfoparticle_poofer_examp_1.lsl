// :CATEGORY:Particles
// :NAME:llGetAgentInfoparticle_poofer_examp
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:483
// :NUM:650
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// llGetAgentInfoparticle_poofer_example
// :CODE:

//\x95/\x95/\x95/\x95/\x95/\x95/\x95/\xD0/A/M/E/N/\x95/H/A/X/\x95/\x95/\x95/\x95/\x95/\x95/\x95/\x95/\x95//

//something i put together to use as a template for detecting diff AGENT INFO things
//eg usage; make particles when you walk, have different particles start when you fly etc.

key owner;
key target;
integer dChannel;

key sub;
integer info;
//Particles
integer flags;
integer glow = TRUE;
integer bounce = FALSE;
integer interpColor = TRUE;
integer interpSize = TRUE;
integer wind = FALSE;
integer followSource = FALSE;
integer followVel = TRUE;

flying(){
    //llSay(0,"flying");
    flags = 0;
    if (target == "me") target = owner;
    if (target == "object") target = llGetKey();
    if (glow) flags = flags | PSYS_PART_EMISSIVE_MASK;
    if (bounce) flags = flags | PSYS_PART_BOUNCE_MASK;
    if (interpColor) flags = flags | PSYS_PART_INTERP_COLOR_MASK;
    if (interpSize) flags = flags | PSYS_PART_INTERP_SCALE_MASK;
    if (wind) flags = flags | PSYS_PART_WIND_MASK;
    if (followSource) flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
    if (followVel) flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target != "") flags = flags | PSYS_PART_TARGET_POS_MASK;
    llParticleSystem([  PSYS_PART_MAX_AGE,                         0.85,//Particle age
                        PSYS_PART_FLAGS,                          flags,//Flags^
                        PSYS_SRC_PATTERN,      PSYS_SRC_PATTERN_EXPLODE,//Particle pattern
                        PSYS_SRC_BURST_RATE,                       0.00,//Burst rate/how fast to emitt
                        PSYS_SRC_ACCEL,                   <0.0,0.0,0.0>,//Push <X,Y,X>
                        PSYS_SRC_BURST_PART_COUNT,                   66,//How many to emitt
                        PSYS_SRC_TARGET_KEY,                     target,//Particle target
                        PSYS_SRC_INNERANGLE,                       1.55,//Inner angle
                        PSYS_SRC_OUTERANGLE,                       1.54,//Outer angle
                        PSYS_SRC_BURST_SPEED_MIN,                  0.01,//Min Speed
                        PSYS_SRC_BURST_SPEED_MAX,                  0.10,//Max Speed
                        PSYS_SRC_OMEGA,                   <0.0,0.0,0.0>,//Rotation
                        PSYS_SRC_TEXTURE,"34d7dc0f-ca85-402f-8a40-0ded9cdf4f5b",//Particle texture
                        PSYS_SRC_MAX_AGE,                           0.0,//How long to wait before stopping
                        PSYS_SRC_BURST_RADIUS,                     4.50,//how far to begin emitting
                        PSYS_PART_START_COLOR,         <0.55,0.75,1.55>,//Starting color
                        PSYS_PART_END_COLOR,           <0.01,0.01,0.01>,//Ending color
                        PSYS_PART_START_SCALE,         <0.04,0.04,0.04>,//Start size
                        PSYS_PART_END_SCALE,           <0.05,1.55,0.05>,//End size
                        PSYS_PART_START_ALPHA,                      1.0,//Starting visibility
                        PSYS_PART_END_ALPHA,                        0.0//Ending visibility
                        ]);
}
/////////////////////////////////
walking(){
     //llSay(0,"walking");
     llParticleSystem([]);
}
////////////////////////////////
away(){
    //llSay(0,"afk");
    flags = 0;
    if (target == "me") target = owner;
    if (target == "object") target = llGetKey();
    if (glow) flags = flags | PSYS_PART_EMISSIVE_MASK;
    if (bounce) flags = flags | PSYS_PART_BOUNCE_MASK;
    if (interpColor) flags = flags | PSYS_PART_INTERP_COLOR_MASK;
    if (interpSize) flags = flags | PSYS_PART_INTERP_SCALE_MASK;
    if (wind) flags = flags | PSYS_PART_WIND_MASK;
    if (followSource) flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
    if (followVel) flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target != "") flags = flags | PSYS_PART_TARGET_POS_MASK;
    llParticleSystem([  PSYS_PART_MAX_AGE,                         10.0,//Particle age
                        PSYS_PART_FLAGS,                          flags,//Flags^
                        PSYS_SRC_PATTERN,      PSYS_SRC_PATTERN_EXPLODE,//Particle pattern
                        PSYS_SRC_BURST_RATE,                       0.00,//Burst rate/how fast to emitt
                        PSYS_SRC_ACCEL,                  <0.0,0.0,0.47>,//Push <X,Y,X>
                        PSYS_SRC_BURST_PART_COUNT,                   66,//How many to emitt
                        PSYS_SRC_TARGET_KEY,                     target,//Particle target
                        PSYS_SRC_INNERANGLE,                       1.55,//Inner angle
                        PSYS_SRC_OUTERANGLE,                       1.54,//Outer angle
                        PSYS_SRC_BURST_SPEED_MIN,                 0.001,//Min Speed
                        PSYS_SRC_BURST_SPEED_MAX,                 0.001,//Max Speed
                        PSYS_SRC_OMEGA,                   <0.0,0.0,0.0>,//Rotation
                        PSYS_SRC_TEXTURE,"9b0f8485-3b11-a9a3-7d16-3fccbcb2d7c0",//Particle texture
                        PSYS_SRC_MAX_AGE,                           0.0,//How long to wait before stopping
                        PSYS_SRC_BURST_RADIUS,                     2.50,//how far to begin emitting
                        PSYS_PART_START_COLOR,         <1.00,1.00,1.00>,//Starting color
                        PSYS_PART_END_COLOR,           <0.15,0.15,0.15>,//Ending color
                        PSYS_PART_START_SCALE,         <0.04,0.04,0.04>,//Start size
                        PSYS_PART_END_SCALE,           <2.22,2.22,2.22>,//End size
                        PSYS_PART_START_ALPHA,                      1.0,//Starting visibility
                        PSYS_PART_END_ALPHA,                        0.0//Ending visibility
                        ]);
}
////////////////////////////////
nothing(){
     //llSay(0,"Idle");
    flags = 0;
    if (target == "me") target = owner;
    if (target == "object") target = llGetKey();
    if (glow) flags = flags | PSYS_PART_EMISSIVE_MASK;
    if (bounce) flags = flags | PSYS_PART_BOUNCE_MASK;
    if (interpColor) flags = flags | PSYS_PART_INTERP_COLOR_MASK;
    if (interpSize) flags = flags | PSYS_PART_INTERP_SCALE_MASK;
    if (wind) flags = flags | PSYS_PART_WIND_MASK;
    if (followSource) flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
    if (followVel) flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target != "") flags = flags | PSYS_PART_TARGET_POS_MASK;
    llParticleSystem([  PSYS_PART_MAX_AGE,                         2.25,//Particle age
                        PSYS_PART_FLAGS,                          flags,//Flags^
                        PSYS_SRC_PATTERN,      PSYS_SRC_PATTERN_EXPLODE,//Particle pattern
                        PSYS_SRC_BURST_RATE,                       0.00,//Burst rate/how fast to emitt
                        PSYS_SRC_ACCEL,                  <0.0,0.0,0.47>,//Push <X,Y,X>
                        PSYS_SRC_BURST_PART_COUNT,                   66,//How many to emitt
                        PSYS_SRC_TARGET_KEY,                     target,//Particle target
                        PSYS_SRC_INNERANGLE,                       1.55,//Inner angle
                        PSYS_SRC_OUTERANGLE,                       1.54,//Outer angle
                        PSYS_SRC_BURST_SPEED_MIN,                  0.01,//Min Speed
                        PSYS_SRC_BURST_SPEED_MAX,                  0.10,//Max Speed
                        PSYS_SRC_OMEGA,                   <0.0,0.0,0.0>,//Rotation
                        PSYS_SRC_TEXTURE,"b85073b6-d83f-43a3-9a89-cf882b239488",//Particle texture
                        PSYS_SRC_MAX_AGE,                           0.0,//How long to wait before stopping
                        PSYS_SRC_BURST_RADIUS,                     0.50,//how far to begin emitting
                        PSYS_PART_START_COLOR,         <0.00,0.00,0.00>,//Starting color
                        PSYS_PART_END_COLOR,           <0.15,0.15,0.15>,//Ending color
                        PSYS_PART_START_SCALE,         <0.55,0.55,0.55>,//Start size
                        PSYS_PART_END_SCALE,           <0.04,2.55,0.04>,//End size
                        PSYS_PART_START_ALPHA,                      1.0,//Starting visibility
                        PSYS_PART_END_ALPHA,                        0.0//Ending visibility
                        ]);
}

default{
    state_entry() {
        dChannel = 0;
        target = "";
        owner = llGetOwner();
        llListen(dChannel,"",owner,"");//listens in public chat
        llSetTimerEvent(0.2);
    }
//
    on_rez(integer tot){
        llOwnerSay("Say on channel 1 \"stop\" & \"start\" for related effects.\n(eg; /1 stop    .. or /1 start)"); 
    }
//
    listen(integer number, string name, key id, string m){
        if (m=="stop"){
            llSetTimerEvent(0.0);
            llParticleSystem([]);
        }
        else if (m=="start"){
            llSetTimerEvent(0.1);
        }
    }
//
    timer(){
        integer flying     = llGetAgentInfo(owner) & AGENT_FLYING;
        integer walking    = llGetAgentInfo(owner) & AGENT_WALKING;
        integer away       = llGetAgentInfo(owner) & AGENT_AWAY;
        if (flying ){
            flying();
        }
        else if (walking ){
            walking();
        }
        else if (away ){
            away();
        }
        else{
            nothing();
        }
    } 
//
    changed(integer change){
        if(change & CHANGED_OWNER){
            llResetScript();
        }
    }
//
} 
