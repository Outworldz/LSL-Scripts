// :CATEGORY:CLock
// :NAME:Day-Of-Week
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:51
// :ID:222
// :NUM:308
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Day-of-the-week.lsl
// :CODE:

string getDay(integer offset)
{
    list weekdays = ["Thursday", "Friday", "Saturday", "Sunday", "Monday", "Tuesday", "Wednesday"];
    integer hours = llGetUnixTime()/3600;
    integer days = (hours + offset)/24;
    integer day_of_week = days%7;
    return llList2String(weekdays, day_of_week);
}

default
{
    touch_start(integer total_number)
    {
        integer offset = -4; // offset from UTC
        llSay(0, "Today is " + getDay(offset) + ".");
    }
}  // end 
// CREATOR:

