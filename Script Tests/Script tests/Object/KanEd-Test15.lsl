// :SHOW:
// :CATEGORY:Scripting
// :NAME:Script Tests
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :CREATED:2019-04-04 20:49:51
// :EDITED:2019-04-04  19:49:51
// :ID:1124
// :NUM:1989
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

