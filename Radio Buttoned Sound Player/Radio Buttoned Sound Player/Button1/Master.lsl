// :CATEGORY:Music
// :NAME:Radio Buttoned Sound Player
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2014-09-08 19:05:37
// :EDITED:2014-09-24
// :ID:1042
// :NUM:1631
// :REV:1.1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Music player for radios or paianos with multupole buttons and sounds..
//  Can play many 9-second clips in sequence.
// Put this script in multile proims., Each prim gets unique wav files. Click a prim to play a music clip.
// ************************************************************************************
// You MUST add a channel number unique to the music in this prim to the description to use with the slave script..
// You can use as many slave scripts in a region as you like.  Change the channel number
// to play more than one sound.
// ************************************************************************************

// :CODE:
// Rev 1.1: 09-18-2014 used llTriggerSOund instead of llPlaySOund for skipping in Firestorm

// May be triggered to run continually, start it by touching it or use the sensor script when someone gets nearby.

// This work is licensed under a Creative Commons Attribution-NonCommercial 3.0 Unported License.
// http://creativecommons.org/licenses/by-nc/3.0/deed.en_US
// This script cannot be sold even as part of another object, it must always remain free and fully modifiable.

// 10-09-2012 first released by Ferd Frederix
// 01-05-2014 ev 1.1 change order of vars and set it to 9.0 seconds length files. added touch on/offRT
// 9-27-2014 Rev 1.2 optimized for Opensim
//
// Drop 9 second song clips in the inventory of the obect, and touch to play.  You an set the lenngth in timer_interval variable.
// 9 seems to work well.
// A great free tool to make these files is the slice audio file splitter at http://www.nch.com.au/splitter/index.html
// Set the variable loop = TRUE to loop after reaching the end, set it to FALSE to play once.

// Scriptable Control:
// Send a link message string of 'play' and 'stop' for use with external control scripts.
// Or just touch the prim to play


// tunable bumbers follow:
integer debugflag = FALSE;          // chat debug info to owner if TRUE
float timer_interval = 8.9;         // how long you sliced your wave files, must be less than 10. 9.0 is typical.
float set_text_alpha = 1;           //Set this to 0 to disable hovertext the text transparency fo alpha text.
integer play_at_master = TRUE;      // if TRUE, the master will play sounds, too.  Set to FALSE and the Master will only broadcast to slaves.
float VOLUME = 1.0;                 // 1.0 = full volume

// Stuff that you should not mess with:
 
integer preloadchannel ;
integer playchannel ;

integer running = TRUE;                // flag to say we are on
vector set_text_colour = <1,1,1>;   // colour of floating text label ( white)


integer total_wave_files;           // number of wave files
integer i_playcounter;              // used by timer() player


DEBUG (string msg)
{
    if (debugflag) llSay(0,msg);
}
 
  
go(integer play) {

    if (play)
    {
        Preload();
        llSetTimerEvent(timer_interval);
        running = TRUE;
        llSetColor(<0,1,0>,ALL_SIDES);
    } else {
        llStopSound();
        running = FALSE;
        llSetTimerEvent(0.0);
        //llStopSound();
        DEBUG("Stopped");
        llSetText(llGetInventoryName(INVENTORY_SOUND,0), <0,1,0>, set_text_alpha);

        llSetColor(<0,0,1>,ALL_SIDES);
    }
}
 


Preload() 
{ 
    string preloading_wave_name = llGetInventoryName(INVENTORY_SOUND, i_playcounter);
 
    llRegionSay(preloadchannel,preloading_wave_name); // tell slaves to preload a file     
    DEBUG("Preloading wav: " + (string)i_playcounter  + " " + (string) preloading_wave_name);
    llSetTimerEvent(2.0);   
    // start playing 
}

Loadnext()
{
    
    i_playcounter ++;
    if (i_playcounter >= total_wave_files)
        i_playcounter = 0;
        
    integer next = i_playcounter +1;
    if (next > total_wave_files)
        next = 0;
    
    string preloading_wave_name = llGetInventoryName(INVENTORY_SOUND, i_playcounter);
 
    llRegionSay(preloadchannel,preloading_wave_name); // tell slaves to preload a file
    DEBUG("Preloading wav: " + (string)i_playcounter + " " + (string) preloading_wave_name);
    llSetTimerEvent(timer_interval);     
}

default
{
    state_entry()
    {
        llMessageLinked(LINK_SET,0,"stop","");
        total_wave_files = llGetInventoryNumber(INVENTORY_SOUND);
        llSetSoundQueueing(TRUE); // only works on llPlaySound not llTriggerSound, so we can queue these silently
        preloadchannel = (integer) llGetObjectDesc();
        playchannel = preloadchannel +1;
        //set text above object to the name of the object
        llSetText(llGetInventoryName(INVENTORY_SOUND,0), <0,1,0>, set_text_alpha);
        go(TRUE);
    }

    touch_start(integer total_number)
    {
        if (!running) {
            llMessageLinked(LINK_SET,0,"stop","");
            llSetText("Starting\n" + llGetInventoryName(INVENTORY_SOUND,0), <0,1,0>, set_text_alpha);
            go(TRUE);
        } else {
            go(FALSE);
        }
    }

    timer()
    {
        string playing_wave_name = llGetInventoryName(INVENTORY_SOUND, i_playcounter);
        DEBUG("llPlaySound wav: " + (string)i_playcounter + " " + playing_wave_name );
    
        llRegionSay(playchannel,playing_wave_name); // tell slaves to play a file
        if (play_at_master)
            llTriggerSound(playing_wave_name,VOLUME);



        string toplay  = llGetInventoryName(INVENTORY_SOUND, i_playcounter );
        llSetText(toplay + "\n"
                  +"Playing " + (string)(i_playcounter +1) 
                  + " of " + (string)(total_wave_files) , set_text_colour, set_text_alpha);
         
        DEBUG("Playing  wav:" 
            + (string)(i_playcounter ) 
            + ":" 
            + (string) toplay);

          
        Loadnext();
    }

    link_message(integer sender_number, integer number, string message, key id)
    {
        DEBUG("Sender num " +  (string) sender_number);
        DEBUG("Link  num " +  (string) llGetLinkNumber());
        if (sender_number == llGetLinkNumber())
            return; 
        
        if (message == "play")
        {
            go(TRUE);
        } 
        else if (message == "stop")
        {
            go(FALSE);
        }
    } 

    on_rez(integer param)
    {
        llResetScript();
    }
}
