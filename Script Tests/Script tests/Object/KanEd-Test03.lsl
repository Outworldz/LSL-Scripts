// :SHOW:
// :CATEGORY:Scripting
// :NAME:Script Tests
// :AUTHOR:Justin Clark-Casey (justincc)
// :KEYWORDS:Opensim
// :CREATED:2019-03-18 23:44:21
// :EDITED:2019-03-18  22:44:21
// :ID:1116
// :NUM:1924
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// One of many tests for Opensim
// :CODE:

integer counter;
integer second;

default
{
   state_entry()
   {
       llSay( 0, "Hello, Avatar! Touch to change color and size.");
       counter = 0;
   }

   touch_start(integer total_number)
   {
       counter = counter + 1;        
        
       llSay( 0, "Touched by angel number " + (string)counter);

       llSetTimerEvent( 2 );  // create a "timer event" every 2 seconds.
   }

   timer()  // do these instructions every time the timer event occurs.
   {
       second++;
 
       // choose three random RGB color components between 0. and 1.0.
       float red = llFrand( 1.0 );  
       float green = llFrand( 1.0 );
       float blue = llFrand( 1.0 );
        
       // combine color components into a vector and use that vector
       // to set object color.
       vector prim_color = < red, green, blue >;  
       llSetColor( prim_color, ALL_SIDES );   // set object color to new color.
        
       // a choose random number between 0. and 10 for use as a scale factor.
       float new_scale = llFrand( 10.0 );  
       llSetScale(< new_scale, new_scale, new_scale > ); // set object scale.
       
       if ( second > 19 )  // then time to wrap this up.
       {         
           // turn object black, print "resting" message, and reset object....
           llSetColor( < 0, 0, 0 >, ALL_SIDES );
            
           llSay( 0, "Object now resting and resetting script." );
           llResetScript();  // return object to ready state.
       }
   }
}

