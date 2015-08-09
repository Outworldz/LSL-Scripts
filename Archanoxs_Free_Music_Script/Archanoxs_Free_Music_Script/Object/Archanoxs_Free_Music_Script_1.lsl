// :CATEGORY:Music
// :NAME:Archanoxs_Free_Music_Script
// :AUTHOR:Archanox Underthorn
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:51
// :NUM:71
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Archanox's Free Music Script.lsl
// :CODE:

//----------------------------------
//I am freely distributing this script with only three conditions:
//1: Please do not change the name of the script
//2: Please do NOT try to sell this script individually(with music is OK)
//3: If you modify my script(within reason), please distribute it freely as well
//
//Just doing my part to improve SL's music community
//Archanox Underthorn
//-----------------------------------

string stringnum(integer number, integer digits)
{
    string curstring = (string)number; 
   
    while(llStringLength(curstring) < digits)
    {
        curstring = "0" + curstring;
    }
    
    return curstring;
}


default
{
    touch_start(integer total_number)
    {    
    
    
    //----------------------------
    //You only need to setup these 7 variables
        
        //------------
        //firstsongname is the text that comes before the file number and secondsongname is what comes after it
        //put "" if either of them need to be blank
        //REMEMBER to include .wav if its there
        //i.e.- in Gorillaz001.wav: 
        //firstsongname is "Gorillaz" - secondsongname is ".wav"
        //-------------
        string firstsongname = "";
        string secondsongname = " - Nine Inch Nails - Closer.wav";
        
        //only change curfile if you want the song to start off on a specific file
        integer curfile = 1;

        //digits tells the script how many digit places the file numbering is
        //i.e.- Gorillaz001.wav : there are 3 digits
        integer digits = 2;
                      
        integer totalfiles = 38;
        float volume = 2;
        
    //---------------------------
       
        
        llSetSoundQueueing(TRUE);
        llPreloadSound(firstsongname + stringnum(1,digits) + secondsongname);
        llPreloadSound(firstsongname + stringnum(2,digits) + secondsongname);
        llSleep(10);
        
        integer preloadfile = 3;
        
        while(curfile <= totalfiles)
        {
        llPlaySound(firstsongname + stringnum(curfile,digits) + secondsongname, volume);       
            if(preloadfile <= totalfiles)
            {
            llPreloadSound(firstsongname + stringnum(preloadfile,digits) + secondsongname); 
            }
        llSleep(9.7);
        curfile += 1;
        preloadfile += 1;   
        }
    }
    
    on_rez(integer param)
    {
        llResetScript();
    }
}
// END //
