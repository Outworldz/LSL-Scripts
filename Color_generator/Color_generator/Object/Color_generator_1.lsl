// :CATEGORY:Color
// :NAME:Color_generator
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:194
// :NUM:267
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Color generator.lsl
// :CODE:

integer toggle = 0; // This is our toggle switch for turning the
                    // script on and off.  0 is off, 1 is on.

float base_delay = 1.0;  // This is the minimum amount of delay 
                         // that will happen between color changes.
                         // If you want a consistently longer or 
                         // shorter delay, change this value.

float variable_delay = 1.5;  // This is the maximum delay added to 
                             // the base_delay.  If you want a wider
                             // variation in the delay, then increase
                             // the value.  If you want less variance.
                             // then decrease it.

default
{
     touch_start(integer counter)
     {
          toggle *= -1;  // Here we multiply negative one, to change its 
                         // sign.

          if(toggle < 0) // We test to see if it is less than 0, and if it
                         // is, then we turn on the color changer.
          {
               llSetTimerEvent(llFrand(variable_delay) + base_delay);
          }
          else
          {
               llSetTimerEvent(0);
          }
     }

     timer()
     {
          llSetColor(<llFrand(1),llFrand(1),llFrand(1)>,ALL_SIDES);
          llSetTimerEvent(llFrand(variable_delay) + base_delay);
     }
}

// END //
