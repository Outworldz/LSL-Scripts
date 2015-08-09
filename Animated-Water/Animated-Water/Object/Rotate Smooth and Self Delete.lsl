// :CATEGORY:Water
// :NAME:Animated-Water
// :AUTHOR:Auryn Beorn
// :CREATED:2013-12-13 13:08:35
// :EDITED:2013-12-13 13:08:35
// :ID:1006
// :NUM:1550
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Rotate Smooth and Self Delete
// :CODE:
// [Black Tulip] Anim - Rotate Smooth & Self Delete
// Auryn Beorn - Please don't sell this script! - It's OK to GIVE it FOR FREE

// Drop me in the prim you want the texture rotating - I'll clean up after animating


// Need to do changes? Modify the values below in INVENTORY
// Then save your script and drop it in the prim you want the texture animated

integer face = ALL_SIDES;   // Face you want animated - ALL_SIDES for all the prim faces
float   rate = 0.025;       // Rate - Low values: Slow - High values: Quick



// No need to change anything from here

default
{
    state_entry()
    {
        llSetTextureAnim(ANIM_ON | LOOP | SMOOTH | ROTATE, face, 1, 1, 0.0, TWO_PI, rate);
        llRemoveInventory(llGetScriptName());
    }
}
