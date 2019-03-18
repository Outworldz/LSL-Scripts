// :CATEGORY:XS Pet
// :NAME:XS Pet Robot
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS: Pet,XS,breed,breedable,companion,Ozimal,Meeroo,Amaretto,critter,Fennux,Pets
// :CREATED:2013-09-06
// :EDITED:2014-01-30 12:24:21
// :ID:988
// :NUM:1463
// :REV:0.50
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// XS Pet  xs_brain

// :CODE:


// xs_brain

// 8-17-2012 patch changes CONST 28 to PRIM_DESC in several places for otherworld compatibility now that the LSLEditor supports PRIM_DESC
// 3-25-2013 fixed on rez for opensim where pet did not sync with egg
// 4-10-2013 V 0.43 Lots of casting to fix Opensim 0.7.4 failures to parse llList2Float and llList2Integer when there are strings in the list
// 11-16-2013 no rev bump, just a test to make sure the revsions match everywhere

// tunable numbers just for the brain

integer SECURE = FALSE;  // Set this to true to check that the script names and counts match exactly.
// This double-checks that pets have the correct scripts in them, but it causes grief to new users.






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










// code begins





// DON'T CHANGE THE FOLLOWING! (Unless you know what you are doing!)

integer XTEA_DELTA      = 0x9E3779B9; // (sqrt(5) - 1) * 2^31
integer xtea_num_rounds = 6;
list    xtea_key        = [0, 0, 0, 0];

integer hex2int(string hex) {
    if(llGetSubString(hex,0,1) == "0x")
        return (integer)hex;
    if(llGetSubString(hex,0,0) == "x")
        return (integer)("0"+hex);
    return(integer)("0x"+hex);
}


// Convers any string to a 32 char MD5 string and then to a list of
// 4 * 32 bit integers = 128 bit Key. MD5 ensures always a specific
// 128 bit key is generated for any string passed.
list xtea_key_from_string( string str )
{
    str = llMD5String(str,0); // Use Nonce = 0
    return [    hex2int(llGetSubString(  str,  0,  7)),
        hex2int(llGetSubString(  str,  8,  15)),
        hex2int(llGetSubString(  str,  16,  23)),
        hex2int(llGetSubString(  str,  24,  31))];
}

// Encipher two integers and return the result as a 12-byte string
// containing two base64-encoded integers.
string xtea_encipher( integer v0, integer v1 )
{
    integer num_rounds = xtea_num_rounds;
    integer sum = 0;
    do {
        // LSL does not have unsigned integers, so when shifting right we
        // have to mask out sign-extension bits.
        v0  += (((v1 << 4) ^ ((v1 >> 5) & 0x07FFFFFF)) + v1) ^ (sum + llList2Integer(xtea_key, sum & 3));
        sum +=  XTEA_DELTA;
        v1  += (((v0 << 4) ^ ((v0 >> 5) & 0x07FFFFFF)) + v0) ^ (sum + llList2Integer(xtea_key, (sum >> 11) & 3));

    } while( num_rounds = ~-num_rounds );
    //return only first 6 chars to remove "=="'s and compact encrypted text.
    return llGetSubString(llIntegerToBase64(v0),0,5) +
        llGetSubString(llIntegerToBase64(v1),0,5);
}

// Decipher two base64-encoded integers and return the FIRST 30 BITS of
// each as one 10-byte base64-encoded string.
string xtea_decipher( integer v0, integer v1 )
{
    integer num_rounds = xtea_num_rounds;
    integer sum = XTEA_DELTA*xtea_num_rounds;
    do {
        // LSL does not have unsigned integers, so when shifting right we
        // have to mask out sign-extension bits.
        v1  -= (((v0 << 4) ^ ((v0 >> 5) & 0x07FFFFFF)) + v0) ^ (sum + llList2Integer(xtea_key, (sum>>11) & 3));
        sum -= XTEA_DELTA;
        v0  -= (((v1 << 4) ^ ((v1 >> 5) & 0x07FFFFFF)) + v1) ^ (sum + llList2Integer(xtea_key, sum  & 3));
    } while ( num_rounds = ~-num_rounds );

    return llGetSubString(llIntegerToBase64(v0), 0, 4) +
        llGetSubString(llIntegerToBase64(v1), 0, 4);
}

