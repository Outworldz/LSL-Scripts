// :CATEGORY:Building
// :NAME:Fractal_Generator
// :AUTHOR:Seifert Surface
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:336
// :NUM:451
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Rescaler
// :CODE:
///////////////////////////////////////////
/////Fractal Generator 1.0 Rescaler////////
///////////////////////////////////////////
///////////////////by//////////////////////
///////////////////////////////////////////
/////////////Seifert Surface///////////////
/////////////2G!tGLf 2nLt9cG/////Aug 2005//
///////////////////////////////////////////

default
{
    state_entry()
    {
    }

    on_rez(integer number)
    {
        if(number != 0) //when rezzed by an avatar, don't do anything
        {
            float scale = (float)number/1000000.0;  //sneaky way to get a float in here using an integer...
            llSetScale(llGetScale()*scale);
            llRemoveInventory(llGetScriptName());   //kill the script when done
        }
    }
}
