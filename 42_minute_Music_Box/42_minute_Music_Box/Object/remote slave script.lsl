// :SHOW:
// :CATEGORY:Music
// :NAME:42_minute_Music_Box
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2014-01-07 22:38:00
// :EDITED:2015-04-27  12:31:53
// :ID:5
// :NUM:1561
// :REV:1.3
// :WORLD:Second Life
// :DESCRIPTION:
// Music player slave script.   Add sound clips just like the 42 minute prim has.
// Put these about every 20-25 meters to spread sound through an entire region.
// Add a channel number from Master script description in this prim's description.

// Rev 1.2: added changed event, and the channel comes from the description.
// Rev 1.3  added some diagbnostics and warnings about description and adding wav files.

// This work is licensed under a Creative Commons Attribution 3.0 Unported License.
// http://creativecommons.org/licenses/by/3.0/deed.en_US



// :CODE:
 
 
integer preloadchannel ;
integer playchannel ;
float text = 1.0;  // set too to see debug title text

default
{
   
    state_entry()
    {
        integer total_wave_files = llGetInventoryNumber(INVENTORY_SOUND);

        if (total_wave_files == 0)
        {
            llOwnerSay("Add 9 second wav files to the prim and reset it");
            return;
        }

        
        preloadchannel = (integer) llGetObjectDesc();
        if (preloadchannel == 0) {
            llOwnerSay("put the same number in the desription that you have in the Master prim and reset this script");
            return;
        }
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

