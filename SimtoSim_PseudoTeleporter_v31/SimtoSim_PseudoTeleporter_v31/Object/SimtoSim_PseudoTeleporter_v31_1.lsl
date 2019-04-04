// :CATEGORY:Teleport
// :NAME:SimtoSim_PseudoTeleporter_v31
// :AUTHOR:Sheena Desade
// :CREATED:2012-04-28 22:10:33.173
// :EDITED:2013-09-18 15:39:02
// :ID:769
// :NUM:1056
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This is Sheena Desade's Sim-to-Sim Teleporter Script (v3.1). // // Features/Pros: // Smart Menu - seamlessly cycles, rearranges buttons in a logical order.// Dynamic List Parsing - never worry about breaking the script by adding or removing a location.Instant Teleportation (no confirmation required!) via chat link (visit http://wiki.secondlife.com/wiki/Viewer_URI_Name_Space for more nifty links you can add to your own products).
// Add as many locations as the script's memory can hold!
//
// Missing/Cons:
// Sanity checks! Format things correctly, or it will break.
// Private chat - this says everything on channel zero for everyone to hear (does not use llRegionSayTo).
// Annoying notecard configuration.
// The sim/place names/location vectors lists could have been combined into one to save a little more memory.
//
// ---------
// 'Data' notecard:
//
// Hover_Text = Multi-Region Pseudo Teleporter: Click for Destinations
// Menu_Text = Please select your destination:
// Menu_Channel = 4765
// Selection_Wait_Time = 30.0
// Niamhinations! | Windlesham @ 207/580/133
// ---------
//
// (template for the locations: Company Name | Region Name @ location x/location y/location z)
// :CODE:
/*
	This script was made April 10, 2012 by Sheena Desade. It is meant only to be redistributed freely (not ever to be sold)! Leave this header intact; other than those two requirements, do what you will with it. And if you make an improvement, feel free to send me a copy. :-)
		*/

			// ******** OPTIONAL SETTINGS **********
			string hoverText = "Sim-to-Sim Pseudo Teleporter - click for destinations.";
float menuWait = 30.0;          // How long to wait for the user to pick a menu choice
integer menuChannel = 0;        // what channel for the object to 'listen' on. You can change this channel as needed,
// it's not calling out to an object outside of itself.
string menuText = "Please select your destination:";
string itemDataNotecard = "Data";
// The name of the notecard to read from
// ******** END OF OPTIONAL SETTINGS **********

// ******** SYSTEM SETTINGS - DO NOT MODIFY **********

// General variables
integer menu_handler;        // what the function that brings up the menu is called
integer loc = -1;            // -1 = none chosen; 0 = first location, etc.
integer length;              // How long the placeNames list is, which we base everything else off of
integer curList = 1;         // The current list number we're on
key curUser = NULL_KEY;      // The current user's key

// The following are required to read the notecard properly
integer notecardLine;
key currentDataRequest;
key notecarduuid;

// These are the lists that hold all of our information
list simNames;               // The sim names of the places to teleport to
list placeNames;             // The region names of the places to teleport to
list locationVectors;        // The position to teleport to
// ******** END OF SYSTEM SETTINGS **********

init() // Setup the dataserver event for future use
{
	llOwnerSay("Reading item data...");
	notecardLine = 0; // we start reading the notecard at line 0, the first line
	currentDataRequest = llGetNotecardLine(itemDataNotecard, notecardLine); // specify our initial request
}

advancedMenu(key user, string text, integer channel)
{
	menu_handler = llListen(menuChannel,"","",""); // Lets the object 'hear' the option you choose
	if (length <= 12) llDialog(user,text,placeNames,channel); // Brings up a simple dialog if you have 12 or less options.

	else // If we have more than 12 options, create a multi-page dialog
	{
		list buttons; // Makes a list called 'buttons' that we will use later

		if (curList >= 1) // If we are not on page 0 (shouldn't be possible)
		{
			integer temp = (9*curList)-1; // Figures out which locations to display as buttons
			buttons = llList2List(placeNames, temp-8, temp); // the 'buttons' list now has nine locations
			// (List2List starts at 0, so we count 0 as 1)
			buttons = llListInsertList(buttons, ["<< Prev", "Cancel", "Next >>"], temp+1);
			// the 'buttons' list also now has three other options besides our nine locations
			// (ListInsertList does NOT start at 0. It starts at 1.)
		}

		buttons =
			llList2List(buttons, -3, -1)
				+ llList2List(buttons, -6, -4)
			+ llList2List(buttons, -9, -7)
			+ llList2List(buttons, -12, -10);  // Puts our buttons in the logical order, instead of the default reversed one

		llDialog(user,text,buttons,channel);  // Sends a dialog to the user with the new improved button list

	}
}

