// :CATEGORY:Light
// :NAME:light_script
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2014-09-07
// :ID:470
// :NUM:631
// :REV:1.1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// touchable on/off lamp that casts shadows. You can have up to 4 in view at a time ( SL restriction as moon, + sun + 4 lights is a a max of 6)
// :CODE:

// Touch the object to light it up.
// Lighting is configurable.
 
integer light_s    = FALSE;
vector  lightcolor = <1.0, 0.75, 0.5>;
float   intensity  = 1.0;             // 0.0 <= intensity <= 1.0
float   radius     = 10.0;            // 0.1 <= radius <= 20.0
float   falloff    = 0.01;            // 0.01 <= falloff <= 2.0
float   glow       = 0.05;
 
toggle()
{
    float thisglow = 0.0;
    light_s = !light_s;
 
    if (light_s)
        thisglow = glow;
 
    llSetPrimitiveParams([
        PRIM_POINT_LIGHT, light_s, lightcolor, intensity, radius, falloff,
        PRIM_FULLBRIGHT, ALL_SIDES, light_s,
        PRIM_GLOW,       ALL_SIDES, thisglow
    ]);
      llSetColor(lightcolor, ALL_SIDES);
}
 
default
{
    state_entry()
    {
        llSetText("Touch for light", <1.0, 1.0, 1.0>, 1.0);
        toggle();
    }
 
    touch_start(integer total_number)
    {
        toggle();
    }
    
    changed(integer what)
    {
        if (what & CHANGED_REGION_RESTART)
        {
            llResetScript();
        }
    }
}

// END //
