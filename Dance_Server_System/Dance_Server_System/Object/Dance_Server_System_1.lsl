// :CATEGORY:Dance
// :NAME:Dance_Server_System
// :AUTHOR:Holy Gavenkrantz
// :CREATED:2011-07-05 15:58:40.700
// :EDITED:2013-10-14 12:01:10
// :ID:212
// :NUM:286
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Dance Srver for multiple people and dnaces
// :CODE:
// I have had a lot of people asking about dance server scripts or needing help modifying scripts and they were always by or modeled after the SOLOP server script by Evil Fool. It worked well enough but seemed to be tough on SIM resources in my opinion so I made up my own based on the same idea. The problem I found was that all the scripts would fire their link_message event every time someone touched the dance prim and the more dancers there were the slower the response because each script passes the link_message on to the next script until the filter matched. This causes an onslaught of message_linked events because even though a script may not do anything with the message its event still must fire. Additionally, there were the scanners to detect if the avatar was still around. Add to that again any menus or other features people were requesting to be added to the scripts.// // In my example below all the dance scripts are set to NOT running. The only scripts running are the main server script and any dancer script associated with each avatar. There is only one 30 second timer running checking for the presence of each avatar via llGetAgentSize. The only other running timers only occur while someone has a menu open and those will stop if a selection is made or they time out. It works well for me but I haven't been able to stress test it because well, I don't have enough friends. (I've had 50 dance scripts and 250 dance animations in the server and it worked well but again I didn't have many dancers) Anyway, follow the instructions below and let me know what you think or if you see ways of improving it.// // To Start:// 
// 1. Create a folder in your inventory - call it Dance Server or what ever you want.
// 
// 2. Create a new script in this folder called "!Holy Server" ( the name isn't important but you will help my ego by leaving it this)
// 
// 3. Copy and paste the script from below of the same name into this new script. Save and close it.
// 
// 4. Create another script in this folder and call it "!Dancer" ( name not important again)
// 
// 5. Copy and paste the script from below of the same name into this new script. Save and close it.
// 
// 6. Create your prim that will hold all the animations and scripts.
// 
// 7. Drag a copy of the "!Holy Server" script into the prims inventory.
// 
// 8. Drag as many copies of the "!Dancer" script as you think you will need into the prims inventory. You will see the names of this script change automatically as a number is added to the script name. This is fine as well as required to identify each script later on.
// 
// 9. Drag all your dance animations into the Prim.
// 
// 10. If you have more than 200 animations plus dancer scripts then, while you have the edit box open, go to Tools at the top of your viewer and select Recompile Scripts in Selection > MONO. This is to prevent stack heap errors. Otherwise you should be able to recompile in LSL. If at all possible run the dance server in LSL mode - its just that much less memory used.
// 
// 11. Close the edit box and touch the prim and select "Reset" from the menu when it comes up.
// 
// 12. Dance!

//           !Holy Server
// mods by DonJr SpeigelBlatt and Fred Beckhusen (Ferd Frederix)
//Created Oct 2010 by Holy Gavenkrantz
//This work uses content from the Second Life® LSL Script library. 
//Copyright © 2007-2009 Linden Research, Inc. Licensed under the 
//Creative Commons Attribution-Share Alike 3.0 License
// Insert this script in your prim
// If you sell this I have hidden code in here that will delete your head

list    gAvKeyList; //store all the keys and associated dance script numbers here
list    gDanceList; //store all the dance animations in the prims inventory here
integer gActive = FALSE;    //part of the dance script reset function

updatetext()//this keeps the users updated as to dance server status
{
    llSetText(llGetObjectName() + "-" + (string)llGetListLength(gDanceList) + " Dances"
    + "\nClick to start dancing!\nCurrently Dancing: " + (string)(llGetListLength(gAvKeyList) / 2)
    + " of " + (string)(llGetInventoryNumber(INVENTORY_SCRIPT) - 1)
    + " possible slots.", <llFrand(1.0),llFrand(1.0),llFrand(1.0)>, 1);
}

reset_scripts()//this function resets all the individula dance scripts
{
    llSetText(llGetObjectName() +"\nResetting Dance Scripts...", <llFrand(1.0),llFrand(1.0),llFrand(1.0)>, 1);
    gActive = TRUE;
    integer num = llGetInventoryNumber(INVENTORY_SCRIPT);//get the number of scripts
    integer i;
    while ( i < num )
    {
        string script_name = llGetInventoryName(INVENTORY_SCRIPT, i);//store the script name temporarily
        if ( script_name != llGetScriptName() )//don't reset this script... just yet
        {
            llSetScriptState(script_name, TRUE);//turn on the dance script
            llResetOtherScript(script_name);//reset it so it loads the data it needs to store ( it will shut itself back off)
        }
        ++i;//get the next script
    }
    llSleep(1);     //this isn't required if you have 10 or more dance scripts
    updatetext();
}

