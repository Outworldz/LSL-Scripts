// :CATEGORY:Music
// :NAME:HUD Music Player
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:55
// :ID:392
// :NUM:544
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// long term player for MP3 files
// :CODE:

// suitable for museum-like headphone action. Where you stand in front of something and it talks to you until you move away.

// 10/9/2012
// This work is licensed under a Creative Commons Attribution-NonCommercial 3.0 Unported License.
// http://creativecommons.org/licenses/by-nc/3.0/deed.en_US
// This script cannot be sold even as part of another object, it must always remain free and fully modifiable.

// This script goes into a prim worn as a HUD.
// Drop 10 second song clips in the inventory of the Sensor object, not the HUD.
// A great free tool to make these files is the slice audio file splitter at http://www.nch.com.au/splitter
//
// Set the variable loop = TRUE to loop over and over after reaching the end, set it to FALSE to play once.
// Requires another trigger prim in world with the Sensor script in it.

integer loop = FALSE;                // set to TRUE to loop again and again
float set_text_alpha = 1;            // the text transparency fo alpha text. Set this to 0 to disable hovertext
integer debugflag = FALSE;           // chat debug info to owner if TRUE

// Suff that you should not mess with.

integer waves_to_preload = 3;         // wave files to Preload ahead of the wav being played.
float preload_load_time = 0.5;        // seconds pause between each preloaded wave file attempt b4 play comnences
integer secret_channel = 9876;        // just a magic number
vector set_text_colour = <1,1,1>;     // colour of floating text label ( white)
list soundQueue;                      // a list of sound UUIDs from the sensor
list nameQueue;                       // a list of sound names from the sensor
float timer_interval = 9.8;           // time interval between requesting server to play the next 10 second wave
                                      // times just below 10 seconds are suitable as we use sound queueing
integer total_wave_files;             //number of wave files
integer i_playcounter;                //used by timer() player


DEBUG (string msg)
{
    if (debugflag) llOwnerSay(msg);
}


go(integer play) {

    if (play)
    {
        sound();

    } else {
            llSetTimerEvent(0.0);
        llStopSound();
        DEBUG("Stoped");
        llSetText(llGetObjectName() + "\n.", <0,1,0>, set_text_alpha);
    }
}



sound() {


    total_wave_files = llGetListLength(soundQueue);
    integer counter = 0;        //do full preload of sound
    llSetSoundQueueing(TRUE); // only works on llPlaySound not llTriggerSound, so we can queue these silently
    integer local_total_wave_files = total_wave_files -1 ;

    float length = total_wave_files * 10.0;
    for (counter = 0 ; counter < waves_to_preload  ; counter ++)  //preload X wave files b4 we play
    {
        key preloading_wave_key = llList2Key(soundQueue,counter);
        string preloading_wave_name = llList2Key(nameQueue,counter);

        //Attempt to preload first x wave files to local machines cache!
        llPreloadSound(preloading_wave_key);

        DEBUG("Preloading wav: " + (string)counter + " " + preloading_wave_name);

        llSleep(preload_load_time);
    }

    llSetTimerEvent(0.1);
    i_playcounter=0;
    counter=0;
}


default
{
    state_entry()
    {

        //set text above object to the name of the object
        llListen(secret_channel,"","","");
        llSetText(llGetObjectName() + "\n.", <0,1,0>, set_text_alpha);
    }

    listen(integer channel, string name, key id, string message)
    {
        //DEBUG("Heard:" + message);
        list msg = llParseString2List(message,["^"],[""]);

        string targetid = llList2String(msg,0);    // avatar key to play
        string cmd = llList2String(msg,1);         // stop, queue, or play
        string soundKey  = llList2String(msg,2);          // UUID of sound file
        string soundName  = llList2String(msg,3);          // UUID of sound file

        if (( key) targetid == llGetOwner())
        {
            if (cmd =="queue") {
                soundQueue += (key) soundKey;
                nameQueue +=  soundName;
            }
            else if (cmd == "play")
            {
                go(TRUE);
            }
            else if (cmd == "stop")
            {
                soundQueue = [];
                nameQueue = [];
                go(FALSE);
            }
        }
    }

    touch_start(integer total_number)
    {
        go(TRUE);
    }

    timer()
    {
        llSetTimerEvent(timer_interval);
        if( i_playcounter > (total_wave_files -1) )
        {
            if (!loop)
            {
                llSetTimerEvent(0);
            }
            else
            {
                sound();
            }

        }  else {
                key playing_wave_key = llList2Key(soundQueue, i_playcounter);
            string playing_wave_name = llList2String(nameQueue, i_playcounter);
            DEBUG("llPlaySound wav: " + (string)i_playcounter + " " + (string)playing_wave_key );

            llSetText("Playing " + (string)i_playcounter + " of " + (string)(total_wave_files -1) , set_text_colour, set_text_alpha);

            llPlaySound(playing_wave_key, 1.0);

            key    preloading_wave_key  = llList2String(soundQueue, i_playcounter + waves_to_preload);
            string preloading_wave_name = llList2String(nameQueue,  i_playcounter + waves_to_preload);

            DEBUG("Preloading wav:" + (string)(i_playcounter +  waves_to_preload) + "\n" +
                " key: " + (string) playing_wave_key +  "\n" +
                "Preloading sequence: " + (string)(i_playcounter + waves_to_preload));

            llPreloadSound(playing_wave_key);
        }
        i_playcounter ++;     //increment for next wave file in sequence!
    }


    on_rez(integer param)
    {
        llResetScript();
    }
}





