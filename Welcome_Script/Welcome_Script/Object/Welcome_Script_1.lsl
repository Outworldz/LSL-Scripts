// :CATEGORY:Greeter
// :NAME:Welcome_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:974
// :NUM:1396
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Welcome Script.lsl
// :CODE:

string previously_Welcomed;
default
{
    touch_start(integer total_number)
    {
         llSetTimerEvent(30);
    }
    collision(integer numDetected)
    {
        if(llDetectedName(0) != previously_Welcomed)
        {
            previously_Welcomed=llDetectedName(0);
            llSay(0,"Welcome to Egypt Nile Valley and The Great Sahara , part of the Era of Gods RP combat sims. Please touch the Pyramid to receive the information pack.  " + llDetectedName(0));
        }
    }
    timer()
    {
        previously_Welcomed = "";
    }
}// END //
