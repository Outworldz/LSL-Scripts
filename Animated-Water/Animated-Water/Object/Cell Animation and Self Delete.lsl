// :CATEGORY:Water
// :NAME:Animated-Water
// :AUTHOR:Auryn Beorn
// :CREATED:2013-12-13 13:07:22
// :EDITED:2014-01-21 15:37:25
// :ID:1006
// :NUM:1548
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Cell Animation and Self Delete
// :CODE:
// [Black Tulip] Anim - Cell Animation & Self Delete
// Auryn Beorn - Please don't sell this script! - It's OK to GIVE it FOR FREE

// Drop me in the prim you want the texture cell animated - I'll clean up after animating


// Need to do changes? Modify the values below in INVENTORY
// Then save your script and drop it in the prim you want the texture animated

integer face = ALL_SIDES;   // Face you want animated - ALL_SIDES for all the prim faces
float   rate = 10.0;        // Rate - Low values: Slow - High values: Quick

integer columns = 3;
integer rows = 4;


// No need to change anything from here

default
{
    state_entry()
    {
        llSetTextureAnim(ANIM_ON | LOOP, face, columns, rows, 0.0, columns * rows, rate);
        llRemoveInventory(llGetScriptName());
    }
}