// Encrypt a full string using XTEA.
string xtea_encrypt_string( string str )
{
    if (! ENCRYPT)
        return str;
    // encode string
    str = llStringToBase64(str);
    // remove trailing =s so we can do our own 0 padding
    integer i = llSubStringIndex( str, "=" );
    if ( i != -1 )
        str = llDeleteSubString( str, i, -1 );

    // we don't want to process padding, so get length before adding it
    integer len = llStringLength(str);

    // zero pad
    str += "AAAAAAAAAA=";

    string result;
    i = 0;

    do {
        // encipher 30 (5*6) bits at a time.
        result += xtea_encipher(llBase64ToInteger(llGetSubString(str,   i, i + 4) + "A="), llBase64ToInteger(llGetSubString(str, i+5, i + 9) + "A="));
        i+=10;
    } while ( i < len );

    return result;
}

// Decrypt a full string using XTEA
string xtea_decrypt_string( string str ) {
    if (! ENCRYPT)
        return str;
    integer len = llStringLength(str);
    integer i=0;
    string result;
    //llOwnerSay(str);
    do {
        integer v0;
        integer v1;

        v0 = llBase64ToInteger(llGetSubString(str,   i, i + 5) + "==");
        i+= 6;
        v1 = llBase64ToInteger(llGetSubString(str,   i, i + 5) + "==");
        i+= 6;

        result += xtea_decipher(v0, v1);
    } while ( i < len );

    // Replace multiple trailing zeroes with a single one

    i = llStringLength(result) - 1;
    while ( llGetSubString(result, i - 1, i) == "AA" ){
        result = llDeleteSubString(result, i, i);
        i--;
    }
    i = llStringLength(result) - 1;
    //    while (llGetSubString(result, i, i + 1) == "A" ) {
    //        i--;
    //    }
    result = llGetSubString(result, 0, i+1);
    i = llStringLength(result);
    integer mod = i%4; //Depending on encoded length diffrent appends are needed
    if(mod == 1) result += "A==";
    else if(mod == 2 ) result += "==";
    else if(mod == 3) result += "=";

    return llBase64ToString(result);
}

string base64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";


integer setup = FALSE; // added to cure opensim rezzing issue
integer random_number;         // food bowl chatted key
integer random_number2;        // food bowl chatted key
integer hunger_amount;         // from 0 to 30

// breedeable numbers
vector colour1;
vector colour2;
integer sex;
integer shine;
float glow;
integer gen;
integer age;
// Male
vector mcolour1;    // male color for the famel to breed against, and so on
vector mcolour2;
integer mshine;
float mglow;
integer mgen;
integer glow_gene;
string special;
integer mglow_gene;

// globals
vector home_loc;        // where the home post is chatted to us
key new_egg_key;        // egg key of a laid egg so we can give a egg and animal to it

integer locked;        // global flag for crate PING and PONG
integer pregnancy_time;// clock time we have been pregnant





