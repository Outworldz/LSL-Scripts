// :CATEGORY:Texture
// :NAME:play_texture
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:635
// :NUM:863
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// play texture.lsl
// :CODE:

default
{
    state_entry()
    {
        llSetStatus(STATUS_PHANTOM,TRUE);
        llSetTexture("wavypiano", ALL_SIDES);
        llSetTextureAnim (ANIM_ON | LOOP, ALL_SIDES, 1, 8, 0, 0,4);
    }
}// END //
