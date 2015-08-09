// :CATEGORY:Glow
// :NAME:glow_when_stept_on
// :AUTHOR:melnik Balogh
// :CREATED:2010-10-10 05:58:08.137
// :EDITED:2014-01-17 11:07:15
// :ID:354
// :NUM:477
// :REV:1.0
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// Category: Lighting
// Description: I got tired of paying for ridiculously overpriced Avatar-like plants that glow when you walk on them.
// Same thing goes for sidewalks that light up.  So here is a simple script that changes the glow of a prim when you walk on it.
// Useful for ground plants that glow in the dark, lighted footsteps, and trails that point people the 
// direction you want them to go.  makes floor tiles, dance floors and other objects glow when bumped
//
// :CODE:
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// Other licenses may be located within the source of this script, 
// in which case the more restrictive license is to take effect
//
////////////////////////////////////////////////////////////////////
integer is_on = FALSE;
float glow = .1;
default
{
    collision_start(integer num_detected) 
    {
        if(!is_on)
        {
            float i;
            for(i = 0.0; i < glow; i += 0.020 )
            {
                llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, i]);
                //llSleep(1.0);
            }
            is_on = TRUE;
        }
    }

    collision_end(integer num_detected) 
    {
        if(is_on)
        {
            float i;
            for(i = glow; i > 0.0; i -= 0.020 )
            {
                llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, i]);
                //llSleep(1.0);
            }
            llSetPrimitiveParams([PRIM_GLOW, ALL_SIDES, 0]); // Turn off glow when step off prim....
            is_on = FALSE;
            llResetScript();
            
        }
    }
}
