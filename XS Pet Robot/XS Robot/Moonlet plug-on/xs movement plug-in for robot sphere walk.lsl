// :CATEGORY:XS Pet
// :NAME:XS Pet Robot
// :AUTHOR:Ferd Frederix
// :KEYWORDS: Pet,XS,breed,breedable,companion,Ozimal,Meeroo,Amaretto,critter,Fennux,Pets
// :CREATED:2013-09-06
// :EDITED:2014-01-30 12:24:20
// :ID:988
// :NUM:1443
// :REV:0.50
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// XS Pet xs_movement (for walking on a globe )

// :CODE:

// xs_movement ( for walking on a globe )
// this replaces xs_movement in xs+pets and lets them live on a sphere
//  The prim animation must be flipped to the bottom of the root prim since the prim will face inwards.






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
float FOOD_BOWL_SCAN_INTERVAL = 1800.0;	// look for food every 3 hours
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












vector home_location;
float roam_distance;
list food_bowls;
list food_bowl_keys;
list food_bowl_time;

vector destination;

integer sex_dest = 0;
integer food_dest = 0;
float tolerance = 0.15;
float increment = 0.1;
integer rest;
integer age;
float zoffset;
integer sleep_last_check ;
integer sound_on;
integer sleep_disabled;


//new mover on a sphere
float RADIUS = 1.0;
rotation gOrient;
list gSilly_walks;
integer gCounter;



GetNewPos()
{
    // start over and calc a new walk

    gSilly_walks = [];


    float x = llFrand(5) + 5;

    float y = llFrand(5) + 5;

    float z = llFrand(5) + 5;

    if (llFrand(2) > 1)
        x = 1-x;
    if (llFrand(2) > 1)
        y = 1-z;
    if (llFrand(2) > 1)
        z = 1-z;


    rotation delta = llEuler2Rot(<x,y,z> * DEG_TO_RAD);

    integer STEPS = llCeil( llFrand(10)) + 1;
    integer i;
    for (i = 0; i < STEPS; i++)
    {
        vector unitpos = llRot2Fwd( gOrient );
        vector pos = home_location + unitpos * RADIUS;

        gSilly_walks += pos;
        gSilly_walks += gOrient;

        gOrient = gOrient * delta;
    }



}




face_target(vector lookat) {

    rotation rot = llGetRot() * llRotBetween(<1.0 ,0.0 ,0.0 > * llGetRot(), lookat - llGetPos());


    llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_WALKL, "");
    llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_WALKR, "");

    vector nine = <90,0,0> * DEG_TO_RAD;
    rotation new = llEuler2Rot(nine);


    llSetRot(rot * new);
    llSleep(.1);

    rot = llGetRot() * llRotBetween(<0.0 ,0.0 ,1.0 > * llGetRot(), home_location - llGetPos());
    llSetRot(rot * new);
}

