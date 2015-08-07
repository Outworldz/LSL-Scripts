// :CATEGORY:Browser
// :NAME:Touch_Urlloader
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:07
// :ID:906
// :NUM:1282
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Touch Url-loader.lsl
// :CODE:

default
{
    touch_start(integer total_number)
    {
        llLoadURL(llDetectedKey(0), "Connecting to Stream", "http://64.34.180.110:11734/listen.pls");
    }
}// END //
