// :CATEGORY:Sound
// :NAME:Sound_Prim_Script__On_Attach
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:04
// :ID:814
// :NUM:1124
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Sound Prim Script - On Attach.lsl
// :CODE:


// Sound Prim Script - On Attach
//
// Randomly picks a sound in inventory, 
// plays it whenever the prim is attached
// to an avatar.
//
// If the attachment is a HUD, only the
// wearer will hear it.
//
// Set this between 0.0 and 1.0
float LOUDNESS = 0.5;
//
////////////////////////////////////////////////
default
{

attach(key attached)
{
    if (attached == NULL_KEY) return; // comment this out if you want noise when detached.
    //if (attached != NULL_KEY) return; // comment this out if you want noise when attached.   
        
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
