// :CATEGORY:Particles
// :NAME:Good_particle_script_example
// :AUTHOR:Xah Lee
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:360
// :NUM:493
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The script
// :CODE:
// This script is from http://xahlee.org/sl/ .

// Copyright © 2007 Xah Lee.

// Permission is granted for use or modification provided this note is intact.



// This is a template for particles.

// tweak the various parameters to get different effects.

// Make sure that floats stays float and integers stays integers.



partyOn(){

llParticleSystem([

 //------------------------------------

 // overall pattern of the whole particles

 // pick one in the following.



 // The pattern EXPLODE is good for fireworks. The DROP would be good for water drops. The PATTERN_ANGLE will burst particles in a pie-shape in the x-plane. Good for example for rainbow. ANGLE_CONE is a cone along the z-axes, good for example for jet exhaust, or water fountain. ANGLE_CONE_EMPTY is like ANGLE_CONE, but where ANGLE_CONE shoots, ANGLE_CONE_EMPTY will not.



 PSYS_SRC_PATTERN,

  PSYS_SRC_PATTERN_EXPLODE

  //PSYS_SRC_PATTERN_DROP

  //PSYS_SRC_PATTERN_ANGLE

  //PSYS_SRC_PATTERN_ANGLE_CONE

  //PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY

 ,

 //------------------------------------

 // THE SHAPE OF EACH PARTICLE



 PSYS_SRC_TEXTURE, "", // invt name, or UUID of a texture



 //------------------------------------

 // parameters for the particle emiter. (units for time are in seconds.)



 // duration of the emitter will be spawning. Use 0. for forever. “60.” is the max.

 PSYS_SRC_MAX_AGE, 0.,



 //frequency of spawning

 PSYS_SRC_BURST_RATE, .9,



 // number of particles per burst

 PSYS_SRC_BURST_PART_COUNT, 4,



// The distance the particle will be created from the emitter.

 PSYS_SRC_BURST_RADIUS, 6.,



 // Particles will fly off at a random speed between min and max. For example, if you want a firework burst such that all sparkles are on the increasingly larger spherical boundary, set the max and min speed to the same value such as “1.0”. If you want the firework sparkles to be inside the spherical boundary as well, use for example “0.1” and “1.0”.

 PSYS_SRC_BURST_SPEED_MIN, 1.,

 PSYS_SRC_BURST_SPEED_MAX, 1.,



 // A force on the particle after they are emitted. Each unit is meter per second. Max is 100. So, to emulate water falling from a sprinkler nozzle, use  <0.0,0.0,-0.8> to emulate a gravity. To emulate smoke being sucked into a tunnel, use a vector with non-zero x and y coordinates.

 PSYS_SRC_ACCEL, <0.0,0.0,-0.8>,



 // The following are for the directions of the particle burst. They are valid if the particle pattern is one of PSYS_SRC_PATTERN_ANGLE, PSYS_SRC_PATTERN_ANGLE_CONE, PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY. The PSYS_SRC_OMEGA will rotate the shooting. Angle starts from the z-axes and are in radians.

 PSYS_SRC_ANGLE_BEGIN, 1.0,

 PSYS_SRC_ANGLE_END, 1.1,

 PSYS_SRC_OMEGA, < 0., 0. , 0.>,



 //------------------------------------

 // parameters that controls the particle sprites (a sprite is a 2D image that always faces the viewer. Particles are sprites.)



 // the age of each particle. Max is 30.

 PSYS_PART_MAX_AGE, 10., 



 // The end color must have PSYS_PART_INTERP_COLOR_MASK on in PSYS_PART_FLAGS

 PSYS_PART_START_COLOR, <1,0,0>,

 PSYS_PART_END_COLOR, <0,0,1>,



 // The ALPHA is transparency, from 0 to 1. 1 means opaque.

 PSYS_PART_START_ALPHA, .8 ,

 PSYS_PART_END_ALPHA, 0. ,



 //scale change. valid values are from 0.031 to 4.0 .

 //must have INTERP_SCALE_MASK on in PSYS_PART_FLAGS.

 PSYS_PART_START_SCALE, <1,1,0>,

 PSYS_PART_END_SCALE, <.1,.1,0>,



 //------------------------------------

 // miscellaneous behaviors controlled by PSYS_PART_FLAGS

 PSYS_PART_FLAGS

 , 0



 // glows. Basically brighter.

 | PSYS_PART_EMISSIVE_MASK



 // change particle color. Makes PSYS_PART_START_COLOR, PSYS_PART_END_COLOR work.

 | PSYS_PART_INTERP_COLOR_MASK



 // make it change size during its life. makes PSYS_PART_START_SCALE, PSYS_PART_END_SCALE work.

 | PSYS_PART_INTERP_SCALE_MASK



 // make particles bounce off emiter's z-axis height, works only when the particle falls after bust.

 | PSYS_PART_BOUNCE_MASK



 // The PSYS_PART_FOLLOW_SRC_MASK makes the emitted particle's positions follow the emiter (disables PSYS_SRC_BURST_RADIUS). If not set, then particles once emitted outside of the PSYS_SRC_BURST_RADIUS will flow by themselves. For example, a blinking LED on a watch should have this set. Smokes from a cigerette should not have this set.

 | PSYS_PART_FOLLOW_SRC_MASK



 // Orient the particle sprite (the image) with the emiter's bursting direction. For example, a rotating water sprinkler should have this set.  But if your sprite is textual such as “I Love You”, then it should not have this set.

 | PSYS_PART_FOLLOW_VELOCITY_MASK



 // straight line to target (cancels PSYS_SRC_ACCEL, PSYS_SRC_BURST_RADIUS)

 //| PSYS_PART_TARGET_LINEAR_MASK



 // make it blown by wind

 //| PSYS_PART_WIND_MASK



 //make particles follow a target specified at PSYS_SRC_TARGET_KEY

 //PSYS_PART_TARGET_POS_MASK



 //------------------------------------

 // following behavior. (needs PSYS_PART_FOLLOW_VELOCITY_MASK on)



 //PSYS_SRC_TARGET_KEY,llGetKey(),

]);

}



default { state_entry() { partyOn(); } }
