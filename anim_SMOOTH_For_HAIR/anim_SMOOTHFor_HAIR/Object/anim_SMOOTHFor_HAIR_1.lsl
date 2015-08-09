// :CATEGORY:Animation
// :NAME:anim_SMOOTH_For_HAIR
// :AUTHOR:Doug Linden
// :KEYWORDS:
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2015-01-31
// :ID:38
// :NUM:51
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// anim SMOOTH-For HAIR.lsl
// :CODE:

// anim SMOOTH Script
// By Doug Linden (I think)
//
// Drop on an object to make it change colors.
//
// If you are interested in scripting, check out
// the Script Help under the help menu.

// The double slash means these lines are comments
// and ignored by the computer.

// All scripts have a default state, this will be
// the first code executed.
default
{
    // state_entry() is an event handler, it executes
    // whenever a state is entered.
    state_entry()
    {   
        // llSetTextureAnim() is a function that animates a texture on a face.
        llSetTextureAnim(ANIM_ON | SMOOTH | LOOP, ALL_SIDES,0,0,0.0, 0,0.05);
                            // animate the script to scroll across all the faces.
    }
 
    
}
 // END //
