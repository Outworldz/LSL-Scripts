// :CATEGORY:Weapon
// :NAME:HammerThrower
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:54
// :ID:372
// :NUM:514
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// bullet
// :CODE:

// Project: Hammer thrower
// Script: Bullet
// Fly to target and rez hammer. Tell hammer AV name
// Target named avatar with thor's hammer
// rezzed by Launcher and passed avatar name on control channel
// weights fly to 30m above avatar, then rez weight which is physical and drops onto them 
// they delete themselves after 10 minutes
// ZZZ can be deleted by chat
// ZZZ orbit around sim for 3 minutes if cannot find AV named
// pass channel number offset in rez param

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



key k_owner;

integer channel_bullet = 540123;
integer channel_hammer = 477591;

integer time_livefor = 120;  // could live longer

vector bomb_offset = <0,0,10>;

string avname;


set_position(vector targetpos) {
    // fly to position
   while (llVecDist(llGetPos(),targetpos) > 0.001) llSetPos(targetpos);
}


reset() {
    k_owner = llGetOwner();
    llSetAlpha(0.0,ALL_SIDES);
}

fly_to_av(vector avpos) {
    set_position(avpos + bomb_offset);
}

drop_hammer() {
    llRezObject("Hammer",llGetPos() + <0,0,0>,<0,0,0>,<0,0,1,PI>,1);
    llSay(channel_hammer,"attack^" + avname);
}


default
{
    on_rez(integer start_param) {
        reset();
        llSetTimerEvent(time_livefor);
        channel_bullet += start_param;
        llListen(channel_bullet,"","","");
    }
    
    state_entry() {
    }

    listen(integer channel,string name,key id, string message) {
        list cmdline = llParseString2List(message,["^"],[]);
        string cmd = llList2String(cmdline,0);
        string par = llList2String(cmdline,1);
        if (cmd == "attack") {
            // par is the avatar name
            avname = par;
            llSensor(avname,NULL_KEY,AGENT,300,PI);
        } else if (cmd == "die") {
            llDie();
        }
    }
    
    no_sensor() {
        // fly around looking for them
    }
    
    sensor(integer num_detected) {
        vector avpos = llDetectedPos(0);
        fly_to_av(avpos);
        drop_hammer();
        llDie();
    }
}
