// :CATEGORY:Color
// :NAME:Color_fade_script
// :AUTHOR:Jesrad Seraph
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:193
// :NUM:266
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Color fade script.lsl
// :CODE:

// linkset color variation over time
// can be random or sequential in hue
// random is NOT advised as it strains the Sim's resources

// Author: Jesrad Seraph
// use, modify and redistribute freely


// commands:
// /23 toggle => toggles between sequential and random color change
// /23 reset  => sets color back to pure red, useful to sync multiple items
// /23 start  => starts the color change effect
// /23 stop   => freezes the color change effect
// /23 clear  => stops the effect and sets color to white
// /23 blue   => stops the effect and sets color to pure blue
// /23 green  => stops the effect and sets color to pure green
// /23 red    => stops the effect and sets color to pure red
// /23 saturate   => augments the saturation up 10%
// /23 desaturate => decreases saturation by 10%
// /23 faster => makes the effect twice as fast (WARNING may cause lag on the whole Sim at high speeds)
// /23 slower => makes the effect half as fast
// /23 alpha   => makes the object 10% more transparent
// /23 dealpha => makes the object 10% less transparent
// /23 transparent => makes the object fully transparent
// /23 opaque      => makes the object fully opaque
// /23 change  => manually triggers the color change
// saturation control only affects the sequential fade effect

key owner;

integer ISSEQUENTIAL = 1;

integer listen_handle;

float colordelay = 2.0;
// this is the default color update frequency

float unsaturation = 0.0;
float opacity = 1.0;

vector currentcolor = <1.0, 0.0, 0.0>;
// switch to pure red on reset

integer currentangle = 0;
integer currentdir = 0;
// 0 for red to green
// 1 for green to blue
// 2 for blue to red

integer angle_increment = 3;
// determines the number of steps around the hue wheel.
// the lower the more steps, doesn't go over 90
// Always use a factor of 90 for better results
// 3 or 5 are good values


    
colorupdate()
{
    // change current color
    if (ISSEQUENTIAL < 0)
    {
        // set a random color:
        currentcolor = <llFrand(1),llFrand(1),llFrand(1)>;
    }
    else
    {
        // rotate the color vector along X Y Z to vary between red, green and blue
        if (currentangle >= 90)
        {
            currentdir += 1;
            currentangle = 0;
            if ((currentdir >= 3) || (currentdir < 0))
                currentdir = 0;
        }
        currentangle += angle_increment;
    }
}

colorchange()
{
    float float_angle = ((float)currentangle) * DEG_TO_RAD;
    float sinelement = llSin(float_angle) * (1.0 - unsaturation) + unsaturation;
    float coselement = llCos(float_angle) * (1.0 - unsaturation) + unsaturation;

    if (ISSEQUENTIAL > 0)
    {
        if (currentdir == 0)
        {
            currentcolor = <coselement, sinelement, unsaturation>;
        }
        else if (currentdir == 1)
        {
            currentcolor = <unsaturation, coselement, sinelement>;
        }
        else if (currentdir == 2)
        {
            currentcolor = <sinelement, unsaturation, coselement>;
        }
    }
    
    llSetColor(currentcolor,ALL_SIDES);
    llMessageLinked(LINK_SET,105,(string)currentcolor,  NULL_KEY);
}

default
{
    state_entry()
    {
        llListenRemove(listen_handle);
        owner=llGetOwner();
        listen_handle = llListen(23,"",owner,"");
    }

    timer()
    {
        colorupdate();
        colorchange();
    }

    listen(integer channel, string name, key id, string message)
    {
        if (message == "toggle")
        {
            ISSEQUENTIAL *= -1;
        }
        else if (message == "reset")
        {
            currentcolor = <1.0, 0.0, 0.0>;
            unsaturation = 0.0;
            currentangle = 0;
            currentdir = 0;
            ISSEQUENTIAL = 1;
            colordelay = 2.0;
            llSetColor(currentcolor,ALL_SIDES);
            llMessageLinked(LINK_SET,105,(string)currentcolor,  NULL_KEY);
            llSetTimerEvent(colordelay);
        }
        else if (message == "start")
        {
            llSetTimerEvent(colordelay);
        }
        else if (message == "stop")
        {
            llSetTimerEvent(0);
        }
        else if (message == "clear")
        {
            llSetTimerEvent(0);
            currentcolor = <1.0, 1.0, 1.0>;
            llSetColor(currentcolor,ALL_SIDES);
            llMessageLinked(LINK_SET,105,(string)currentcolor,  NULL_KEY);
        }
        else if (message == "blue")
        {
            llSetTimerEvent(0);
            unsaturation = 0.0;
            currentangle = 0;
            currentdir = 2;
            colorchange();
        }
        else if (message == "green")
        {
            llSetTimerEvent(0);
            unsaturation = 0.0;
            currentangle = 0;
            currentdir = 1;
            colorchange();
        }
        else if (message == "red")
        {
            llSetTimerEvent(0);
            unsaturation = 0.0;
            currentangle = 0;
            currentdir = 0;
            colorchange();
        }
        else if (message == "black")
        {
            llSetTimerEvent(0);
            currentcolor = <0.0, 0.0, 0.0>;
            llSetColor(currentcolor,ALL_SIDES);
            llMessageLinked(LINK_SET,105,(string)currentcolor,  NULL_KEY);
        }
        else if (message == "faster")
        {
            colordelay /= 2.0;
            if (colordelay < 0.25)
                colordelay = 0.25;
            llSetTimerEvent(colordelay);
        }
        else if (message == "slower")
        {
            colordelay *= 2.0;
            llSetTimerEvent(colordelay);
        }
        else if (message == "saturate")
        {
            unsaturation -= 0.1;
            if (unsaturation < 0.0)
                unsaturation = 0.0;
            colorchange();
        }
        else if (message == "desaturate")
        {
            unsaturation += 0.1;
            if (unsaturation > 1.0)
                unsaturation = 1.0;
            colorchange();
        }
        else if (message == "alpha")
        {
            opacity -= 0.1;
            if (opacity < 0.0)
                opacity = 0.0;
            llSetAlpha(opacity, ALL_SIDES);
            llMessageLinked(LINK_SET,106,(string)opacity,NULL_KEY);
        }
        else if (message == "dealpha")
        {
            opacity += 0.1;
            if (opacity > 1.0)
                opacity = 1.0;
            llSetAlpha(opacity, ALL_SIDES);
            llMessageLinked(LINK_SET,106,(string)opacity,NULL_KEY);
        }
        else if (message == "transparent")
        {
            opacity = 0.0;
            llSetAlpha(opacity, ALL_SIDES);
            llMessageLinked(LINK_SET,106,(string)opacity,NULL_KEY);
        }
        else if (message == "opaque")
        {
            opacity = 1.0;
            llSetAlpha(opacity, ALL_SIDES);
            llMessageLinked(LINK_SET,106,(string)opacity,NULL_KEY);
        }
        else if (message == "change")
        {
            colorupdate();
            colorchange();
        }
    }
}// END //
