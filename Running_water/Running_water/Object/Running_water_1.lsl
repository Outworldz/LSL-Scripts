// :CATEGORY:Water
// :NAME:Running_water
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:01
// :ID:716
// :NUM:981
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Running water.lsl
// :CODE:

default
{
    state_entry()
    {
      llSetStatus(STATUS_PHANTOM, TRUE);
      llSetTextureAnim(ANIM_ON|LOOP|SMOOTH, ALL_SIDES, 1, 1, 0, 0, .225);
    }
}
// END //
