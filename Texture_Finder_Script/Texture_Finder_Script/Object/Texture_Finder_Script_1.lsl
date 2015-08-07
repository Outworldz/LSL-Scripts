// :CATEGORY:Texture
// :NAME:Texture_Finder_Script
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:06
// :ID:877
// :NUM:1237
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Texture Finder Script.lsl
// :CODE:

1// Remove this number for this script to work





//This script gives you the Key for the texture on the object that you place this script in.

default
{
    state_entry()
    {
        llInstantMessage(llGetOwner(), "Please click the object to get the Texture Key");
    }
    
    touch_start(integer total_number)
    {
        llInstantMessage(llGetOwner(), (string)llGetTexture(0));
    }  
}// END //
