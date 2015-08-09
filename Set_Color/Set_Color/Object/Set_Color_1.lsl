// :CATEGORY:Color
// :NAME:Set_Color
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:02
// :ID:742
// :NUM:1025
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Set Color.lsl
// :CODE:

1// remove this number for the script to work.



//This script will set the color of an object, Very useful when used with the get color vector script.
 
 //This is the color vector, Change the numbers between the 2 arrows.
 
 vector color = <1,1,1>;
 
 //This is side of the object which the script will change the color of. Using ALL_SIDES will change the color of all the sides.

integer side = ALL_SIDES;



default
{
    state_entry()
    {
        llSetColor(color,side);
    }
}
// END //
