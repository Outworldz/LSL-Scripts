// :CATEGORY:Texture
// :NAME:Remote_Texture_Loader
// :AUTHOR:Bobbyb30 Swashbuckler
// :CREATED:2010-12-27 12:20:34.060
// :EDITED:2013-09-18 15:39:01
// :ID:691
// :NUM:944
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Get key & set pin.lsl 
// :CODE:
//***********************************************************************************************************
//                                                                                                          *
//                                                    -- Get key & set pin --                               *
//                                                                                                          *
//***********************************************************************************************************
// www.lsleditor.org  by Alphons van der Heijden (SL: Alphons Jano)
//Creator: Bobbyb30 Swashbuckler
//Attribution: None required, but it is appreciated.
//Created: November 28, 2009
//Last Modified: November 28, 2009
//Released: Saturday, November 28, 2009
//License: Public Domain
 
//Status: Fully Working/Production Ready
//Version: 1.0.1
 
//Name: Get key & set pin.lsl
//Purpose: To set the pin and print out the UUID of the object.
//Description: Gets the key of the object and sets the object remote load pin.
//Directions: Modify pin to match the one used in remote loader and then drop into prim.
 
//Compatible: Mono & LSL compatible
//Other items required: For use with 'Remote Loader.lsl'
//Notes: Commented for easier following. Removes itself after use.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
 
integer pin = 606;//change the pin to match what you put in remote loader.lsl
default
{
    state_entry()
    {
        llSetRemoteScriptAccessPin(pin);
        llOwnerSay("Pin has been set. My key is:" + (string)llGetKey());
        llRemoveInventory(llGetScriptName());//remove script from inventory
        llSleep(.5);
        //if that fails we'll get here
        llInstantMessage(llGetOwner(),"The script '" + (string)llGetScriptName() + "' in object " + llGetObjectName()
            + "at Region " + (string)llGetRegionName() + " loc: " + (string)llGetPos() + " failed to delete.");
        llSetScriptState(llGetScriptName(),FALSE);//shut off script
    }
}
