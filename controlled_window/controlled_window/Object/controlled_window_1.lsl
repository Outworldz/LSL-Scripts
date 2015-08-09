// :CATEGORY:Windows
// :NAME:controlled_window
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:204
// :NUM:278
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// controlled window.lsl
// :CODE:

// window script to set transparency between 0 and 1 in 5 steps
// use ll
default {

    touch_start(integer total_number) {
        llOwnerSay("Use the controller to switch transparency.");
    }
    
    link_message(integer sender_num, integer num, string str, key id) {
        if(str == "transp") {
            llSetAlpha((0.25 * (float)num), ALL_SIDES); // set entire prim 100% visible.
        }
    }
    
}
// END //
