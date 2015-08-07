// :CATEGORY:XS Pet
// :NAME:XS Pet Robot
// :AUTHOR:Ferd Frederix
// :KEYWORDS: Pet,XS,breed,breedable,companion,Ozimal,Meeroo,Amaretto,critter,Fennux,Pets
// :CREATED:2013-09-06
// :EDITED:2014-05-18
// :ID:988
// :NUM:1452
// :REV:0.52
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// XS Pet  xs_cryocrate

// :CODE:

// xs_cryocrate

// 11-24-2012 added LINK_TEXTURE to allow crate to be textured.
// 4-10-2013 V 0.43 Lots of casting to fix Opensim 0.7.4 failures to parse llList2Float and llList2Integer when there are strings in the list

// Tunables

// Quail rezzed eggs up 0.25 meters above the egg cup.
float position = 0.25; // just above the egg cup for XS QUail, not used when MoveUp is TRUE
integer BOX = FALSE;           // if TRUE, uses XS Quail prim type of a BOX, if False, uses Name of linked prim to color or texture
integer MoveUp = TRUE;     // if set to TRUE, will move the box up when an egg is rezzed and set it on top of the animal, then play an effect
float distance = 0.5;    // how far the crate will move up if MoveUp is set to TRUE, the egg is laid this distance below it.
float delay = 3;    // numner of seconds for effects to begin and then end. 0 is default for a Quail







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



vector colour1;        // saved animal coloration 1 breedable param
vector colour2;        // saved animal coloration 2 breedable param
integer gen;           // saved animal Gen 0 is first born, 1 is babies, etc
integer shine;         //saved animal  0 = None, 1 = Low, 2 = Medium, 3 = High shine
float glow;            // saved animal food fed glow in percent
key uuid;                // Animal UUID from a CRATE_PING
integer listener;        // listener ID for menu
integer owner_touch;    // flag to prevent a second touch from someone else from cancelling the menu timer
integer sex;            // 1 = Male, 2 = Female
integer age;            // age in days
integer hunger;         // saved animal hunger value
string myname;          // saved animal pet name
integer glow_gene;      // saved animal glow gene
string special;         // saved animal special feature

string colourName1;    // new string to hold color name version 0.52
string colourName2;

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
            mysex = (string)sex;
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

    llWhisper(0, "Color: " + colourName1);
    llWhisper(0, "Color: " + colourName2);
    llWhisper(0, "Shine: " + myshine);
    llWhisper(0, "Glow: " + (string)((integer)(glow * 100)) + "%");
    llWhisper(0, "Special: " + special);
    llWhisper(0, "Sex: " + mysex);
    llWhisper(0, "Age: " + (string)age + " days");
    llWhisper(0, "Generation: " + (string)gen);

    llSay(API_CHANNEL, "XSPet^" + (string)llGetKey() + "^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)shine + "^" + (string)glow + "^" + special + "^" + (string)gen + "^" + (string)sex + "^" + (string)age + "^XSPetEnd");
}

