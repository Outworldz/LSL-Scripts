// :CATEGORY:Sound
// :NAME:Psykes_Music_Script_Looped
// :AUTHOR:BACANA
// :CREATED:2010-09-24 10:03:21.933
// :EDITED:2013-09-18 15:39:00
// :ID:664
// :NUM:904
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Psykes_Music_Script_Looped
// :CODE:

//Psyke's Music Script v4.15.1
//Song Player
//Modified by Psyke Phaeton... this script is free for anyone to use or copy.. please make it copyable from your "CD"
//Drop 9 second song clips in reverse order into the Inv of the obect, and touch to play.
//user variables
integer waves_to_preload = 3;         //wave files to Preload ahead of the wav being played.
float preload_load_time = 0.5;         //seconds pause between each preloaded wave file attempt b4 play comnences
vector set_text_colour = <0,0,0>;     // colour of floating text label
float set_text_alpha = 1;            //no idea what this is LOL
float timer_interval = 8.9;        
// time interval between requesting server to play the next 9 second wave
//  times just below 9 seconds are suitable as we use sound queueing
integer timer_started;
// program variables

integer total_wave_files;          //number of wave files
integer last_wave_file_number;     //final wave sequence number (note: sequence starts at zero
                                   //- so this is 1 less than total wave files)
integer i_playcounter; //used by timer() player

string preloading_wave_name; //the name of the wave file being preloaded
string playing_wave_name;    //the name of the wave being played
integer play = FALSE;        //toggle for music playing or stopped

sound()
{
    total_wave_files = llGetInventoryNumber(INVENTORY_SOUND);
    last_wave_file_number = total_wave_files - 1;  // because wav files are numbered from zero
    float length = total_wave_files*9.0;

    integer c = 0;        //do full preload of sound
    llSetSoundQueueing(TRUE); //ONLY WORKS ON llPlaySound not llTriggerSound        /////////////////
    integer x = total_wave_files;
    
    timer_started = FALSE;
    for (c = 0 ; c <= (x - 1) ; c++)  //preload X wave files b4 we play
    { 
        //since wavs are numbered from 0 we minus 1
        preloading_wave_name = llGetInventoryName(INVENTORY_SOUND, c);
        llSetText(llGetObjectName() +
            "\n(preloading " + llGetSubString((string)((x - c)*preload_load_time),0,3) + " secs)"
        //////debug lines
        //+ "\n--debug--\n"
        + "Preload wav: " + (string)c
        + "\nkey: " + (string)llGetInventoryKey(preloading_wave_name)                    ////
        //end debug line
        +"\n.", <1,0,0>, set_text_alpha);
        //Attempt to preload first x wave files to local machines cache!
        llTriggerSound(preloading_wave_name, 0.0);
        llPreloadSound(preloading_wave_name);
        
        llWhisper(0,"Preloading wav: " + (string)c + (string)llGetInventoryKey(preloading_wave_name));
        //start play sound timer in 'timer_interval' seconds when we are less than 'timer_interval' seconds from
        // finishing preloading.
        if ( ((total_wave_files - c) * preload_load_time) < timer_interval && !timer_started)
        {
            llWhisper(0, "Starting timer:" + (string)timer_interval);
            llSetTimerEvent(timer_interval);
        
            timer_started = TRUE;
            }
        llSleep(preload_load_time);
    }
    
    i_playcounter=0;
    c=0;
    llSay(0, "Done! Playing..  (" + (string)llFloor(length) + " secs) Click to stop.");
    //llSetTimerEvent(8.85);
}
default
{
    on_rez(integer start_param)
    {
        //set text above object to the name of the object
        llSetText(llGetObjectName() + "\n.", <0,1,0>, set_text_alpha);
        //llSetSoundQueueing(FALSE); //ONLY WORKS ON llPlaySound not llTriggerSound
    }
    touch_start(integer total_number)
    {
        if (!play)
        {
            //llTargetOmega(<0,0,1>,PI,1.0) ;
            sound();
        } else {
            //llTargetOmega(<0,0,1>,0,0);
            llSetTimerEvent(0.0);
            llStopSound();
            //llSetSoundQueueing(FALSE); //ONLY WORKS ON llPlaySound not llTriggerSound
            llSay(0, "Stopping..");
            llSetText(llGetObjectName() + "\n.", <0,1,0>, set_text_alpha);
        }
        play = !play;
    }
    
    timer()
    {
        if( i_playcounter > last_wave_file_number )
        {
            sound();//This is what I changed or added to keep it looping till you touch it again and stop it. All the rest below was either already omitted or omitted by me where ie:
            //  play = FALSE; was done by me and
            //llSay(0, "finished."); was omitted by the original maker that was prolly used for testing and such.
            //llSay(0, "finished.");
            //  play = FALSE;
            //llSetSoundQueueing(FALSE);
            //ONLY WORKS ON llPlaySound not llTriggerSound
            // llSetText(llGetObjectName() + "\n.", <0,1,0>, set_text_alpha);
            //llResetScript();
            // llSetTimerEvent(0);
        }  else {
            playing_wave_name = llGetInventoryName(INVENTORY_SOUND, i_playcounter);
            //llWhisper(0, "llPlaySound wav: " + (string)i + " " + (string)llGetInventoryKey(playing_wave_name) );
            llPlaySound(playing_wave_name, 1.0);
            llSetText(  llGetObjectName() + "\n(playing " + (string)i_playcounter +" of "+ (string)last_wave_file_number +")\n.", <0,1,1>, set_text_alpha);
            if(i_playcounter + waves_to_preload <= last_wave_file_number)
            {
                preloading_wave_name = llGetInventoryName(INVENTORY_SOUND, i_playcounter + waves_to_preload);
                llSetText(   llGetObjectName() +
                    "\n(playing " + (string)i_playcounter +" of "+ (string)last_wave_file_number +")"
                    ////
                //debug line
                + "\n--debug--\n"
                + "Playing key: " + (string)llGetInventoryKey(playing_wave_name) + "\n"
                + "Preloading sequence: " + (string)(i_playcounter + waves_to_preload)
                + "\nPreloading key: " + (string)llGetInventoryKey(preloading_wave_name)                             ////
                //end debug line
                , set_text_colour, set_text_alpha);
                llWhisper(0, "Preloading wav:" + (string)(i_playcounter + waves_to_preload) + " " +
                                (string)llGetInventoryKey(preloading_wave_name) +" last = " + (string)last_wave_file_number);
                llTriggerSound(llGetInventoryName(INVENTORY_SOUND, i_playcounter + waves_to_preload), 0.0);
                llPreloadSound(llGetInventoryName(INVENTORY_SOUND, i_playcounter + waves_to_preload));
            }
        }
        i_playcounter++;     //increment for next wave file in sequence!
    }
}


