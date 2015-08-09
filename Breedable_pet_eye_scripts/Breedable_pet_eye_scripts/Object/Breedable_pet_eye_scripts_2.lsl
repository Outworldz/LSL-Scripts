// :CATEGORY:XS Pet
// :NAME:Breedable_pet_eye_scripts
// :AUTHOR:Ferd Frederix
// :CREATED:2012-08-16 10:21:14.630
// :EDITED:2013-09-17 21:48:30
// :ID:116
// :NUM:174
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// xs sleep script.  This script makes particle Zzzzs float above the head on XS pets at night.
// :CODE:
// xs_sleep
// Particle plug in for XS_Pets.
// place this in the head of any animal. When it falls asleep, it will spit out Zzzzs
// only use this with xs_animated_eye script, as the xs_two_texture eye script has this built-in

// GLOBAL CONSTANTS VERSION 0.38
//
// COPIED FROM GLOBAL CONSTANTS FILE LOCATED IN the /Debug folder
// INCLUDE THESE IN ALL SCRIPTS!  //
// If you change this in any script, change it in all of them
//
// LICENSE
/////////////////////////////////////////////////////////////////////
// This code is licensed as Creative Commons Attribution/NonCommercial/Share Alike
// See http://creativecommons.org/licenses/by-nc-sa/3.0/
// Noncommercial -- You may not use this work for commercial purposes
// If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.
// This means that you cannot sell this code but you may share this code.
// You must attribute authorship and leave this notice intact.
// Exception: I am allowing this script to be sold inside an original build.
// You are not selling the script, you are selling the build.
// Ferd Frederix
// Based on original code from Xundra Snowpaw
////////////////////////////////////////////////////////////////////

// This first section are tuneable numbers that should be changed for any new pet


// SECURITY
/////////////////////////
string  SECRET_PASSWORD = "top secret string";    // must use a password unique to any animal with enctryption on
integer SECRET_NUMBER = 99999;             		  // any number thats a secret
integer ENCRYPT = TRUE;                           // set to TRUE to encrypt all data, Opensim prefers FALSE, TRUE is the most secure

// if you add the UUID for your avatar here, you can change it later
// and other alts or friends can change it too, and all of you can work on these pets.
// If you leave it blank, only the creator of the root prim can work on these pets.

key YOUR_UUID = "";

// PET NAMES
/////////////////////////
string Animal = "Troubot";        // was 'Quail', must be the name of your animal
string Egg = "Nut and Bolt";      // was 'XS Egg', must be the name of your egg
string Crate = "Transport UFO";   // was XS-Cryocrate, must be the name of the crate
string HomeObject = "Home Flag"; // was "XS Home Object", must be the name of your Home Post
string sound = "robot_sound";	// a basic sound, one needed, You can also use xs_sound, a plugin for more sounds


// more  changeble numbers

// Prim animation linkmessages are sent by these scripts on Link Message number 1
// These are the bnames of the animations that are recorded.
// No need to change them unless you want to change names of the animations when you run the prim animator, or you add additional link messages
// you need to record these and save them in the notecard
// Example:
// llMessageLinked(LINK_SET, 1, ANI_STAND, "");
// The above line will play the pre-recorded 'stand up' animation "stand" using the animator script.

string ANI_STAND = "stand";             // default standing animation
string  ANI_WALKL   = "left";           // triggers Left foot and Right arm walk animation
string  ANI_WALKR   = "right";          // triggers Right foot and Left arm walk animation
string  ANI_SLEEP  = "sleep";           // Sleeping
string  ANI_WAVE = "wave";              // Calling for sex, needs help with food, etc.


// misc tunables
float GROWTH_AMOUNT = 0.10; 			// 10% size increase each day for MaxAge days
integer MaxAge = 7;              		// can get pregnant in 7 days
integer UNITS_OF_FOOD = 168;     		// food bowl food qty, used by food bowl only
float secs_to_grow = 86400;      		// grow daily = 86400
float   FOOD_BOWL_SCAN_INTERVAL = 1800.0;	// look for food every 3 hours
float fPregnancy = 172800.0; 			// how many seconds to lay an egg  = 2 days or 48 hours.
float fDaysToAdult = 7;     			// 7 days to become old enough to breed.
integer SECONDS_BETWEEN_FOOD_NORMAL = 14400;	// this number of seconds to get hungry = 4 hours
integer SECONDS_BETWEEN_FOOD_HUNGRY = 3600;		// this number of seconds before hunger count increases = 1 hour
integer MAXIMUM_HUNGER = 30;			// not used, just displayed


// the following are global constants and do not need to be changed

float VERSION = 0.28;        // This is the Protocol version.  If you change this, then all pets older than this will not be compatible

///// GLOBAL CONSTANTS extracted from original source //////
//
// if you change any of these constants, change it everywhere and in a list in XS_Debug so it can print them
//
integer FOOD_CHANNEL = -999191;
integer ANIMAL_CHANNEL = -999192;
integer EGG_CHANNEL = -999193;
integer HOME_CHANNEL = -999194;
integer BOX_CHANNEL = -999195;
integer ACC_CHANNEL = -999196;
integer UPDATE_CHANNEL = -999197;
integer API_CHANNEL = -999198;



