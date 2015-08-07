// :SHOW:
// :CATEGORY:Music
// :NAME:42_minute_Music_Box
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2012-10-09 15:37:27.430
// :EDITED:2015-04-27  12:31:53
// :ID:5
// :NUM:9
// :REV:1.3
// :WORLD:Second Life, OpensiM
// :DESCRIPTION:
// Music player script.   Can play up to 254 9-second clips in sequence.
// Trigger it with a link message, the  sensor script, or touch the prim


// :CODE:
// 10-09-2012 first reeleasedby Ferd Frederix
// 1-5-2014 rev 1.1
// Rev 1.1: change order of vars and set it to 9.0 seconds length files. added touch on/off
// Rev 1.2 optimized for Opensim
// Rev 1.3 Make the master play, too

// This work is licensed under a Creative Commons Attribution 3.0 Unported License.
// http://creativecommons.org/licenses/by/3.0/deed.en_US

// May be triggered to run continually, start/stop it by touching it or use the sensor script when someone gets nearby.

// This work is licensed under a Creative Commons Attribution-NonCommercial 3.0 Unported License.
// http://creativecommons.org/licenses/by-nc/3.0/deed.en_US

// This script cannot be sold even as part of another object, it must always remain free and fully modifiable.

// Drop 9 second song clips in the inventory of the obect, and touch to play.  You an set the length in timer_interval variable.
// 9 seems to work well.
// A great free tool to make these files is the slice audio file splitter at http://www.nch.com.au/splitter/index.html
// Set the variable loop = TRUE to loop after reaching the end, set it to FALSE to play once.

// Scriptable Control:
// Send a link message string of 'play' and 'stop' for use with external control scripts.
// Or just touch the prim to play

// IMPORTANT = HOW LONG you have sliced your wav files into pieces
float timer_interval = 9.0;         // time interval between requesting server to play the next 10 second wave

float set_text_alpha = 1;            // the text transparency fo alpha text. Set this to 0 to disable hovertext
integer debugflag = FALSE;           // chat debug info to owner if TRUE

// Stuff that you should not mess with:
 
integer preloadchannel ;
integer playchannel ;

integer running = TRUE;                // flag to say we are on
vector set_text_colour = <1,1,1>;   // colour of floating text label ( white)

// times just below 10 seconds are suitable as we use sound queueing
integer total_wave_files;           // number of wave files
integer i_playcounter;              // used by timer() player


DEBUG (string msg)
{
    if (debugflag) llOwnerSay(msg);
}
 
 
go(integer play) {

    if (play)
    {
        Preload();
        llSetTimerEvent(timer_interval);
        running = TRUE;
    } else {
        running = FALSE;
        llSetTimerEvent(0.0);
        llStopSound();
        DEBUG("Stopped");
        llSetText(llGetObjectName() + "\n"
            + (string) preloadchannel
            + "\n"
            + "Stopped", <0,1,0>, set_text_alpha);
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
        total_wave_files = llGetInventoryNumber(INVENTORY_SOUND);

        if (total_wave_files == 0)
        {
            llOwnerSay("Add 9 second wav files to the prim and reset it");
            return;
        }
        llSetSoundQueueing(TRUE); // only works on llPlaySound not llTriggerSound, so we can queue these silently
        preloadchannel = (integer) llGetObjectDesc();
        if (preloadchannel == 0) {
            preloadchannel = llCeil(llFrand(1000) + 1000);
            llSetObjectDesc((string) preloadchannel);
        }
        
        playchannel = preloadchannel +1;
        //set text above object to the name of the object and channel
        llSetText(llGetObjectName()
                + "\nChannel: "
                 + (string) preloadchannel, <0,1,0>, set_text_alpha);
        go(TRUE);

    }

    touch_start(integer total_number)
    {
        if (!running)
            go(TRUE);
        else
            go(FALSE);
    }

    timer()
    {
        string playing_wave_name = llGetInventoryName(INVENTORY_SOUND, i_playcounter);
        DEBUG("llPlaySound wav: " + (string)i_playcounter + " " + playing_wave_name );
        llPlaySound(playing_wave_name,1.0);
        llRegionSay(playchannel,playing_wave_name); // tell slaves to play a file
        
        llSetText(llGetObjectName() + "\n"
                                + playing_wave_name + "\n"
                                 +"Playing " + (string)(i_playcounter +1) 
                                 + " of " + (string)(total_wave_files) , set_text_colour, set_text_alpha);
         
        DEBUG("Playing  wav:" 
            + (string)(i_playcounter ) 
            + ":" 
            + (string) playing_wave_name);

        
        Loadnext();
    }

    link_message(integer sender_number, integer number, string message, key id)
    {
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
