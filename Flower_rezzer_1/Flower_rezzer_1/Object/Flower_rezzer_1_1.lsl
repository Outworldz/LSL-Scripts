// :CATEGORY:Particles
// :NAME:Flower_rezzer_1
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:327
// :NUM:440
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Flower rezzer 1.lsl
// :CODE:


float MAX_RADIUS = 2.5;
float RADIUS_INTERVAL = 0.5;

// Modified values
integer IS_ON = FALSE;
float RADIUS = 2;
string TEXTURE = "f42bcc2b-20c8-9df7-cf1c-69566e377fd8";

garden() {
llParticleSystem([
PSYS_PART_FLAGS, 0 | PSYS_PART_EMISSIVE_MASK | 
PSYS_PART_INTERP_COLOR_MASK | PSYS_PART_INTERP_SCALE_MASK,
PSYS_SRC_PATTERN,PSYS_SRC_PATTERN_ANGLE_CONE,

// Texture / Size / Alpha / Color
PSYS_SRC_TEXTURE, "ground_vegetation_004" ,
PSYS_PART_START_SCALE,<0.2000, 0.2000, 0.0000>,
PSYS_PART_END_SCALE,<0.5000, 0.5000, 0.0000>,
PSYS_PART_START_ALPHA,0.000000,
PSYS_PART_END_ALPHA,1.000000,
PSYS_PART_START_COLOR, <1.0,1.0,1.0>,
PSYS_PART_END_COLOR, <1.0,1.0,1.0>, 

// Flow
PSYS_PART_MAX_AGE,1000.0000,
PSYS_SRC_BURST_RATE,1.000000,
PSYS_SRC_BURST_PART_COUNT,1,
PSYS_SRC_MAX_AGE,0.000000,

// Rez position
PSYS_SRC_BURST_RADIUS,RADIUS,
PSYS_SRC_INNERANGLE,1.550000,
PSYS_SRC_OUTERANGLE,1.550000,
PSYS_SRC_OMEGA,<0.00000, 0.00000, 4>, 
PSYS_SRC_BURST_SPEED_MIN,0.000000,
PSYS_SRC_BURST_SPEED_MAX,0.000000
]);
}

stop() {
    llParticleSystem([]);
}

default {
state_entry() {
    if(IS_ON) {
        llSetTimerEvent(RADIUS_INTERVAL);
        garden();
    } else {
        stop();
    }
}

touch_start(integer num_detected) {
    if(IS_ON) {
        llSetTimerEvent(0.0);
        stop();
        llWhisper(0, "Garden has stopped");
    } else {
        llSetTimerEvent(RADIUS_INTERVAL);
        garden();
        llWhisper(0, "Garden has started");
    }
    IS_ON = !IS_ON;
}

timer() {
    integer max_inventory = llGetInventoryNumber(INVENTORY_TEXTURE);
    if(max_inventory > 0) {
        TEXTURE = llGetInventoryName(INVENTORY_TEXTURE, (integer)llFrand(max_inventory));
    }
    RADIUS = llFrand(MAX_RADIUS);
    garden();
}
}
