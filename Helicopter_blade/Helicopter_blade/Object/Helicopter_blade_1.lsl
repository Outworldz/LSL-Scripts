// :CATEGORY:Vehicles
// :NAME:Helicopter_blade
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:378
// :NUM:525
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Blade
// :CODE:
// From the book:
//
// Scripting Recipes for Second Life
// by Jeff Heaton (Encog Dod in SL)
// ISBN: 160439000X
// Copyright 2007 by Heaton Research, Inc.
//
// This script may be freely copied and modified so long as this header
// remains unmodified.
//
// For more information about this book visit the following web site:
//
// http://www.heatonresearch.com/articles/series/22/

float rad = 0.0;
float radinc = 0.05;
float time_inc = .2;
float rotspeed = 3.2;

default
{    

    state_entry()
    {
        llSetTextureAnim(0, ALL_SIDES, 0, 0, 0, 0, 0);
    }
    
    link_message(integer sender_num, integer num, string str, key id)
    {
        if(str=="stop")
        {
            llSetTextureAnim(0, ALL_SIDES, 0, 0, 0, 0, 0);
        }
        if(str=="start")
        {
            llSetTextureAnim(ANIM_ON | ROTATE | LOOP | SMOOTH, ALL_SIDES, 0, 0, 0, 100, 20);
        }
    }
    
}
