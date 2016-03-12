// :CATEGORY:Dance
// :NAME:DanceServer
// :AUTHOR:Holy Gavenkrantz
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:51
// :ID:216
// :NUM:291
// :REV:1.0
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// Dance Server for a prim.  Insert as many copies of this script in your prim that you think you will need to match the number of dancers
// :CODE:



// mods by DonJr SpeigelBlatt and Ferd Frederix
//This work uses content from the Second LifeÂ® LSL Script library. Copyright  2007-2009 Linden Research, Inc. Licensed under the Creative Commons Attribution-Share Alike 3.0 License
/*      !Dancer

	Created Oct 2010 by Holy Gavenkrantz
		Insert as many copies of this script in your prim that you think you will need to match the number of dancers
			If you sell this I have hidden code in here that will delete your head*/

integer gDialogCH;  //channel the menu will use
integer gListener;  //open a listen so the script will hear menu choices
integer gIndex = 0; //used in the menu system to track NEXT and PREV functions
integer gScriptNum; //store the script number taken from the script name here
key     gAvKey;     //store the avatar key here
list    gDanceList; //store the list of dance animations here
string  gDance;     //store the current dance here
integer gCount_limit = 9  ; // number of menu items

menu( list button_list )//le menu
{
	integer items = llGetListLength(button_list);
	string dialog_text = "\nSelect a Dance";
	list button;
	integer count = 0;
	string check_item = "foo";
	while ( check_item != "" )//compile buttons and descriptions
	{
		check_item = llList2String(button_list, gIndex + count);
		if ( check_item != "" )
		{
			if ( count < gCount_limit )
			{
				++ count;
				string count_item = (string)( count + gIndex) + ".";
				dialog_text += "\n" + count_item + " " + check_item;
				button += (string)( count + gIndex); 			}
			else
			{
				check_item = "";
			}
		}
	}
	integer dumb_button;//fill in the spaces with "-"
	integer i;
	if ( count > 3 && count < 6 )
	{
		dumb_button = 6 - count;
	}
	if ( count > 6 && count < 9 )
	{
		dumb_button = 9 - count;
	}
	if ( count > 10 && count < 12 )
	{
		dumb_button = 12 - count;
	}
	for ( i = 0; i < dumb_button; ++ i )
	{
		button += "-";
	}
	button = llList2List(button, -3, -1) + llList2List(button, -6, -4)
		+ llList2List(button, -9, -7) + llList2List(button, -12, -10);//flip the list
	if ( gIndex + gCount_limit < items )//add the next, previous and cancel buttons
	{
		button = "Next >>" + button;
	}
	else if ( gIndex + gCount_limit >= items && items > gCount_limit )//wrap back to start of list
	{
		button = "Start >>" + button;
	}
	else
	{
		button = "-" + button;
	}
	button = "Stop" + button;
	if ( gAvKey == llGetOwner() )   button = "Reset" + button;
	if ( gIndex > 0 )
	{
		button = "<< Prev." + button;
	}
	else if ( gIndex == 0 && items > gCount_limit )//wrap to the end of list
	{
		button = "<< End" + button;
	}
	else
	{
		button = "-" + button;
	}
	llSetTimerEvent(60);
	llListenRemove(gListener);
	gListener = llListen(gDialogCH, "", gAvKey, "");
	llDialog(gAvKey, dialog_text, button, gDialogCH);//send the menu
}

