// :CATEGORY:Greeter
// :NAME:Who_touched_me
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:977
// :NUM:1399
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Who touched me.lsl
// :CODE:

// when touched, IM the owner with the name of the touching agent
default {
    touch_start(integer num_detected) {
        llInstantMessage(llGetOwner(), llDetectedName(0) + " touched me.");
    }
}// END //
