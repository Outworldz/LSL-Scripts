// :CATEGORY:Weapon
// :NAME:HammerThrower
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:54
// :ID:372
// :NUM:515
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// a hammer to toss on people
// :CODE:

// Script: The hammer
// die() after 10mins
// chase avatar around bashing them
// non physical object, but use damage if they collide
// particle system of little hammers/anvils/sparks/lightning?

//Simple OpenSource Licence (I am trusting you to be nice)
//1.  PLEASE SEND ME UPDATES TO THE CODE
//2.  You can do what you want with this code and object including selling it in other objects and so on. 
//You can sell it in closed source objects if you must, but please try to send any updates or
//improvements back to me for possible inclusion in the main trunk of development.
//3.  You must always leave these instructions in any object created; notecard written; posting to
//any electronic medium such as Forum, Email &c. of the source code & generally be nice (as
//already requested!)
//4.  You must not claim that anyone apart from sparti Carroll wrote the original version of this software.
//5.  You can add and edit things below =THE LINE= but please try  to keep it all making sense.
//Thank you for your co-operation
//sparti Carroll


integer FLAGdebug = FALSE;

integer channel_bullet = 540123;
integer channel_hammer = 477591;

// working
key hammer_avkey;
vector hammer_avpos;  // current position of AV being attacked
string hammer_targetting;  // name of AV being attacked
integer hammer_attacks;  // how many attacks left

// configuration
integer hammer_new_attacks_on_touch = 3;
float hammer_attack_timeout = 120.0; // how long before die if in attack mode
// how long before start attack again in resting mode
float hammer_resting_timeout_min = 15.0;  // minimum
float hammer_resting_timeout_range = 50.0;  // range


set_position(vector targetpos) {
    // fly to position
    while (llVecDist(llGetPos(),targetpos) > 0.001)
        llSetPos(targetpos);
}

// can have several of these
animate_bash() {
    //spin around to an arbitrary attack angle
    //bash the av a random number of times
    //do particle effects
    //go to rest position
    //set orientation
    if (FLAGdebug)
        llOwnerSay("attack starts");
    llSetPrimitiveParams([PRIM_PHYSICS,FALSE]);
    vector v_random_rot = <0,0,llFrand(360)> * DEG_TO_RAD;
    rotation random_rot = llEuler2Rot(v_random_rot);
    vector anim_blow_ready = <0,9,0> * random_rot;

    anim_blow_ready += <0,0,9>;

    vector nowpos = hammer_avpos + anim_blow_ready;
    set_position(nowpos);
    vector v_base_rotation = <45,0,0> * DEG_TO_RAD;
    vector v_swipe_down_rotation = <135,0,0> * DEG_TO_RAD;
    vector v_finish_rotation= <95,llFrand(90),llFrand(90)> * DEG_TO_RAD;
    rotation hammer_base_rotation = llEuler2Rot(v_base_rotation);
    rotation hammer_swipe_down_rotation = llEuler2Rot(v_swipe_down_rotation);
    rotation hammer_finish_rotation = llEuler2Rot(v_finish_rotation);
    hammer_base_rotation *= random_rot;
    hammer_swipe_down_rotation *= random_rot;
    hammer_finish_rotation *= random_rot;
    llSetRot(hammer_base_rotation);
    llSleep(1.0);
    // pound on AV!
    integer c_swipe;
    float swipes_random = 10.0;
    float swipes_base = 4.0;
    integer num_swipes = (integer)(llFrand(swipes_random) + swipes_base);
    for (c_swipe=0;c_swipe < num_swipes; c_swipe++)
    {
        llSleep(0.5);
        llSetRot(hammer_swipe_down_rotation);
        llSleep(0.5);
        llSetRot(hammer_finish_rotation);
        llSleep(0.5);
        llSetRot(hammer_base_rotation);
       
    }
    
}

animate_resting() {
    llSetPrimitiveParams([PRIM_PHYSICS,TRUE]);
}


reset() {
    hammer_attacks = (integer)(llFrand(10.0) + 5.0);
    llSetTimerEvent(120.0); // time to init
}

default {
    on_rez(integer start_param) {
        llListen(channel_hammer,"","","");
        reset();
        llSetPrimitiveParams([PRIM_PHYSICS,TRUE]);
    }
    
    state_entry() {
        if (FLAGdebug) llOwnerSay("Starting up");
        reset();
    }
    
    listen(integer channel,string name,key id, string message) {
        list cmdline = llParseString2List(message,["^"],[]);
        string cmd = llList2String(cmdline,0);
        string par = llList2String(cmdline,1);
        if (cmd == "attack") {
            hammer_targetting = par;
            state attack;
        } else if (cmd == "die") {
            llDie();
        }
    }
    
    touch_start(integer num_detected) {
        key k_touch = llDetectedKey(0);
        if (k_touch == hammer_avkey) {
            //start attack now and add some more attacks
            hammer_attacks += (integer)llFrand(hammer_new_attacks_on_touch);
            state attack;
        } else {
            string name = llKey2Name(k_touch);
            float dowhat = llFrand(3.0);
            if (dowhat < 2.0)  {
                llSay(0,"I have not come for you " + name + " so don't tempt me!");
            }    else {
                llSay(0,"I had not come for you " + name);
                llSleep(3.0);
                llSay(0,"But I have changed my mind !!!");
                hammer_targetting = name;
                state attack;
            }
        }
    }

    
    timer() {
        // failed to init
        llOwnerSay("failed to initialise hammer: llDie");
    }
}


state attack {
    on_rez(integer start_param) {
        // should not rez in this state
        llDie();
    }
    
    state_entry() {
        // find them (again) and attack
        // turn off phys
        hammer_attacks--;
        llSensor(hammer_targetting,NULL_KEY,AGENT,300,PI);
        llSetTimerEvent(hammer_attack_timeout);
    }
    
    no_sensor() {
        // fly around looking for them
        // die if not found after N seconds
    }
    
    sensor(integer num_detected) {
        hammer_avkey = llDetectedKey(0);
        hammer_avpos = llDetectedPos(0);
        animate_bash();
        // finshed attacking ?
        if (hammer_attacks <= 0) {
            llDie();
        } else {
            state resting;
        }
    }

    touch_start(integer num_detected) {
        // advertise ?
    }
    
    timer() {
        llDie();
    }
}


state resting {
    // wait before attacking av again
    on_rez(integer start_param) {
        // should not be rezzed in this state
        llDie();
    }
    state_entry() {
        animate_resting();
        llSetTimerEvent(hammer_resting_timeout_min + llFrand(hammer_resting_timeout_range));
    }
    
    touch_start(integer num_detected) {
        key k_touch = llDetectedKey(0);
        if (k_touch == hammer_avkey) {
            //start attack now and add some more attacks
            hammer_attacks += (integer)llFrand(hammer_new_attacks_on_touch);
            state attack;
        } else {
            string name = llKey2Name(k_touch);
            float dowhat = llFrand(3.0);
            if (dowhat < 2.0)  {
                llSay(0,"I have not come for you " + name + " so don't tempt me!");
            }    else {
                llSay(0,"I had not come foo you " + name);
                llSleep(3.0);
                llSay(0,"But I have changed my mind !!!");
                hammer_targetting = name;
                state attack;
            }
        }
    }
    
    timer() {
        state attack;
    }
}