default
{
	changed(integer change)
	{//this probably isn't required because the natural operation of the script resets it anyway
		if ( change & CHANGED_OWNER )
		{
			llResetScript();
		}
	}

	state_entry()
	{
		//create a negative integer using the scripts key
		//assign a script number using the number at teh end of the script name
		//shut the script off
		gDialogCH = (integer)("0x"+llGetSubString(llGetInventoryKey(llGetScriptName()),0,6)) * -1;
		integer name_search = llSubStringIndex(llGetScriptName(), " ");
		gScriptNum = (integer)llGetSubString(llGetScriptName(), name_search + 1, -1);
		llSetScriptState(llGetScriptName(), FALSE);
		llSleep(.5);
	}

	link_message(integer sender_num,integer num,string str,key id)
	{
		if ( num == gScriptNum )
		{
			if ( id )//if id is a valid key means the main server has passed someone touch request
			{
				gAvKey = id;
				gDanceList = llParseString2List(str, [","], []);//store the list of animations
				if ( gAvKey == llGetOwner() )
				    gCount_limit = 8;
				else
				    gCount_limit = 9;
				menu(gDanceList);
			}
			else
			{
				llResetScript();//any other message from the server requires a reset
			}
		}
	}

	listen(integer channel, string name, key id, string message)
	{
		if ( channel == gDialogCH )
		{
			llSetTimerEvent(0);
			llListenRemove(gListener);
			if ( message == "Cancel" || message == "-" )
			{
				if ( llGetPermissionsKey() )//if already dancing just close the menu
				{
					gIndex = 0;
				}
				else //avatar changed mind. clear the avatar key and reset script
				{
					llMessageLinked(LINK_THIS, -5555, "cancel", gAvKey);
					llResetScript();
				}
			}
			else if ( message == "<< Prev." )
			{
				gIndex -= gCount_limit;
				menu ( gDanceList );
			}
			else if ( message == "Next >>" )
			{
				gIndex += gCount_limit;
				menu ( gDanceList );
			}
			else if ( message == "Start >>" )
			{
				gIndex = 0;
				menu ( gDanceList );
			}
			else if ( message == "<< End" )//go to the last page
			{
				if ( llGetListLength(gDanceList) % gCount_limit )
				{
					gIndex = llGetListLength(gDanceList) - (llGetListLength(gDanceList) % gCount_limit);
				}
				else
				{
					gIndex = (llGetListLength(gDanceList) - (llGetListLength(gDanceList) % gCount_limit)) - gCount_limit;
				}
				menu ( gDanceList );
			}
			else if ( message == "Dance" )
			{
				menu ( gDanceList );
			}
			else if ( message == "Stop" )
			{
				llMessageLinked(LINK_THIS, -5555, "cancel", gAvKey);//clear avatar key
				if ( llGetPermissionsKey() )//only stop the dance if they are actually dancing
				{
					llStopAnimation(gDance);
					llInstantMessage(gAvKey, "Thanks for dancing " + llKey2Name(gAvKey) + ".");
				}
				llResetScript();
			}
			else if ( message == "Reset" )//reset everything
			{
				llMessageLinked(LINK_THIS, -5555, "reset", gAvKey);
				llResetScript();
			}
			else if ( (integer)message > 0 )//dance was selected
			{
				string old_dance = gDance; //store the current dance
				gDance = llList2String(gDanceList,(integer)message -1);//load the next dance
				if ( llGetPermissions() & PERMISSION_TRIGGER_ANIMATION )//if already dancing
				{
					llMessageLinked(LINK_THIS, -5555, "color", gAvKey);
					llStopAnimation(old_dance);
					llStartAnimation(gDance);
				}
				else //else get permission
				{
					llSetTimerEvent(30);//safety net in case they never accept or deny permissions
					llRequestPermissions(gAvKey, PERMISSION_TRIGGER_ANIMATION);
				}
			}
		}
	}

	run_time_permissions(integer perms)
	{
		if ( perms & PERMISSION_TRIGGER_ANIMATION )//have permission - start dancing
		{
			llSetTimerEvent(0);
			llMessageLinked(LINK_THIS, -5555, "color", gAvKey);
			llStartAnimation(gDance);
		}
		else //cancel everything
		{
			llMessageLinked(LINK_THIS, -5555, "cancel", gAvKey);
			llResetScript();
		}
	}

	timer()
	{// if we're here something went wrong
		llSetTimerEvent(0);
		llListenRemove(gListener);
		if( llGetAgentSize(gAvKey) )//still on the sim
		{
			if ( llGetPermissionsKey() == NULL_KEY )//they're just standing there - reset
			{
				llMessageLinked(LINK_THIS, -5555, "cancel", gAvKey);
				llInstantMessage(gAvKey, "The menu has timed out.");
				llResetScript();
			}
			else//they're dancing - just really slow decision makers
			{
				llInstantMessage(gAvKey, "The menu has timed out.");
			}
		}
		else//they're gone - just reset
		{
			llMessageLinked(LINK_THIS, -5555, "cancel", gAvKey);
			llResetScript();
		}
	}
}
// End Of code
