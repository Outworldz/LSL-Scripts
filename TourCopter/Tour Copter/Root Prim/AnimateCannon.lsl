// :CATEGORY:Tour
// :NAME:TourCopter
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:08
// :ID:909
// :NUM:1288
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



integer fps = 14;

off()
{
    llSetTextureAnim(FALSE, ALL_SIDES, 4, 1, 3, 1, fps);
    llSetTextureAnim(ANIM_ON, ALL_SIDES, 4, 1, 3, 1, fps);
}

default
{
    state_entry()
    {
        //llSetAlpha(0.0, ALL_SIDES);
      //  llSetAlpha(1.0, 1);
      //  llSetAlpha(1.0, 2);
      //  llSetColor(<1.0, 1.0, 1.0>, ALL_SIDES);
      //  llSetColor(ZERO_VECTOR, 0);
        off();
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "fire") {
             llSetColor(<1,1,0>,2);
              llSetTexture("6d209b1b-495c-2c9a-2efd-720bcd61e239" , 2);
             llSetTextureAnim(ANIM_ON | LOOP, 2, 2, 1, 0.0, 2.0, 20.0);
        } else if (str == "fire1") {
            llSetTextureAnim(FALSE, ALL_SIDES, 4, 1, 1, 3, fps * 3);
            llSetTextureAnim(ANIM_ON, ALL_SIDES, 4, 1, 1, 3, fps * 3);
        } else {
            llSetTextureAnim(FALSE, 2, 2, 1, 0.0, 2.0, 20.0);
            llSetColor(<0,0,0>,2);
            
        }
    }
}

