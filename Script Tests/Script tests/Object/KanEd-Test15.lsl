// :CATEGORY:Scripting
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// One of many tests for Opensim
// :CODE:

default
{
   state_entry()
   {
       llSetStatus(STATUS_PHANTOM,TRUE);
       llSetTexture("lit_texture", ALL_SIDES);
       llSetTextureAnim (ANIM_ON | LOOP, ALL_SIDES, 4, 4, 0, 0, 15.0);
   }
} 