// global link messages to control the animal
integer LINK_AGE_START = 800;      // when quail is rezzed and secret_number, is sent by brain to breeder, eater and informatic get booted up
integer LINK_TEXTURE = 801;        // ask for a new texture, or paint a color
integer LINK_FOOD_CONSUME = 900;   // from movement to brain when close to food, brain then consumes a random amount up to 10000
integer LINK_FOODMINUS = 901;    // xs_brain  receives FOOD_CONSUME, decrement hunger (eat)
integer LINK_HUNGRY = 903;        // sent by eater (string)hunger_amount, checks each hour
integer LINK_HAMOUNT = 904;       // hunger_amount = (integer)str,m updates the hunger amount in scripts
integer LINK_SET_HOME = 910;      // loc ^ dist
integer LINK_MOVER = 911;         // tell mover to rest for str seconds
integer LINK_FOODIE_CLR = 920;    // clear all food_bowl_keys and contents
integer LINK_FOODIE = 921;        // send FOOD_LOCATION coordinates to movement
integer LINK_COLOR1 = 930;             // colour1
integer LINK_COLOR2 = 931;             // colour2
integer LINK_SEX = 932;                // sex
integer LINK_SHINE = 933;              // shine
integer LINK_GLOW = 934;               // glow
integer LINK_GEN = 935;                // generation
integer LINK_RESET_SIZE = 936;          // reset size to 1
integer LINK_MAGE = 940;                // xs_brain sends, xs_ager consumes, adds str to age, if older than 7 days, will grow the animal
integer LINK_DAYTIME = 941;             // xs_ager consumes, starts a timer of 86,400 seconds in xs_ager
integer LINK_GET_AGE = 942;             // get age from xs_ager and sent it on channel 943
integer LINK_PUT_AGE = 943;             // print age from xs_ager
integer LINK_PACKAGE = 950;             // look for a cryo_crate
integer LINK_SEEK_FEMALE = 960;         // MALE_BREED_CALL
integer LINK_MALE_BREED_CALL = 961;     // triggered by LINK_SEEK_FEMALE
integer LINK_SIGNAL_ELIGIBLE = 962;     // sent by female when hears LINK_MALE_BREED_CALL
integer LINK_FEMALE_ELIGIBLE = 963;     // sent when it hears in chat FEMALE_ELIGIBLE
integer LINK_CALL_MALE = 964;           // if LINK_FEMALE_ELIGIBLE && looking_for_female
integer LINK_MALE_ON_THE_WAY = 965;     // triggered by LINK_CALL_MALE
integer LINK_FEMALE_LOCATION = 966;     // female location, sends coordinates of a female
integer LINK_RQST_BREED  = 967;         // sent when close enough to male/female
integer LINK_CALL_MALE_INFO = 968;      // sent by xs_breeding, this line of code was in error in v.24 of xs_breeding see line 557 and 636 of xs_brain which make calls and also xs_breeding which receives LINK_MALE_INFO.
integer LINK_MALE_INFO = 969;
integer LINK_LAY_EGG = 970;             // llRezObject("XS Egg"
integer LINK_BREED_FAIL = 971;          // key = father, failed, timed out
integer LINK_PREGNANT = 972;            // chick is preggers
integer LINK_SOUND_OFF= 974;             // sound is off
integer LINK_SOUND_ON= 973;             // sound is on
integer LINK_SLEEPING = 990;            // close eyes
integer LINK_UNSLEEPING = 991;          // open eyes
integer LINK_SOUND = 1001;              // plays a sound if enabled
integer LINK_SPECIAL = 1010;            // xs_special, is str = "Normal", removes script
integer LINK_PREGNANCY_TIME = 5000;    // in seconds as str
integer LINK_SLEEP = 7999;              // disable sleep by parameter
integer LINK_TIMER = 8000;              // scan for food bowl about every 1800 seconds
integer LINK_DIE = 9999;                // death


///////// end global Link constants ////////


///////////// END OF COPIED CODE ////////////



// Original Particle Script 0.4j
// Created by Ama Omega 3-7-2004
// Updated by Jopsy Pendragon 5-11-2004
// For classes/tutorials/tricks, visit the Particle Labratory in Teal
// Values marked with (*) are defaults.

// SECTION ONE: APPEARANCE -- These settings affect how each particle LOOKS.
integer      glow = TRUE;        // TRUE or FALSE(*)
vector startColor = <1,1,1>;     // RGB color, black<0,0,0> to white<1,1,1>(*)
vector   endColor = <1,1,1>;     //
float  startAlpha = 1.0;         // 0.0 to 1.0(*), lower = more transparent
float    endAlpha = 1.0;         //
vector  startSize = <0.1,0.1,0>; // <0.04,0.04,0>(min) to <10,10,0>(max>, <1,1,0>(*)
vector    endSize = <.3,.3,0>; // (Z part of vector is discarded)
key texture = "f9b67edf-d837-e507-361b-0d34f4c64396";          // Texture used for particles. Texture must be in prim's inventory.

