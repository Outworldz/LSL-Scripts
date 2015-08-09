// :CATEGORY:Land
// :NAME:LandOwner_Key
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:458
// :NUM:614
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// LandOwner Key.lsl
// :CODE:


1// remove this number for the script to work.



// This script will give you the AV key of the land owner. Place this script in an object then click it to get the key.


//This script will only return the name if the owner is ONLINE at the time althoug it will give you the key of the owner.

default
{

    touch_start(integer total_number)
    {
        llSay(0, "The land owner's key is: " + (string)llGetLandOwnerAt(llGetPos()));
        llSay(0, "THe land owner's name is: " + llKey2Name(llGetLandOwnerAt(llGetPos())));
    }
}
// END //
