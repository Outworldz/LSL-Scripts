// :CATEGORY:XY Text
// :NAME:Prim_setup
// :AUTHOR:fratserke
// :CREATED:2010-11-09 06:01:00.363
// :EDITED:2013-09-18 15:39:00
// :ID:654
// :NUM:891
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// setup script for XyText v1.0.3 (5 Face, Multi Texture)
// :CODE:
////////////////////////////////////////////
// XyText v1.0.3 Prim Setup Script (5 Face, Multi Texture)
//
// Rewritten by Tdub Dowler
//
////////////////////////////////////////////
 
string FACE_TEXTURE = "09b04244-9569-d21f-6de0-4bbcf5552222";
string  TRANSPARENT = "701917a8-d614-471f-13dd-5f4644e36e3c";
 
default
{
    state_entry()
    {
        llSetPrimitiveParams([
          PRIM_TYPE, PRIM_TYPE_PRISM, PRIM_HOLE_SQUARE, <0.199, 0.8, 0.0>, 0.30,
            ZERO_VECTOR, <1.0, 1.0, 0.0>, ZERO_VECTOR,
 
          // display a default face texture
          PRIM_TEXTURE, 1, FACE_TEXTURE, <2.48, 1.0, 0.0>, <-0.740013, 0.0, 0.0>, 0.0,
          PRIM_TEXTURE, 6, FACE_TEXTURE, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>, 0.0,
          PRIM_TEXTURE, 4, FACE_TEXTURE, <-14.75, 1.0, 0.0>, <0.130009, 0.0, 0.0>, 0.0,
          PRIM_TEXTURE, 7, FACE_TEXTURE, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>, 0.0,
          PRIM_TEXTURE, 3, FACE_TEXTURE, <2.48, 1.0, 0.0>, <-0.255989, 0.0, 0.0>, 0.0,
 
          // show transparent textures for the other sides
          PRIM_TEXTURE, 0, TRANSPARENT, <0.1, 0.1, 0>, ZERO_VECTOR, 0.0,
          PRIM_TEXTURE, 2, TRANSPARENT, <0.1, 0.1, 0>, ZERO_VECTOR, 0.0,
          PRIM_TEXTURE, 5, TRANSPARENT, <0.1, 0.1, 0>, ZERO_VECTOR, 0.0,
 
          PRIM_SIZE, <0.03, 2.89, 0.5>
        ]);
 
        // Remove ourselves from inventory.
        llRemoveInventory(llGetScriptName());
    }
}



