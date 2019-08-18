// :SHOW:
// :CATEGORY:Scripting
// :NAME:Script Tests
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :CREATED:2019-04-04 20:49:50
// :EDITED:2019-04-04  19:49:50
// :ID:1124
// :NUM:1976
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// One of many tests for Opensim
// :CODE:

integer counter;

default
{
   state_entry()
   {
       llSay( 0, "Hello, Avatar! Touch to change color and size.");
       counter = 0;
   }

   touch_start(integer total_number)
   {   // do these instructions when the object is touched.
       counter = counter + 1;

       // choose three random RGB color components between 0. and 1.0.
       float redness = llFrand( 1.0 );
       float greenness = llFrand( 1.0 );
       float blueness = llFrand( 1.0 );

       // combine color components into a vector and use that vector
       // to set object color.
       vector prim_color = < redness, greenness, blueness >;
       llSetColor( prim_color, ALL_SIDES );   // set object color to new color.

       // choose a random number between 0. and 10. for use as a scale factor.
       float new_scale = llFrand(10.0) + 1.0;
       llSetScale(< new_scale, new_scale, new_scale > ); // set object scale.        
       llSay( 0, "Touched by angel number " + (string)counter);
   }
}

