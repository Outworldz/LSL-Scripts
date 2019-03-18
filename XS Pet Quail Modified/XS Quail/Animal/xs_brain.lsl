// :CATEGORY:XS Pet
// :NAME:XS Pet Quail Modified
// :AUTHOR:Xundra Snowpaw, Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:09
// :ID:987
// :NUM:1416
// :REV:1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Modified Pet Quail
// :CODE:

// Version .24  10-3-2011

// script by Xundra Snowpaw
// mods by Fred Beckhusen (Ferd Frederix)
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


///// GLOBAL LINK CONSTANTS extracted from original source //////
///
// if you change anything, you change it everywhere and in a list in XS_Debug
///

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
integer LINK_CALL_MALE_INFO = 968;      // ****** BUG  ***** read, but never sent by anybody!!!!!
                                        // see line 557 and 636 of xs_brain which make calls and also xs_breeding which receives LUNK_MALE_INFO.
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

// END //



float VERSION = 0.22;

string  SECRET_PASSWORD = "top secret";
integer SECRET_NUMBER = 99999;

integer FOOD_CHANNEL = -999191;
integer ANIMAL_CHANNEL = -999192;
integer HOME_CHANNEL = -999194;
integer BOX_CHANNEL = -999195;
integer ACC_CHANNEL = -999196;
integer UPDATE_CHANNEL = -999197;
integer EGG_CHANNEL = -999193;

float   FOOD_BOWL_SCAN_INTERVAL = 1800.0;

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


integer setup = FALSE; // added to cure opensim rezzing issue

//integer food_left;
integer random_number;
integer random_number2;
//list    food_bowl_keys;
//list    food_bowl_locations;
integer hunger_amount;
vector colour1;
vector colour2;

integer sex;

integer shine;
float glow;

integer gen;
integer age;

vector mcolour1;
vector mcolour2;

integer mshine;
float mglow;

integer mgen;
vector home_loc;
key new_egg_key;

integer glow_gene;
string special;

integer mglow_gene;

integer locked;

integer pregnancy_time;

