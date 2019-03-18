// :CATEGORY:XS Pet
// :NAME:XS Pet Robot
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS: Pet,XS,breed,breedable,companion,Ozimal,Meeroo,Amaretto,critter,Fennux,Pets
// :CREATED:2013-09-06
// :EDITED:2014-07-15
// :ID:988
// :NUM:1448
// :REV:0.53
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// XS Pet xs_egg
// :CODE:

// xs_egg

// this egg script will color a 2-prim egg when rezzed.
// When born from a pet, it will accept a new pet and egg from the Mama.
// The only thing ever needed to start with in an egg is this script , as it get the rest of the contents from the egg crate or Mama.

// 11-30-2012 added AUTO_HATCH variable.  If set to TRUE, rthe egg will auto-hatch when laid. Default: FALSE. If FALSE, you have to touch and hatch the egg manually
// 4-10-2013 V 0.43 Lots of casting to fix Opensim 0.7.4 failures to parse llList2Float and llList2Integer when there are strings in the list
//  Version 0.45 7-31-2013 List2Float and list2Integer do not parse strings in Opensim worlds the same. Converted in xs_egg and xs_eggcup

// 0.53 07-15-2014 bug in init - did not switch to state state rezzed;


/// tunables:
string SPECIAL = "Normal";    // change this to trigger the xs_special script in the pet.   See xs_special documentation in the pet
vector  Position = <0.0, 0.0, 0.25>; // how far above the egg to rez the pet.
vector  Rot = <0,0,0>;   // the rotation of the pet when rezzed
integer AUTO_HATCH = FALSE;   //If set to TRUE, rthe egg will auto-hatch when laid. Default: FALSE. If FALSE, you have to touch and hatch the egg manually



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
integer LINK_COLOR1_GET = 101;       // to xs_egg color plugin.
integer LINK_COLOR2_GET = 102;       // to xs_egg color plugin.
integer LINK_COLOR1_PUT = 103;       // to xs_egg color plugin.
integer LINK_COLOR2_PUT = 104;       // to xs_egg color plugin.
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




// EGG code begins again, see tunables up above

integer unpackaged = FALSE; // Opensim has issues with establishing a on_rez, so we use a timer to fix the bug

// breedable params
vector colour1;
vector colour2;
integer sex;
integer gen;
integer shine;
float glow;

// globals
string colourName1;    // new string to hold color name version 0.52
string colourName2;

integer api_listener;        // holds the API listener id so we can remove it
integer locked;              // only hear 1 PONG from a crate
integer owner_touch;         // flag set when ower has touched the prim
integer menu_listener;        // integer of the listener so we can remove it.

// allow either a UUID to be entered, or not, and still maintain security
integer CheckPerms()
{
    if (YOUR_UUID != "" && llGetOwner() != YOUR_UUID)
        return 1;

    if (llGetOwner() != llGetCreator())
        return 1;

    return 0;
}


