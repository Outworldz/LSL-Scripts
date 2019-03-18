// :CATEGORY:Tour
// :NAME:TourCopter
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:08
// :ID:909
// :NUM:1303
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



default
{
    link_message(integer from, integer int, string txt, key id)
    {
        if (txt == "on")
        {
            llSetTextureAnim(ANIM_ON | ROTATE | SMOOTH | LOOP, ALL_SIDES, 1, 1, 0, PI, 10);
           //  llLoopSound("f46d98b3-a812-0db8-a6d5-4943f1f7c1a3",1);
            llSetTexture("helibladesmove" , ALL_SIDES);
            llSetTexture("heliblades", 1);
        }
        if (txt == "off")
        {
            llSetTexture("heliblades" , ALL_SIDES);
            llSetTextureAnim(FALSE, ALL_SIDES, 1, 1, 0, PI, 10);
            llStopSound();
            llSetTexture("helibladesmove", 1);
        }
    }
}