// change the color of any prim named 'color1' or color2'
Color(integer colornum, vector color, integer shine, float glow )
{


    integer nPrims = llGetNumberOfPrims();
    integer i;
    for (i = 1; i <= nPrims; i++)
    {
        list param = llGetLinkPrimitiveParams(i,[PRIM_DESC]);
        string desc = llList2String(param,0);

        if (llToLower(desc) == "color1" && colornum == 1 )
        {
            llSetLinkPrimitiveParamsFast(i, [PRIM_COLOR, ALL_SIDES, color, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
        }
        else if (llToLower(desc) == "color2" && colornum == 2 )
        {
            llSetLinkPrimitiveParamsFast(i, [PRIM_COLOR, ALL_SIDES, color, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
        }
    }
}


// sets all prims to have a PRIM_BUMP_SHINY that have a color1 or a color2 in the description.
Shine(integer shine)
{
    integer nPrims = llGetNumberOfPrims();
    integer i;
    for (i = 1; i <= nPrims; i++)
    {
        list param = llGetLinkPrimitiveParams(i,[PRIM_DESC]);
        string desc = llList2String(param,0);

        if (llToLower(desc) == "color1" || llToLower(desc) == "color2"  )
        {
            llSetLinkPrimitiveParamsFast(i, [PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE]);
        }
    }
}

// sets all prims to have a PRIM_BUMP_SHINY and color  that have a eye in the description.
Eye(vector color, integer shine)
{
    integer nPrims = llGetNumberOfPrims();
    integer i;
    for (i = 1; i <= nPrims; i++)
    {
        list param = llGetLinkPrimitiveParams(i,[PRIM_DESC]);        // 28 should be PRIM_DESC but lsleditor is old and does not support this.
        string desc = llList2String(param,0);

        if (llToLower(desc) == "eye" )
        {
            llSetLinkPrimitiveParamsFast(i, [PRIM_COLOR, ALL_SIDES, color, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE]);
        }
    }
}

// allow either a UUID to be entered, or not, and still maintain security
integer CheckPerms()
{
    if (YOUR_UUID != "" && llGetOwner() != YOUR_UUID)
        return 1;

    if (llGetOwner() != llGetCreator())
        return 1;

    return 0;
}


default
{
    state_entry()
    {
        if (CheckPerms()) {
            llOwnerSay("Someone not the creator reset the script. That's naughty.");
            state dead;
        }

        if ((integer) 0)        // set to TRUE to play with colors
        {
            llOwnerSay("Color Test");
            Color(1, <1,0,0>, 0, 0);
            Color(2, <0,1,0>, 0, 0);
            llSleep(2);
            Color(1, <0,0,1>, 0, 0);
            Color(2, <0,0,0>, 0, 0);
            llSleep(1);
            Color(1, <1,1,1>, 0, 0);
            Color(2, <1,1,1>, 0, 0);
        }

        llSetText("", <1,1,1>, 1.0);
        random_number = 0;
        random_number2 = 0;
        hunger_amount = 0;
        locked = 0;

        xtea_key = xtea_key_from_string(SECRET_PASSWORD);
        llListen(ANIMAL_CHANNEL, "", "", "");
    }

    changed(integer change)
    {

        if (change & CHANGED_ALLOWED_DROP) {
            if (llGetInventoryType(FemaleName) != INVENTORY_NONE  && llGetInventoryType(MaleName) != INVENTORY_NONE && llGetInventoryType(Egg) != INVENTORY_NONE) {
                llAllowInventoryDrop(FALSE);
            }
        }

        if (change & CHANGED_INVENTORY) {
            if ( CheckPerms() ) {

                integer inventory_count = llGetInventoryNumber(INVENTORY_ALL);
                integer extras = 4;

                if (SECURE)    // set this to TRUE to do extra security checks
                {

                    if (llGetInventoryType("xs_ager") == INVENTORY_NONE || !llGetScriptState("xs_ager")) {
                        llOwnerSay("no xs_ager");
                        state dead;
                    }
                    if (llGetInventoryType("xs_infomatic") == INVENTORY_NONE || !llGetScriptState("xs_infomatic")) {
                        llOwnerSay("no xs_infomatic");
                        state dead;
                    }
                    if (llGetInventoryType("xs_breeding") == INVENTORY_NONE || !llGetScriptState("xs_breeding")) {
                        llOwnerSay("no xs_breeding");
                        state dead;
                    }
                    if (llGetInventoryType("xs_eater") == INVENTORY_NONE || !llGetScriptState("xs_eater")) {
                        llOwnerSay("no xs_eater");
                        state dead;
                    }
                    if (llGetInventoryType("xs_movement") == INVENTORY_NONE || !llGetScriptState("xs_movement")) {
                        llOwnerSay("no xs_movement");
                        state dead;
                    }


                    if (llGetInventoryType("xs_special") == INVENTORY_NONE) {
                        llOwnerSay("no xs_special");
                        extras--;
                    }

                    if (llGetInventoryType(Egg) == INVENTORY_NONE) {
                        extras--;
                    }

                    if (llGetInventoryType(MaleName) == INVENTORY_NONE) {
                        extras--;
                    }

                    if (llGetInventoryType(FemaleName) == INVENTORY_NONE) {
                        extras--;
                    }

                    if (llGetInventoryType(HomeObject) == INVENTORY_NONE) {
                        state dead;
                    }

                    if (8 + extras != inventory_count) {
                        llOwnerSay("Count wrong, was " + (string) (8 + extras) + " should be " + (string) inventory_count);
                        state dead;
                    }
                }
            }
        }
    }

    timer()
    {
         // for OpenSIm to establish an on_rez, the durn thing does not for the onrez even in the egg unless the script goes idle
        if (setup == TRUE)
        {
            llSay(EGG_CHANNEL, xtea_encrypt_string("XSPET^READY^" + (string)llGetKey() + "^XSPET"));
            llSay(BOX_CHANNEL, xtea_encrypt_string("XSPET^READY^" + (string)llGetKey() + "^XSPET"));
            setup = FALSE;
            return;
        }



        llMessageLinked(LINK_SET, LINK_FOODIE_CLR, "", "");
        // llWhisper(0, "Scanning for food bowls.");
        random_number = (integer)(llFrand(10000.0) + 1);
        llSay(FOOD_CHANNEL, xtea_encrypt_string("XSPET^FOOD_LOCATION^" + (string)random_number + "^" + (string)llGetKey()));
        llSetTimerEvent(llFrand(60.0) + (FOOD_BOWL_SCAN_INTERVAL - 30.0));
    }

    listen(integer channel, string name, key id, string message)
    {
        if (channel == ANIMAL_CHANNEL) {
            list data = llParseString2List(xtea_decrypt_string(message), ["^"], []);

            DEBUG(llDumpList2String(data,","));
            
            if (llList2String(data, 0) == "XSPET") {
                if (llList2String(data, 1) == "FOOD_LOCATION") {
                    llMessageLinked(LINK_SET, LINK_FOODIE, llList2String(data, 3), id);
                } else
                if (llList2String(data, 1) == "FOOD_CONSUME") {
                    if ((integer) llList2String(data, 2) == random_number2 && (key) llList2String(data, 3) == llGetKey()) {
                        hunger_amount--;
                        llMessageLinked(LINK_SET, LINK_FOODMINUS, "", "");
                        random_number2 = 0;
                        if ((integer) llList2String(data, 4) == 1 && glow_gene < 10) {
                            glow_gene ++;
                        }
                    }
                } else
                if (llList2String(data, 1) == "HOME_LOCATION") {
                    vector n_home_loc = (vector)llList2String(data, 2);
                    float home_dis = (float) llList2String(data, 3);
                    vector my_loc = llGetPos();
                    //                llOwnerSay((string)llVecDist(home_loc, my_loc) + " " + (string)my_loc + (string)home_loc + (string)home_dis + llList2String(data, 2));
                    if (llVecDist(n_home_loc, my_loc) <= home_dis && llFabs(llFabs(n_home_loc.z) - llFabs(my_loc.z)) < 1) {
                        if (llGetOwnerKey(id) == llGetOwner()) {
                            home_loc = n_home_loc;
                            llMessageLinked(LINK_SET, LINK_SET_HOME, (string)n_home_loc + "^" + (string)home_dis, "");
                        }
                    }
                } else
                    if (llList2String(data, 1) == "CONFIG" && (key) llList2String(data, 2) == llGetKey()) {

                    llMessageLinked(LINK_SET, LINK_AGE_START, "", "");  // start the pet up!
                    colour1  = (vector) llList2String(data, 3);
                    colour2 = (vector) llList2String(data, 4);    // 0.43 4-1-2013  Opensim requires the cast


                    sex = (integer) llList2String(data, 5);

                    shine = (integer)llList2String(data, 6);
                    glow = (float) llList2String(data, 7);

                    gen = (integer) llList2String(data, 8);
                    integer mage = (integer) llList2String(data, 9);
                    integer hamount = (integer)llList2String(data, 10);
                    string myname = llList2String(data, 11);
                    glow_gene = (integer) llList2String(data, 12);
                    special = llList2String(data, 13);

                    Color(1,colour1, shine, glow); // set prims labeled color1 to color 1
                    Color(2,colour2, shine, glow); // set prims labeled color2 to color 2

                    // v.36 added texture plugin
                    string msg = (string) colour1 + "^" +
                        (string) colour2 + "^" +
                        (string) sex + "^" +        // sex should be a 1 or a 2
                        (string) shine + "^" +
                        (string) glow + "^";

                    
                    llSleep(2);  //give opensim time to switch states *sighs *

                    llMessageLinked(LINK_SET,LINK_TEXTURE,msg,NULL_KEY);        // tell the optional texture plugin

                    llSetTimerEvent(llFrand(60.0) + (FOOD_BOWL_SCAN_INTERVAL - 30.0));

                    llMessageLinked(LINK_SET, LINK_COLOR1, (string)colour1, "");
                    llMessageLinked(LINK_SET, LINK_COLOR2, (string)colour2, "");
                    llMessageLinked(LINK_SET, LINK_SEX, (string)sex, "");
                    llMessageLinked(LINK_SET, LINK_SHINE, (string)shine, "");
                    llMessageLinked(LINK_SET, LINK_GLOW, (string)glow, "");
                    llMessageLinked(LINK_SET, LINK_GEN, (string)gen, "");
                    llMessageLinked(LINK_SET, LINK_MAGE, (string)mage, "");

                    if (hamount > 0) {
                        llMessageLinked(LINK_SET, LINK_HAMOUNT, (string)hamount, "");
                    }

                    if (name != MaleName && name != FemaleName) {
                        llSetObjectName(myname);
                    }

                    if (sex == 1)
                        llSetObjectDesc(MaleName + "v" + (string)VERSION + Copyright);
                    else
                        llSetObjectDesc(FemaleName + "v" + (string)VERSION + Copyright);

                    llMessageLinked(LINK_SET, LINK_SPECIAL, special, "");
                    llMessageLinked(LINK_SET, LINK_DAYTIME, "", "");

                    llSay(HOME_CHANNEL, "XSPET_PING_HOME");

                    llSetText("", <1,1,1>, 1.0);
                } else
                if (llList2String(data, 1) == "UPDATE_CONFIG" && (key) llList2String(data, 2) == llGetKey()) {
                    colour1  = (vector) llList2String(data, 3);;
                    colour2 = (vector) llList2String(data, 4);

                    sex = (integer) llList2String(data, 5);

                    shine = (integer) llList2String(data, 6);
                    glow = (float) llList2String(data, 7);

                    gen = (integer) llList2String(data, 8);
                    integer mage = (integer) llList2String(data, 9);
                    integer hamount = (integer) llList2String(data, 10);
                    string myname = llList2String(data, 11);
                    glow_gene = (integer) llList2String(data, 12);
                    special = llList2String(data, 13);
                    mcolour1 = (vector) llList2String(data, 14);
                    mcolour2 = (vector) llList2String(data, 15);
                    mshine = (integer) llList2String(data, 16);
                    mglow = (float) llList2String(data, 17);
                    mgen = (integer) llList2String(data, 18);
                    mglow_gene = (integer) llList2String(data, 19);
                    pregnancy_time = (integer) llList2String(data, 20);

                    Color(1,colour1,shine,glow);
                    Color(2,colour2,shine,glow);

                    // v.36 added txture plugin
                    string msg = (string) colour1 + "^" +
                        (string) colour2 + "^" +
                        (string) sex + "^" +
                        (string) shine + "^" +
                        (string) glow + "^";

                    llMessageLinked(LINK_SET, LINK_AGE_START, "", "");  // start the pet up!
                    llSleep(2);  //give opensim time to switch states *sighs *


                    llMessageLinked(LINK_SET,LINK_TEXTURE,msg,NULL_KEY);        // tell the optional texture plugin

                    llSetTimerEvent(llFrand(60.0) + (FOOD_BOWL_SCAN_INTERVAL - 30.0));

                    llMessageLinked(LINK_SET, LINK_COLOR1, (string)colour1, "");
                    llMessageLinked(LINK_SET, LINK_COLOR2, (string)colour2, "");

                    if (sex == 1) {
                        llMessageLinked(LINK_SET, LINK_SEX, (string)sex, "");
                    } else {
                            llMessageLinked(LINK_SET, LINK_PREGNANCY_TIME, (string)pregnancy_time, "");
                    }

                    llMessageLinked(LINK_SET, LINK_SHINE, (string)shine, "");
                    llMessageLinked(LINK_SET, LINK_GLOW, (string)glow, "");
                    llMessageLinked(LINK_SET, LINK_GEN, (string)gen, "");


                    llMessageLinked(LINK_SET, LINK_MAGE, (string)mage, "");


                    if (hamount > 0) {
                        llMessageLinked(LINK_SET, LINK_HAMOUNT, (string)hamount, "");
                    }

                    if (name != FemaleName && name != MaleName) {
                        llSetObjectName(myname);
                    }

                    if (sex == 1)
                        llSetObjectDesc(MaleName + " version " + (string)VERSION + Copyright);
                    else
                        llSetObjectDesc(FemaleName + " version " + (string)VERSION + Copyright);

                    llMessageLinked(LINK_SET, LINK_SPECIAL, special, "");

                    llMessageLinked(LINK_SET, LINK_DAYTIME, "", "");
                    
                    llSay(HOME_CHANNEL, "XSPET_PING_HOME");

                    llSetText("", <1,1,1>, 1.0);
                } else
                if (llList2String(data, 1) == "CRATE_PONG" && (key) llList2String(data, 2) == llGetKey()) {
                    if ((float) llList2String(data, 3) >= VERSION && locked == 0) {
                        locked = 1;
                        llSay(BOX_CHANNEL, xtea_encrypt_string("XSPET^" + (string)id + "^" + (string    )colour1 + "^" + (string)colour2 + "^" + (string)shine + "^" + (string)glow + "^" + (string)gen + "^" + (string)sex + "^" + (string)age + "^" + (string)hunger_amount + "^" + llGetObjectName() + "^" + (string)glow_gene + "^" + special));
                    }
                } else
                if (llList2String(data, 1) == "CRATE_DIE" && (key) llList2String(data, 2) == llGetKey()) {
                    llDie();
                } else
                if (llList2String(data, 1) == "MALE_BREED_CALL") {
                    llMessageLinked(LINK_SET, LINK_MALE_BREED_CALL, "", "");
                } else
                if (llList2String(data, 1) == "FEMALE_ELIGIBLE" && home_loc == (vector)llList2String(data, 2)) {
                    llMessageLinked(LINK_SET, LINK_FEMALE_ELIGIBLE, "", id);
                } else
                if  (llList2String(data, 1) == "MALE_ON_THE_WAY" && (key) llList2String(data, 2) == llGetKey()) {
                    llMessageLinked(LINK_SET, LINK_MALE_ON_THE_WAY, "", id);
                    llSay(ANIMAL_CHANNEL, xtea_encrypt_string("XSPET^FEMALE_LOC^" + (string)id + "^" + (string)llGetPos()));
                } else
                if (llList2String(data, 1) == "FEMALE_LOC" && (key) llList2String(data, 2) == llGetKey())  // missing key cast - Ferd
                {
                    llMessageLinked(LINK_SET, LINK_FEMALE_LOCATION, llList2String(data, 3), "");
                } else
                if (llList2String(data, 1) == "MALE_INFO" && (key) llList2String(data, 2) == llGetKey()){
                    // pregnant
                    mcolour1 = (vector) llList2String(data, 3);
                    mcolour2 = (vector) llList2String(data, 4);

                    mshine = (integer) llList2String(data, 5);
                    mglow = (float) llList2String(data, 6);

                    mgen = (integer) llList2String(data, 7);
                    mglow_gene = (integer) llList2String(data, 8);
                    pregnancy_time = llGetUnixTime();
                    llMessageLinked(LINK_SET, LINK_PREGNANT, "", "");
                } else
                if (llList2String(data, 1) == "BREEDING_FAIL" && (key) llList2String(data, 2) == llGetKey())  // was missing key cast - Ferd
                {
                    llMessageLinked(LINK_SET, LINK_MALE_INFO, "", "");
                } else
                if (llList2String(data, 1) == "EGG_READY" && id == new_egg_key)
                {
                    llGiveInventory(id, Egg);
                    llGiveInventory(id, MaleName);
                    llGiveInventory(id, FemaleName);

                    llSay(EGG_CHANNEL, xtea_encrypt_string("XSPET^" + (string)id + "^BORN^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)gen + "^" + (string)shine + "^" + (string)glow + "^" + (string)glow_gene + "^" + (string)mcolour1 + "^" + (string)mcolour2 + "^" + (string)mgen + "^" + (string)mshine + "^" + (string)mglow + "^" + (string)mglow_gene));
                } else
                if (llList2String(data, 1) == "SHINE_GOO" && (key) llList2String(data, 2) == llGetKey()) {   
                    if (shine == 0) {
                        shine = 1;
                        llMessageLinked(LINK_SET, LINK_SHINE, (string)shine, "");
                        llSay(ACC_CHANNEL, xtea_encrypt_string("XSPET^" + (string)id + "^SHINE_GOO_DIE"));

                        Shine(shine);

                        if (sex == 1) {
                            llWhisper(0, "Look out ladies, Mr Slick has arrived!");
                        } else {
                                llWhisper(0, "Look out gentlemen! Miss Slick has arrived!");
                        }
                    } else {
                            llWhisper(0, "I'm already shiny!");
                        llSay(ACC_CHANNEL, xtea_encrypt_string("XSPET^" + (string)id + "^SHINE_GOO_FAIL"));
                    }
                } else
                if (llList2String(data, 1) == "DIE" && (key) llList2String(data, 2) == llGetKey()) {  
                    llDie();
                } else
                if (llList2String(data, 1) == "VERSION" && VERSION < (float) llList2String(data, 2) && llGetOwnerKey(id) == llGetOwner()) {
                    llShout(UPDATE_CHANNEL, "VERSION^" + (string)VERSION);
                } else
                if (llList2String(data, 1) == "UPDATE" && (key) llList2String(data, 2) == llGetKey() && llGetOwnerKey(id) == llGetOwner()) {   // missing key cast - Ferd
                    state update;
                }
            }
        }
    }

    link_message(integer sender, integer num, string str, key id)
    {
        if (num == LINK_HUNGRY || num == LINK_HAMOUNT) {
            hunger_amount = (integer)str;
            if (hunger_amount > MAXIMUM_HUNGER) {     // usually 30, see globals
                state dead;
            }
        } else
        if (num == LINK_FOOD_CONSUME) {
            random_number2 = (integer)(llFrand(10000.0) + 1);
            llSay(FOOD_CHANNEL, xtea_encrypt_string("XSPET^FOOD_CONSUME^" + (string)id + "^" + (string)random_number2 + "^" + (string)llGetKey()));
        } else
        if (num == LINK_MAGE) {
            age += (integer)str;
        } else
        if (num == LINK_PACKAGE) {
            llWhisper(0, "Looking for a " + Crate + "...");
            llSay(BOX_CHANNEL, xtea_encrypt_string("XSPET^" + (string)llGetKey() + "^CRATE_PING^" + (string)VERSION));
        } else
        if (num == LINK_SEEK_FEMALE) {
            llSay(ANIMAL_CHANNEL, xtea_encrypt_string("XSPET^MALE_BREED_CALL^" + (string)llGetKey()));
        } else
        if (num == LINK_SIGNAL_ELIGIBLE) {
            llSay(ANIMAL_CHANNEL, xtea_encrypt_string("XSPET^FEMALE_ELIGIBLE^" + (string)home_loc));
        } else
        if (num == LINK_CALL_MALE) {
            llSay(ANIMAL_CHANNEL, xtea_encrypt_string("XSPET^MALE_ON_THE_WAY^" + (string)id));
        } else
        if (num == LINK_CALL_MALE_INFO) {
            llSay(ANIMAL_CHANNEL, xtea_encrypt_string("XSPET^MALE_INFO^" + (string)id + "^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)shine + "^" + (string)glow + "^" + (string)gen + "^" + (string)glow_gene));
            llMessageLinked(LINK_SET, LINK_MALE_INFO, "", "");
        } else
        if (num == LINK_LAY_EGG) {
            // lay an egg
            pregnancy_time = 0;
            llRezObject(Egg, llGetPos() + <0.0, 0.0, 0.25>, ZERO_VECTOR, ZERO_ROTATION, SECRET_NUMBER);
        } else
        if (num == LINK_BREED_FAIL) {
            llSay(ANIMAL_CHANNEL, xtea_encrypt_string("XSPET^BREEDING_FAIL^" + (string)id));
            pregnancy_time = 0;
        } else
        if (num == LINK_SLEEPING) {
            Eye(<0,0,0>,shine);            // white eyes
        } else
        if (num == LINK_UNSLEEPING) {
            Eye(<1,1,1>,shine);        // blackout the eyes
        } else
        if (num == LINK_DIE) {
            state dead;
        } else
        if (num == LINK_TIMER) {
            llSetTimerEvent(llFrand(60.0) + (FOOD_BOWL_SCAN_INTERVAL - 30.0));
        }
    }

    object_rez(key id)
    {
        new_egg_key = id;
    }

    on_rez(integer param)
    {
        if (param == SECRET_NUMBER) {
            llSetText("Rezzing...", <1,0,0>, 1.0);
            setup = TRUE;   // Opensim issue with on_rez, the UUID is not sent until the script stops processing, so we use a timer
            
            if (llGetOwner() != llGetCreator()) {
                llAllowInventoryDrop(TRUE);
            }

            llListen(ANIMAL_CHANNEL, "", "", "");
            llSetTimerEvent(5.0);
        } else {
            llOwnerSay("I died in your inventory, please use a " +  Crate + " next time.");
            state dead;
        }
    }
}

state dead
{
    state_entry()
    {
        llSetText("Dead", <1,0,0>, 1.0);
        llMessageLinked(LINK_SET,1,"death","");    // play the death animation v.37

        llRemoveInventory("xs_ager");
        llRemoveInventory("xs_breeding");
        llRemoveInventory("xs_eater");
        llRemoveInventory("xs_infomatic");
        llRemoveInventory("xs_movement");
        if (llGetInventoryType("xs_special") != INVENTORY_NONE) {
            llRemoveInventory("xs_special");
        }
        llListen(ANIMAL_CHANNEL, "", "", "");
    }


    // no one has Xtra Strong Mojo, script has been lost. It appears that it triggers a box to rez a new pet with the params from this one.

    touch_start(integer number)
    {
        llWhisper(0, "I've died. You could re-animate me with a jar of Xtra Strong Mojo. But we don't have any Mojo coded just yet");
        if (llDetectedKey(0) == llGetOwner()) {
            llSay(ACC_CHANNEL, xtea_encrypt_string("XSPET^STRONG_MOJO^" + (string)llGetKey() + "^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)shine + "^" + (string)glow + "^" + special + "^" + (string)gen + "^" + (string)sex + "^" + (string)age + "^" + (string)glow_gene + (string)VERSION));

        }
    }

    listen(integer channel, string name, key id, string message) {
        list data = llParseString2List(xtea_decrypt_string(message), ["^"], []);
        if (llList2String(data, 0) == "XSPET") {
            if (llList2String(data, 1) == "STRONG_MOJO_DIE" && (key) llList2String(data, 2) == llGetKey()) {
                llDie();
            }
        }
    }
}

// likewise, the updater script is (no longer) lost to history.   Apparently you set the pet near a prim, that when touched, chats out "UPDATE", which leads you here.
// code remains here in case you want to make an updater. It givbes this pet a new pet and egg, then causes this pet to give birth to the new pet, then causes this pet to die.

state update
{
    state_entry()
    {
        llSetText("Updating.", <1,0,0>, 1.0);
        llRemoveInventory(FemaleName);
        llRemoveInventory(MaleName);
        llRemoveInventory(Egg);
        llAllowInventoryDrop(TRUE);
        llShout(UPDATE_CHANNEL, "UPDATE_READY");
    }

    changed(integer change)
    {
        if (change & CHANGED_ALLOWED_DROP) {
            if (llGetInventoryType(FemaleName) != INVENTORY_NONE  && llGetInventoryType(MaleName) != INVENTORY_NONE && llGetInventoryType(Egg) != INVENTORY_NONE) {
                llAllowInventoryDrop(FALSE);
                if (sex == 1)
                    llRezObject(MaleName, llGetPos() + <0.0, 0.0, 0.25>, ZERO_VECTOR, ZERO_ROTATION, SECRET_NUMBER);
                else
                    llRezObject(FemaleName, llGetPos() + <0.0, 0.0, 0.25>, ZERO_VECTOR, ZERO_ROTATION, SECRET_NUMBER);
            }
        }

    }
    object_rez(key id)
    {
        llListen(BOX_CHANNEL, "", id, "");
    }

    listen(integer channel, string name, key id, string msg)
    {
        if (channel == BOX_CHANNEL) {
            list data = llParseString2List(xtea_decrypt_string(msg), ["^"], []);
            if (llList2String(data, 0) == "XSPET" && llList2String(data, 1) == "READY") {

                llGiveInventory(id, Egg);
                llGiveInventory(id, FemaleName);
                llGiveInventory(id, MaleName);
                llSay(ANIMAL_CHANNEL, xtea_encrypt_string("XSPET^UPDATE_CONFIG^" + (string)id + "^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)sex + "^" + (string)shine + "^" + (string)glow + "^" + (string)gen + "^" + (string)age + "^" + (string)hunger_amount + "^" + llGetObjectName() + "^" + (string)glow_gene + "^" + special + "^" + (string)mcolour1 + "^" + (string)mcolour2 + "^" + (string)mshine + "^" + (string)mglow + "^" + (string)mgen + "^" + (string)mglow_gene + "^" + (string)pregnancy_time));
                llDie();
            }
        }
    }
}

