// :CATEGORY:Door
// :NAME:AirLock_Door_Script
// :AUTHOR:Mitzpatrick Fitzsimmons
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:22
// :NUM:32
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Air-Lock Door Script.lsl
// :CODE:

//__________________________________________________  ___________________

//Air-Lock Door Script by Mitzpatrick Fitzsimmons
//********************** DESCRIPTION *************************
// This door script differs from most, as it uses the
// llSetPrimativeParams function to simulate an open
// or closed door. It can be used with any Prim Type, 
// however, the script will need to be modified slightly.
// I find the best effect is with BOX or CYLINDER, as it
// reminds me of a Star-Trek type operation.
// The benefits with this type of door is that no rotation
// factors need to be calculated (as there is no real movement)
// but it might not be the best solution for a "HOUSE-TYPE" door.
// I use this on my space-ship, and it looks pretty cool IMHO.
// Note that the prim you use will need to be rotated 90 on the X
// or Y axis for a door that you would walk through, or if you plan
// to jump/fly through you can leave it as is.

// This script is set to the owners chat commands on channel 1
// but can easily be modified to a touch responce or other method.

// Feel free to modify this script as you see fit, and NO you
// dont need to give me any credit, OR leave this 'EXTRA-LONG'
// DESCRIPTION in it....heheh :)



//---------------------------------------------------------------------------------- GLOBAL VARIABLES

// I find it is easier to copy the UUID of your sounds and then set them as Globals rather than to have
// mulitple copies stuffed inside your prims... just a thought. You dont need to use sounds, but it's more fun.

 key DOOR_OPEN_SOUND="  ";        //Paste the UUID of your favorite door sound between the quotes
 key DOOR_CLOSE_SOUND="  ";        //Paste the UUID of your favorite door sound between the quotes

//---------------------------------------------------------------------------------- FUNCTIONS

OPEN_DOOR()  {  
    llPlaySound(DOOR_OPEN_SOUND, 1);    
    llWhisper(0, "Door open!");
    // Here is where the door open effect comes into play. the setting is 0.60 (just above half) play around with it to suit your needs.

    llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_CYLINDER, 0, <0.0, 1.0, 0.0>, 0.60, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>]);
}

CLOSE_DOOR()  {
    llPlaySound(DOOR_CLOSE_SOUND, 1);
    llWhisper(0, "Door closed!");
    llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_CYLINDER, 0, <0.0, 1.0, 0.0>, 0.0, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>]);
}

//---------------------------------------------------------------------------------- MEAT & POTATOES

default
{
    state_entry()  {
        llListen(1,"",llGetOwner(),"");     // Listens for the OWNER on channel 1
        llSay(0, "Activated");        // Just something I use to know the door is working. You can leave this out if you want.    
    }

    
    listen(integer channel, string name, key id, string message)  {
       
        if(id==llGetOwner())  {        // WE WILL ONLY LISTEN TO THE OWNER
            if( message    ==  "open door1" )      {    // I number doors so I can call on just one specific door at a time
            OPEN_DOOR();
            }
            
            if( message    == "open all" )      {    // For multiple doors to open simutaneously
            OPEN_DOOR();
            }
        
        if( message    == "close door1" )      {
            CLOSE_DOOR();
            }
            
            if( message    == "close all" )      {
            CLOSE_DOOR();
            }
            
        }else
        {
            llSay(0, "You are not the OWNER." );    // In case someone else trys to open your door
        }
    }
}// END //
