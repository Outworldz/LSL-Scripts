// :CATEGORY:XS Quail
// :NAME:XS Pet Quail Modified
// :AUTHOR:Xundra Snowpaw, Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-17 21:48:47
// :ID:987
// :NUM:1427
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Xs FoodBowl Animation
// :CODE:
// WORLD: Second Life, Opensim
// DESCRIPTION:
// Modified Pet Quail

// Version .26 Robot 11-16-2011

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

// revisions
// 0.26 modified to show food bowl filling for creator only.


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

float VERSION = 0.26;

key YOUR_UUID = "";        // if you add a UUID for your avatar here, you can change it later
                              // and other alts or feruiends can edit and make these pets
                              // If you leave it blank, only the creator can work on them
string Animal = "Troubot";        // was 'Quail', must be the name of your animal
string Egg = "Nut and Bolt";      // was 'XS Egg', must be the name of your egg
string Crate = "Transport UFO";   // was XS-Cryocrate
string HomeObject = "Home Flag"; // was "XS Home Object
string sound = "robot_sound";
string  SECRET_PASSWORD = "top secret robot";    // must use one unique to any animal
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
string  ANI_WALKL   = "left";           // triggers Left foot and righrt arm walk animation
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
integer LINK_CALL_MALE_INFO = 968;      // sent by xs_breeding, this line of code was in error in v.24 of xs_breeding see line 557 and 636 of xs_brain which make calls and also xs_breeding which receives LINK_MALE_INFO.
integer LINK_MALE_INFO = 969;
integer LINK_LAY_EGG = 970;             // llRezObject("XS Egg"
integer LINK_BREED_FAIL = 971;          // key = father, failed, timed out
integer LINK_PREGNANT = 972;            // chick is preggers
integer LINK_SOUND_OFF= 974;             // sound is off
integer LINK_SOUND_ON= 973;             // sound is on
integer LINK_SLEEPING = 990;            // close eyes
integer LINK_UNSLEEPING = 991;          // open eyes
integer LINK_SOUND = 1001;              // plays a sound if enabled
integer LINK_SPECIAL = 1010;            // xs_special, is str = "Normal", removes script
integer LINK_PREGNANCY_TIME = 5000;    // in seconds as str
integer LINK_SLEEP = 7999;              // disable sleep by parameter
integer LINK_TIMER = 8000;              // scan for food bowl about every 1800 seconds
integer LINK_DIE = 9999;                // death


///////// end global Link constants ////////


///////////// END OF COPIED CODE ////////////

// tunable constants

integer PIE = TRUE;            // set to TRUE for pie slices, set to FALSE for Vertical liquid/plasma effect


// globals

integer food_left;
// code

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
        food_left = UNITS_OF_FOOD;

        if ( ! CheckPerms() )
        {
            float i = 0 ;
            while (i < 1)
            {
                if (PIE)
                    llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_CYLINDER, PRIM_HOLE_DEFAULT, <0, i, 0>, 0, <0, 0, 0>, <1.0, 1.0, 0.0>, <0,0,0>]);
                else
                {
                    float unit =  (float) UNITS_OF_FOOD /10;
                    llMessageLinked(LINK_SET,100,(string) unit,"");
                }
                i += 0.1 ;
            }
            // set the fusion back to full
            if (!PIE)
                llOffsetTexture(1,0.5,ALL_SIDES);
        }
    }

    link_message(integer sender, integer number, string str, key id)
    {

        if (number == 100) {
            // its a decrease message
            integer amount = (integer)str;

            food_left = food_left - amount;


            if (PIE)
            {
                // do the pie slice thing
                float cut_amount = ((float)food_left / (float)UNITS_OF_FOOD) * 0.95;
                llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_CYLINDER, PRIM_HOLE_DEFAULT, <0, cut_amount, 0>, 0.0, <0, 0, 0>, <1.0, 1.0, 0.0>, <0,0,0>]);
            }
            else
            {
                // do the vertical plasma draining effect

                float offset_amount = 1 - ((float)food_left / (float)UNITS_OF_FOOD) /2;

                llOffsetTexture(1,offset_amount,ALL_SIDES);    // slide the texture
            }
        }
        llSleep(0.1);   // time to see this at startup
    }
}
