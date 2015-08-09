// :CATEGORY:Color
// :NAME:Color_and_TextONclick_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:190
// :NUM:263
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Color and TextONclick Script.lsl
// :CODE:

// Cycle through colours and set prim colour and light property to match

float red = 1;
float green = 1;
float blue = 1;

vector currentColour = <1,1,1>;

float COLOUR_INCREMENT = 0.20;

float TIMER_INT = 0.5;


changeColour()
{
    if (red == 1.0)
    {
        if (blue > 0)
        {
            blue -= COLOUR_INCREMENT;
        }
        else if (green < 1.0)
        {
            green += COLOUR_INCREMENT;
        }
    }
    if (green == 1.0)
    {
        if (red > 0)
        {
            red -= COLOUR_INCREMENT;
        }
        else if (blue < 1.0)
        {
            blue += COLOUR_INCREMENT;
        }
    }
    if (blue == 1.0)
    {
        if (green > 0)
        {
            green -= COLOUR_INCREMENT;
        }
        else if (red < 1.0)
        {
            red += COLOUR_INCREMENT;
        }
    }
    currentColour = <red, green, blue>;
    llSetColor(currentColour, ALL_SIDES);
    llSetPrimitiveParams([PRIM_POINT_LIGHT, TRUE, currentColour, 1, 10, 2]);
    
}


default
{
    state_entry()
    {
        llSetTimerEvent(TIMER_INT);
        llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);
    }

    touch_start(integer total_number)
    {
        llSay(0, "It all starts with a cube.");
    }
    
    timer()
    {
        changeColour();
    }
}
// END //
