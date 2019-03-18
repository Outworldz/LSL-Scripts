// :CATEGORY:Boat
// :NAME:DaVinci Boat
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-08
// :EDITED:2013-09-18 15:38:51
// :ID:220
// :NUM:296
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// A drivable, smoking, wheel spinning mesh daVinci boat, meshes and textures.
// :CODE:
default
{
    state_entry()
    {
        llSetTextureAnim( ANIM_ON | LOOP, ALL_SIDES, 2, 4, 0.0, 8.0, 10 );
    }
}
