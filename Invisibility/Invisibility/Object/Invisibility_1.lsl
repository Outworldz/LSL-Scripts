// :CATEGORY:Invisibility
// :NAME:Invisibility
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:403
// :NUM:559
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Invisibility.lsl
// :CODE:

1// remove this number for the script to work.

// global variables
string texture_a="invis1";  // use a "blank texture here.  The easiest
                            // way to get it is by selecting the "blank"
                            // from the texture picker and then copying 
                            // it to your inventory.  Either call it
                            // "invis1" or change the value for texture_a
                            // to be the name you choose.
                            
key texture_b="ffffffff-ffff-ffff-ffff-ffffffffffff"; 
// The above is a key for an "image not available" texture which is
// globally available.  I chose it because it is simple and easy for
// just about any client to load.


// gloabl functions

// This is the function that makes an object "invisible"
invis()
{
    llSetTexture(texture_a,ALL_SIDES);
    llSetAlpha(0.0,ALL_SIDES);
    llScaleTexture(500.0,500.0,ALL_SIDES);
    llSetTexture(texture_b,4);
    llSetTexture(texture_a,4);
    llSetTexture(texture_a,2);
    llSetTexture(texture_b,2);
}
    

default
{
    state_entry()
    {
        invis(); // call the invisibility function on entry.
    }
    on_rez(integer i)
    {
        invis(); // Call it upon being rezzed :-)
    }
    
}
// END //
