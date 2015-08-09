// :CATEGORY:Texture
// :NAME:Remote_Texture_Loader
// :AUTHOR:Bobbyb30 Swashbuckler
// :CREATED:2010-12-27 12:20:34.060
// :EDITED:2013-09-18 15:39:01
// :ID:691
// :NUM:943
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Main Display.lsl
// :CODE:
//***********************************************************************************************************
//                                                                                                          *
//                                                    --Main Display --                                     *
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
 
//Name: Main Display.lsl
//Purpose: This is the heart of the server. It tells remote loader when to load and changes the pictures on the server.
//Technical Overview:  Tell remote loader when to load using a timer. Also displays texture on server.
//Description: The main display serves as the core of the server telling remote loader when to load and changin the
//             texture on the server.
//Directions: Create a prim. Place the script in prim inventory. Modify the script parameters to suit your needs and
//            save. Copy the textures from here to the 'Remote Load Texture Display(input list).lsl' script.
 
//Compatible: Mono & LSL compatible
//Other items required: Requires the 'Remote Loader.lsl' & 'Remote Load Texture Display(input list).lsl' scripts.
//Notes: Uses a timer event. Should be low lag. Commented for easier following.
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
//Adjustable global variables...you may change these
//texture list...this list should have 2 or more textures
list textures = [//put your texture UUIDs/keys in here
    "f150313b-1f38-8978-b2ed-e0b2ffb62d5c",// black
    "16e92b19-7407-44c6-1f7a-03d75ef3e4a6",// unabletoconnect
    "1c482bda-802d-2991-5a03-4bb128792326"// white
        ];//end of list
 
//Please note there is a .2 second delay between prims.
integer side = ALL_SIDES;//which side to change , put #, or put ALL_SIDES for all sides,-1 equals all sides
float frequency = 100.0;//how often to change the texture in seconds. Shouldn't be below 20.0
//This script is meant for longer periods of time such as 1 or 2 minutes for savings to be viable
 
//please note that the last and first texture will be shown less frequently than those in between
integer random = TRUE;//whether to show the textures randomly, or in order
integer duplicatecheck = TRUE;//if random is true, this will check to make sure the random selection is a new texture
 
 
/////////////////////////////////////////////////////////////
//global variables...do not change
integer numberoftextures;//number of textures in inventory
integer currenttexture;//inventory number of current texture
 
changetexture()//user fucntion to change texture
{
    llSetScriptState("Remote Loader.lsl",TRUE);//turn on remote loader
    llMessageLinked(LINK_THIS,-1,(string)currenttexture,"");//tell remote loader which texture to load
    llSetTexture(llList2String(textures,currenttexture),side);//set texture using key
}
 
default
{
    on_rez(integer start_param)//on rez reset...probably not needed.
    {
        llResetScript();
    }
    state_entry()
    {
        llOwnerSay("Bobbyb's 'Main Display.lsl' (Public Domain 2009)");
        llOwnerSay("Because knowledge should be free.");
        numberoftextures = llGetListLength(textures);//speed hack here
        //assume correct
        llOwnerSay("There are " + (string)numberoftextures + " pictures which I will change every "
            + (string)frequency + " seconds on side: " + (string)side);
        llOwnerSay("My current free memory is : " + (string)llGetFreeMemory()
            + " bytes. If it is below 2500 bytes, I may not work properly.");
        llSetTimerEvent(frequency);
    }
    timer()
    {
        if(random)//show pics randomly
        {
            integer randomtexture;
            if(duplicatecheck)//whether to make sure random doesn't repeat itself
            {
                do
                {
                    randomtexture= llRound(llFrand(numberoftextures - 1));
                    //llOwnerSay("r" + (string)randomtexture);//debug
                }while(randomtexture == currenttexture);//make sure the random one isn't the same as the current one
            }
            else//no duplicate check
                randomtexture = llRound(llFrand(numberoftextures - 1));//generate random texture number
            currenttexture = randomtexture;//set the current one to the random one selected
            changetexture();//change the texture
            //llOwnerSay("c" + (string)currenttexture);//debug
        }
        else//not random, go in order
        {
            ++currenttexture;
            if(currenttexture == numberoftextures)//if current texture = number of textures, reset counter
                currenttexture = 0;
            changetexture();//change the texture
            //llOwnerSay("c" + (string)currenttexture);//debug
        }
    }
}
