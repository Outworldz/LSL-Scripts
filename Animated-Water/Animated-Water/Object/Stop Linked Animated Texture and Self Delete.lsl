// :CATEGORY:Water
// :NAME:Animated-Water
// :AUTHOR:Auryn Beorn
// :CREATED:2013-12-13 13:09:00
// :EDITED:2013-12-13 13:09:00
// :ID:1006
// :NUM:1551
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Stop Linked Animated Texture and Self Delete
// :CODE:
// [Black Tulip] Anim - Stop Linked Animated Texture & Self Delete
// Auryn Beorn - Please don't sell this script! - It's OK to GIVE it FOR FREE

// Drop me in the object you want ALL the animated textures to stop - I'll clean up on my own


default
{
    state_entry()
    {
        llSetLinkTextureAnim(LINK_SET, FALSE, ALL_SIDES, 1, 1, 0.0, 0.0, 0.1);
        llRemoveInventory(llGetScriptName());
    }
}
