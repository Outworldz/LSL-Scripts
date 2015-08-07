// :CATEGORY:XS Pet
// :NAME:XS Pet Quail Modified
// :AUTHOR:Xundra Snowpaw, Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:10
// :ID:987
// :NUM:1425
// :REV:1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Modified Pet Quail
// :CODE:

// Version 0.35 5-22-2012 


// script by Xundra Snowpaw
// mods by Ferd Frederix
//
// New BSD License: http://www.opensource.org/licenses/bsd-license.php
// Copyright (c) 2010, Xundra Snowpaw
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

//* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////
// COPY FROM GLOBAL CONSTANTS FILE LOCATED IN Debug Folder
// INCLUDE THESE IN ALL SCRIPTS //
// XS_pet constants and names

///// GLOBAL CONSTANTS extracted from original source //////
//
// if you change any of these constants, change it everywhere and in a list in XS_Debug so it can print them
//
// 0.24 is the original Pet Quail
// 0.25 is the modified Pet Quail
// 0.26 is the Robot code, which is generic

float VERSION = 0.25;

string Animal = "Quail";        // was 'Quail', must be the name of your animal
string Egg = "XS Egg";      // was 'XS Egg', must be the name of your egg
string Crate = "Transport Crate";   // was XS-Cryocrate
string HomeObject = "Home Post"; // was "XS Home Object
string sound = "robot_sound";
string  SECRET_PASSWORD = "top secret";    // must use one unique to any animal
integer SECRET_NUMBER = 99999;             // any number thats a secret

integer MaxAge = 7;              // can get prggers in 7 days
integer UNITS_OF_FOOD = 168;     // food bowl food
float secs_to_grow = 86400;      // grow daily = 86400

// global listeners

integer FOOD_CHANNEL = -999191;
integer ANIMAL_CHANNEL = -999192;
integer EGG_CHANNEL = -999193;
integer HOME_CHANNEL = -999194;
integer BOX_CHANNEL = -999195;
integer ACC_CHANNEL = -999196;
integer UPDATE_CHANNEL = -999197;
integer API_CHANNEL = -999198;

// global prim animation linkmessages on channel 1
// these are the prim animations played for each type of possible animation

string ANI_STAND = "stand";             // default standing animation
string  ANI_WALKL   = "left";           // triggers Left foot anbd righrt arm walk animation
string  ANI_WALKR   = "right";          // triggers Right foot and left arm walk animation
string  ANI_SLEEP  = "sleep";           // Sleeping
string  ANI_WAVE = "wave";              // Calling for sex, needs help with food, etc.



// global link messages to control the animal
integer LINK_AGE_START = 800;      // when quail is rezzed and secret_number, is sent by brain to breeder, eater and informatic get booted up
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
integer LINK_CALL_MALE_INFO = 968;      // sent by xs_breeding, this line of code was in error in v.24 of xs_breeding
// see line 557 and 636 of xs_brain which make calls and also xs_breeding which receives LINK_MALE_INFO.
integer LINK_MALE_INFO = 969;
integer LINK_LAY_EGG = 970;             // llRezObject("XS Egg"
integer LINK_BREED_FAIL = 971;          // key = father, failed, timed out
integer LINK_PREGNANT = 972;            // chick is preggers
integer LINK_SLEEPING = 990;            // close eyes
integer LINK_UNSLEEPING = 991;          // open eyes
integer LINK_SOUND = 1001;              // plays a sound if enabled
integer LINK_SPECIAL = 1010;            // xs_special, is str = "Normal", removes script
integer LINK_PREGNANCY_TIME = 5000;    // in seconds as str
integer LINK_SLEEP = 7999;              // disable sleep by parameter
integer LINK_TIMER = 8000;              // scan for food bowl about every 1800 seconds
integer LINK_DIE = 9999;                // death


///////// end global Link constants ////////






////////////////////////////////////////////////////////////////////

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


// tunables
integer up_down = FALSE ; // set to TRUE to rez above the egg cup, set to false to rez below the UFO
vector colour1;
vector colour2;
integer gen;
integer shine;
float glow;
key uuid;
integer listener;
integer owner_touch;
string special;

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

    llWhisper(0, "Color: " + (string)colour1);
    llWhisper(0, "Color: " + (string)colour2);
    llWhisper(0, "Shine: " + myshine);
    llWhisper(0, "Glow: " + (string)((integer)(glow * 100)) + "%");
    llWhisper(0, "Special: " + special);
    llWhisper(0, "Generation: " + (string)gen);

    llSay(API_CHANNEL, "XSQuail^" + (string)llGetKey() + "^"+ (string)colour1 + "^" + (string)colour2 + "^" + (string)shine + "^" + (string)glow + "^" + special + "^" + (string)gen + "^XSQuailEnd");
}

