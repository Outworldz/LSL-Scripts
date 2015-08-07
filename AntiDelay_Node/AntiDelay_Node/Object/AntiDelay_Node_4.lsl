// :CATEGORY:AntiDelay
// :NAME:AntiDelay_Node
// :AUTHOR:Xaviar Czervik
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:43
// :NUM:60
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The code to make it all work:// // // AntiDelay Node Manager: 
// :CODE:
list l = [];
list functions = ["email", "loadurl", "teleportagenthome", "remoteloadscriptpin", "remotedatareply", "giveinventorylist", 
                  "setparcelmusicurl", "instantmessage", "preloadsound", "mapdestination", "dialog", "createlink", "setpos",
                  "setrot", "settexture", "rezobject"];
list delays = [20000, 10000, 5000, 3000, 3000, 2000, 2000, 1000, 1000, 1000, 1000, 1000, 200, 200, 200, 100];
integer count = 1;
integer time() {
    string stamp = llGetTimestamp();
    return (integer) llGetSubString(stamp, 11, 12) * 3600000 +
           (integer) llGetSubString(stamp, 14, 15) * 60000 +
           llRound((float)llGetSubString(stamp, 17, -2) * 1000000.0)/1000;
}
integer nextFreeScript() {
    integer i = 0;
    integer curTime = time();
    while (i < llGetListLength(l)) {
        if (llList2Integer(l, i) - curTime <= 0) {
            return i;
        }
        ++i;
    }
    return -1;
}
 
default {
    state_entry() {
        llMessageLinked(LINK_SET, -112, "", "");
        llSleep(1);
        llMessageLinked(LINK_SET, -111, "", "");
    }
    link_message(integer send, integer i, string s, key k) {
        if (i == -2) {
            llMessageLinked(LINK_SET, (integer)s, (string)count, "");
            ++count;
            l += time();
            llSetTimerEvent(6);
        }
    }
    timer() {
        state run;
    }
}
 
state run {
    state_entry() {
    }
    link_message(integer send, integer i, string s, key k) {
        if (i == -123) {
            llOwnerSay("A");
            integer d = llList2Integer(delays, llListFindList(functions, [(string)k]));
            integer ii = nextFreeScript();
            l = llListReplaceList(l, [time() + d], ii, ii);
            llMessageLinked(LINK_SET, ii+1, s, k);
        }
    }
}