set_colours(vector c1, vector c2, integer shine, float glow)
{

    string msg = (string) c1 + "^" +
        (string) c2 + "^" +
        "0^" +		// sex is unknown in an egg
        (string) shine + "^" +
        (string) glow + "^";
    llMessageLinked(LINK_SET,LINK_TEXTURE,msg,NULL_KEY);		// tell the optional texture plugin
    llMessageLinked(LINK_SET,LINK_COLOR1_GET,(string) colour1,"");    // V 0.52 send colors to plug in
    llMessageLinked(LINK_SET,LINK_COLOR2_GET,(string) colour2,"");

    if (BOX)
        // sets color 1  on sides 0,1,3,5 and color 2 on sides 2 &4 of a box
        llSetPrimitiveParams([PRIM_COLOR, 0, c1, 1.0, PRIM_COLOR, 1, c1, 1.0, PRIM_COLOR, 3, c1, 1.0, PRIM_COLOR, 5, c1, 1.0, PRIM_COLOR, 2, c2, 1.0, PRIM_COLOR, 4, c2, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
    else
    {
        integer N = llGetNumberOfPrims();
        integer i;
        for (i = 1; i <= N; i++)
        {
            list  lDesc = llGetLinkPrimitiveParams(i,[28]);    // 28 = PRIM_DESC, but LSLEdit does not support it yet :-(
            string desc = llToLower(llList2String(lDesc,0));    // get the string description

            if (desc == "color1")
            {
                llSetLinkPrimitiveParamsFast(i,[PRIM_COLOR, 0, c1, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
            } else if (desc == "color2")
        {
            llSetLinkPrimitiveParamsFast(i,[PRIM_COLOR, 0, c2, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
        }
        }

    }
}

default
{
    state_entry()
    {
        set_colours(<1,1,1>,<1,1,1>,0,0);       // default box color

        xtea_key = xtea_key_from_string(SECRET_PASSWORD);
        uuid = NULL_KEY;
        listener = llListen(BOX_CHANNEL, "", "", "");
    }
    
    touch_start(integer num)
    {
        llWhisper(0, "This " + llGetObjectName() + " is version " + (string)VERSION);
    }

    listen(integer channel, string name, key id, string msg)
    {
        if (llGetOwnerKey(id) != llGetOwner()) {
            return;
        }

        list data = llParseString2List(xtea_decrypt_string(msg), ["^"], []);

        if (uuid == NULL_KEY) {
            if (llList2String(data, 0) == "XSPET" && llList2String(data, 2) == "CRATE_PING") {
                uuid = id;
                llSay(ANIMAL_CHANNEL, xtea_encrypt_string("XSPET^CRATE_PONG^" + (string)id + "^" + (string)VERSION));
                llSetTimerEvent(15.0);
            }
        } else
        if (uuid == id) {
            if (llList2String(data, 0) == "XSPET" && (key) llList2String(data, 1) == llGetKey()) {
                llSetTimerEvent(0.0);
                colour1 = (vector)llList2String(data, 2);
                colour2 = (vector)llList2String(data, 3);
                shine = (integer) llList2String(data, 4);
                glow = (float) llList2String(data, 5);
                gen = (integer) llList2String(data, 6);
                sex = (integer) llList2String(data, 7);
                age = (integer) llList2String(data, 8);
                hunger = (integer) llList2String(data, 9);
                myname = llList2String(data, 10);
                glow_gene = (integer) llList2String(data, 11);
                special = llList2String(data, 12);
                llListenRemove(listener);
                llSay(ANIMAL_CHANNEL, xtea_encrypt_string("XSPET^CRATE_DIE^" + (string)id + "^" + (string)VERSION));

                state full;
            } else {
                if (llList2String(data, 0) == "XSPET" && (key) llList2String(data, 1) != llGetKey()) {
                    uuid = NULL_KEY;
                }
            }
        }
    }

    timer()
    {
        llSetTimerEvent(0.0);
        uuid = NULL_KEY;
    }
}

state full
{
    state_entry()
    {
        llSetObjectName(Crate + ":" + myname);
        set_colours(colour1, colour2, shine, glow);
        llListen(API_CHANNEL, "", "", "");
    }

    touch_start(integer num)
    {
        owner_touch = 0;
        say_details();

        if (llDetectedKey(0) == llGetOwner()) {
            owner_touch = 1;
            integer chan = (integer)llFrand(10000.0) + 1000;
            listener = llListen(chan, "", llGetOwner(), "");

            llDialog(llGetOwner(), "Would you like to unpackage me?", ["Yes", "No"], chan);
        }
        llSetTimerEvent(20.0);
    }

    link_message(integer sender_number, integer number, string message, key id)
    {
        if (number == LINK_COLOR1_PUT)
        {
            colourName1 = message;
        } else if (number == LINK_COLOR2_PUT)
        {
            colourName2 = message;
        }
    }

    timer()
    {
        if (owner_touch == 1) {
            llListenRemove(listener);
        }
        llSetTimerEvent(0.0);
    }

    listen(integer channel, string name, key id, string msg)
    {
        if (channel == API_CHANNEL) {
            list data = llParseString2List(msg, ["^"], []);
            if (llList2String(data, 0) == "XSPet" && (key) llList2String(data, 1) == llGetKey()) {
                llSay(API_CHANNEL, "XSPet^" + (string)llGetKey() + "^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)shine + "^" + (string)glow + "^" + special + "^" + (string)gen + "^" + (string)sex + "^" + (string)age + "^XSPetEnd");
            }
        } else {
                llListenRemove(listener);
            if (msg == "Yes") {
                state unbox;
            }
        }
    }
}



state unbox
{
    state_entry()
    {

        if (MoveUp) {
            vector pos = llGetPos();
            pos.z +=  distance;
            llSetPos(pos);          // move up a bit
            position = - distance; // down below us for ufo
        }


        // v.25 ufo particles
        llMessageLinked(LINK_SET,LINK_EFFECTS_ON,"","");     // V.25 turn on effects
        if (sex == 1)
            llRezObject(MaleName, llGetPos() + <0.0, 0.0, position>, ZERO_VECTOR, ZERO_ROTATION, SECRET_NUMBER);
        else
            llRezObject(FemaleName, llGetPos() + <0.0, 0.0, position>, ZERO_VECTOR, ZERO_ROTATION, SECRET_NUMBER);
    }

    object_rez(key id)
    {
        listener = llListen(BOX_CHANNEL, "", id, "");
    }

    listen(integer channel, string name, key id, string msg)
    {
        if (channel == BOX_CHANNEL) {
            list data = llParseString2List(xtea_decrypt_string(msg), ["^"], []);
            if (llList2String(data, 0) == "XSPET" && llList2String(data, 1) == "READY") {

                llGiveInventory(id, Egg);
                llGiveInventory(id, MaleName);
                llGiveInventory(id, FemaleName);

                llSay(ANIMAL_CHANNEL, xtea_encrypt_string("XSPET^CONFIG^" + (string)id + "^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)sex + "^" + (string)shine + "^" + (string)glow + "^" + (string)gen + "^" +(string)age + "^" + (string)hunger + "^" + myname + "^" + (string)glow_gene + "^" + special));
                if (delay) {
                    llSleep(delay);   // V.25 give some time for effects to rez
                }

                llDie();
            }
        }
    }
}

