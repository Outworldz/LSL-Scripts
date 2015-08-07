// :CATEGORY:Building
// :NAME:Show_Sides
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:02
// :ID:750
// :NUM:1033
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Show Sides.lsl
// :CODE:

default
{
    touch_start(integer num)
    {
        llSetText("0. Black / 1. White / 2. Red\n3. Blue / 4. Yellow /  5. Green\n6. Orange / 7. Purple / 8. Grey", <1,1,1>, 1.0);
        
        llSetColor(<0,0,0>, 0);
        llSetColor(<1,1,1>, 1);
        llSetColor(<1,0,0>, 2);
        llSetColor(<0,0,1>, 3);
        llSetColor(<1,1,0>, 4);
        llSetColor(<0,1,0>, 5);
        llSetColor(<1,0.5,0>, 6);
        llSetColor(<0.5,0,0.5>, 7);
        llSetColor(<0.5,0.5,0.5>, 8);
    }
}// END //
