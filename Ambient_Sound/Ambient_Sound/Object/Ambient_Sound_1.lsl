// :CATEGORY:Sound
// :NAME:Ambient_Sound
// :AUTHOR:Alfkin Small
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:30
// :NUM:41
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Ambient Sound.lsl
// :CODE:

// Ambient Sound script by Alfkin Small.

// To use: Place this script in the object that you want to play a sound.
// The object need not be special.  Just place is where you want the sound
// to come from.
// Drop a sound file in the object, then change the key sound line below to
// the name of your sound file.
// If you like, you can set the min and max values as well, in addition to
// the volume.  That's all there is to it!

// Set debug to TRUE if you'd like to get debugging messages, otherwise
// leave the next line alone.
integer debug = FALSE;

// Minimum amount of time (in seconds) between sounds.
float min = 10;

// Maximum amount of time (in seconds) between sounds.
float max = 30;

// This is the volume at which the sound will play.  0 = Inaudible
// Valid values are between 0.0 - 1.0
float vol = 0.5;

// Sound to play.
key sound = "dolphin1.wav";

default
{
    state_entry()
    {
        if (debug) llSay(0, "Debugging is ON");
     
        // Set the initial timer
        llSetTimerEvent(5.0);        
    }
    timer()
    {     
        // Play the sound once        
        llPlaySound(sound, vol);
        
        // Randomly select the next time (in seconds) to play the sound.
        float time = min + llFrand(max - min);
        
        if (debug) llSay(0, "Time set to" + (string)time);
        
        llSetTimerEvent(time);
    }        
}
// END //
