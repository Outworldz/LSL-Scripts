// :CATEGORY:Clock
// :NAME:Get_Day_of_Week
// :AUTHOR:DoteDote Edison
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:346
// :NUM:468
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Method to get the day of the week from a unix timestamp - llGetUnixTime. The timestamp returns the number of seconds elapsed beginning Thursday, January 1, 1970 UTC. This script first converts the seconds to hours, then adds the GMT offset (if desired), then converts the hours to days, and finally grabs the day of the week from a list.
// :CODE:
// Gives day of the week 
// DoteDote Edison 

list weekdays = ["Thursday", "Friday", "Saturday", "Sunday", "Monday", "Tuesday", "Wednesday"]; 
integer offset = -4; // offset from UTC 

default { 
    state_entry() { 
        // 
    } 
    touch_start(integer total_number) { 
        integer hours = llGetUnixTime()/3600; 
        integer days = (hours + offset)/24; 
        integer day_of_week = days%7; 
        llSay(0, "Today is " + llList2String(weekdays, day_of_week)); 
    } 
}
