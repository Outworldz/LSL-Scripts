// :SHOW:
// :CATEGORY:Scripting
// :NAME:Script Tests
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :CREATED:2019-03-18 23:44:21
// :EDITED:2019-03-18  22:44:21
// :ID:1116
// :NUM:1926
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// One of many tests for Opensim
// :CODE:

default
{
   state_entry()
   {
       llSay( 0, "Hello, Avatar!");
       vector startPoint = llGetPos();
   }

   touch_start(integer total_number)
   {
       llSay( 0, "Touched." );

       // Define a rotation of 10 degrees around the Y-axis.
       rotation Y_10 = llEuler2Rot( < 0, 10 * DEG_TO_RAD, 0 > );
       
       // now rotate the object 10 degrees in the X-Z plane during
       // each loop iteration. note that each call to llSetRot 
       // causes a .2 second delay.
       integer i;
       for( i = 1; i < 100; i++ )  
       { 
           // rotate object in the X-Z plane around its own Y-axis.
           rotation newRotation = llGetRot() * Y_10; 

           llSetRot( newRotation ); 
       }  
       llSay( 0, "Rotation stopped" );              
   }
} 

