// :CATEGORY:XS Pet
// :NAME:XS Pet Quail Modified
// :AUTHOR:Xundra Snowpaw, Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:09
// :ID:987
// :NUM:1417
// :REV:1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Modified Pet Quail
// :CODE:

// Version .25  12-15-2011
// revision history
// xs_breeding: LINK_CALL_MALE_INFO was in error on line 159, was LINK_CALL_MALE, should be LINK_CALL_MALE_INFO

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

integer age;
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
        } else
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

state male
{
    state_entry()
    {
        looking_for_female = 0;

        mother = NULL_KEY;
        father = NULL_KEY;

        llMessageLinked(LINK_SET, LINK_GET_AGE, "", "");

        if (age >= 7) {
            llSetTimerEvent(10800.0);
        }
    }
    link_message(integer sender, integer num, string str, key id)
    {
        if (num == LINK_PUT_AGE) {
            age = (integer)str;
            if (age >= 7) {
                llSetTimerEvent(10800.0);
            }
        } else
        if (num == LINK_MAGE) {

            age += (integer)str;
            if (age >= 7) {
                llSetTimerEvent(10800.0);
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
                llMessageLinked(LINK_SET, LINK_CALL_MALE_INFO, "", mother);          // error by Ferd, was LINK_CALL-MALE, should be LINK_CALL_MALE_INFO
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
            age += (integer)str;
        } else
        if (num == LINK_MALE_BREED_CALL) {
            // signal I am eligible
            if (age >= 7 && father == NULL_KEY) {
                llWhisper(0, llGetObjectName() + " blushes then bobs her head up and down.");
                llMessageLinked(LINK_SET, LINK_SIGNAL_ELIGIBLE, "", "");
            }
        } else
        if (num == LINK_MALE_ON_THE_WAY) {
            // male on the way, rest for 20m
            llSetTimerEvent(900.0);
            father = id;
            mother = llGetKey();
            llMessageLinked(LINK_SET, LINK_MOVER, "1200", "");
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
            llSetTimerEvent(172800.0 - (float)(llGetUnixTime() - preg_time));
        } else {
                llSetTimerEvent(172800.0);
        }
    }
    timer()
    {
        // lay egg.
        llSetTimerEvent(0);
        llMessageLinked(LINK_SET, LINK_LAY_EGG, "", "");
        state female;
    }
}


