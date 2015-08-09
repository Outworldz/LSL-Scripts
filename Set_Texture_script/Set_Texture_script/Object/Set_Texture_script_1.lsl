// :CATEGORY:Texture
// :NAME:Set_Texture_script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:02
// :ID:743
// :NUM:1026
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Set_Texture script.lsl
// :CODE:

1// remove this number for the script to work.

//This script uses the texture key to set a new Texture on an object. If you are unsure of the key of a certain texture then get a copy of the Texture finder script.
 
   
default
{
    state_entry()
    {
        llSetTexture (" ", ALL_SIDES);
//The texture key you wish for the object to be set as needs to go between the two " ".
    }
}
// END //
