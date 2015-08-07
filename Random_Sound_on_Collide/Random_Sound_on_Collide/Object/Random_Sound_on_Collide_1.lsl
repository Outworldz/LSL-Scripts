// :CATEGORY:Sound
// :NAME:Random_Sound_on_Collide
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:00
// :ID:681
// :NUM:924
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// BRan.lsl
// :CODE:

test( integer chargeval )
{
    
    float SoundVal = llFrand(100);
    if (SoundVal <= 33) llTriggerSound("ric2.wav", 10.0);
    else if (SoundVal >= 66) llTriggerSound("ric1.wav", 10.0);             
    else llTriggerSound("ric4.wav", 10.0); 
}

default
{
    state_entry()
    {
        //llSay(0, "Hello, Avatar!");
    }

    collision_start(integer chargeval)
    {
        test( (integer) chargeval );
}
}
// END //
