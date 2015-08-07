// :CATEGORY:Texture
// :NAME:Remote_Texture_Loader
// :AUTHOR:Bobbyb30 Swashbuckler
// :CREATED:2010-12-27 12:20:34.060
// :EDITED:2013-09-18 15:39:01
// :ID:691
// :NUM:942
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Remote Load Texture Display(input list).lsl
// :CODE:
//***********************************************************************************************************
//                                                                                                          *
//                            --Remote Load Texture Display(input list)--                                   *
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
 
//Name: Remote Load Texture Display(input list).lsl
//Purpose: To be remotely loaded onto a prim and then display the appropriate texture.
//Technical Overview: When this script is remotely loaded to an object, it changes that objects texture and then
//                    deletes itself.
//Directions: Add the appropriate textures to the list. Place the script in the server.
 
//Compatible: Mono & LSL compatible
//Other items required: Requires the 'Remote Loader.lsl' & 'Main Display.lsl' scripts.
//Notes: Commented for easier following. This script will delete itself after use. Do not rename script.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
//Adjustable global variables...you may change these
//texture list...this list should have 2 or more textures
list textures = [//put your texture UUIDs/keys in here
    "f150313b-1f38-8978-b2ed-e0b2ffb62d5c",// black
    "16e92b19-7407-44c6-1f7a-03d75ef3e4a6",// unabletoconnect
    "1c482bda-802d-2991-5a03-4bb128792326"// white
        ];//end of list
 
integer side = ALL_SIDES;//which side(face) to change
// put # of side, or put ALL_SIDES for all sides,-1 equals all sides
 
default
{
    state_entry()
    {
        integer param = llGetStartParameter();;
        if(param != 0)
        {
            --param;//param - 1
            llSetTexture(llList2String(textures,param),side);//set the texture
            llRemoveInventory(llGetScriptName());//remove script from inventory
            llSleep(1.0);
            llRemoveInventory(llGetScriptName());//remove script from inventory
            //if that fails we'll get here
            llInstantMessage(llGetOwner(),"The script '" + (string)llGetScriptName() + "' in object " + llGetObjectName()
                + "at Region " + (string)llGetRegionName() + " loc: " + (string)llGetPos() + " failed to delete.");
            llSetScriptState(llGetScriptName(),FALSE);//shut off script
        }
        else
        {
            llOwnerSay("Bobbyb's 'Remote Load Texture Display(input list).lsl' running (Public Domain 2009)");
            llOwnerSay("This script should be deleted if it is in a remote object...");
            llSetScriptState(llGetScriptName(),FALSE);//shut off
        }
    }
}
