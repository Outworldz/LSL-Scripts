// :CATEGORY:XS Pet
// :NAME:XS Pet Quail Modified
// :AUTHOR:Xundra Snowpaw, Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:09
// :ID:987
// :NUM:1419
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



integer API_CHANNEL = -999198;
integer MAXIMUM_HUNGER = 30;
integer ANIMAL_CHANNEL = -999192;


integer hunger_amount;
//integer eaten;

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

    llWhisper(0, "Head/Body Colour: " + (string)colour1);
    llWhisper(0, "Tail/Wing Colour: " + (string)colour2);
    llWhisper(0, "Shine: " + myshine);
    llWhisper(0, "Glow: " + (string)((integer)(glow * 100)) + "%");
    llWhisper(0, "Special: " + special);
    llWhisper(0, "Sex: " + mysex);
    llWhisper(0, "Age: " + (string)age + " days");
    llWhisper(0, "Generation: " + (string)gen);

    llSay(API_CHANNEL, "XSQuail^" + (string)llGetKey() + "^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)shine + "^" + (string)glow + "^" + special + "^" + (string)gen + "^" + (string)sex + "^" + (string)age + "^XSQuailEnd");
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
        hunger_amount = 0;
        age = 0;
        pregnant = "";
        play_sounds = 1;
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
            mysex = (string)sex;
        }

        llSetText(llGetObjectName() + "\n" +  mysex + " - Age: " + (string)age + " - Gen: " + (string)gen + "\n" + "Hunger: " + (string)hunger_amount + "/" + (string)MAXIMUM_HUNGER + "\n" + pregnant + sleep, <1,1,1>, 1.0);

        say_details();


        menu_expired = 0;

        if (llDetectedKey(0) == llGetOwner()) {
            integer menu_chan = (integer)llFrand(10000.0) + 100;
            llListenRemove(menu_listener);
            menu_listener = llListen(menu_chan, "", llGetOwner(), "");


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
        if (num == LINK_SOUND) {
            if (play_sounds) {
                llPlaySound("bird_sound", 1.0);
            }
        } else
        if (num == LINK_SPECIAL) {
            special = str;
        }
        //
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
                llSetObjectName(myname);
                llListenRemove(name_listener);
            }
        } else if (channel == API_CHANNEL) {
                list data = llParseString2List(msg, ["^"], []);
            if (llList2String(data, 0) == "XSQuail" && llList2Key(data, 1) == llGetKey()) {
                llSay(API_CHANNEL, "XSQuail^" + (string)llGetKey() + "^" + (string)colour1 + "^" + (string)colour2 + "^" + (string)shine + "^" + (string)glow + "^" + special + "^" + (string)gen + "^" + (string)sex + "^" + (string)age + "^XSQuailEnd");
            }
        } else if (channel != ANIMAL_CHANNEL) {
                llListenRemove(menu_listener);
            menu_expired = 0;
            if (msg == "Name") {
                name_listener = llListen(0, "", llGetOwner(), "");
                llSetTimerEvent(30.0);
            } else
            if (msg == "Package") {
                llMessageLinked(LINK_SET, LINK_PACKAGE, "", "");
            } else
            if (msg == "Sound") {
                if (play_sounds) {
                    llWhisper(0, "Turning sound off.");
                } else {
                    llWhisper(0, "Turning sound on.");
                }
                play_sounds = !play_sounds;
            } else
            if (msg == "Home Object") {
                llGiveInventory(llGetOwner(), "XS Home Object");
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



