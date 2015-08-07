// :CATEGORY:Avatar Age
// :NAME:Age_Check
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:19
// :NUM:29
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Age Check.lsl
// :CODE:

// This is a simple method to verify the age of a person.
// It does not use all the fancy leap year detection and whatever stuff.
// It compensates for leap years by adding a quarter day to each full year.
// For everyday use the accuracy of +/- 1 to 2 days should be sufficient.

// Free Script. Do not remove this header or the comments if you plan to pass it on to others.
// This script may NOT be sold for monetary profit unless it is integrated in some other script
// you want or need an age check for.

// Enjoy.

key Query;

default
{
    
    on_rez(integer X) {llResetScript();}
    
    touch_start(integer X)
    {
        llSetText("Verifying your age...",<0,1,0>,1);
        Query = llRequestAgentData(llDetectedKey(0),DATA_BORN);
    }
    
    dataserver(key QID,string Data)
    {
        if (QID == Query)
        {
            // The following variables are set to account for leap years and assume
            // the days evenly distributed amongst the 12 months of a year.
            float YrDays = 365.25;
            float MnDays = YrDays / 12;
            float DyInc = 1 / MnDays;
            // This is the user's birthdate.
            integer uYr = (integer)llGetSubString(Data,0,3);
            integer uMn = (integer)llGetSubString(Data,5,6);
            integer uDy = (integer)llGetSubString(Data,8,9);
            float uXVal = uYr * YrDays + (uMn - 1) * MnDays + uDy * DyInc;
            // This is today's date
            Data = llGetDate();
            integer Yr = (integer)llGetSubString(Data,0,3);
            integer Mn = (integer)llGetSubString(Data,5,6);
            integer Dy = (integer)llGetSubString(Data,8,9);
            float XVal = Yr * YrDays + (Mn - 1) * MnDays + Dy * DyInc;
            // We calculate the difference between those two dates to get the number of days.
            integer DDiff = (integer)(XVal - uXVal);
            // Here we check if the calculated age fits our requirements.
            if (DDiff < 180) {
                llSetText("Age Check Failed!\nYou are younger than 180 days!",<1,1,1>,1);
            } else {
                llSetText("Age Check Passed!",<1,1,1>,1);
            }
        }
    }
}
// END //
