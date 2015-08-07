// :CATEGORY:Sound
// :NAME:Loop_Sound_in_inventory
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:493
// :NUM:660
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Loop Sound in inventory.lsl
// :CODE:


// Sound Prim Script - Loop
//
// Repeatly plays the sound in inventory if there is
// ONE and ONLY ONE sound.  Silent otherwise.
//
// Set this between 0.0 and 1.0
float LOUDNESS = 0.5;
//
////////////////////////////////////////////////
Noisy()
{
    if ( llGetInventoryNumber(INVENTORY_SOUND) == 1 )
    {
        string soundname = llGetInventoryName(INVENTORY_SOUND, 0);
        if ( soundname != "" )
        {
            llLoopSound( soundname, LOUDNESS );
        }
    }
    else
    {
        llStopSound();
    }
}
////////////////////////////////////////////////
default
{

state_entry()
{
    llStopSound();
    Noisy();
}

changed(integer change)
{
    if (change & CHANGED_INVENTORY)
    {
    llStopSound();
        Noisy();
    }
}

}
// END //