integer sleeping()
{
    vector sun = llGetSunDirection();
    if (!sleep_disabled) {
        if (sun.z < 0) {
            if (sleep_last_check == 0) {
                // close eyes
                llMessageLinked(LINK_SET, LINK_SLEEPING, "", "");
                llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_SLEEP, "");
            }
            sleep_last_check = 1;
        } else {
                if (sleep_last_check == 1) {
                    // open eyes
                    llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
                    llMessageLinked(LINK_SET, LINK_UNSLEEPING, "", "");
                }
            sleep_last_check = 0;
        }
        return sleep_last_check;
    } else {
            if (sleep_last_check == 1) {
                llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
                llMessageLinked(LINK_SET, LINK_UNSLEEPING, "", "");
                sleep_last_check = 0;
            }
        return 0;
    }
}

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
        gOrient = ZERO_ROTATION;
        home_location = <0,0,0>;
        roam_distance = 0;
        destination = <0,0,0>;
        age = 0;
        sleep_last_check = 0;
        sound_on = 1;
    }


    timer()
    {


        if (!sleeping())
        {
            if (sound_on) {
                llMessageLinked(LINK_SET, LINK_SOUND, "", "");
            }
            sound_on = !sound_on;

            if (rest >  0) {
                // llSetText((string) rest,<1,0,0>,1);
                rest--;
                return;
            }

            if (llVecDist( destination, llGetPos()) <= tolerance || destination == <0,0,0>)
            {
                // if at food_destination send 900 msg
                if (food_dest > 0) {
                    llMessageLinked(LINK_SET, LINK_FOOD_CONSUME, (string)food_dest, llList2Key(food_bowl_keys, 0));
                }

                if (sex_dest > 0) {

                    llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_WAVE, "");
                    llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
                    llMessageLinked(LINK_SET, LINK_RQST_BREED, "", "");

                }
                // pick a new destination
                sex_dest = 0;
                food_dest = 0;

            }


            integer walkLength = llGetListLength(gSilly_walks);
            if ( walkLength > 0)
            {
                vector pos = llList2Vector(gSilly_walks,0);
                rotation  orient = llList2Rot(gSilly_walks,1);

                gCounter++;
                face_target(pos);
                llSetPos(pos);



                //llSetRot(orient);

                gSilly_walks = llDeleteSubList(gSilly_walks,0,1);                  // we have walked in those shoes
            }
            else
            {
                GetNewPos();

                rest = (integer)llFrand(12.0);      // 1 minute rest
                //llOwnerSay("resting for " + (string) rest);
            }

            llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_WALKL, "");
            llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_WALKR, "");
            llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");

        }
    }

    link_message(integer sender, integer num, string str, key id)
    {
        if (num == LINK_HUNGRY) {
            if (sex_dest == 0) {
                // move to food bowl, then send 900
                if (llGetListLength(food_bowl_keys) > 0) {
                    if (roam_distance == 0 || home_location == <0,0,0>) {
                        llOwnerSay("I'm hungry, but I'm not homed so I can not move! Attempting to use Jedi Mind Powers to teleport food to my belly.");
                        llMessageLinked(LINK_SET, LINK_FOOD_CONSUME, str, llList2Key(food_bowl_keys, 0));
                        llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
                        llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_WAVE, "");
                        llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
                    } else {
                            // find nearest food bowl
                            integer i;
                        destination = (vector)llList2String(food_bowls, 0);
                        for (i=1;i<llGetListLength(food_bowls);i++) {
                            if (llVecDist(destination, llGetPos()) > llVecDist((vector)llList2String(food_bowls, i), llGetPos())) {
                                destination = (vector)llList2String(food_bowls, i);
                            }
                        }
                        destination.z = home_location.z + zoffset;
                        // set destination,
                        // face it
                        face_target(destination);
                        food_dest = (integer)str;
                        rest = 0;
                        //llMessageLinked(LINK_SET, LINK_FOOD_CONSUME, str, llList2Key(food_bowl_keys, 0));
                    }
                } else {
                        llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
                    llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_WAVE, "");
                    llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
                    llOwnerSay("I'm hungry, but I can't seem to find any food bowls at present.");
                }
            }
        } else
        if (num == LINK_SET_HOME) {
            list values = llParseString2List(str, ["^"], []);
            home_location = (vector)llList2String(values, 0);
            roam_distance = llList2Float(values, 1);
            vector current_loc = llGetPos();

            food_bowls = [];
            food_bowl_keys = [];
            food_bowl_time = [];

            destination = <0,0,0>;
            food_dest = 0;
            llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
            llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_WAVE, "");
            llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");

            GetNewPos();
            llSetTimerEvent(4.0);

            llOwnerSay("Homed");

        } else
        if (num == LINK_MOVER) {
            if (rest < (integer)str) {
                rest = (integer)str;
            }
        } else
        if (num == LINK_FOODIE_CLR) {
            food_bowls = [];
            food_bowl_keys = [];
            food_bowl_time = [];
        } else
        if (num == LINK_FOODIE) {
            vector food_loc = (vector)str;

            if (llVecDist(home_location, food_loc) <= roam_distance && llFabs(llFabs(home_location.z) - llFabs(food_loc.z)) < 2) {
                if(llListFindList(food_bowls, (list)str) == -1) {
                    integer id_pos = llListFindList(food_bowl_keys, (list)id);
                    if (id_pos == -1) {
                        food_bowls += str;
                        food_bowl_keys += id;
                        food_bowl_time += llGetUnixTime();
                    } else {
                            food_bowls = llListReplaceList(food_bowls, [str], id_pos, id_pos);
                        food_bowl_time  = llListReplaceList(food_bowl_time, [llGetUnixTime()], id_pos, id_pos);
                    }
                }

                integer iter;

                iter = 0;

                while(iter<llGetListLength(food_bowls)) {
                    if (llGetUnixTime() - llList2Integer(food_bowl_time, iter) > 3600) {//3600
                        food_bowls = llDeleteSubList(food_bowls, iter, iter);
                        food_bowl_keys = llDeleteSubList(food_bowl_keys, iter, iter);
                        food_bowl_time = llDeleteSubList(food_bowl_time, iter, iter);
                    } else {
                            iter++;
                    }
                }

                if (llGetListLength(food_bowls) > 0) {
                    llMessageLinked(LINK_SET, LINK_TIMER, "", "");
                }

            }
        } else
        if (num == LINK_FEMALE_LOCATION) {
            destination = (vector)str;
            face_target(destination);
            rest = 0;
            food_dest = 0;
            sex_dest = 1;
            llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
            llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_WAVE, "");
            llMessageLinked(LINK_SET, LINK_ANIMATE, ANI_STAND, "");
        } else
        if (num == LINK_MAGE) {
            integer heightm;
            age += (integer)str;
            heightm = age;

            if (heightm > MaxAge)
                heightm = MaxAge;
            float new_scale = (GROWTH_AMOUNT * heightm) + 1.0;

            float legsz = 0.064 * new_scale;        /// !!! does this need scaling?
            float legso = 0.052399 * new_scale;

            zoffset = 0 ;// no offset
        } else
        if (num == LINK_SLEEP) {
            sleep_disabled = (integer)str;
        }
    }
}



