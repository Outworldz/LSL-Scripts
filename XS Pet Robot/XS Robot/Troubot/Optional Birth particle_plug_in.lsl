// :CATEGORY:XS Pet
// :NAME:XS Pet Robot
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS: Pet,XS,breed,breedable,companion,Ozimal,Meeroo,Amaretto,critter,Fennux,Pets
// :CREATED:2013-09-06
// :EDITED:2014-01-30 12:24:21
// :ID:988
// :NUM:1460
// :REV:0.50
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// XS Pet plug in for particle effects when a pet lays an egg.
// :CODE:


//// plug in for particle effects when a pet lays an egg.
// You can look at my script library at http://outworldz.com/cgi/freescripts.plx?Category=Particles  for particle subroutines.
//  Just be sure that whatever subroutine you use, it is named "startParticles()".
// To mix particles together and have more than one effect, you have to put a script in additional prims.
// Change the particle effect, and put this script in different child prims, as each prim can have only one particle emitter.


// you can change this next line
float SECONDS = 5.0;    // how long to play the effect before it is shut off

// this message is sent by xs_brain when she lays an egg. A Global Constant in the XS Pets. Don't mess with it.
integer LINK_LAY_EGG = 970;             // Rez Object(Egg...

// this next function makes the particles.
// change this function to any particle effect you want.

startParticles() {

// this is a well-documented particle subroutine by Xah Lee from
// http://outworldz.com/cgi/freescripts.plx?ID=1240

    
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

 PSYS_SRC_TEXTURE, "", // invt name, or UUID of a texture, when blank it wil be white spots

 //------------------------------------
 // parameters for the particle emiter. (units for time are in seconds.)

 // duration of the emitter will be spawning. Use 0. for forever. 60. is the max.
 PSYS_SRC_MAX_AGE, 0.0,

 //frequency of spawning
 PSYS_SRC_BURST_RATE, 0.9,        // 

 // number of particles per burst
 PSYS_SRC_BURST_PART_COUNT, 4,

// The distance the particle will be created from the emitter.
 PSYS_SRC_BURST_RADIUS, 1.0,        

// Particles will fly off at a random speed between min and max.
// For example, if you want a burst such that all sparkles are on the increasingly larger spherical boundary,
// set the max and min speed to the same value such as 1.0.
// If you want the sparkles to be inside the spherical boundary as well, use for example 0.1 and 1.0.
 PSYS_SRC_BURST_SPEED_MIN, 1.0,
 PSYS_SRC_BURST_SPEED_MAX, 1.0,

// A force on the particle after they are emitted. Each unit is meter per second. Max is 100.
// So, to emulate water falling from a sprinkler nozzle, use  <0.0,0.0,-0.8> to emulate a gravity.
// To emulate smoke being sucked into a tunnel, use a vector with non-zero x and y coordinates.
 PSYS_SRC_ACCEL, <0.0,0.0,0.1>,        // push up so the particles rise slowly = 0.1 in th Z axis

// The following are for the directions of the particle burst.
// They are valid if the particle pattern is one of PSYS_SRC_PATTERN_ANGLE, PSYS_SRC_PATTERN_ANGLE_CONE, PSYS_SRC_PATTERN_ANGLE_CONE_EMPTY.
// The PSYS_SRC_OMEGA will rotate the shooting. Angle starts from the z-axes and are in radians.
 PSYS_SRC_ANGLE_BEGIN, 1.0,
 PSYS_SRC_ANGLE_END, 1.1,
 PSYS_SRC_OMEGA, < 0.0, 0.0 , 0.0>,

 //------------------------------------
// parameters that controls the particle sprites (a sprite is a 2D image that always faces the viewer.Particles are sprites.)

 // the age of each particle. Max is 30.
 PSYS_PART_MAX_AGE, 10.0, 

 // The end color must have PSYS_PART_INTERP_COLOR_MASK on in PSYS_PART_FLAGS
 PSYS_PART_START_COLOR, <1.0,0.0,0.0>,        // from Red 
 PSYS_PART_END_COLOR, <0.0,0.0,1.0>,          // to Blue as they age

 // The ALPHA is transparency, from 0 to 1. 1 means opaque.
 PSYS_PART_START_ALPHA, 0.8 ,        // Start from 0.8 = slighty transparent, like smoke
 PSYS_PART_END_ALPHA, 0.0 ,          // to 0, wheich makes them fade away

 //scale change. valid values are from 0.031 to 4.0 .
 //must have INTERP_SCALE_MASK on in PSYS_PART_FLAGS.
 PSYS_PART_START_SCALE, <1.0,1.0,0.0>,        // from full size
 PSYS_PART_END_SCALE, <0.1,0.1,0.0>,          // to 1/10 size, so they shrink as they age

 //------------------------------------
 // miscellaneous behaviors controlled by PSYS_PART_FLAGS, you can comment out any of the lines that begin with |
 PSYS_PART_FLAGS
 , 0        // leave this alone, a 0 or'd with the following is harmless, but it stops errors if you comment out everything below

 // glows. Basically brighter.
 | PSYS_PART_EMISSIVE_MASK

 // change particle color. Makes PSYS_PART_START_COLOR, PSYS_PART_END_COLOR work.
 | PSYS_PART_INTERP_COLOR_MASK

 // make it change size during its life. makes PSYS_PART_START_SCALE, PSYS_PART_END_SCALE work.
 | PSYS_PART_INTERP_SCALE_MASK

 // make particles bounce off emiter's z-axis height, works only when the particle falls after bust.
 | PSYS_PART_BOUNCE_MASK

// The PSYS_PART_FOLLOW_SRC_MASK makes the emitted particle's positions follow the emiter (disables PSYS_SRC_BURST_RADIUS). If not set, then particles once emitted outside of the PSYS_SRC_BURST_RADIUS will flow by themselves.
// For example, a blinking LED on a watch should have this set. Smokes from a cigerette should not have this set.
 | PSYS_PART_FOLLOW_SRC_MASK

// Orient the particle sprite (the image) with the emiter's bursting direction.
// For example, a rotating water sprinkler should have this set.
// But if your sprite is textual such as "I Love You", then it should not have this set.
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

// Plays the effect for SECONDS, then shuts it off.
PlayEffect()
{
    startParticles();        // turn particles on
    llSleep(SECONDS);        // wait X seconds
    llParticleSystem([]);    // turn particles off
}

// This is the default state we are in
default
{
    // play the effect for X seconds when you reset the script so you can see it and debug it. Otherwise is unused.
    state_entry()
    {
        PlayEffect();
    }

       // The pet sends a link message when it lays an egg.
    link_message(integer sender, integer num, string str, key id)
    {
        if (num == LINK_LAY_EGG)
        {
            PlayEffect();
        }
    }
}

