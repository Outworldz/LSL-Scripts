// :CATEGORY:XS Pet
// :NAME:XS Pet Robot
// :AUTHOR:Ferd Frederix
// :KEYWORDS: Pet,XS,breed,breedable,companion,Ozimal,Meeroo,Amaretto,critter,Fennux,Pets
// :CREATED:2013-09-06
// :EDITED:2014-01-30 12:24:21
// :ID:988
// :NUM:1464
// :REV:0.46
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// XS Pet  xs_breeding
// :CODE:

// xs_breeding

// 9-18-2012  exposed some internal timers to make it easier to debug breeding
// 12-26-2012 father = id;  // was on a line by itself, probably a nasty bug
// 3-14-2013 Added a check that integer rest nebver goes negative, or else the pet may stop walking forever.
// Version 0.46 9-18-2013 xs_breeding now has a new variable to delay getting fertile by 1 day after laying an egg.
// Version 0.47 - made the tunable a contants, not a calc.

// tunable for this script
float TIME_TO_WAIT = 86400; // 86400 secs = wait 1 day to get fertile again.






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
// You must attribute authorship in the original scripts to Ferd Frederix and Xundra Snowpaw, and leave this notice intact.
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

string Copyright = " (c)2014 by Ferd Frederix";    // You cannot change this line, but you can change the code that prints it!
// See License agreements above.
//  Attribution is required, as these files are copyrighted. 


DEBUG ( string msg){
    if (debug) {
        llOwnerSay(llGetScriptName() + ":" + msg);
    }
}



///////// end global Link constants ////////

// END OF COPIED CODE












// globals
integer age;                // age in days, starting at 0
integer looking_for_female;

key father;
key mother;

integer preg_time;

default
{
    link_message(integer sender, integer num, string str, key id)
    {
        if (num == LINK_AGE_START) {
            state running;
        }
    }
}

state running
{
    state_entry()
    {
        age = 0;
    }

    link_message(integer sender, integer num, string str, key id)
    {
        if (num == LINK_SEX) {
            if (str == "1") {
                state male;
            } else {
                    state female;
            }
        } else
        if (num == LINK_MAGE) {
            age += (integer)str;
        } else {
            if (num == LINK_PREGNANCY_TIME) {
                preg_time = (integer)str;
                if (preg_time != 0) {
                    state pregnant;
                } else {
                        state female;
                }
            }
        }
    }
}

state male
{
    state_entry()
    {
        looking_for_female = 0;

        mother = NULL_KEY;
        father = NULL_KEY;

        llMessageLinked(LINK_SET, LINK_GET_AGE, "", "");

        if (age >= fDaysToAdult) {
            llSetTimerEvent(SEX_WAIT);    // 3 hours
        }
    }
    link_message(integer sender, integer num, string str, key id)
    {
        if (num == LINK_PUT_AGE) {
            age = (integer)str;
            if (age >= fDaysToAdult) {
                llSetTimerEvent(SEX_WAIT);
            }
        } else
        if (num == LINK_MAGE) {

            age += (integer)str;
            if (age >= fDaysToAdult) {
                llSetTimerEvent(SEX_WAIT);    // look ebvery 3 hours for a female
            }
        } else
        if (num == LINK_FEMALE_ELIGIBLE) {
            if (looking_for_female == 1) {
                looking_for_female = 0;
                mother = id;
                father = llGetKey();
                llMessageLinked(LINK_SET, LINK_CALL_MALE, "", mother);
            }
        } else
        if (num == LINK_RQST_BREED) {
            if (mother != NULL_KEY) {
                llMessageLinked(LINK_SET, LINK_CALL_MALE_INFO, "", mother);          // V0.25 fix error by Ferd, was LINK_CALL_MALE, should be LINK_CALL_MALE_INFO
            }
        } else
        if (num == LINK_MALE_INFO) {
            state male;
        }

    }

    timer()
    {
        looking_for_female = 1;
        // look for an eligible female.
        llWhisper(0, llGetObjectName() + " gets a gleam in his eye.");
        llMessageLinked(LINK_SET, LINK_SEEK_FEMALE, "", "");
    }
}

state female
{
    state_entry()
    {
        mother = NULL_KEY;
        father = NULL_KEY;

        if (age == 0) {
            llMessageLinked(LINK_SET, LINK_GET_AGE, "", "");
        }
    }

    link_message(integer sender, integer num, string str, key id)
    {
        if (num == LINK_MAGE) {
            age += (integer)str;        // add to age
        } else
        if (num == LINK_MALE_BREED_CALL) {
            // signal I am eligible
            if (age >= fDaysToAdult && father == NULL_KEY) {
                llWhisper(0, llGetObjectName() + " blushes then bobs her head up and down.");
                llMessageLinked(LINK_SET, LINK_SIGNAL_ELIGIBLE, "", "");
            }
        } else
        if (num == LINK_MALE_ON_THE_WAY) {
            // male on the way, timeout in 15 minutes
            llSetTimerEvent(MALE_TIMEOUT);        // 20 minutes
            father = id;        // was on a line by itself, probably a nasty bug
            mother = llGetKey();
            llMessageLinked(LINK_SET, LINK_MOVER, (string) MALE_TIMEOUT, "");        // tell mover to rest for 20 minutes
        } else
        if (num == LINK_PREGNANT) {
            // pregnant
            llSetTimerEvent(0);
            preg_time = 0;
            state pregnant;
        } else
        if (num == LINK_MALE_INFO) {
            llSetTimerEvent(0);
            state female;
        } else
        if (num == LINK_PUT_AGE) {
            age = (integer)str;
        } else
        if (num == LINK_PREGNANCY_TIME) {
            preg_time = (integer)str;
            if (preg_time != 0) {
                state pregnant;
            }
        }

    }

    timer()
    {
        llSetTimerEvent(0);
        // fail
        llMessageLinked(LINK_SET, LINK_BREED_FAIL, "", father);
        state female;
    }
}

state pregnant
{
    state_entry()
    {
        if (preg_time != 0) {
            llSetTimerEvent(fPregnancy - (float)(llGetUnixTime() - preg_time));
        } else {
           llSetTimerEvent(fPregnancy);
        }
    }
    timer()
    {
        // lay egg.
        llSetTimerEvent(0);
        llMessageLinked(LINK_SET, LINK_LAY_EGG, "", "");
        state Wait;
    }

    changed(integer change)
    {
        if (change & CHANGED_REGION_START)
        {
            llSetTimerEvent(fPregnancy);
        }
    }
}



state Wait
{
     state_entry()
    {
        llSetTimerEvent(TIME_TO_WAIT);
    }
    timer()
    {
        llSetTimerEvent(0);
        state female;
    }

    changed(integer change)
    {
        if (change & CHANGED_REGION_START)
        {
            llSetTimerEvent(TIME_TO_WAIT);
        }
    }
}
