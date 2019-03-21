// :CATEGORY:Music
// :NAME:Music Player
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:58
// :ID:548
// :NUM:745
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Sensor
// :CODE:

// 10-09-2012 by Fred Beckhusen (Ferd Frederix)

// May be triggered to run continually, start it by touching it or use the sensor script when someone gets nearby.

// This work is licensed under a Creative Commons Attribution-NonCommercial 3.0 Unported License.
// http://creativecommons.org/licenses/by-nc/3.0/deed.en_US
// This script cannot be sold even as part of another object, it must always remain free and fully modifiable.

// Drop 10 second song clips in the inventory of the obect, and touch to play.
// A great free tool to make these files is the slice audio file splitter at http://www.nch.com.au/splitter/index.html
// Set the variable loop = TRUE to loop after reaching the end, set it to FALSE to play once.

// Scriptable Control:
// Send a link message string of 'play' and 'stop' for use with external control scripts.
// Or just touch the prim to play

integer loop = FALSE;                // set to TRUE to loop again and again
float set_text_alpha = 1;            // the text transparency fo alpha text. Set this to 0 to disable hovertext

// Stuff that you should not mess with:

integer debugflag = TRUE;           // chat debug info to owner if TRUE
integer waves_to_preload = 3;       // wave files to Preload ahead of the wav being played.
float preload_load_time = 0.5;      // seconds pause between each preloaded wave file attempt b4 play comnences
integer secret_channel = 54345;     // just a magic number
vector set_text_colour = <1,1,1>;   // colour of floating text label ( white)
float timer_interval = 9.8;         // time interval between requesting server to play the next 10 second wave
// times just below 10 seconds are suitable as we use sound queueing
integer total_wave_files;           // number of wave files
integer i_playcounter;              // used by timer() player
string preloading_wave_name;        // the name of the wave file being preloaded
string playing_wave_name;           // the name of the wave being played


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


    total_wave_files = llGetInventoryNumber(INVENTORY_SOUND);
    integer counter = 0;        //do full preload of sound
    llSetSoundQueueing(TRUE); // only works on llPlaySound not llTriggerSound, so we can queue these silently
    integer local_total_wave_files = total_wave_files -1 ;

    float length = total_wave_files * 10.0;
    for (counter = 0 ; counter < waves_to_preload ; counter++)  //preload X wave files b4 we play
    {
        //since wavs are numbered from 0 we minus 1
        preloading_wave_name = llGetInventoryName(INVENTORY_SOUND, counter);


        llSetText(llGetObjectName()
            + "Preload wav: " + (string)counter +"\n."
            +"\n.", <1,0,0>, set_text_alpha);
        //Attempt to preload first x wave files to local machines cache!
        llPreloadSound(preloading_wave_name);


        DEBUG("Preloading wav: " + (string)counter + " " + (string)llGetInventoryKey(preloading_wave_name));
        //start play sound timer in 'timer_interval' seconds when we are less than 'timer_interval' seconds from
        // finishing preloading.
        llSleep(preload_load_time);

    }
    llSetTimerEvent(0.1);   // start playing
    i_playcounter=0;
    counter=0;
}


default
{
    state_entry()
    {
        //set text above object to the name of the object
        llSetText(llGetObjectName() + "\n.", <0,1,0>, set_text_alpha);
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
                playing_wave_name = llGetInventoryName(INVENTORY_SOUND, i_playcounter);
            DEBUG("llPlaySound wav: " + (string)i_playcounter + " " + playing_wave_name );

            llPlaySound(playing_wave_name, 1.0);
            llSetText(  llGetObjectName() + "\n(playing " + (string)i_playcounter +" of "+ (string)(total_wave_files -1) +")\n.", <0,1,1>, set_text_alpha);
            if(i_playcounter + waves_to_preload <= (total_wave_files -1))
            {
                preloading_wave_name = llGetInventoryName(INVENTORY_SOUND, i_playcounter + waves_to_preload);
                llSetText("Playing " + (string)i_playcounter + " of " + (string)(total_wave_files -1) , set_text_colour, set_text_alpha);

                DEBUG("Preloading wav:" + (string)(i_playcounter + waves_to_preload) + "\n" +
                    (string) llGetInventoryKey(preloading_wave_name) +  "\n" +
                    "Preloading sequence: " + (string)(i_playcounter + waves_to_preload));


                llPreloadSound(llGetInventoryName(INVENTORY_SOUND, i_playcounter + waves_to_preload));
            }
        }
        i_playcounter++;     //increment for next wave file in sequence!
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





