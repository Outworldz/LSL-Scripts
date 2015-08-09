// :CATEGORY:AntiDelay
// :NAME:AntiDelay_Node
// :AUTHOR:Xaviar Czervik
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:43
// :NUM:58
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Example
// :CODE:
default {
    touch_start(integer total_number) {
        vector v =  <128,128,300>;
        integer i = 0;
        float vecDist = llVecDist(llGetPos(), v);
        vecDist /= 5;
        vecDist += 1;
        while (i < vecDist) {
            llMessageLinked(LINK_SET, -123, (string)v, "setpos");
            i++;
        }
    }
}
