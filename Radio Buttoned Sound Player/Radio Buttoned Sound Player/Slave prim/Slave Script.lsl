// :CATEGORY:Music
// :NAME:Radio Buttoned Sound Player
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2014-09-08 19:06:13
// :EDITED:2014-09-08
// :ID:1042
// :NUM:1634
// :REV:1.0
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Radio/Music player slave script.   Add the sound clips the same as in the master(s).
// Put these about every 20-25 meters to spread sound through an entire region.
// ************************************************************************************
// You MUST add a channel number unique to the music in this prim to the description.
// IT MUST match thje  Master player(s)
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

