// :CATEGORY:Greeter
// :NAME:Welcome_Mat
// :AUTHOR:Jason Keegan
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:973
// :NUM:1395
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Welcome Mat.lsl
// :CODE:



1// Remove this number for this script to work





//Script Donated to The Wall Of Script by Alan Edison, Original creator       Unknown. Modified by Jason Keegan.

//This is a welcoming script, It will be triggered as it detects someone       walking on the prim which has this script in it.


string Welcome = "Welcome to my humble abode"; //This is the message the                                                      welcome mat will give when                                                  it detects someone on it.
                                                 

string Online = "Welcome mat Online."; //This is the message you will hear                                            when the script is reset to confirm                                         the script is active.
                                                 
                                                 

float gSleep = 3;// This is the time delay of the welcome mat, Giving time                       for the person that sets the welcome mat enough time                        to walk off.
                    
                    
                    
integer name = TRUE; //If you do not wish for the welcome mat to also add thename of the person that walked on it, Then change the TRUE to FALSE.                    
                    

default
{
    state_entry()
    {
        llSay(0, Online);
    }

    collision_start(integer total_number)
    {
        if (name == TRUE)
        {
            llWhisper(0, Welcome + " " + llDetectedName(0));
            llSleep(gSleep);
        }
        else
        {
            llWhisper(0, Welcome);
            llSleep(gSleep);
        }
    }
    on_rez(integer start_param)
    {
        llResetScript();
    }
}
// END //
