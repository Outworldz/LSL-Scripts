// :CATEGORY:Hovertext
// :NAME:click_on_the_sign
// :AUTHOR:Malaer Sunchaser
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:176
// :NUM:247
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// click on the sign to receve free jutsu's and the rules.lsl
// :CODE:

// Hovering Text Script
// Written by and Comments by: Malaer Sunchaser
// Very Simple Script that allows you to hover text over an object.
// How The Script Works:
// llSetText() Specifies for the object to create text above it.  
//
// Customizing the script:
// Change the text inside of "TEXT GOES HERE" to whatever you please.
// The <1.0,1.0,1.0> is the color the text will show in Float form, 1.0,1.0,1.0
// being WHITE while, 0.0, 0.0, 0.0 is BLACK this is all in RGB (Red, Green, Blue).
// experiement with combinations to get different colors.
// The 1 at the end sets the text's transparency, 1.0 being SOLID, while 0 would be clear,
// and .5 would be half way between clear and solid.

default
{
    state_entry()
    {
        llSetText("Click this sign to recieve free jutsu's and the rules for the shadow village ", <1.0,0.0,0.0>, 1);
    }
}// END //
