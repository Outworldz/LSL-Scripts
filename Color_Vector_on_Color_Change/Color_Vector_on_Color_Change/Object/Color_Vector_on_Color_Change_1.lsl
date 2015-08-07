// :CATEGORY:Color
// :NAME:Color_Vector_on_Color_Change
// :AUTHOR:Aki-Tools
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:196
// :NUM:269
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Color Vector on Color Change.lsl
// :CODE:

//Aki-Tools 
//"ColorVec on ColorChange" 01/27/2004 
//This script is useful if you are trying to figure out a color vector. When you change the color of the object this script is on, the object will whisper the new color vector. 

init() 
{ 
    llSetColor(<1,1,1>, ALL_SIDES); 
} 

colorize() 
{ 
    integer s; 
    vector color = llGetColor(1); 
    llWhisper(0, "Current Color Vector: [ "+(string)color+" ]"); 
} 

default 
{ 
    state_entry() 
    { 
    init(); 
    } 

    on_rez(integer a) 
    { 
        init(); 
    } 

    touch_start(integer total_number) 
    { 
        colorize(); 
    } 

    changed(integer change) 
    { 
        if (change & CHANGED_COLOR) 
        { 
            colorize(); 
        } 
    } 
}

state sold
{
   state_entry() { }
}// END //