default
{
    state_entry()
    {
        llSetText(llGetObjectName() +"\nLoading animations...", <llFrand(1.0),llFrand(1.0),llFrand(1.0)>, 1);
        integer num = llGetInventoryNumber(INVENTORY_ANIMATION);
        integer i;
        while ( i < num )//build the list of animations
        {
            gDanceList += llGetInventoryName(INVENTORY_ANIMATION, i);
            ++i;
        }
        updatetext();
        //llOwnerSay((string)llGetFreeMemory());
    }

    touch_start(integer total_number)
    {
        if ( ! gActive ) //if gActive is false then reset all the scripts
        {
            reset_scripts();
        }       
        integer i;
        for (i = 0; i < total_number; ++i)
        {
            key current_key = llDetectedKey(i);
            integer search = llListFindList(gAvKeyList,[current_key] ); // missing current_key
            if ( ~search ) //if the detected key is found they already have a dance script assigned
            {
                llMessageLinked(LINK_THIS, llList2Integer(gAvKeyList, search + 1),
                llDumpList2String(gDanceList, ","), current_key);                
            }
            else
            {
                gAvKeyList += current_key;//else add their key to the list
                if ( llGetListLength(gAvKeyList) / 2 > llGetInventoryNumber(INVENTORY_SCRIPT) - 1 )
                {//check to see if there are any positions left
                //- if not remove their key from the list and let them know they must wait
                    llInstantMessage(current_key, "Sorry but there are no dance positions left");
                    gAvKeyList = llDeleteSubList(gAvKeyList, -1, -1);
                }
                else//there is an opening - find a non running script to assign to them
                {
                    integer num = llGetInventoryNumber(INVENTORY_SCRIPT);
                    integer j;
                    while ( j < num )
                    {
                        string script_name = llGetInventoryName(INVENTORY_SCRIPT, j);
                        if ( llGetScriptState(script_name) )//if the script name = this script goto the next one
                        {
                            ++j;
                        }
                        else
                        {
                            j = num;//stop the loop
                            llSetScriptState(script_name, TRUE);//start the dance script
                            integer name_search = llSubStringIndex(script_name, " ");//parse the script number from its name
                            integer script_num = (integer)llGetSubString(script_name, name_search + 1, -1);
                            gAvKeyList += script_num;//add the number to the key list
                            //send a message to the appropriate script containg the list of animation and the users key
                            llMessageLinked(LINK_THIS, script_num, llDumpList2String(gDanceList, ","), current_key);
                        }
                    }                   
                }
            }                   
        }
    }
   
    link_message(integer sender_num, integer num, string msg, key id)
    {
        if ( num == -5555 )//only do stuff if a message was sent to this number
        {
            if ( msg == "cancel" )//if the message was cancel then delete the users key and script number from the key list
            {
                integer search = llListFindList(gAvKeyList, [id]);  // missing id
                if ( ~search )
                {
                    gAvKeyList = llDeleteSubList(gAvKeyList, search, search + 1);
                }
            }
            else if ( msg == "color" )//this means a dance was selected - start a timer ( explained in the timer function)
            {
                llSetTimerEvent(30);
            }
            else if ( msg == "reset" )//reset the system - only the owner as this capability
            {
                reset_scripts();
                llResetScript();
            }
            updatetext();
        }
    }
   
    timer()
    {
        if ( gAvKeyList )//as long as there is a key in the keylist keep checking that each user is still in the sim
        {
            integer len = llGetListLength(gAvKeyList);
            integer i;
            while ( i < len )
            {
                if ( llGetAgentSize(llList2Key(gAvKeyList, i)) )//if a valid size is returned then they are still here
                {
                    i += 2;//check the next key                   
                }
                else//nope, they're gone remove them from the list and check the next key
                {
                    llMessageLinked(LINK_THIS, llList2Integer(gAvKeyList, i + 1), "", "");
                    gAvKeyList = llDeleteSubList(gAvKeyList, i, i + 1);
                    len = llGetListLength(gAvKeyList);
                }
            }
            updatetext();
        }
        else
        {
            llSetTimerEvent(0);//the key list is empty - stop checking
        }
    }


    changed(integer change)
    {
        if ( change & CHANGED_REGION_START )
        {
            reset_scripts();
            llResetScript();
        }
    }


    on_rez(integer rez)
    {
        llResetScript();//gets the ball rolling
    }
}
