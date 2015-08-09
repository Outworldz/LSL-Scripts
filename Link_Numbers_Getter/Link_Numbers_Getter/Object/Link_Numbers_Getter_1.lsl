// :CATEGORY:Linking
// :NAME:Link_Numbers_Getter
// :AUTHOR:Kanker Greenacre
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:472
// :NUM:633
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// I made a function like this for my Flying Tako sailboat so that I didn't have to worry about linking the various parts in just the right order, or have to remember which part was link #14 (or which link number the sail was). If all your child prims have unique names (like "mast" or "door"), then you can use this function to automatically get the link numbers for them and assign them to variables in your script. This makes using llMessageLinked much easier - for example, you could just use a new variable DOOR to send a link message to the door on your vehicle. Or use the DOOR variable to change the color of your door in llSetLinkColor.
// :CODE:
integer PRIM1;
integer PRIM2;
integer PRIM3;

getLinkNums() {
    integer i;
    integer linkcount=llGetNumberOfPrims();
    for (i=1;i<=linkcount;++i) {
        string str=llGetLinkName(i);
        if (str=="prim1") PRIM1=i;
        if (str=="prim2") PRIM2=i;
        if (str=="prim3") PRIM3=i;
    }
}

default {
    
    state_entry() {
        getLinkNums();
        llMessageLinked(PRIM1,0,"Test","");
        llMessageLinked(PRIM2,0,"Test","");
        llMessageLinked(PRIM3,0,"Test","");
    }
    
}
