// :CATEGORY:Sound
// :NAME:single_song
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:02
// :ID:772
// :NUM:1060
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// single song.lsl
// :CODE:

default
{
    state_entry()
    {
        llLoopSound(llGetInventoryName(INVENTORY_SOUND, 0), 1);
    }
}
// END //
