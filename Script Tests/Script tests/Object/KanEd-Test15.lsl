// :SHOW:
// :CATEGORY:Scripting
// :NAME:Script Tests
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :CREATED:2019-03-18 23:44:21
// :EDITED:2019-03-18  22:44:21
// :ID:1116
// :NUM:1936
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

