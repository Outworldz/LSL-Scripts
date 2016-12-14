// :SHOW:
// :CATEGORY:CLock
// :NAME:Day-Of-Week
// :AUTHOR:DoteDote Edison
// :KEYWORDS:
// :CREATED:2013-09-06
// :EDITED:2016-11-09  08:46:32
// :ID:222
// :NUM:308
// :REV:1.1
// :WORLD:Second Life
// :DESCRIPTION:
// Day-of-the-week Function
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


