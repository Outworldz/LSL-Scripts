// :CATEGORY:Texture
// :NAME:Remote_Texture_Loader
// :AUTHOR:Bobbyb30 Swashbuckler
// :CREATED:2010-12-27 12:20:34.060
// :EDITED:2013-09-18 15:39:01
// :ID:691
// :NUM:941
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Remote Texture Loader Description// // These set of scripts allow for a prim to act as a server and load textures onto unlinked prims. The main benefit is that the recieving prims have *no* scripts. This means that the server, which consists of three scripts can load onto 30 prims without needing 20 scripts. Please note there is a 3 second delay for each remote load.// // It's main use would be for billboards, although it could substitute some texture changers.// 
// 
// They are hereby released into public domain.
// Disclaimer
// 
// These programs are distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
// Directions
// 
// Get the keys of the textures you want to use. Put them into both Remote Load Texture Display(input list).lsl and Main Display.lsl. Now decide on what number you want to use as your pin(you can leave the default of 606 if you choose). Set up the prims you want to use as billboards. Select which billboard you want to use as a server. Get the keys and set the pins for all the billboards except the server using Get key & set pin.lsl. Copy these keys into Remote Loader.lsl. Add Remote Loader.lsl to the server. Add Load Texture Display(input list).lsl to the server. Check Main Display.lsl parameters to make sure they are what you want and add that to the server. Enjoy=D.
// 
// Scripts
// 
// There are 3 scripts that go in the server:
// 
//     * Remote Loader.lsl which remotely loads the 'Remote Load Texture Display(input list).lsl' script.
//     * Remote Load Texture Display(input list).lsl which is remotely loaded and display the texture before deleting itself.
//     * Main Display.lsl which tells the remote loader when to load, and is the only active script most of the time. 
// 
// Two other scripts are:
// 
//     * Print inventory texture keys.lsl which prints the keys of inventory textures
//     * Get key & set pin.lsl which sets the remote load pin on prims and tells the owner the prim key. 
// :CODE:
//***********************************************************************************************************
//                                                                                                          *
//                                            --Remote Loader--                                             *
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
 
//Name: Remote Loader.lsl
//Purpose: To remotely load the 'Remote Load Texture Display(input list).lsl' script.
//Technical Overview: This script remotely loads Remote Load Texture Display(input list).lsl into the proper objects.
//Directions: Add object UUID's to targets list. Correct the pin to the one you set.
 
//Compatible: Mono & LSL compatible
//Other items required: Requires the 'Remote Load Texture Display(input list).lsl' & 'Main Display.lsl' scripts.
//Notes: Commented for easier following. This script will shut off after use. Do not rename script. There is a
//       3 second delay between remote loads.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
///////////////////////////////////////////
//user variables...you may change these...
integer pin = 606;//pin
 
//takes 3 seconds per each target
list targets =[//put object UUIDS here
    "ad367823-4e38-fcee-fdeb-f41fdb045149",
    "dac99b54-d23a-e890-2cb9-d57b1f80c6d6"
        ];
 
///////////////
//global variables...do not change
integer targetslistlength;//length of targets list
 
default
{
    state_entry()
    {
        llOwnerSay("'Remote Loader.lsl' (Public Domain 2009)");
        targetslistlength = llGetListLength(targets);//speed hack here
        llSetScriptState(llGetScriptName(),FALSE);//turn off until needed
    }
    link_message(integer sender, integer ch, string msg, key id)
    {
        if(ch == -1)//begin remote loading
        {
            //msg is texture number to load, its bumped up one so that 0 is 1...
            integer counter;
            do
            {
                integer param = ((integer)msg) + 1;
                llRemoteLoadScriptPin(llList2String(targets,counter),"Remote Load Texture Display(input list).lsl",pin, TRUE,param);
            }while(++counter < targetslistlength);
            llSetScriptState(llGetScriptName(),FALSE);//turn off until next time...
        }
    }
}
