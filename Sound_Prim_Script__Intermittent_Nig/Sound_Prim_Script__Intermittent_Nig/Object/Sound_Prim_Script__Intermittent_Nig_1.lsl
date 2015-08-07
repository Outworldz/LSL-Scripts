// :CATEGORY:Sound
// :NAME:Sound_Prim_Script__Intermittent_Nig
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:04
// :ID:812
// :NUM:1122
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Sound Prim Script - Intermittent Night.lsl
// :CODE:


// Sound Prim Script - Intermittent Nighttime
//
// If the sun is below the horizon, this
// randomly picks a sound in inventory, plays it,
// waits a random interval, repeats.
//
// Set this between 0.0 and 1.0
float LOUDNESS = 0.5;
//
// Interval in seconds to be silent.
// If you set these to be less than 10 seconds,
// they default to 10 seconds.
integer SHORTEST = 60;
integer LONGEST = 180;
//
////////////////////////////////////////////////
default
{

state_entry()
{
    if (SHORTEST < 10 )     SHORTEST = 10;
    if (LONGEST < 10 )      LONGEST = 10;
    if (SHORTEST > LONGEST) SHORTEST = LONGEST;

    llSleep( 1.0 );    
    state noisy;
}

on_rez(integer start_param)
{
    llSleep( 1.0 );
    state noisy;
}

}
////////////////////////////////////////////////
state noisy
{

state_entry()
{ 
    vector sun_point = llGetSunDirection();
    if ( sun_point.z >= 0.0 ) state silent;
    
    integer sounds = llGetInventoryNumber(INVENTORY_SOUND);
    if ( sounds <= 0 ) state default;

    string soundname = llGetInventoryName( INVENTORY_SOUND, llFloor(llFrand(sounds)) );
    if ( soundname != "" )
    {
        llPlaySound( soundname, LOUDNESS );
    }
    
    state silent;
}

on_rez(integer start_param)
{
    state default;
}

}
////////////////////////////////////////////////
state silent
{

state_entry()
{    
    llSleep( (float)(llFloor(llFrand(LONGEST - SHORTEST)) + SHORTEST) );
    state noisy;
}

on_rez(integer start_param)
{
    state default;
}

}

// END //
