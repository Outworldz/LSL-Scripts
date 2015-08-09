// :CATEGORY:Windows
// :NAME:Windows_and_controller
// :AUTHOR:Emmas Seetan
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:983
// :NUM:1405
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
//  Window// // Put this in the windows; 
// :CODE:
 
// script that changes opacity of object based on external messages
 
integer gChannel = 5; // communication channel on which we listen for opacity change commands
integer gLastListen; // id of last listen command
 
default
 {
     state_entry()
     {
         gLastListen = llListen(gChannel, "", "", "0");
     }
 
     listen(integer channel, string name, key id, string msg)
     {
         llListenRemove(gLastListen);
 
         integer nextOpacityLvl = (integer)msg;
         nextOpacityLvl += 1;
         if (nextOpacityLvl > 3) nextOpacityLvl = 0;
         gLastListen = llListen(gChannel, "", "", (string)nextOpacityLvl);
 
         float opacityLvl = (float)msg;
         opacityLvl = 1.1 - ((opacityLvl / 3) * 0.9);
         llSetAlpha(opacityLvl, ALL_SIDES);
     } 
 }
