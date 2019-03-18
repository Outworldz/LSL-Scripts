// :CATEGORY:XS Pet
// :NAME:XS Pet Robot
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS: Pet,XS,breed,breedable,companion,Ozimal,Meeroo,Amaretto,critter,Fennux,Pets
// :CREATED:2013-09-06
// :EDITED:2014-05-18
// :ID:988
// :NUM:1466
// :REV:0.52
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// XS Pet xs_infomatic
// :CODE:


// xs_infomatic

// This code handles the hovertext and also the Dialog boxes

// 4-10-2013 V 0.43 Lots of casting to fix Opensim 0.7.4 failures to parse llList2Float and llList2Integer when there are strings in the list
// 12-9-2013 C 0.48  added Breed name string






// START OF COPIED file 'Global Constants.txt' from the Debug folder.  It has to be the same in all files
// If you change this in any script, change it in all of them, please. It works a lot better that way.

// This is code based on Version 0.50 01-30-2014
// For version history, see file revisions.txt
//
// LICENSE
/////////////////////////////////////////////////////////////////////
// This code is licensed as Creative Commons Attribution/NonCommercial/Share Alike
// See http://creativecommons.org/liceses/by-nc-sa/3.0/
// Noncommercial -- You may not use this work for commercial purposes, i.e., you cannot sell this script in any form, including derivatives.
// If you alter, transform, or build upon this work, you may distribute the resulting work only under the same or similar license to this one.
// This means that you cannot sell this or derivative code by itself, but you may share and use this code in any object or virtual world.
// You must attribute authorship in the original scripts to Fred Beckhusen (Ferd Frederix) and Xundra Snowpaw, and leave this notice intact.
// You do not have to give back to the community any changes you make, however, code changes would be greatly appreciated!
//
// Exception: I am allowing this script to be used in an original build and sold with the build.
// You are not selling the script, you are selling the build. If you want to sell these scripts, write your own or use the original at http://code.google.com/p/xspets/
// Note: Xundra Snowpaw's license was 'New BSD' license and adding additional licenses is allowed.

// Based on code from Xundra Snowpaw
// New BSD License: http://www.opensource.org/licenses/bsd-license.php
// Copyright (c) 2010, Xundra Snowpaw
// All rights reserved.
// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

//* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer
// in the documentationand/or other materials provided with the distribution.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
// BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
//  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
////////////////////////////////////////////////////////////////////

// DEBUG - lets you see and hear wtf is happening
integer debug = FALSE;        // set to TRUE TO hear a lot of chat


// This  section has a few tuneable items that MUST be changed for any new pet

// SECURITY
string  SECRET_PASSWORD = "top secret string";    // must use a password unique to any species of animal, when ENCRYPT= TRUE. Otherwise you will find Pet type A fucking pet type B.
integer SECRET_NUMBER = 99999;             		  // any number thats a secret, not necessary to change usually, this is used when pets are born and eggs are rezzed to establish a comm channel.
integer ENCRYPT = TRUE;                           // set to TRUE to encrypt all data, Some Opensim worlds prefer FALSE due to parsing bugs, TRUE is the most secure. If FALSE you MUST change the FOOD_CHANNEL and other channels for different pets. or they will literally fuck each other.

// if you add the UUID for your avatar here, you can change it later
// and other alts or friends can change it too, and all of you can work on these pets.
// If you leave it blank, only the creator of the root prim can work on these pets.
key YOUR_UUID = "";

// PET NAMES  - YOU MUST CHANGE THEM HERE AND IN THE ROOT PRIM OF THE OBJECT - THEY MUST MATCH EXACTLY
/////////////////////////
string MaleName = "Troubot";        // Must be the name of your animal
string FemaleName = "Troubot";        // The name of the female pet, if a different shape or prim count. Can be the same as the Male for pets like the robot that are unisex.
string Egg = "Nut and Bolt";      // was 'XS Egg', must be the name of your egg
string Crate = "Transport Spaceship";   // was XS-Cryocrate, must be the name of the crate you package pets in
string HomeObject = "Home Flag"; // was "XS Home Object", must be the name of your Home Post indicator
string EggCup = "Toolbox";      // was "XS Egg Cup", must be the name of your egg holder
// any other object names are 'do not cares'.