default
{
    state_entry()
    {
        if (llGetOwner() != llGetCreator()) {
            // someone not the creator reset the script. Thats naughty.
            state dead;
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
            if (llGetInventoryType("Quail") != INVENTORY_NONE && llGetInventoryType("XS Egg") != INVENTORY_NONE) {
                llAllowInventoryDrop(FALSE);
            }
        }

        if (change & CHANGED_INVENTORY) {
            if (llGetOwner() != llGetCreator()) {

                integer inventory_count = llGetInventoryNumber(INVENTORY_ALL);
                integer extras = 3;


                if (llGetInventoryType("xs_ager") == INVENTORY_NONE || !llGetScriptState("xs_ager")) {
                    state dead;
                }
                if (llGetInventoryType("xs_infomatic") == INVENTORY_NONE || !llGetScriptState("xs_infomatic")) {
                    state dead;
                }
                if (llGetInventoryType("xs_breeding") == INVENTORY_NONE || !llGetScriptState("xs_breeding")) {
                    state dead;
                }
                if (llGetInventoryType("xs_eater") == INVENTORY_NONE || !llGetScriptState("xs_eater")) {
                    state dead;
                }
                if (llGetInventoryType("xs_movement") == INVENTORY_NONE || !llGetScriptState("xs_movement")) {
                    state dead;
                }
                if (llGetInventoryType("bird_sound") == INVENTORY_NONE) {
                    state dead;
                }


                if (llGetInventoryType("xs_special") == INVENTORY_NONE) {
                    extras--;
                }

                if (llGetInventoryType("XS Egg") == INVENTORY_NONE) {
                    extras--;
                }

                if (llGetInventoryType("Quail") == INVENTORY_NONE) {
                    extras--;
                }

                if (llGetInventoryType("XS Home Object") == INVENTORY_NONE) {
                    state dead;
                }

                if (8 + extras != inventory_count) {
                    state dead;
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
            if (llList2String(data, 0) == "XSPET") {
                if (llList2String(data, 1) == "FOOD_LOCATION") {
                    llMessageLinked(LINK_SET, LINK_FOODIE, llList2String(data, 3), id);
                } else
                if (llList2String(data, 1) == "FOOD_CONSUME") {
                    if (llList2Integer(data, 2) == random_number2 && llList2Key(data, 3) == llGetKey()) {
                        hunger_amount--;
                        llMessageLinked(LINK_SET, LINK_FOODMINUS, "", "");
                        random_number2 = 0;
                        if (llList2Integer(data, 4) == 1 && glow_gene < 10) {
                            glow_gene ++;
                        }
                    }
                } else
                if (llList2String(data, 1) == "HOME_LOCATION") {
                    vector n_home_loc = (vector)llList2String(data, 2);
                    float home_dis = llList2Float(data, 3);
                    vector my_loc = llGetPos();
                    //                llOwnerSay((string)llVecDist(home_loc, my_loc) + " " + (string)my_loc + (string)home_loc + (string)home_dis + llList2String(data, 2));
                    if (llVecDist(n_home_loc, my_loc) <= home_dis && llFabs(llFabs(n_home_loc.z) - llFabs(my_loc.z)) < 1) {
                        if (llGetOwnerKey(id) == llGetOwner()) {
                            home_loc = n_home_loc;
                            llMessageLinked(LINK_SET, LINK_SET_HOME, (string)n_home_loc + "^" + (string)home_dis, "");
                        }
                    }
                } else
                if (llList2String(data, 1) == "CONFIG" && llList2Key(data, 2) == llGetKey()) {
                    colour1  = (vector)llList2String(data, 3);;
                    colour2 = (vector)llList2String(data, 4);

                    sex = llList2Integer(data, 5);

                    shine = llList2Integer(data, 6);
                    glow = llList2Float(data, 7);

                    gen = llList2Integer(data, 8);
                    integer mage = llList2Integer(data, 9);
                    integer hamount = llList2Integer(data, 10);
                    string myname = llList2String(data, 11);
                    glow_gene = llList2Integer(data, 12);
                    special = llList2String(data, 13);

                    llSetLinkPrimitiveParams(5, [PRIM_COLOR, ALL_SIDES, colour1, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
                    llSetLinkPrimitiveParams(1, [PRIM_COLOR, ALL_SIDES, colour1, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);

                    //                llSetLinkColor(8, colour1, ALL_SIDES);
                    //                llSetLinkColor(1, colour1, ALL_SIDES);

                    llSetLinkPrimitiveParams(7, [PRIM_COLOR, ALL_SIDES, colour2, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
                    llSetLinkPrimitiveParams(4, [PRIM_COLOR, ALL_SIDES, colour2, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
                    llSetLinkPrimitiveParams(9, [PRIM_COLOR, ALL_SIDES, colour2, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
                    //                llSetLinkColor(3, colour2, ALL_SIDES);
                    //                llSetLinkColor(2, colour2, ALL_SIDES);
                    //                llSetLinkColor(7, colour2, ALL_SIDES);

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

                    if (name != "Quail") {
                        llSetObjectName(myname);
                    }

                    llSetObjectDesc("XS Quail v" + (string)VERSION + " (c) 2010 Xundra Snowpaw");


                    llMessageLinked(LINK_SET, LINK_SPECIAL, special, "");

                    llMessageLinked(LINK_SET, LINK_DAYTIME, "", "");

                    llSay(HOME_CHANNEL, "XSPET_PING_HOME");

                    llSetText("", <1,1,1>, 1.0);
                } else
                if (llList2String(data, 1) == "UPDATE_CONFIG" && llList2Key(data, 2) == llGetKey()) {
                    colour1  = (vector)llList2String(data, 3);;
                    colour2 = (vector)llList2String(data, 4);

                    sex = llList2Integer(data, 5);

                    shine = llList2Integer(data, 6);
                    glow = llList2Float(data, 7);

                    gen = llList2Integer(data, 8);
                    integer mage = llList2Integer(data, 9);
                    integer hamount = llList2Integer(data, 10);
                    string myname = llList2String(data, 11);
                    glow_gene = llList2Integer(data, 12);
                    special = llList2String(data, 13);
                    mcolour1 = (vector)llList2String(data, 14);
                    mcolour2 = (vector)llList2String(data, 15);
                    mshine = llList2Integer(data, 16);
                    mglow = llList2Float(data, 17);
                    mgen = llList2Integer(data, 18);
                    mglow_gene = llList2Integer(data, 19);
                    pregnancy_time = llList2Integer(data, 20);

                    llSetLinkPrimitiveParams(5, [PRIM_COLOR, ALL_SIDES, colour1, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
                    llSetLinkPrimitiveParams(1, [PRIM_COLOR, ALL_SIDES, colour1, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);

                    //                llSetLinkColor(8, colour1, ALL_SIDES);
                    //                llSetLinkColor(1, colour1, ALL_SIDES);

                    llSetLinkPrimitiveParams(7, [PRIM_COLOR, ALL_SIDES, colour2, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
                    llSetLinkPrimitiveParams(4, [PRIM_COLOR, ALL_SIDES, colour2, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
                    llSetLinkPrimitiveParams(9, [PRIM_COLOR, ALL_SIDES, colour2, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE, PRIM_GLOW, ALL_SIDES, glow]);
                    //                llSetLinkColor(3, colour2, ALL_SIDES);
                    //                llSetLinkColor(2, colour2, ALL_SIDES);
                    //                llSetLinkColor(7, colour2, ALL_SIDES);

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

                    if (name != "Quail") {
                        llSetObjectName(myname);
                    }

                    llSetObjectDesc("XS Quail v" + (string)VERSION + " (c) 2010 Xundra Snowpaw");


                    llMessageLinked(LINK_SET, LINK_SPECIAL, special, "");

                    llMessageLinked(LINK_SET, LINK_DAYTIME, "", "");



                    llSay(HOME_CHANNEL, "XSPET_PING_HOME");

                    llSetText("", <1,1,1>, 1.0);
                } else
                if (llList2String(data, 1) == "CRATE_PONG" && llList2Key(data, 2) == llGetKey()) {
                    if (llList2Float(data, 3) >= VERSION && locked == 0) {
                        locked = 1;
                        llSay(BOX_CHANNEL, xtea_encrypt_string("XSPET^" + (string)id + "^" + (string    )colour1 + "^" + (string)colour2 + "^" + (string)shine + "^" + (string)glow + "^" + (string)gen + "^" + (string)sex + "^" + (string)age + "^" + (string)hunger_amount + "^" + llGetObjectName() + "^" + (string)glow_gene + "^" + special));
                    }
                } else
                if (llList2String(data, 1) == "CRATE_DIE" && llList2Key(data, 2) == llGetKey()) {
                    llDie();
                } else
                if (llList2String(data, 1) == "MALE_BREED_CALL") {
                    llMessageLinked(LINK_SET, LINK_MALE_BREED_CALL, "", "");
                } else
                if (llList2String(data, 1) == "FEMALE_ELIGIBLE" && home_loc == (vector)llList2String(data, 2)) {
                    llMessageLinked(LINK_SET, LINK_FEMALE_ELIGIBLE, "", id);
                } else
                if (llList2String(data, 1) == "MALE_ON_THE_WAY" && llList2Key(data, 2) == llGetKey()) {
                    llMessageLinked(LINK_SET, LINK_MALE_ON_THE_WAY, "", id);
                    llSay(ANIMAL_CHANNEL, xtea_encrypt_string("XSPET^FEMALE_LOC^" + (string)id + "^" + (string)llGetPos()));
                } else
                if (llList2String(data, 1) == "FEMALE_LOC" && (key) llList2String(data, 2) == llGetKey())  // missing key cast - Ferd
                {
                    llMessageLinked(LINK_SET, LINK_FEMALE_LOCATION, llList2String(data, 3), "");
                } else
                if (llList2String(data, 1) == "MALE_INFO" && llList2Key(data, 2) == llGetKey()){
                    // pregnant
                    mcolour1 = (vector)llList2String(data, 3);
                    mcolour2 = (vector)llList2String(data, 4);

                    mshine = llList2Integer(data, 5);
                    mglow = llList2Float(data, 6);

                    mgen = llList2Integer(data, 7);
                    mglow_gene = llList2Integer(data, 8);
                    pregnancy_time = llGetUnixTime();
                    llMessageLinked(LINK_SET, LINK_PREGNANT, "", "");
                } else
                if (llList2String(data, 1) == "BREEDING_FAIL" && (key) llList2String(data, 2) == llGetKey())  // missing key cast - Ferd
                {
                    llMessageLinked(LINK_SET, LINK_MALE_INFO, "", "");
                } else
                if (llList2String(data, 1) == "EGG_READY" && id == new_egg_key)
                {
                    llGiveInventory(id, "XS Egg");
                    llGiveInventory(id, "Quail");

                    llSay(EGG_CHANNEL, xtea_encrypt_string("XSPET^" + (string)id + "^BORN^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)gen + "^" + (string)shine + "^" + (string)glow + "^" + (string)glow_gene + "^" + (string)mcolour1 + "^" + (string)mcolour2 + "^" + (string)mgen + "^" + (string)mshine + "^" + (string)mglow + "^" + (string)mglow_gene));
                } else
                if (llList2String(data, 1) == "SHINE_GOO" && (key) llList2String(data, 2) == llGetKey()) {   // missing key cast - Ferd
                    if (shine == 0) {
                        shine = 1;
                        llMessageLinked(LINK_SET, LINK_SHINE, (string)shine, "");
                        llSay(ACC_CHANNEL, xtea_encrypt_string("XSPET^" + (string)id + "^SHINE_GOO_DIE"));
                        llSetLinkPrimitiveParams(5, [PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE]);
                        llSetLinkPrimitiveParams(1, [PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE]);

                        //                llSetLinkColor(8, colour1, ALL_SIDES);
                        //                llSetLinkColor(1, colour1, ALL_SIDES);

                        llSetLinkPrimitiveParams(7, [PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE]);
                        llSetLinkPrimitiveParams(4, [PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE]);
                        llSetLinkPrimitiveParams(9, [PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE]);
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
                if (llList2String(data, 1) == "DIE" && (key) llList2String(data, 2) == llGetKey()) {  // missing key cast - Ferd
                    llDie();
                } else
                if (llList2String(data, 1) == "VERSION" && VERSION < llList2Float(data, 2) && llGetOwnerKey(id) == llGetOwner()) {
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
            if (hunger_amount > 30) {
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
            llWhisper(0, "Looking for a cryo-crate...");
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
            llRezObject("XS Egg", llGetPos() + <0.0, 0.0, 0.25>, ZERO_VECTOR, ZERO_ROTATION, SECRET_NUMBER);
        } else
        if (num == LINK_BREED_FAIL) {
            llSay(ANIMAL_CHANNEL, xtea_encrypt_string("XSPET^BREEDING_FAIL^" + (string)id));
            pregnancy_time = 0;
        } else
        if (num == LINK_SLEEPING) {
            llSetLinkPrimitiveParams(3, [PRIM_COLOR, ALL_SIDES, colour1, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE]);
            llSetLinkPrimitiveParams(8, [PRIM_COLOR, ALL_SIDES, colour1, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, shine, PRIM_BUMP_NONE]);
        } else
        if (num == LINK_UNSLEEPING) {
            llSetLinkPrimitiveParams(3, [PRIM_COLOR, ALL_SIDES, <0,0,0>, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, 1, PRIM_BUMP_NONE]);
            llSetLinkPrimitiveParams(8, [PRIM_COLOR, ALL_SIDES, <0,0,0>, 1.0, PRIM_BUMP_SHINY, ALL_SIDES, 1, PRIM_BUMP_NONE]);
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
            llMessageLinked(LINK_SET, LINK_AGE_START, "", "");

            setup = TRUE;
            
            if (llGetOwner() != llGetCreator()) {
                llAllowInventoryDrop(TRUE);
            }
            
            llSetTimerEvent(5.0);
            
        } else {
                llOwnerSay("I died in your inventory, please use a cryo-crate next time.");
            state dead;
        }
    }
}

state dead
{
    state_entry()
    {
        llSetText("Dead", <1,0,0>, 1.0);
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

    touch_start(integer number)
    {
        llWhisper(0, "I've died. You could re-animate me with a jar of Xtra Strong Mojo");
        if (llDetectedKey(0) == llGetOwner()) {
            llSay(ACC_CHANNEL, xtea_encrypt_string("XSPET^STRONG_MOJO^" + (string)llGetKey() + "^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)shine + "^" + (string)glow + "^" + special + "^" + (string)gen + "^" + (string)sex + "^" + (string)age + "^" + (string)glow_gene + (string)VERSION));

        }
    }

    listen(integer channel, string name, key id, string message) {
        list data = llParseString2List(xtea_decrypt_string(message), ["^"], []);
        if (llList2String(data, 0) == "XSPET") {
            if (llList2String(data, 1) == "STRONG_MOJO_DIE" && llList2Key(data, 2) == llGetKey()) {
                llDie();
            }
        }
    }
}

state update
{
    state_entry()
    {
        llSetText("Updating.", <1,0,0>, 1.0);
        llRemoveInventory("Quail");
        llRemoveInventory("XS Egg");
        llAllowInventoryDrop(TRUE);
        llShout(UPDATE_CHANNEL, "UPDATE_READY");
    }

    changed(integer change)
    {
        if (change & CHANGED_ALLOWED_DROP) {
            if (llGetInventoryType("Quail") != INVENTORY_NONE && llGetInventoryType("XS Egg") != INVENTORY_NONE) {
                llAllowInventoryDrop(FALSE);
                llRezObject("Quail", llGetPos() + <0.0, 0.0, 0.25>, ZERO_VECTOR, ZERO_ROTATION, SECRET_NUMBER);
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

                llGiveInventory(id, "XS Egg");
                llGiveInventory(id, "Quail");
                llSay(ANIMAL_CHANNEL, xtea_encrypt_string("XSPET^UPDATE_CONFIG^" + (string)id + "^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)sex + "^" + (string)shine + "^" + (string)glow + "^" + (string)gen + "^" + (string)age + "^" + (string)hunger_amount + "^" + llGetObjectName() + "^" + (string)glow_gene + "^" + special + "^" + (string)mcolour1 + "^" + (string)mcolour2 + "^" + (string)mshine + "^" + (string)mglow + "^" + (string)mgen + "^" + (string)mglow_gene + "^" + (string)pregnancy_time));
                llDie();
            }
        }
    }
}



