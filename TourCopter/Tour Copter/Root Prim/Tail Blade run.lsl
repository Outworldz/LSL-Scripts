// :CATEGORY:Tour
// :NAME:TourCopter
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:08
// :ID:909
// :NUM:1302
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tour
// :CODE:

﻿
//tail blade run

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

