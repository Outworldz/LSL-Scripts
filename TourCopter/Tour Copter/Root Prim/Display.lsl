// :CATEGORY:Tour
// :NAME:TourCopter
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:08
// :ID:909
// :NUM:1294
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tour
// :CODE:

﻿// ______           _  ______            _           _
// |  ___|         | | |  ___|          | |         (_)
// | |_ ___ _ __ __| | | |_ _ __ ___  __| | ___ _ __ ___  __
// |  _/ _ \ '__/ _` | |  _| '__/ _ \/ _` |/ _ \ '__| \ \/ /
// | ||  __/ | | (_| | | | | | |  __/ (_| |  __/ |  | |>  <
// \_| \___|_|  \__,_| \_| |_|  \___|\__,_|\___|_|  |_/_/\_\
//
// fred@mitsi.com
// tour copter script
// Display
//
//Revisions:
// 1/28/2010 initial release




integer display = TRUE;
string guest = "";

vector pos;
string altitude;
string altitude_sea;
string text;


integer afterburner;
vector velocity;
string speed;
string throttle;


default
{
    state_entry()
    {
        llSetText(" ", <1.0, 1.0, 1.0>, 0.0);
        afterburner = FALSE;
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "start") {
            state active;
        } else if (str == "throttle") {
            throttle = (string)num;
        } else if (str == "displayoff") {
            display = FALSE;
        } else if (str == "displayon") {
            display = TRUE;
        }
    }
}

state active
{
    state_entry()
    {
        if (display) {
            llSetTimerEvent(0.25);
        }
    }
    
    state_exit()
    {
        llSetTimerEvent(0.0);
    }
    
    on_rez(integer sparam)
    {
        state default;
    }

    timer()
    {
        if (display) {
            pos = llGetPos() + (llGetVel() / 2.0);
            if (pos.x > 256.0 || pos.x < 0.0 || pos.y > 256.0 || pos.y < 0.0) {
                llMessageLinked(LINK_SET, 0, "afterburneroff", NULL_KEY);
            }
            pos = llGetPos();
    
            if (afterburner) {
                text = "Throttle: AFTERBURNER";
            } else {
                text = "Throttle: " + throttle + "%";
            }
            
            velocity = llGetVel();
            speed = (string)llVecMag(velocity);
            speed = llGetSubString(speed, 0, llSubStringIndex(speed, ".") + 3);
            text += "  -  Speed: " + speed + " m/s";
            
//            rot = llGetRot();
//            fwd = llRot2Up(rot * llRotBetween(llRot2Fwd(rot), <0.0, 0.0, 1.0>)) * -1.0;
//            heading = llFloor((llAtan2(fwd.x, fwd.y) * RAD_TO_DEG) + 0.5);
//            if (heading < 0) {
//                heading += 360;
//            }
//            text += "  -  Heading: " + (string)heading + " degrees";
            
            text += "\n----------";
            
            altitude = (string)pos.z;
            altitude = llGetSubString(altitude, 0, llSubStringIndex(altitude, ".") + 3);
            altitude_sea = (string)(pos.z - llWater(ZERO_VECTOR));
            altitude_sea = llGetSubString(altitude_sea, 0, llSubStringIndex(altitude_sea, ".") + 3);
            text += "\nAltitude (abs): " + altitude + " meters";
            text += "\nAltitude (sea): " + altitude_sea + " meters";
            
            text += "\nCoordinates: " + (string)llFloor(pos.x) + ", " + (string)llFloor(pos.y) + " (" + llGetRegionName() + ")";
            
            guest = llGetLinkName(18);
            if (guest != "Object") {
                text += "\nGuest Pilot: " + guest;
            }
            
            llSetText(text + "\n ", <0.25, 0.25, 1.0>, 1.0);
        } else {
            llSetTimerEvent(0.0);
            llSetText(" ", <0.25, 0.25, 1.0>, 0.0);
        }
    }

    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "stop" ) {
            state default;
        } else if (str == "throttle") {
            throttle = (string)num;
        } else if (str == "afterburner") {
            afterburner = TRUE;
        } else if (str == "afterburneroff") {
            afterburner = FALSE;
        } else if (str == "displayoff") {
            display = FALSE;
        } else if (str == "displayon") {
            display = TRUE;
            llSetTimerEvent(0.25);
        }
    }
}

