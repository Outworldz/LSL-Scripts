// :CATEGORY:Clock
// :NAME:Millisecond_Time
// :AUTHOR:Minsk Oud
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:57
// :ID:513
// :NUM:694
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// A collection of time utility functions, to try and make sub-second and timezone handling easier.// // First a timezone-aware cousin of llGetGMTclock:
// :CODE:
// By Christopher Wolfe (SL name "Minsk Oud").
// This script is in the public domain.

//
// A version of llGetGMTclock() with timezone support, using the
// offset in seconds. Some useful offsets:
//
// EST = -5 * 3600 = -18000
// PST = -8 * 3600 = -28800
//
integer GetTZclock(integer offset)
{
    if (offset < 0) offset += 86400;
    integer time = (integer) llGetGMTclock() + offset;
    if (time >= 86400) time -= 86400;
    return time;
}
