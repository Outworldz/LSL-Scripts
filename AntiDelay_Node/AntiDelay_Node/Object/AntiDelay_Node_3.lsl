// :CATEGORY:AntiDelay
// :NAME:AntiDelay_Node
// :AUTHOR:Xaviar Czervik
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:43
// :NUM:59
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// And now for the full and complete power of this code *drum roll*. Only 2 scripts are needed for the following code to work. 
// :CODE:
default {
    touch_start(integer total_number) {
        string s = llGetOwner();
        llMessageLinked(LINK_SET, -123, s + "~~~This is a dialog~~~With, Three, Options~~~0", "dialog");
        llMessageLinked(LINK_SET, -123, "youemail@theaddress.com~~~Subj~~~Body", "email");
        llSleep(1);
        llMessageLinked(LINK_SET, -123, s + "~~~This is a dialog~~~With, Three, Options~~~0", "dialog");
        llSleep(1);
        llMessageLinked(LINK_SET, -123, "youemail@theaddress.com~~~Subj~~~Body", "email");
 
    }
}
 
