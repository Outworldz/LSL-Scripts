// :CATEGORY:Texture
// :NAME:Fade_Texture
// :AUTHOR:Nash Baldwin
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:295
// :NUM:394
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The script
// :CODE:
// Call this from an event handler.
// Currently only fades the top.
// Set kSide to ALL_SIDES to fade all sides.
integer kSide = 0;

fade_in_and_out()
{
    integer steps = 15;
    float base = 0.85;
    float delay = 1.0 / steps;
    integer i;

    // fade up
    for (i = 0; i < steps; i++)
    {
        llSetAlpha(1.0 - llPow(base,i), kSide);
        llSleep(delay);
    }

    llSetAlpha(1.0, kSide);
    llSleep(4);

    // fade out
    for (i = 0; i < steps; i++)
    {
        llSetAlpha(llPow(base,i), kSide);
        llSleep(delay);
    }

    llSetAlpha(0.0, kSide);
}



default
{
    
    touch_start(integer total_number)
    {
        fade_in_and_out();
    }
}
