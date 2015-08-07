// :CATEGORY:Clock
// :NAME:Millisecond_Time
// :AUTHOR:Minsk Oud
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:57
// :ID:513
// :NUM:695
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The remainder of these functions deal with time of day as *milliseconds* since midnight. As this format would overflow every ~24 days, it must not be used to represent date or elapsed time information (unless you are Microsoft and like your servers crashing).
// :CODE:
// By Christopher Wolfe (SL name "Minsk Oud").
// This script is in the public domain.

// Gets the number of milliseconds since midnight UTC.
integer GetGMTmsclock()
{
    string stamp = llGetTimestamp();
    return
        (integer) llGetSubString(stamp, 11, 12) * 3600000 +
        (integer) llGetSubString(stamp, 14, 15) * 60000 +
        llRound((float) llGetSubString(stamp, 17, -2) * 1000.0);
}

// Gets the number of milliseconds since midnight in the specified
// timezone, using the offset in milliseconds. Some useful offsets:
//
// EST = -5 * 3600000 = -18000000
// PST = -8 * 3600000 = -28800000
//
integer GetTZmsclock(integer offset)
{
    if (offset < 0) offset += 86400000;
    integer time = (integer) GetGMTmsclock() + offset;
    if (time >= 86400000) time -= 86400000;
    return time;
}

//
// Formats a number of milliseconds since midnight as human readable
// time of day.
//
// time:     Number of milliseconds since midnight. Must be greater than
//           or equal to zero and strictly less than 86400000.
//
// military: If TRUE, output in 24-hour (or military) time.
//           If FALSE, output in 12-hour time with AM/PM indicator.
//
// second_decimals: Number of decimal digits to display for seconds.
//           Zero will remove the decimal point, greater than three
//           is useless.
//
string FormatTime(integer time, integer military, integer second_decimals)
{
    // Uncomment this to ensure time is within the correct range
    //
    // while (time < 0) time += 86400000;
    // while (time >= 86400000) time -= 86400000;
    //

    integer hour = time / 3600000; time -= hour * 3600000;
    integer minute = time / 60000; time -= minute * 60000;
    integer second = time / 1000; time -= second * 1000;

    string ampm;
    if (military) {
        ampm = "";
    }
    else {
        // 12 noon until 11:59:59 (just before midnight) are "PM"
        if (hour >= 12) ampm = " PM";
        // 12 midnight until 11:59:59 (just before noon) are "AM"
        else ampm = " AM";

        if (hour == 0) hour = 12;
        else if (hour > 12) hour -= 12;
    }

    // Only pad the hour field if military time is specified

    string shour;
    if (military && hour < 10) shour = "0" + (string) hour; else shour = (string) hour;
    
    // Pad the minute and second fields in either time format

    string sminute;
    if (minute < 10) sminute = "0" + (string) minute; else sminute = (string) minute;

    string ssecond;
    if (second < 10) ssecond = "0" + (string) second; else ssecond = (string) second;

    string decimals;
    if (second_decimals > 0) {
        // Construct the decimals string with all interesting digits to the
        // left of the decimal point. This automatically provides zero padding
        // unless the actual decimal value is zero.
        decimals = (string) llFloor(time * llPow(10, second_decimals - 3));

        // If the decimal value was exactly zero, additional padding will need
        // to be added.
        while (llStringLength(decimals) < second_decimals) decimals += "0";

        // Prepend a decimal point.
        decimals = "." + decimals;
    }
    else {
        decimals = "";
    }

    return shour + ":" + sminute + ":" + ssecond + decimals + ampm;
}
