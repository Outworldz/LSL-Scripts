// :CATEGORY:Cache
// :NAME:View_Your_Second_Life_Cache
// :AUTHOR:Ferd Frederix
// :CREATED:2010-11-04 13:44:29.640
// :EDITED:2013-09-18 15:39:09
// :ID:955
// :NUM:1377
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// A program to put textures onto prims using the UUID's from the above script. Put the UUID into the Description and rez the object
// :CODE:
default
{
  state_entry()
  {
    llSetTexture(llGetObjectDesc(), ALL_SIDES);
  }
  touch_start(integer total_number)
  {
    llResetScript();
  }
}
