// :CATEGORY:CLock
// :NAME:clock
// :AUTHOR:Beverly Larkin 
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:180
// :NUM:251
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Clock.lsl
// :CODE:


//Simple clock by Beverly Larkin to show example of how to use llGetWallClock()

integer H; //Hours
integer M; //Minutes
string AP; //AM or PM

default
{
    state_entry()
    {
        integer T = (integer)llGetWallclock(); // Get time PST
        if (T > 43200) //If it's after noon
        {
            T = T - 43200; //Subtract 12 hours
            AP = "PM";  //set to PM
            H = T / 3600; //get hours
            M = (T - (H * 3600)) / 60; //get minutes
        
            if(H == 0) //if the hour is 0
            {
                H = 12; // make the hour 12
            }
        }
    
        else
        {
            AP = "AM"; //set to AM
            H = T / 3600; //get the hour
            M = (T - (H * 3600)) / 60; //get minutes
            if(H == 0) //if the hour is 0
            {
                H = 12; // make the hour 12
            }
        }
    
        if(M < 10)
        {
            llOwnerSay((string)H + ":" + "0" + (string)M + AP); //if the mintues is less than 10 add the extra 0 (so it doesn't say 1:3PM) for example
        }
    
        else
        {
            llOwnerSay((string)H + ":" + (string)M + AP); // otherwise just say the time
        }
    }
}     // end 
