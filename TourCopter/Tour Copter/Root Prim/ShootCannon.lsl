// :CATEGORY:Tour
// :NAME:TourCopter
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:08
// :ID:909
// :NUM:1300
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
key gunnerId = NULL_KEY;

string bullet = "bullet";
float bullet_speed = 100.0;
integer fire = FALSE;

key sound_full = "e6b53731-58b2-9a5a-aafa-9a01ef21c1b8";
key sound_leadout = "05100d06-bf41-785b-1747-6f476f6288b8";

default
{
    state_entry()
    {
        //llSetLocalRot(<0.00000, 0.70711, 0.00000, 0.70711>);
    }
    
    link_message(integer sender_num, integer num, string str, key id)
    {
        if (str == "fire")
        {
            llResetOtherScript("bullet_rez_1");
            llResetOtherScript("bullet_rez_2");
            llResetOtherScript("bullet_rez_3");
            llResetOtherScript("bullet_rez_4");
            llTriggerSound("05100d06-bf41-785b-1747-6f476f6288b8", 1.0);
            
            llSetScriptState("bullet_rez_1", TRUE);
            llSetScriptState("bullet_rez_2", TRUE);
            llSetScriptState("bullet_rez_3", TRUE);
            llSetScriptState("bullet_rez_4", TRUE);
            llMessageLinked(LINK_THIS, 0, "fire", NULL_KEY);
                
        }
        else
        {
            llSetScriptState("bullet_rez_1", FALSE);
            llSetScriptState("bullet_rez_2", FALSE);
            llSetScriptState("bullet_rez_3", FALSE);
            llSetScriptState("bullet_rez_4", FALSE);
            
            
        }

    }
    
   

}

