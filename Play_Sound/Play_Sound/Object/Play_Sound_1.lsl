// :CATEGORY:Sound
// :NAME:Play_Sound
// :AUTHOR:Scot Titian
// :CREATED:2010-10-21 21:39:06.097
// :EDITED:2013-09-18 15:38:59
// :ID:634
// :NUM:862
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Simple sound script.
// :CODE:
/*//--Written by Scot Titian--//*/
/*// This script is free to   //*/
/*// use and distribute as    //*/
/*// long as you leave this   //*/
/*// headear here at the top  //*/
/*// of the script.           //*/
/*//--------------------------//*/ 

//--NOTE: To use the name of the Sound you must put the sound in the same object this script is in

integer gPlaying;          //--If we are playing sound
key     gAnimKey  = "";    //--The ID of the sound to play
string  gAnimName = "";    //--The name of the animation if you don't have the ID
integer gUseKey   = TRUE;  //--Set to false if you don't have the ID of the animation
integer gDelay    = 20;                                     //--How long to wait before we can play the sound again (In seconds)
integer gCanPlay;                                           //--If the animation can play (for the delay)
integer gAllowAll = TRUE;                                   //--If everyone can click us (Set to false for owner only)

default
{
    state_entry()
    {
        gPlaying = FALSE; //--We start out not playing sound
        gCanPlay = TRUE;  //--We start able to play
    }

    touch_start(integer total_number)
    {
        if(TRUE == gAllowAll)
        {
            if(TRUE == gCanPlay)
            {
                if(TRUE == gUseKey)       //--Play the sound using it's key
                    llPlaySound(gAnimKey,1);
                
                else if(FALSE == gUseKey) //--Play the sound using it's name
                    llPlaySound(gAnimName,1);
                gCanPlay = FALSE;
                llSetTimerEvent(gDelay);
            }
        }
        else if(FALSE == gAllowAll)
        {
            key vKey = llDetectedKey(0);
            
            if(TRUE == gCanPlay && llGetOwner() == vKey)
            {
                if(TRUE == gUseKey)       //--Play the sound using it's key
                    llPlaySound(gAnimKey,1);
                
                else if(FALSE == gUseKey) //--Play the sound using it's name
                    llPlaySound(gAnimName,1);
                gCanPlay = FALSE;
                llSetTimerEvent(gDelay);
            }
        }
    }
    timer()
    {
        llSetTimerEvent(0);
        gCanPlay = TRUE;
    }
}
