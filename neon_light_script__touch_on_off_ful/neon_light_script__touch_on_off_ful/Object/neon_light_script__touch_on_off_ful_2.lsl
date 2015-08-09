// :CATEGORY:Light
// :NAME:neon_light_script__touch_on_off_ful
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:553
// :NUM:757
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// a version that blinks
// :CODE:
vector color = <1,1,1>;  // Use to change the color of the light
float intensity = 1.000; // Use to change the intensity of the light, from 0 up to 1
float radius = 10.000;  //  Use to change the Radius of the light, from 0 up to 20
float falloff = 0.750;  //  Use to set the falloff of the light, from 0 up to 2

// Everything below here is just script stuff, you don't have to mess with it unless you know what you are doing.

integer flag = 0;

on()
{
     llSetPrimitiveParams([PRIM_POINT_LIGHT, TRUE, color, intensity, radius, falloff]);
     llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);
     g_OpenNow = TRUE;
}

off()
{
    llSetPrimitiveParams([PRIM_POINT_LIGHT, FALSE, <1, 1, 1>, 1.0, 10.0, 0.75]);
    llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, FALSE]);
    g_OpenNow = FALSE;
}

integer g_OpenNow;                // True (1) if light is on now

default
{
    on_rez(integer param)
    {
        llResetScript();
    }
    
    state_entry()
    {
        llSay(0, "touch to turn on and off"); 
        if (g_OpenNow == TRUE)
        { 
            state WaitToClose;
        }
        else 
        {
            g_OpenNow = FALSE;
            state WaitToOpen;
        }
    }
}
      
state WaitToClose // light is off waiting to turn on
{
    state_entry()
    {
        llSetTimerEvent(1)   ;
    }
    
    timer()
    {
        if ($flag++ %2 == 0 )
            on();
        else
            off();
    }
    
    touch_start(integer total_number)
    {
        off();
        state WaitToOpen;
    }
}

state WaitToOpen // light is on, waiting to turn off
{
    
   
    

    
    touch_start(integer total_number)
    {
        on();
        state WaitToClose;
    }
}
