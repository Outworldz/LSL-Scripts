// :CATEGORY:Effects
// :NAME:Blink_prim_2_colors
// :AUTHOR:Tal Chernov
// :CREATED:2013-08-04 08:13:36.167
// :EDITED:2013-09-18 15:38:49
// :ID:102
// :NUM:137
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// //I made this script specifically so I could have a prim to flash between 2 colors.//Feel free to use it as you like.
// :CODE:
//I made this script specifically so I could have a prim to flash between 2 colors.
//Feel free to use it as you like.
//Tal Chernov 
integer x = 0;
default
{
    state_entry()
    {
        llSetTimerEvent(2);//change number to slow down or speed up flash
        llSetTexture(TEXTURE_BLANK, ALL_SIDES);//this ensures the prim stays blank as the texture
    }
    timer()
    {
        if (x == 0)
        {
            llSetColor(<1, 0, 0>, -1);//basic color change with 1 and 0.  1, 0, 0 is red. 0, 1, 0 is green. 0, 0, 1 is blue 
            x = 1;
        }
        else
        {
            llSetColor(<0, 1, 0>, -1);//setting the numbers to both the same will change the color. 1, 0, 1 is purple. 1, 1, 1 is white. 0, 0, 0 is black
            x = 0;
        }
    }
}
