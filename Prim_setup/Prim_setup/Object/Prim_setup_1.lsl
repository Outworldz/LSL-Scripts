// :CATEGORY:XY Text
// :NAME:Prim_setup
// :AUTHOR:fratserke
// :CREATED:2010-11-09 06:01:00.363
// :EDITED:2013-09-18 15:39:00
// :ID:654
// :NUM:890
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// put this script in a new box that you just rezz & you get a display off 5 characters
// :CODE:
 ////////////////////////////////////////////
 // XyText Prim Setup
 //
 // Written by Xylor Baysklef
 ////////////////////////////////////////////
 
 /////////////// CONSTANTS ///////////////////
 // Transparent texture key.
 string  TRANSPARENT = "701917a8-d614-471f-13dd-5f4644e36e3c";
 
 default {
     state_entry() {
         // Set up the prim to be the correct shape.
         vector Scale = llGetScale();
         llSetPrimitiveParams([
             // Set the top size so this shows 3 faces at once.
             PRIM_TYPE, PRIM_TYPE_BOX, PRIM_HOLE_DEFAULT, 
               <0, 1, 0>, 0.0, ZERO_VECTOR, 
               <0.333333, 1, 0>, ZERO_VECTOR,
 
             // Display the string "XyText" for now.
             PRIM_TEXTURE, 4, "0e47c89e-de4a-6233-a2da-cb852aad1b00",
               <0.1, 0.1, 0>,  <0.200000, -0.450000, 0.000000>, PI_BY_TWO,
 
             PRIM_TEXTURE, 0, "20b24b3a-8c57-82ee-c6ed-555003f5dbcd",
               <0.1, 0.1, 0>, <-0.200000, -0.450000, 0.000000>, 0.0,
 
             PRIM_TEXTURE, 2, "2f713216-4e71-d123-03ed-9c8554710c6b",
               <0.1, 0.1, 0>, <-0.050000, -0.350000, 0.000000>, -PI_BY_TWO,
 
             // Show transparent textures for the other sides.
             PRIM_TEXTURE, 1, TRANSPARENT, <0.1, 0.1, 0>, ZERO_VECTOR, 0.0,
             PRIM_TEXTURE, 3, TRANSPARENT, <0.1, 0.1, 0>, ZERO_VECTOR, 0.0,
             PRIM_TEXTURE, 5, TRANSPARENT, <0.1, 0.1, 0>, ZERO_VECTOR, 0.0,
 
             // Set the correct aspect ratio.
             PRIM_SIZE, <Scale.x, Scale.x / 3, 0.01>
             ]);
 
         // Remove ourselves from inventory.
         llRemoveInventory(llGetScriptName());
     }
 }
 