// NOTHING NEEDS TO BE CHANGED BELOW, BUT CAN BE CHANGED IF YOU DO IT EVERYWHERE

// misc tunables
float GROWTH_AMOUNT = 0.10; 			// 10% size increase each day for MaxAge days = 200% (double size after 7 days)
integer MaxAge = 7;              		// stop growing in seven days.  10% growth compounded daily means that your pet will be 194% larger ( 2x, basically) in 7 days.
integer UNITS_OF_FOOD = 168;     		// food bowl food qty, used by food bowl only
float secs_to_grow = 86400;      		// grow daily = 86400 seconds
float FOOD_BOWL_SCAN_INTERVAL = 10800.0;	// look for food every 3 hours
float fPregnancy = 172800.0; 			// how many seconds to lay an egg  = 2 days or 48 hours.
float MALE_TIMEOUT = 900.0 ;            // in seconds, female waits this long in one spot for a male to arrive
float SEX_WAIT = 10800.0;               // How often they desire sex = 3 hours
float fDaysToAdult = 7;     			// 7 days to become old enough to breed.
integer SECONDS_BETWEEN_FOOD_NORMAL = 14400;	// number of seconds to get hungry = 4 hours
integer SECONDS_BETWEEN_FOOD_HUNGRY = 3600;		// number of seconds before hunger count increases = 1 hour
integer MAXIMUM_HUNGER = 30;			// They die after a month with no food.


// I control versions by Subversion Source Code Control.  But the updater needs a version numbert in world.  
// This is the Protocol version.  If you change this, then all pets with a lower version will be updated by the updater
float VERSION = 0.50;            



// the leg sizes are safe to leave alone or set to 0 if you use a thin base prim, these are from the original Quail
float LegLength = 0.064;      // length of pet leg??? - not sure
float LegOffset = 0.052399;  // This is added to the Post Z to position the pet

// the following are global constants and do not need to be changed
// Prim animation linkmessages are sent by scripts on Link Message number 1
// The strings are the names of the animations that are recorded.
// No need to change them unless you want to change names of the animations when you run the prim animator, or you add additional link messages
// If your pet walks, you need to record these names and save them in the notecard
//
// Example:
// llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
// The above line will play the pre-recorded 'stand up' animation "stand" using the animator script.
// The following animations are used in the pet.  You can add your own.

string  ANI_STAND = "stand";             // default standing animation
string  ANI_WALKL   = "left";           // triggers Left foot and Right arm walk animation
string  ANI_WALKR   = "right";          // triggers Right foot and Left arm walk animation
string  ANI_SLEEP  = "sleep";           // Sleeping
string  ANI_WAVE = "wave";              // Calling for sex, needs help with food, etc.

// Channel assignments
// if you change any of these constants, change it everywhere and in the list in XS_Debug so it can print them
// If you turn encryption FALSE, you MUST change these between species of pets are they will fuck with each other. Literally.

integer FOOD_CHANNEL = -999191;
integer ANIMAL_CHANNEL = -999192;
integer EGG_CHANNEL = -999193;
integer HOME_CHANNEL = -999194;
integer BOX_CHANNEL = -999195;
integer ACC_CHANNEL = -999196;
integer UPDATE_CHANNEL = -999197;
integer API_CHANNEL = -999198;

// global link messages to control the animal, never any need to change these.
// They are exposed here so they will be the same everywhere.  This uses a bit of RAM, but who cares?

