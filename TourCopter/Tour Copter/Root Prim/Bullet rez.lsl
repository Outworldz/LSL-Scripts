// :CATEGORY:Tour
// :NAME:TourCopter
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:08
// :ID:909
// :NUM:1292
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
// Bullet rez 1 of 4
//
//Revisions:
// 1/28/2010 initial release


vector rez_pos = <2.5, 0.1, 0.05>;

float bullet_speed = 200.0;



default
{
    state_entry()
    {
        
        
    }
    
    link_message(integer sender_num, integer num, string str, key id)
    {
        if (str == "fire")
        {   
            integer fire = 0;
            rotation rot = <0.00000, -0.70711, 0.00000, 0.70711> * (llGetLocalRot() * llGetRootRotation());
            vector pos = llGetRootPosition() + (llGetLocalPos() * llGetRootRotation()) + (rez_pos * rot);
            vector vel = (<bullet_speed, 0.0, 0.0> * rot) + llGetVel();
            do {
                llTriggerSound("64aeeca3-8760-385b-b2c9-f9465c202ba7", 1.6);    
                llRezObject(llGetObjectDesc(), pos, vel, <0.0000, 0.70711, 0.0000, 0.70711> * rot, 1);
            } while (fire++ < 5);
        }
    }

   
    
    on_rez(integer sparam)
    {
        llResetScript();
    }
}