set_colours(vector c1, vector c2, integer shine, float glow)
{
    llSetPrimitiveParams([PRIM_COLOR, ALL_SIDES, c2, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
    llSetLinkPrimitiveParams(3, [PRIM_COLOR, ALL_SIDES, c1, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
}

default
{
    state_entry()
    {
        xtea_key = xtea_key_from_string(SECRET_PASSWORD);
        uuid = NULL_KEY;
        listener = llListen(BOX_CHANNEL, "", "", "");
    }

    listen(integer channel, string name, key id, string msg)
    {

        if (llGetOwnerKey(id) != llGetOwner()) {
            return;
        }

        list data = llParseString2List(xtea_decrypt_string(msg), ["^"], []);

        if (uuid == NULL_KEY) {
            if (llList2String(data, 0) == "XSPET" && llList2String(data, 2) == "CUP_PING") {
                uuid = id;
                llSay(EGG_CHANNEL, xtea_encrypt_string("XSPET^" + (string)id + "^CUP_PONG^" + (string)VERSION));
                llSetTimerEvent(15.0);
            }
        } else if (uuid == id) {
                if (llList2String(data, 0) == "XSPET" && llList2Key(data, 1) == llGetKey()) {
                    llSetTimerEvent(0.0);
                    colour1 = (vector)llList2String(data, 2);
                    colour2 = (vector)llList2String(data, 3);
                    shine = llList2Integer(data, 4);
                    glow = llList2Float(data, 5);
                    gen = llList2Integer(data, 6);
                    special = llList2String(data, 7);
                    llListenRemove(listener);
                    llSay(EGG_CHANNEL, xtea_encrypt_string("XSPET^" + (string)id + "^CUP_DIE^"));
                    state full;
                } else
            if (llList2String(data, 0) == "XSPET" && llList2Key(data, 1) != llGetKey()) {
                uuid = NULL_KEY;
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
        string my_special = "";
        if (special != "Normal") {
            my_special = "(" + special + ") ";
        }
        llSetObjectName("XS Egg Cup: " + my_special + "S:" + (string)shine + " G:" + (string)((integer)(glow * 100)) + "% <" + llGetSubString((string)colour1.x, 0, 3) + "," + llGetSubString((string)colour1.y, 0, 3) + "," + llGetSubString((string)colour1.z, 0, 3) + ">/<" + llGetSubString((string)colour2.x, 0, 3) + "," + llGetSubString((string)colour2.y, 0, 3) + "," + llGetSubString((string)colour2.z, 0, 3) + ">");
        set_colours(colour1, colour2, shine, glow);
        llListen(API_CHANNEL, "", "", "");
        if (special != "Normal") {
            llSetText(special, <1,1,1>, 1.0);
        }
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

    timer()
    {
        //llOwnerSay("Menu timeout.");
        if (owner_touch == 1) {
            llListenRemove(listener);
        }
        llSetTimerEvent(0.0);
    }

    listen(integer channel, string name, key id, string msg)
    {
        if (channel == API_CHANNEL) {
            list data = llParseString2List(msg, ["^"], []);
            if (llList2String(data, 0) == "XSQuail" && llList2Key(data, 1) == llGetKey()) {
                llSay(API_CHANNEL, "XSQuail^" + (string)llGetKey() + "^"+ (string)colour1 + "^" + (string)colour2 + "^" + (string)shine + "^" + (string)glow + "^" + special + "^" + (string)gen + "^XSQuailEnd");
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
        listener = llListen(BOX_CHANNEL, "", "", "");
        if (up_down)
            llRezObject(Egg, llGetPos() + <0.0, 0.0, 0.25>, ZERO_VECTOR, ZERO_ROTATION, SECRET_NUMBER);
        else
        {
            llMessageLinked(LINK_SET,-2000,"",""); // turn on the particle effects

            llRezObject(Egg, llGetPos() + <0.0, 0.0,-0.1>, ZERO_VECTOR, ZERO_ROTATION, SECRET_NUMBER);

        }
    }

    object_rez(key id)
    {
        vector pos = llGetPos();
        pos.z += .2;
        llSetPos(pos);
    }

    listen(integer channel, string name, key id, string msg)
    {
        if (channel == BOX_CHANNEL) {
            list data = llParseString2List(xtea_decrypt_string(msg), ["^"], []);
            if (llList2String(data, 0) == "XSPET" && llList2String(data, 2) == "EGG_READY") {

                llGiveInventory(id, Egg );
                llGiveInventory(id, Animal);

                llSay(EGG_CHANNEL, xtea_encrypt_string("XSPET^" + (string)id + "^UNBOX^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)gen + "^" + (string)shine + "^" + (string)glow + "^" + special));
                llDie();
            }
        }
    }
}