integer LINK_ANIMATE = 1;          // messages on num 1 are assumed to be directed at the prim animator.
integer DECREASE_FOOD = 100;       // used in the food bowl.
integer LINK_AGE_START = 800;      // when pety  is rezzed and secret_number is sent by brain to breeder, eater and infomatic get booted up
integer LINK_TEXTURE = 801;        // ask for a new texture, or paint a color
integer LINK_BREEDNAME = 802;      // the name of the pet texture from the texture server notecard
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
integer LINK_MALE_INFO = 969;           // Breeding failed, sent info
integer LINK_LAY_EGG = 970;             // Rez Object(Egg...
integer LINK_BREED_FAIL = 971;          // key = father, failed, timed out
integer LINK_PREGNANT = 972;            // chick is preggers
integer LINK_SOUND_OFF= 974;             // sound is off
integer LINK_SOUND_ON= 973;             // sound is on
integer LINK_SLEEPING = 990;            // close eyes
integer LINK_UNSLEEPING = 991;          // open eyes
integer LINK_SOUND = 1001;              // plays a sound if enabled
integer LINK_SPECIAL = 1010;            // xs_special, if str = "Normal", removes script
integer LINK_EFFECTS_ON = 2000;         // particle effects in the packger
integer LINK_PREGNANCY_TIME = 5000;    // in seconds as str
integer LINK_SLEEP = 7999;              // disable sleep by parameter
integer LINK_TIMER = 8000;              // scan for food bowl about every 1800 seconds
integer LINK_DIE = 9999;                // death

string Copyright = " (c)2014 by Fred Beckhusen (Ferd Frederix)";    // You cannot change this line, but you can change the code that prints it!
// See License agreements above.
//  Attribution is required, as these files are copyrighted. 


DEBUG ( string msg){
    if (debug) {
        llOwnerSay(llGetScriptName() + ":" + msg);
    }
}



///////// end global Link constants ////////

// END OF COPIED CODE





string sBreedName;  // hold the breed name fronm texture server, if any
integer hunger_amount;
vector colour1;
vector colour2;
integer sex;
integer shine;
float glow;
string pregnant;
string sleep;
integer gen;

integer name_listener;
integer menu_listener;

integer age;
integer play_sounds;
string special;
integer menu_expired;
integer sleep_disabled;


string gHEX_STRING = "0123456789abcdef";    // hex string index **uses lower case

// vector values of all known system colors
list sysColorsVector;
// names of all known system colors
list sysColorsName;


string HTML2SysColorBestMatch(vector userColor)
{

    // place holder for the system color to match
   
    // start with a large variance and narrow down
    float variance = 2.0;
    float test;
    integer index;
   
    integer count = llGetListLength(sysColorsVector);
    integer i;
    for (i=0;i<count;i++)
    {
        test = llVecMag(userColor - llList2Vector(sysColorsVector, i));
        if (test < variance)
        {
            variance = test;
            index = i;
        }
    }
   
    return llList2String(sysColorsName, index);
}