set_colours(vector c1, vector c2, integer shine, float glow)
{
    // set the root prim (the egg top), skip the base, and then do the egg bottom half
    // Link order is top Egg half, Base, then bottom of the egg half

    // IN CASE YOU ARE USING THE TEXTURE PLUG IN:
    string msg = (string) c1 + "^" +
        (string) c2 + "^" +
        "0^" +		// sex is unknown in an egg
        (string) shine + "^" +
        (string) glow + "^";

    llMessageLinked(LINK_SET,LINK_TEXTURE,msg,NULL_KEY);		// tell the optional texture plugin to fetch the textures

    llSetPrimitiveParams([PRIM_COLOR, ALL_SIDES, c2, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
    llSetLinkPrimitiveParams(2, [PRIM_COLOR, ALL_SIDES, c1, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
    llMessageLinked(LINK_SET,LINK_COLOR1_GET,(string) colour1,"");    // V 0.52 send colors to plug in
    llMessageLinked(LINK_SET,LINK_COLOR2_GET,(string) colour2,"");

}

say_details()
{

    string myshine;

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

    llWhisper(0, "Color: " + colourName1);
    llWhisper(0, "Color: " + colourName2);
    llWhisper(0, "Shine: " + myshine);
    llWhisper(0, "Glow: " + (string)((integer)(glow * 100)) + "%");
    llWhisper(0, "Special: " + SPECIAL);
    llWhisper(0, "Generation: " + (string)gen);
    llSay(API_CHANNEL, "XSPet^" + (string)llGetKey() + "^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)shine + "^" + (string)glow + "^" + SPECIAL + "^" + (string)gen + "^XSPetEnd");
}

default
{
    state_entry()
    {
        DEBUG("RESET");
        llSetText("", <1,1,1>, 1.0);         // no white text
        llSetColor(<1,1,1>, ALL_SIDES);      // all white egg
        llSetLinkColor(2, <1,1,1>, ALL_SIDES);  // white egg link 2
        llParticleSystem([]);                // no particles, beats me why, somebody once had an egg that spewed so I am leaving it.
        xtea_key = xtea_key_from_string(SECRET_PASSWORD);
    }

    // the egg accepts inventory from crates and mama
    changed(integer change) {
        if (change & CHANGED_ALLOWED_DROP) {
            if (llGetInventoryType(FemaleName) != INVENTORY_NONE  && llGetInventoryType(MaleName) != INVENTORY_NONE && llGetInventoryType(Egg) != INVENTORY_NONE) {
                llAllowInventoryDrop(FALSE);
            }
        }
    }

    on_rez(integer param)
    {
        DEBUG("REZZING");
        llSetText("Rezzing...", <1,0,0>, 1.0);     // Rez Rezzing.. text

        // if param = 0, then someone rezzed an egg. It had better be the creator or someone who has put their UUID in the script.
        // all colors start in GEN 0 as primary colors here

        if (param == 0) {
            
            DEBUG("CREATOR REZZED ME");
            if (! CheckPerms() ) {
                integer colour = (integer)llFrand(9.0) + 1;
                if (colour == 1) {
                    colour1 = <1,0,0>;    // red/red
                    colour2 = <1,0,0>;
                } else
                if (colour == 2) {
                    colour1 = <1,0,0>;    // red/blue
                    colour2 = <0,1,0>;
                } else
                if (colour == 3) {
                    colour1 = <1,0,0>;    // red/blue
                    colour2 = <0,0,1>;
                } else
                if (colour == 4) {
                    colour1 = <0,1,0>;  // green/red
                    colour2 = <1,0,0>;
                } else
                if (colour == 5) {
                    colour1 = <0,1,0>;    // blue/blue
                    colour2 = <0,1,0>;
                } else
                if (colour == 6) {
                    colour1 = <0,1,0>; // green/blue
                    colour2 = <0,0,1>;
                } else
                if (colour == 7) {
                    colour1 = <0,0,1>; // blue/red
                    colour2 = <1,0,0>;
                } else
                if (colour == 8) {
                    colour1 = <0,0,1>;    // blue/red
                    colour2 = <0,1,0>;
                } else
                if (colour == 9) {
                    colour1 = <0,0,1>;    // blue/blue
                    colour2 = <0,0,1>;
                }

                set_colours(colour1, colour2, shine, glow);
                state rezzed;
                
            } else {
                llWhisper(0, "Oh no! This " + Egg + " was broken in your inventory! Please use an " + Egg + " container next time.");
                state dead;
            }
        } else if (param == SECRET_NUMBER) {
            DEBUG("REZZING from an object");
            menu_listener = llListen(EGG_CHANNEL, "", "", "");
            if ( CheckPerms() ) {
                llAllowInventoryDrop(TRUE);
            }
            unpackaged = TRUE;
            llSetTimerEvent(5);
        }
    }

    link_message(integer sender_number, integer number, string message, key id)
    {
        if (number == LINK_COLOR1_PUT)
        {
            colourName1 = message;
        } else if (number == LINK_COLOR2_PUT)
        {
            colourName2 = message;
            state rezzed;
        }
    }

    listen(integer channel, string sender, key id, string msg) {
        list data = llParseString2List(xtea_decrypt_string(msg), ["^"], []);
        if (llList2String(data, 0) == "XSPET" && (key) llList2String(data, 1) == llGetKey()) {
            if (llList2String(data, 2) == "UNBOX") {
                colour1 = (vector)llList2String(data, 3);
                colour2 = (vector)llList2String(data, 4);

                gen = (integer) llList2String(data,5);
                shine = (integer) llList2String(data, 6);
                glow = (float) llList2String(data, 7);
                SPECIAL = llList2String(data, 8);

                llListenRemove(menu_listener);

                set_colours(colour1, colour2, shine, glow);
            } else
            if (llList2String(data, 2) == "BORN") {
                vector fcolour1 = (vector)llList2String(data, 3);
                vector fcolour2 = (vector)llList2String(data, 4);

                integer fgen = (integer) llList2String(data,5);
                integer fshine = (integer) llList2String(data, 6);
                float fglow = (float) llList2String(data, 7);
                integer fglow_gene = (integer) llList2String(data, 8);

                vector mcolour1 = (vector)llList2String(data, 9);
                vector mcolour2 = (vector)llList2String(data, 10);

                integer mgen = (integer) llList2String(data, 11);
                integer mshine = (integer)llList2String(data, 12);
                float mglow = (float) llList2String(data, 13);
                integer mglow_gene = (integer)llList2String(data, 14);

                integer mix = (integer)llFrand(2) + 1;

                float deviation1 = (llFrand(10) - 5) / 100;
                float deviation2 = (llFrand(10) - 5) / 100;

                if (mix == 1) {
                    colour1.x = (fcolour1.x / 2 + mcolour1.x / 2) + deviation1;
                    colour1.y = (fcolour1.y / 2 + mcolour1.y / 2) + deviation1;
                    colour1.z = (fcolour1.z / 2 + mcolour1.z / 2) + deviation1;

                    colour2.x = (fcolour2.x / 2 + mcolour2.x / 2) + deviation2;
                    colour2.y = (fcolour2.y / 2 + mcolour2.y / 2) + deviation2;
                    colour2.z = (fcolour2.z / 2 + mcolour2.z / 2) + deviation2;

                } else {
                        colour1.x = (fcolour1.x / 2 + mcolour2.x / 2) + deviation1;
                    colour1.y = (fcolour1.y / 2 + mcolour2.y / 2) + deviation1;
                    colour1.z = (fcolour1.z / 2 + mcolour2.z / 2) + deviation1;

                    colour2.x = (fcolour2.x / 2 + mcolour1.x / 2) + deviation2;
                    colour2.y = (fcolour2.y / 2 + mcolour1.y / 2) + deviation2;
                    colour2.z = (fcolour2.z / 2 + mcolour1.z / 2) + deviation2;
                }

                if (colour1.x < 0)
                    colour1.x = 0;

                if (colour1.x > 1)
                    colour1.x = 1;

                if (colour1.y < 0)
                    colour1.y = 0;

                if (colour1.y > 1)
                    colour1.y = 1;

                if (colour1.z < 0)
                    colour1.z = 0;

                if (colour1.z > 1)
                    colour1.z = 1;

                if (colour2.x < 0)
                    colour2.x = 0;

                if (colour2.x > 1)
                    colour2.x = 1;

                if (colour2.y < 0)
                    colour2.y = 0;

                if (colour2.y > 1)
                    colour2.y = 1;

                if (colour2.z < 0)
                    colour2.z = 0;

                if (colour2.z > 1)
                    colour2.z = 1;


                if (mgen > fgen) {
                    gen = mgen + 1;
                } else {
                        gen = fgen + 1;
                }

                // TODO: shine / glow
                shine = 0;
                if (gen > 2) {
                    integer pos = (integer)llFrand(100) + 1;
                    if (fshine == mshine && fshine > 0) {
                        if (pos < 25) {
                            shine = fshine + 1;
                            if (shine > 3) {
                                shine = 3;
                            }
                        }
                    } else {
                            if (pos < 10) {
                                // increase shine
                                if (mshine > fshine) {
                                    shine = mshine + 1;
                                } else
                                if (fshine > mshine) {
                                    shine = fshine + 1;
                                } else {
                                        shine = 1;
                                }
                                if (shine > 3) {
                                    shine = 3;
                                }
                            }
                    }
                }
                glow = 0.0;

                if (mglow <= 0.3 && fglow <= 0.3) {
                    if (mglow > fglow) {
                        glow = mglow - 0.1;
                    } else if (fglow > mglow) {
                            glow = fglow - 0.1;
                    }
                }

                if (fglow_gene >= 10 && mglow_gene >= 10) {
                    integer poss = (integer)llFrand(100) + 1;
                    if (poss < 25) {
                        glow = 0.3;
                    }
                } else if (fglow_gene >= 10 || mglow_gene >= 10) {
                        integer poss = (integer)llFrand(100) + 1;
                    if (poss < 10) {
                        glow = 0.3;
                    }
                }

                llListenRemove(menu_listener);
                set_colours(colour1, colour2, shine, glow);
                llSetTimerEvent(1.0);
            }
        }
    }
    timer() {
        if (unpackaged)
        {
            DEBUG("UNPACKAGED");
            llSay(ANIMAL_CHANNEL, xtea_encrypt_string("XSPET^EGG_READY^" + (string)llGetKey() + "^SMILE"));  // tell Mama she has a baby
            llSay(BOX_CHANNEL, xtea_encrypt_string("XSPET^" + (string)llGetKey() + "^EGG_READY^SMILE"));       // and tell a crate it is okay to poof
            unpackaged = FALSE;
            return;
        }
        
        DEBUG("TIMER EXPIRED");
        
        if (llGetInventoryType(MaleName) != INVENTORY_NONE && llGetInventoryType(FemaleName) != INVENTORY_NONE && llGetInventoryType(Egg) != INVENTORY_NONE) {
            state rezzed;
        }
    }
}

state rezzed
{
    on_rez(integer param)
    {
        DEBUG("STATE REZZED ON_REZ");
        if (CheckPerms()) {
            llWhisper(0, "Oh no! This " + Egg + " was broken in your inventory! Please use an " + Egg + " container next time.");
            state dead;
        }
    }

    state_entry()
    {
        DEBUG("STATE REZZED STATE ENTRY");
        if (SPECIAL == "Normal") {
            llSetText("", <1,1,1>, 1.0);
        } else {
            llSetText(SPECIAL, <1,1,1>, 1.0);
        }
        api_listener = llListen(API_CHANNEL, "", "", "");

        // added auto hatch operator 11-30-2012 fkb
        if (AUTO_HATCH &&  unpackaged)
            state hatching;    }

    touch_start(integer num)
    {
        owner_touch = 0;
        say_details();

        if (llDetectedKey(0) == llGetOwner()) {
            owner_touch = 1;
            integer chan = (integer)llFrand(100000.0) + 1000;
            menu_listener = llListen(chan, "", llGetOwner(), "");
            llDialog(llGetOwner(), "I'm a " + Egg + ". What would you like to do with me?", ["Hatch", "Package", "Nothing"], chan);
        }
        llSetTimerEvent(30.0);
    }

    timer()
    {
        DEBUG("TIMER EXPIRED");
        llSetTimerEvent(0);

        if (owner_touch == 1) {
            llOwnerSay("Menu timeout.");
            llListenRemove(menu_listener);
            owner_touch = 0;
        }
    }

    listen(integer channel, string sender, key id, string msg)
    {
        if (channel == API_CHANNEL) {
            list data = llParseString2List(msg, ["^"], []);
            if ((llList2String(data, 0) == MaleName || llList2String(data, 0) == FemaleName)  && (key) llList2String(data, 1) == llGetKey()) {
                say_details();
            }
        } else {
                if (id == llGetOwner()) {
                    llSetTimerEvent(0);
                    llListenRemove(menu_listener);

                    if (msg == "Hatch") {
                        state hatching;
                    } else
                    if (msg == "Package") {
                        state package;
                    }
                }
        }
    }

    state_exit() {
        llListenRemove(api_listener);
    }
}

state hatching
{

    state_entry()
    {
        DEBUG("STATE HATCHING");
        sex = (integer)llFrand(2) + 1;
        if (sex == 1)
            llRezObject(MaleName, llGetPos() + Position, ZERO_VECTOR, llGetRot() * llEuler2Rot(Rot * DEG_TO_RAD) , SECRET_NUMBER);
        else
            llRezObject(FemaleName, llGetPos() + Position, ZERO_VECTOR, llGetRot() * llEuler2Rot(Rot * DEG_TO_RAD) , SECRET_NUMBER);
    }

    object_rez(key id)
    {
        DEBUG("OBJECT REZZED");
        menu_listener = llListen(EGG_CHANNEL, "", id, "");
    }

    listen(integer channel, string sender, key id, string msg)
    {
        list decrypted = llParseString2List(xtea_decrypt_string(msg), ["^"], []);

        if (llList2String(decrypted, 0) == "XSPET" && llList2String(decrypted, 1) == "READY" && llList2String(decrypted, 2) == (string)id) {
            llGiveInventory(id, MaleName);
            llGiveInventory(id, FemaleName);
            llGiveInventory(id, Egg);
            string sexname;
            if (sex == 1)
                sexname = MaleName;
            else
                sexname = FemaleName;
            llSay(ANIMAL_CHANNEL, xtea_encrypt_string("XSPET^CONFIG^" + (string)id + "^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)sex + "^" + (string)shine + "^" + (string)glow + "^" + (string)gen + "^0^0^" + sexname + "^0^" + SPECIAL));
            llDie();
        }
    }
}

state package
{
    state_entry() {
        DEBUG("STATE PACKAGED");
        llSetTimerEvent(20.0);
        llWhisper(0, "Looking for a " + Egg + "  container...");
        menu_listener = llListen(EGG_CHANNEL, "", "", "");
        llSay(BOX_CHANNEL, xtea_encrypt_string("XSPET^" + (string)llGetKey() + "^CUP_PING^" + (string)VERSION));
    }
    timer()
    {
        DEBUG("TIMER EXPIRED");
        llListenRemove(menu_listener);
        llSetTimerEvent(0);

        llWhisper(0, "No " + Egg + " container found.");
        state rezzed;
    }

    listen(integer channel, string sender, key id, string msg)
    {
        list data = llParseString2List(xtea_decrypt_string(msg), ["^"], []);
        if (llList2String(data, 0) == "XSPET" && (key) llList2String(data, 1) == llGetKey() && llList2String(data, 2) == "CUP_PONG" && llList2Float(data, 3) >= VERSION && locked == 0) {
            llSay(BOX_CHANNEL, xtea_encrypt_string("XSPET^" + (string)id + "^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)shine + "^" + (string)glow + "^" + (string)gen + "^" + SPECIAL));
            locked = 1;
        } else
        if (llList2String(data, 0) == "XSPET" && llList2Key(data, 1) == llGetKey() && llList2String(data, 2) == "CUP_DIE") {
            llDie();
        }
    }
}

state dead
{
    state_entry()
    {
        llSetText("Broken " + Egg, <1,0,0>, 1.0);
    }
}

