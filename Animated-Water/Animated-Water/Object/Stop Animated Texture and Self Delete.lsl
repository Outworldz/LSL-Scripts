// :CATEGORY:Water
// :NAME:Animated-Water
// :AUTHOR:Auryn Beorn
// :CREATED:2013-12-13 13:09:52
// :EDITED:2013-12-13 13:09:52
// :ID:1006
// :NUM:1553
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Stop Animated Texture and Self Delete
// :CODE:
// [Black Tulip] Anim - Stop Animated Texture & Self Delete
// Auryn Beorn - Please don't sell this script! - It's OK to GIVE it FOR FREE

// Drop me in the prim you want the animated texture to stop - I'll clean up on my own


default
{
    state_entry()
    {
        llSetTextureAnim(FALSE, ALL_SIDES, 1, 1, 0.0, 0.0, 0.1);
        llRemoveInventory(llGetScriptName());
    }
}
