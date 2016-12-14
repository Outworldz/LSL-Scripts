// :CATEGORY:Clock
// :NAME:Get_Day_of_Week
// :AUTHOR:DoteDote Edison
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:346
// :NUM:469
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// And a function version:
// :CODE:

// Copyright © 2016 Linden Research, Inc. Licensed under Creative Commons Attribution-Share Alike 3.0

string getDay(integer offset) { 
    list weekdays = ["Thursday", "Friday", "Saturday", "Sunday", "Monday", "Tuesday", "Wednesday"]; 
    integer hours = llGetUnixTime()/3600; 
    integer days = (hours + offset)/24; 
    integer day_of_week = days%7; 
    return llList2String(weekdays, day_of_week); 
}

default { 
    touch_start(integer total_number) {
        integer offset = -4; // offset from UTC
        llSay(0, "Today is " + getDay(offset) + "."); 
    } 
}