default
{
	on_rez(integer param)
	{
		llResetScript(); // Resets script on rez
	}

	state_entry()
	{
		llOwnerSay("Initializing...");
		notecarduuid = llGetInventoryKey(itemDataNotecard); // collects our notecarduuid as soon as we enter this state
		init(); // runs our init function to use with our dataserver function
	}

	dataserver(key query, string data)
	{
		if (query == currentDataRequest) // if we are trying to read the notecard
		{
			currentDataRequest = ""; // Prevent a bug that occurs with dataserver events.
			if (data != EOF) // If it isn't the end of the file

				// **** IMPORTANT: I did not put any sanity checks in here, so you'll need to type
				// it all correctly, in the format "Store Name | Sim Name @ x/y/z" or it will not
				// work correctly! ****

			{
				integer s = llSubStringIndex(data, "@"); // We're looking for the @ symbol in our NC line
				if(~s) // If we find it
				{
					string data1 = llStringTrim(llDeleteSubString(data, s, -1), STRING_TRIM);
					// this line cuts out and saves everything before the @ symbol to use for the next index
					string data4 = llStringTrim(llDeleteSubString(data, 0, s), STRING_TRIM);
					// this line erases the @ symbol and temporarily saves the location into a seperate string

					integer sy = llSubStringIndex(data1, "|"); // Now we're looking for the pipe symbol in only the
					// 'data1' variable defined when we were parsing for the @ symbol
					if(~sy) // If we find it (which we should, but we will check later to make sure our lists are
						// the same length, anyway)
					{
						string data2 = llDumpList2String(llParseString2List(llStringTrim(llDeleteSubString(data1, 0, sy), STRING_TRIM), [" "], [""]), "%20");
						// Saves the first part in a temp string, erasing all spaces and replacing them with %20... there might be a better way to do this
						string data3 = llStringTrim(llDeleteSubString(data1, sy, -1), STRING_TRIM);
						// Saves the second part in a temp string

						simNames += [data2];
						// copies the temporary string data2 into our simNames list. Could probably combine the two
						// commands as with locationVectors.
						placeNames += [data3];
						// copies the temporary string data3 into our placeNames list. Could probably combine the
						// two commands, as with locationVectors and simNames.
						locationVectors += [data4];
						// this line copies the temporary string into our locationVectors list. We put it here so that it
						// will not add the locationVector unless there are also sim and placeNames.
					}
				}

				else
				{
					integer sx = llSubStringIndex(data, "="); // Now we are looking for the = symbol
					if(~sx) // if we find it
					{
						string token = llToLower(llStringTrim(llDeleteSubString(data, s, -1), STRING_TRIM));
						// use our tokens to determine which variable we are defining
						data = llStringTrim(llDeleteSubString(data, 0, sx), STRING_TRIM);
						// use our data to define our chosen variable

						if (token == "hover_text")
							hoverText = data;
						else if (token == "menu_text")
							menuText = data;
						else if (token == "menu_channel")
							menuChannel = (integer)data;
						else if (token == "selection_wait_time")
							menuWait = (float)data;
					}
				}

				notecardLine++;
				// Get the next line
				currentDataRequest = llGetNotecardLine(itemDataNotecard, notecardLine);
			}

			else // If it is the End of File
			{
				length = llGetListLength(placeNames); // Defines how many entries we have in the placeNames list
				llOwnerSay ("Done reading data.");
				state configured;
			}
		}
	}
}