say_details()
{

    string mysex;
    string myshine;
    if (sex == 1) {
        mysex = "Male";
    } else
    if (sex == 2) {
        mysex = "Female";
    } else {
       mysex = "unknown - not configured correctly";
    }

    if (shine == 0) {
        myshine = "None";
    } else
    if (shine == 1) {
        myshine = "Low";
    } else
    if (shine == 2) {
        myshine = "Medium";
    } else
    if (shine == 3) {
        myshine = "High";
    }
    
    if (llStringLength(sBreedName))
        llWhisper(0, "Breed: " + (string)sBreedName);

    llWhisper(0, "Color1: " + HTML2SysColorBestMatch(colour1));
    llWhisper(0, "Color1: " + HTML2SysColorBestMatch(colour2));
    llWhisper(0, "Shine: " + myshine);
    llWhisper(0, "Glow: " + (string)((integer)(glow * 100)) + "%");
    llWhisper(0, "Special: " + special);
    llWhisper(0, "Sex: " + mysex);
    llWhisper(0, "Age: " + (string)age + " days");
    llWhisper(0, "Generation: " + (string)gen);

    // the API channel is unused at this time.  You can use it for whatever 
    llSay(API_CHANNEL, "XSPet^" + (string)llGetKey() + "^" + sBreedName + "^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)shine + "^" + (string)glow + "^" + special + "^" + (string)gen + "^" + (string)sex + "^" + (string)age + "^XSPetEnd");
}

default
{

    state_entry()
    {
        sysColorsVector =
        [
            <0.941176,0.972549,1.000000>,
            <0.980392,0.921569,0.843137>,
            <0.000000,1.000000,1.000000>,
            <0.498039,1.000000,0.831373>,
            <0.941176,1.000000,1.000000>,
            <0.960784,0.960784,0.862745>,
            <1.000000,0.894118,0.768627>,
            <0.000000,0.000000,0.000000>,
            <1.000000,0.921569,0.803922>,
            <0.000000,0.000000,1.000000>,
            <0.541176,0.168627,0.886275>,
            <0.647059,0.164706,0.164706>,
            <0.870588,0.721569,0.529412>,
            <0.372549,0.619608,0.627451>,
            <0.498039,1.000000,0.000000>,
            <0.823529,0.411765,0.117647>,
            <1.000000,0.498039,0.313725>,
            <0.392157,0.584314,0.929412>,
            <1.000000,0.972549,0.862745>,
            <0.862745,0.078431,0.235294>,
            <0.000000,1.000000,1.000000>,
            <0.000000,0.000000,0.545098>,
            <0.000000,0.545098,0.545098>,
            <0.721569,0.525490,0.043137>,
            <0.662745,0.662745,0.662745>,
            <0.000000,0.392157,0.000000>,
            <0.741176,0.717647,0.419608>,
            <0.545098,0.000000,0.545098>,
            <0.333333,0.419608,0.184314>,
            <1.000000,0.549020,0.000000>,
            <0.600000,0.196078,0.800000>,
            <0.545098,0.000000,0.000000>,
            <0.913725,0.588235,0.478431>,
            <0.560784,0.737255,0.545098>,
            <0.282353,0.239216,0.545098>,
            <0.184314,0.309804,0.309804>,
            <0.000000,0.807843,0.819608>,
            <0.580392,0.000000,0.827451>,
            <1.000000,0.078431,0.576471>,
            <0.000000,0.749020,1.000000>,
            <0.411765,0.411765,0.411765>,
            <0.117647,0.564706,1.000000>,
            <0.698039,0.133333,0.133333>,
            <1.000000,0.980392,0.941176>,
            <0.133333,0.545098,0.133333>,
            <1.000000,0.000000,1.000000>,
            <0.862745,0.862745,0.862745>,
            <0.972549,0.972549,1.000000>,
            <1.000000,0.843137,0.000000>,
            <0.854902,0.647059,0.125490>,
            <0.501961,0.501961,0.501961>,
            <0.000000,0.501961,0.000000>,
            <0.678431,1.000000,0.184314>,
            <0.941176,1.000000,0.941176>,
            <1.000000,0.411765,0.705882>,
            <0.803922,0.360784,0.360784>,
            <0.294118,0.000000,0.509804>,
            <1.000000,1.000000,0.941176>,
            <0.941176,0.901961,0.549020>,
            <0.901961,0.901961,0.980392>,
            <1.000000,0.941176,0.960784>,
            <0.486275,0.988235,0.000000>,
            <1.000000,0.980392,0.803922>,
            <0.678431,0.847059,0.901961>,
            <0.941176,0.501961,0.501961>,
            <0.878431,1.000000,1.000000>,
            <0.980392,0.980392,0.823529>,
            <0.827451,0.827451,0.827451>,
            <0.564706,0.933333,0.564706>,
            <1.000000,0.713725,0.756863>,
            <1.000000,0.627451,0.478431>,
            <0.125490,0.698039,0.666667>,
            <0.529412,0.807843,0.980392>,
            <0.466667,0.533333,0.600000>,
            <0.690196,0.768627,0.870588>,
            <1.000000,1.000000,0.878431>,
            <0.000000,1.000000,0.000000>,
            <0.196078,0.803922,0.196078>,
            <0.980392,0.941176,0.901961>,
            <1.000000,0.000000,1.000000>,
            <0.501961,0.000000,0.000000>,
            <0.400000,0.803922,0.666667>,
            <0.000000,0.000000,0.803922>,
            <0.729412,0.333333,0.827451>,
            <0.576471,0.439216,0.858824>,
            <0.235294,0.701961,0.443137>,
            <0.482353,0.407843,0.933333>,
            <0.000000,0.980392,0.603922>,
            <0.282353,0.819608,0.800000>,
            <0.780392,0.082353,0.521569>,
            <0.098039,0.098039,0.439216>,
            <0.960784,1.000000,0.980392>,
            <1.000000,0.894118,0.882353>,
            <1.000000,0.894118,0.709804>,
            <1.000000,0.870588,0.678431>,
            <0.000000,0.000000,0.501961>,
            <0.992157,0.960784,0.901961>,
            <0.501961,0.501961,0.000000>,
            <0.419608,0.556863,0.137255>,
            <1.000000,0.647059,0.000000>,
            <1.000000,0.270588,0.000000>,
            <0.854902,0.439216,0.839216>,
            <0.933333,0.909804,0.666667>,
            <0.596078,0.984314,0.596078>,
            <0.686275,0.933333,0.933333>,
            <0.858824,0.439216,0.576471>,
            <1.000000,0.937255,0.835294>,
            <1.000000,0.854902,0.725490>,
            <0.803922,0.521569,0.247059>,
            <1.000000,0.752941,0.796078>,
            <0.866667,0.627451,0.866667>,
            <0.690196,0.878431,0.901961>,
            <0.501961,0.000000,0.501961>,
            <1.000000,0.000000,0.000000>,
            <0.737255,0.560784,0.560784>,
            <0.254902,0.411765,0.882353>,
            <0.545098,0.270588,0.074510>,
            <0.980392,0.501961,0.447059>,
            <0.956863,0.643137,0.376471>,
            <0.180392,0.545098,0.341176>,
            <1.000000,0.960784,0.933333>,
            <0.627451,0.321569,0.176471>,
            <0.752941,0.752941,0.752941>,
            <0.529412,0.807843,0.921569>,
            <0.415686,0.352941,0.803922>,
            <0.439216,0.501961,0.564706>,
            <1.000000,0.980392,0.980392>,
            <0.000000,1.000000,0.498039>,
            <0.274510,0.509804,0.705882>,
            <0.823529,0.705882,0.549020>,
            <0.000000,0.501961,0.501961>,
            <0.847059,0.749020,0.847059>,
            <1.000000,0.388235,0.278431>,
            <1.000000,1.000000,1.000000>,
            <0.250980,0.878431,0.815686>,
            <0.933333,0.509804,0.933333>,
            <0.960784,0.870588,0.701961>,
            <1.000000,1.000000,1.000000>,
            <0.960784,0.960784,0.960784>,
            <1.000000,1.000000,0.000000>,
            <0.603922,0.803922,0.196078>
        ];


         sysColorsName =
        [
            "AliceBlue",
            "AntiqueWhite",
            "Aqua",
            "Aquamarine",
            "Azure",
            "Beige",
            "Bisque",
            "Black",
            "BlanchedAlmond",
            "Blue",
            "BlueViolet",
            "Brown",
            "BurlyWood",
            "CadetBlue",
            "Chartreuse",
            "Chocolate",
            "Coral",
            "CornflowerBlue",
            "Cornsilk",
            "Crimson",
            "Cyan",
            "DarkBlue",
            "DarkCyan",
            "DarkGoldenrod",
            "DarkGray",
            "DarkGreen",
            "DarkKhaki",
            "DarkMagenta",
            "DarkOliveGreen",
            "DarkOrange",
            "DarkOrchid",
            "DarkRed",
            "DarkSalmon",
            "DarkSeaGreen",
            "DarkSlateBlue",
            "DarkSlateGray",
            "DarkTurquoise",
            "DarkViolet",
            "DeepPink",
            "DeepSkyBlue",
            "DimGray",
            "DodgerBlue",
            "Firebrick",
            "FloralWhite",
            "ForestGreen",
            "Fuchsia",
            "Gainsboro",
            "GhostWhite",
            "Gold",
            "Goldenrod",
            "Gray",
            "Green",
            "GreenYellow",
            "Honeydew",
            "HotPink",
            "IndianRed",
            "Indigo",
            "Ivory",
            "Khaki",
            "Lavender",
            "LavenderBlush",
            "LawnGreen",
            "LemonChiffon",
            "LightBlue",
            "LightCoral",
            "LightCyan",
            "LightGoldenrodYellow",
            "LightGray",
            "LightGreen",
            "LightPink",
            "LightSalmon",
            "LightSeaGreen",
            "LightSkyBlue",
            "LightSlateGray",
            "LightSteelBlue",
            "LightYellow",
            "Lime",
            "LimeGreen",
            "Linen",
            "Magenta",
            "Maroon",
            "MediumAquamarine",
            "MediumBlue",
            "MediumOrchid",
            "MediumPurple",
            "MediumSeaGreen",
            "MediumSlateBlue",
            "MediumSpringGreen",
            "MediumTurquoise",
            "MediumVioletRed",
            "MidnightBlue",
            "MintCream",
            "MistyRose",
            "Moccasin",
            "NavajoWhite",
            "Navy",
            "OldLace",
            "Olive",
            "OliveDrab",
            "Orange",
            "OrangeRed",
            "Orchid",
            "PaleGoldenrod",
            "PaleGreen",
            "PaleTurquoise",
            "PaleVioletRed",
            "PapayaWhip",
            "PeachPuff",
            "Peru",
            "Pink",
            "Plum",
            "PowderBlue",
            "Purple",
            "Red",
            "RosyBrown",
            "RoyalBlue",
            "SaddleBrown",
            "Salmon",
            "SandyBrown",
            "SeaGreen",
            "SeaShell",
            "Sienna",
            "Silver",
            "SkyBlue",
            "SlateBlue",
            "SlateGray",
            "Snow",
            "SpringGreen",
            "SteelBlue",
            "Tan",
            "Teal",
            "Thistle",
            "Tomato",
            "White",
            "Turquoise",
            "Violet",
            "Wheat",
            "White",
            "WhiteSmoke",
            "Yellow",
            "YellowGreen"
        ];


        if (debug)
        {
            float i;
            float j;
            float k;
            for (i = 0; i <= 1; i+= 0.5)
            {
                for (j = 0; j <= 1; j+= 0.5)
                {
                    for (k = 0; k <= 1; k+= 0.5)
                    {
                        llWhisper(0, (string)<i,j,k> +  ":" + HTML2SysColorBestMatch(<i,j,k>));

                    }
                }
            }
        }
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if (num == LINK_AGE_START) {    // this starts the aging process
            state running;
        }
    }
}


state running
{
    state_entry()
    {
        hunger_amount = 0;
        age = 0;
        pregnant = "";
        play_sounds = TRUE;
        llListen(API_CHANNEL, "", "", "");
    }

    touch_start(integer total_number)
    {
        string mysex;
        if (sex == 1) {
            mysex = "Male";
        } else
        if (sex == 2) {
            mysex = "Female";
        } else {
            mysex = "unknown - not configured correctly";
        }

        llSetText(llGetObjectName() + "\n" +  mysex + " - Age: " + (string)age + " - Gen: " + (string)gen + "\n" + "Hunger: " + (string)hunger_amount + "/" + (string)MAXIMUM_HUNGER + "\n" + pregnant + sleep, <1,1,1>, 1.0);

        say_details();

        menu_expired = 0;

        if (llDetectedKey(0) == llGetOwner()) {
            integer menu_chan = (integer)llFrand(10000.0) + 100;
            llListenRemove(menu_listener);
            menu_listener = llListen(menu_chan, "", llGetOwner(), "");

            llDialog(llGetOwner(), "What would you like to do?\n\n - Name: Name your pet "
                + "\n - Package: Place your pet"
                + "into a nearby " + Crate
                + "\n - Sound: Toggle Sound On/Off\n"
                + "- Home Object: Get a new home object\n"
                + "- Sleep: Toggle Sleep On/Off",  ["Nothing", "Name", "Package", "Sound", "Home Object", "Sleep"], menu_chan);

            menu_expired = 1;

        }
        llSetTimerEvent(30.0);
    }

    timer()
    {
        llListenRemove(menu_listener);
        llListenRemove(name_listener);
        llSetTimerEvent(0.0);
        llSetText("", <1,1,1>, 1.0);
        if (menu_expired) {
            llWhisper(0, "Menu Expired");
            menu_expired = 0;
        }
    }

    link_message(integer sender, integer num, string str, key id)
    {
        if (num == LINK_BREEDNAME) {
            sBreedName = str;
        } else
        if (num == LINK_HUNGRY || num == LINK_HAMOUNT) {
            hunger_amount = (integer)str;
        } else
        if (num == LINK_FOODMINUS) {
            hunger_amount --;
            //eaten ++;
        } else
        if (num == LINK_COLOR1) {
            colour1 = (vector)str;
        } else
        if (num == LINK_COLOR2) {
            colour2 = (vector)str;
        } else
        if (num == LINK_SEX) {
            sex = (integer)str;
        } else
        if (num == LINK_SHINE) {
            shine = (integer)str;
        } else
        if (num == LINK_GLOW) {
            glow = (float)str;
        } else
        if (num == LINK_GEN) {
            gen = (integer)str;
        } else
        if (num == LINK_MAGE) {
            age += (integer)str;
        } else
        if (num == LINK_PREGNANT) {
            pregnant = "Pregnant";
            llSay(API_CHANNEL, "I'm Pregnant!");
        } else
        if (num == LINK_PREGNANCY_TIME) {
            sex = 2;
            if ((integer)str != 0) {
                pregnant = "Pregnant";
            }
        } else
        if (num == LINK_LAY_EGG) {
            pregnant = "";
        } else
        if (num == LINK_SLEEPING) {
            sleep = "\nSleeping";
        } else
        if (num == LINK_UNSLEEPING) {
            sleep = "";
        } else
        if (num == LINK_SPECIAL) {
            special = str;
        } else
        if (num == LINK_SET_HOME) {
            list data = llParseString2List(str, ["^"], []);
            llSetText("Home Set: " + llList2String(data, 0) + " " + llList2String(data, 1) + "m", <1,1,1>, 1.0);
            llSetTimerEvent(15.0);
        }
    }

    listen(integer channel, string name, key id, string msg)
    {
        if (channel == 0 && id == llGetOwner()) {
            list name_parts = llParseString2List(msg, [","], []);
            if (llToLower(llList2String(name_parts, 0)) == "name") {
                string myname = llStringTrim(llList2String(name_parts, 1), STRING_TRIM);

                integer i;

                for (i=0;i<llStringLength(myname);i++) {
                    if (llGetSubString(myname, i, i) == "^") {
                        llWhisper(0, "Sorry, cannot have a \"^\" in the name.");
                        llListenRemove(name_listener);
                        return;
                    }
                }

                llWhisper(0, "My new name is " + myname);
                llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
                llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_WAVE, "");
                llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
                llSetObjectName(myname);
                llListenRemove(name_listener);
            }
        } else if (channel == API_CHANNEL) {
                list data = llParseString2List(msg, ["^"], []);
            if (llList2String(data, 0) == "XSPet" && (key) llList2String(data, 1) == llGetKey()) {
                llSay(API_CHANNEL, "XSPet^" + (string)llGetKey() + "^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)shine + "^" + (string)glow + "^" + special + "^" + (string)gen + "^" + (string)sex + "^" + (string)age + "^XSPetEnd");
            }
        } else if (channel != ANIMAL_CHANNEL) {
                llListenRemove(menu_listener);
            menu_expired = 0;
            if (msg == "Name") {
                llOwnerSay("You have 30 seconds to type a new name: (Format \"name, Charlie\")");
                name_listener = llListen(0, "", llGetOwner(), "");
                llSetTimerEvent(30.0);
            } else
            if (msg == "Package") {
                llMessageLinked(LINK_SET, LINK_PACKAGE, "", "");
            } else
            if (msg == "Sound") {
                if (play_sounds) {
                    llMessageLinked(LINK_SET, LINK_SOUND_OFF, "", "");
                    llWhisper(0, "Turning sound off.");
                } else {
                        llMessageLinked(LINK_SET, LINK_SOUND_ON, "", "");
                    llWhisper(0, "Turning sound on.");
                }
                play_sounds = !play_sounds;
            } else
            if (msg == "Home Object") {
                llGiveInventory(llGetOwner(), HomeObject);
            } else
            if (msg == "Sleep") {
                if (sleep_disabled) {
                    llWhisper(0, "Enabling Sleeping.");
                } else {
                        llWhisper(0, "Disabling Sleeping.");
                }
                sleep_disabled = !sleep_disabled;
                llMessageLinked(LINK_SET, LINK_SLEEP, (string)sleep_disabled, "");
            }
        }
    }
}

