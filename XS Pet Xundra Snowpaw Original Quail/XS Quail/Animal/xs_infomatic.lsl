// :CATEGORY:XS Pet
// :NAME:XS Pet Xundra Snowpaw Original Quail
// :AUTHOR:Xundra Snowpaw
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:10
// :ID:989
// :NUM:1475
// :REV:1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Original Pet Quail
// :CODE:

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
        if (num == 800) {
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
        if (num == 903 || num == 904) {
            hunger_amount = (integer)str;
        } else
        if (num == 901) {
            hunger_amount --;
            //eaten ++;
        } else
        if (num == 930) {
            colour1 = (vector)str;
        } else
        if (num == 931) {
            colour2 = (vector)str;
        } else
        if (num == 932) {
            sex = (integer)str;
        } else
        if (num == 933) {
            shine = (integer)str;
        } else
        if (num == 934) {
            glow = (float)str;
        } else
        if (num == 935) {
            gen = (integer)str;
        } else
        if (num == 940) {
            age += (integer)str;
        } else
        if (num == 972) {
            pregnant = "Pregnant";
            llSay(API_CHANNEL, "I'm Pregnant!");
        } else
        if (num == 5000) {
            sex = 2;
            if ((integer)str != 0) {
                pregnant = "Pregnant";
            }
        } else
        if (num == 970) {
            pregnant = "";
        } else
        if (num == 990) {
            sleep = "\nSleeping";
        } else
        if (num == 991) {
            sleep = "";
        } else
        if (num == 1001) {
            if (play_sounds) {
                llPlaySound("bird_sound", 1.0);
            }
        } else
        if (num == 1010) {
            special = str;
        }
//        
        if (num == 910) {
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
                llMessageLinked(LINK_SET, 950, "", "");
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
                llMessageLinked(LINK_SET, 7999, (string)sleep_disabled, "");
            }
        }
    }
}

