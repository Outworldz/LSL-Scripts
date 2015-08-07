// :CATEGORY:Windows
// :NAME:Windows_and_controller
// :AUTHOR:Emmas Seetan
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:983
// :NUM:1406
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
//   Window Switch// // Put this in a switch; 
// :CODE:
 // script for a switch that controls window opacity
 integer gOpacityLevel = 0; // current opacity level of windows
 integer gChannel = 5; // channel that controls which windows respond to this switch
 
default
 {
     state_entry()
     {
 
     }
 
     touch_start(integer num_touchers)
     {
         gOpacityLevel += 1;
         if (gOpacityLevel > 3)
         {
             gOpacityLevel = 0;
         }
         string opacityCmd = "";
         opacityCmd = opacityCmd + (string)gOpacityLevel;
         llSay(gChannel, opacityCmd);
     }
 }