// SECTION TWO: FLOW -- These settings affect how Many, how Quickly, and for how Long particles are created.
//     Note,
integer count = 1;    // Number of particles created per burst, 1(*) to 4096
float    rate = 1.0;   // Delay between bursts of new particles, 0.0 to 60, 0.1(*)
float     age = 5.0;   // How long each particle lives, 0.1 to 60, 10.0(*)
float    life = 0.0;   // When to stop creating new particles. never stops if 0.0(*)

// SECTION THREE: PLACEMENT -- Where are new particles created, and what direction are they facing?
float      radius = .30;      // 0.0(default) to 64?  Distance from Emitter where new particles are created.
float  innerAngle = 0.75;  // "spread", for all ANGLE patterns, 0(default) to PI
float  outerAngle = 0.0;        // "tilt", for ANGLE patterns,  0(default) to TWO_PI, can use PI_BY_TWO or PI as well.
integer   pattern = PSYS_SRC_PATTERN_ANGLE_CONE; // Choose one of the following:
// PSYS_SRC_PATTERN_EXPLODE (sends particles in all directions)
// PSYS_SRC_PATTERN_DROP  (ignores minSpeed and maxSpeed.  Don't bother with count>1 )
// PSYS_SRC_PATTERN_ANGLE_CONE (set innerangle/outerange to make rings/cones of particles)
// PSYS_SRC_PATTERN_ANGLE (set innerangle/outerangle to make flat fanshapes of particles)
vector      omega = <0,0,0>; // How much to rotate the emitter around the <X,Y,Z> axises. <0,0,0>(*)
// Warning, there's no way to RESET the emitter direction once you use Omega!!
// You must attach the script to a new prim to clear the effect of omega.

// SECTION FOUR: MOVEMENT -- How do the particles move once they're created?
integer followSource = FALSE;   // TRUE or FALSE(*), Particles move as the emitter moves, (TRUE disables radius!)
integer    followVel = FALSE;    // TRUE or FALSE(*), Particles rotate towards their direction
integer         wind = FALSE;   // TRUE or FALSE(*), Particles get blown away by wind in the sim
integer       bounce = TRUE;   // TRUE or FALSE(*), Make particles bounce on Z altitude of emitter
float       minSpeed = 0.1;     // 0.01 to ? Min speed each particle is spit out at, 1.0(*)
float       maxSpeed = 0.2;     // 0.01 to ? Max speed each particle is spit out at, 1.0(*)
vector          push = <0,0,-0.3>; // Continuous force pushed on particles, use small settings for long lived particles
key           target = "";      // Select a target for particles to arrive at when they die
// can be "self" (emitter), "owner" (you), "" or any prim/persons KEY.

// SECTION FIVE:   Ama's "Create Short Particle Settings List"
integer  enableoutput = FALSE; // If this is TRUE, clicking on your emitter prim will cause it to speak
// very terse "shorthand" version of your particle settings.  You can cut'n'paste
// this abbreviated version into a call to llParticleSystem([ ]); in another script.
// Pros:  Takes up far less scripting space, letting you focus on the rest of your code.
// Cons:  makes tune your settings afterwards rather awkward

// === Don't muck about below this line unless you're comfortable with the LSL scripting language ====

// Script variables
integer pre = 2;          //Adjust the precision of the generated list.
integer flags;
list sys;


string float2String(float in)
{
    return llGetSubString((string)in,0,pre - 7);
}

updateParticles()
{
    flags = 0;
    if (target == "owner") target = llGetOwner();
    if (target == "self") target = llGetKey();
    if (glow) flags = flags | PSYS_PART_EMISSIVE_MASK;
    if (bounce) flags = flags | PSYS_PART_BOUNCE_MASK;
    if (startColor != endColor) flags = flags | PSYS_PART_INTERP_COLOR_MASK;
    if (startSize != endSize) flags = flags | PSYS_PART_INTERP_SCALE_MASK;
    if (wind) flags = flags | PSYS_PART_WIND_MASK;
    if (followSource) flags = flags | PSYS_PART_FOLLOW_SRC_MASK;
    if (followVel) flags = flags | PSYS_PART_FOLLOW_VELOCITY_MASK;
    if (target != "") flags = flags | PSYS_PART_TARGET_POS_MASK;
    sys = [  PSYS_PART_MAX_AGE,age,
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
            ];
    float newrate = rate;
    if (newrate == 0.0) newrate=.01;
    if ( (age/rate)*count < 4096) llParticleSystem(sys);
    else {
        llInstantMessage(llGetOwner(),"Your particle system creates too many concurrent particles.");
        llInstantMessage(llGetOwner(),"Reduce count or age, or increate rate.");
        llParticleSystem( [ ] );
    }
}
integer onoff;
default
{
    state_entry()
    {
        onoff=0;
        llParticleSystem( [ ] );
    }

    on_rez(integer num)
    {
        llResetScript();
    }

    link_message(integer sender, integer num, string str, key id)
    {
        if (num == 1 && str==ANI_SLEEP) {
            updateParticles();
        }
        else if (num == 1 && str == ANI_STAND) {
            llParticleSystem( [ ] );
        }
    }

}
