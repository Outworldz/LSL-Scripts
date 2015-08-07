 // :CATEGORY:Music
 // :NAME:Master-Slave Background Sound Player
 // :AUTHOR:Ferd Frederix
 // :KEYWORDS:
 // :CREATED:2014-08-11 17:29:36
 // :EDITED:2014-09-07
// :ID:1039
// :NUM:1624
// :REV:1.0
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Music player slave script.   Add sound clips the same as in the master.
// Put these about every 20-25 meters to spread shound through an entire region.
// ************************************************************************************
// You MUST add a channel number unique to the music in this prim to the description.
// IT MUST match a Master player
// ************************************************************************************

// :CODE:
 
 
integer preloadchannel ;
integer playchannel ;
float text = 1.0;  // set too to see debug title text

 default
 {
    
     state_entry()
     {
         preloadchannel = (integer) llGetObjectDesc();
         playchannel = preloadchannel + 1;
         llListen(preloadchannel,"","","");
         llListen(playchannel,"","","");
         llSetText("", <0,1,0>, 1.0);
     }
     
     listen(integer channel, string name, key id, string music)
     {
         if (channel == playchannel)
         {
             llSetText(music + "\n playing", <0,1,0>, text);
             llPlaySound(music,1.0);
             
         }   
         else
         {
             llSetText(music + "\npreloaded", <0,1,0>, text);
             llPreloadSound(music);
         }
   
     }
     
     changed(integer what)
     {
         if (what & CHANGED_INVENTORY)
             llResetScript();
     }
 
     on_rez(integer param)
     {
         llResetScript();
     }
 }

