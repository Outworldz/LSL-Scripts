// :CATEGORY:AntiDelay
// :NAME:AntiDelay_Node
// :AUTHOR:Xaviar Czervik
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:43
// :NUM:57
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Almost every function in Second Life has a delay associated with it. Ranging from 20 seconds to .2 seconds - delays can get on anyones' nerves. Even the most basic scripters know the easy way to get around this is to have a script and use llMessageLinked to tell it to do something. Below is a more advanced version of that code - that allows for one script to handle almost any type of function with a delay.// // How To Use: Use llMessageLinked - the integer is -123, the string is the list of arguments seperated by "~~~", and the key is the name of the function. 
// :CODE:
default {
    touch_start(integer total_number) {
        string s = llGetOwner();
        llMessageLinked(LINK_SET, -123, s + "~~~This is a dialog~~~With, Three, Options~~~0", "dialog");
    }
}
 
