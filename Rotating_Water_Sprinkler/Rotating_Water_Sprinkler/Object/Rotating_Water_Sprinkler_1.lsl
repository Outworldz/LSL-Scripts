// :CATEGORY:Particles
// :NAME:Rotating_Water_Sprinkler
// :AUTHOR:Xah Lee
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:01
// :ID:711
// :NUM:975
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The script
// :CODE:
// This script is from http://xahlee.org/sl/ .
// Copyright \xA9 2007 Xah Lee.
// Permission is granted for use or modification provided this note is intact.

// a rotating water springler for lawns

partyOn(){
llParticleSystem([
 PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE,

 PSYS_SRC_MAX_AGE, 0.,

 PSYS_SRC_BURST_RATE, .3,
 PSYS_SRC_BURST_PART_COUNT, 50,

 PSYS_SRC_BURST_RADIUS, .2,
 PSYS_SRC_BURST_SPEED_MIN, 1.,
 PSYS_SRC_BURST_SPEED_MAX, 5.,
 PSYS_SRC_ACCEL, <0.0,0.0,-1.>,

 PSYS_SRC_ANGLE_BEGIN, 0.9,
 PSYS_SRC_ANGLE_END, 1.,
 PSYS_SRC_OMEGA, <0.,0.,1.>,

 PSYS_PART_MAX_AGE, 4., 

 PSYS_PART_START_COLOR, <1,1,1>,
 PSYS_PART_END_COLOR, <1,1,1>,

 PSYS_PART_START_ALPHA, .7,
 PSYS_PART_END_ALPHA, 0.1,

 PSYS_PART_START_SCALE, <.08,.8,0>,
 PSYS_PART_END_SCALE, <.05,.1,0>,

 PSYS_PART_FLAGS
 , 0
 | PSYS_PART_INTERP_COLOR_MASK
 | PSYS_PART_INTERP_SCALE_MASK
 | PSYS_PART_FOLLOW_VELOCITY_MASK
 | PSYS_PART_WIND_MASK
]);
}

default { state_entry() { partyOn(); } 