state configured
{
	state_entry()
	{
		if (hoverText != "none") llSetText(hoverText, <1.0,1.0,1.0>, 1); // if you want hovertext
		if (hoverText == "none") llSetText("---", <1.0, 1.0, 1.0>, 0); // if you do not want hovertext
		llWhisper(0, "Ready and waiting.");
		loc = -1; // Resets the location to none
	}

	changed(integer change)
	{
		// We want to reload channel notecard if it changed
		if (change & CHANGED_INVENTORY)
		{
			if(notecarduuid != llGetInventoryKey(itemDataNotecard)) // If the change was triggered by saving the NC
			{
				llOwnerSay("Notecard change detected, resetting script.");
				llResetScript(); // resets the script
			}
		}
	}

	timer()
	{
		llListenRemove(menu_handler); // remove the listen event
		llInstantMessage(curUser, "Menu session timed out; choices automatically reset.");
		llSetTimerEvent(0.0); // removes the timer event, as it's not needed at the moment
		curList = 1; // reset our page to page one
		loc = -1; // set our location to none
		curUser = NULL_KEY; // resets the user to none
	}

	touch_start(integer total_number)
	{
		if(curUser == NULL_KEY || curUser == llDetectedKey(0)) // if there is no user or the toucher is the
			// current user
		{
			curUser = llDetectedKey(0); // records the key of the curent user
			advancedMenu(curUser, menuText, menuChannel); // Sends the user our dialog box
			llSetTimerEvent(menuWait); // Sets our timer event so the menu will time out
		}

		if(curUser != NULL_KEY && curUser != llDetectedKey(0)) // If the toucher is not the current user
			llInstantMessage(llDetectedKey(0), "Sorry, this terminal is in use. Please wait your turn.");
	}

	listen(integer channel,string name,key id,string message)
		//this is for the script to follow instructions based on what happens with the menu.
	{
		if(message == "<< Prev")
		{
			if(curList <= 1) // If we're on the first page
			{
				curList = llCeil((float)length/9); // the current page needs to be changed to the last page, since
				// we're cycling backwards. We do this by rounding up (to cover any remainders) the length variable
				// (how many options we have total) divided by nine (since that's the number of buttons we need). 4.000
				// will always round up to 4 (I think?).
				advancedMenu(curUser, menuText, menuChannel); // Give them our menu dialog
				llSetTimerEvent(menuWait); // how long until the menu times out?
			}

			else // If we're not on page one
			{
				curList--; // Go backwards a page
				advancedMenu(curUser, menuText, menuChannel); // Give them our menu dialog
				llSetTimerEvent(menuWait); // how long until the menu times out?
			}
		}

		else if(message == "Next >>")
		{
			if(curList*9 >= length) // if we have cycled through all options in our list
			{
				curList = 1; // go to page one
				advancedMenu(curUser, menuText, menuChannel); // Give the user our dialog menu
				llSetTimerEvent(menuWait); // how long until the menu times out?
			}

			else
			{
				curList++; // go to the next page
				advancedMenu(curUser, menuText, menuChannel);  // Give the user our dialog menu
				llSetTimerEvent(menuWait); // how long until the menu times out?
			}
		}

		else if(message == "Cancel")
		{
			llInstantMessage(curUser, "Teleport cancelled.");
			curUser = NULL_KEY; // Erase the current user
			curList = 1; // Put our page back on the first page
			llListenRemove(menu_handler); // remove our listen event
			llSetTimerEvent(0.0); //removes the timer event, as it's not needed at the moment
		}

		else
		{

			loc = llListFindList(placeNames, (list)message); // determine which location we are teleporting to

			if(loc >= 0) // if it's an actual location
			{
				if (hoverText != "none") llSetText("Click the link to teleport", <1.0,1.0,1.0>, 1);
				// if you want hovertext
				llInstantMessage(curUser, "Click this link to teleport to your target location - " + "secondlife:///app/teleport/" + llList2String(simNames, loc) + "/" + llList2String(locationVectors, loc)); // Give them the link to click
				llSetTimerEvent(0.0); // removes the timer event, as it's not needed at the moment
				llSleep(2.5);
				curUser = NULL_KEY; // resets our user so others can use the teleporter
				loc = -1; // reset our location to none
				curList = 1; // reset our page to one
				if (hoverText != "none") llSetText(hoverText, <1.0,1.0,1.0>, 1);
			}
		}
	}
}
