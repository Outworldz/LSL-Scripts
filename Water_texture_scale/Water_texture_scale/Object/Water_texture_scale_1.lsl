// :CATEGORY:Water
// :NAME:Water_texture_scale
// :AUTHOR:Harry Rau
// :CREATED:2011-08-17 04:19:53.357
// :EDITED:2013-09-18 15:39:09
// :ID:965
// :NUM:1387
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// the script
// :CODE:
//Workaround for changing texturscale
default {
    state_entry() {
      llSetTextureAnim(ANIM_ON | SMOOTH | LOOP, ALL_SIDES, 1, 0, 0.0, 0.0, 0.02);
      llScaleTexture (5.0,5.0, ALL_SIDES); //Workaround for scaling textures. All Sides or define single sides
      llResetScript();
    }
}

