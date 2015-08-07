// :CATEGORY:Tour
// :NAME:TourCopter
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:08
// :ID:909
// :NUM:1287
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
// aimer 1 of 3
//
//Revisions:
// 1/28/2010 initial release

key gunnerId = NULL_KEY;
integer debug = 1;

Gun(string str, key ShootAt )
{
    if (str == "gun-aim")
    {
        gunnerId = ShootAt;
        if (ShootAt == NULL_KEY)
        {
            llSensorRemove();
            llSetLocalRot(<0.00000, 0.70711, 0.00000, 0.70711>);
        }
        else
        {
            llSensorRepeat("", "", AGENT, 20.0, TWO_PI, 0.1);        // aim at an avatar
        }
    }
    else if (str == "gun-stop")
    {
        llSensorRemove();
        llSetLocalRot(<0.00000, 0.70711, 0.00000, 0.70711>);
    }
    else if (str == "pilot")
    {
        gunnerId = ShootAt;
    }


}

default
{
    state_entry()
    {
        
        llSetLocalRot(<0.00000, 0.70711, 0.00000, 0.70711>);        // point down.
        
        if (debug)
        {
            Gun("gun-aim", llGetOwner());  
        }
    }

    link_message(integer sender_num, integer num, string str, key id)
    {
        Gun(str,id);
    }

    no_sensor()
    {
        gunnerId = NULL_KEY;
        llSensorRemove();
        llSetLocalRot(<0.00000, 0.70711, 0.00000, 0.70711>);
    }

    sensor(integer num_detected)
    {
        integer i;
        for (i = 0; i < num_detected; i++)
        {
            if (llDetectedKey(i) != gunnerId)
            {
                // rotation headRot = llDetectedRot(0) * llEuler2Rot(<0,0,DEG_TO_RAD * 180>);
                //llSay(0, (string)(llRot2Euler(headRot) * RAD_TO_DEG));
                //headRot = llEuler2Rot(<0.0, DEG_TO_RAD * 180.0, 0.0>) * llEuler2Rot(<headRot.y, 0.0, headRot.z>);
                //llSay(0, (string)(llRot2Euler(llDetectedRot(0)) * RAD_TO_DEG));
                llSetLocalRot(<0.00000, 0.70711, 0.00000, 0.70711> * ((llDetectedRot(i) / llGetRootRotation()) / llGetRootRotation()));
                llSleep(0.5);
            }
        }
    }
}

