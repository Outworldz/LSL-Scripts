// :CATEGORY:Sound
// :NAME:Sound_Prim_Script__On_Touch
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:04
// :ID:815
// :NUM:1125
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Sound Prim Script - On Touch.lsl
// :CODE:


// Sound Prim Script - On Touch
//
// Randomly picks a sound in inventory, 
// plays it when touched.
//
// Set this between 0.0 and 1.0
float LOUDNESS = 0.5;
//
////////////////////////////////////////////////
default
{

touch_start(integer num)
{
    integer sounds = llGetInventoryNumber(INVENTORY_SOUND);

    if ( sounds <= 0 ) return;

    string soundname = llGetInventoryName( INVENTORY_SOUND, llFloor(llFrand(sounds)) );
    if ( soundname != "" )
    {
        llPlaySound( soundname, LOUDNESS );
    }  
}

}



// END //
