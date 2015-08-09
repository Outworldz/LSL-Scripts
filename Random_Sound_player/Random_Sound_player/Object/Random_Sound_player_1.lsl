// :CATEGORY:Sound
// :NAME:Random_Sound_player
// :AUTHOR:Jamethiel Wickentower
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:00
// :ID:682
// :NUM:925
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// 1. Put this script inside of the object you'd like to make a "random" greeter// 2. Put a notecard called "SAYINGS" inside the script//    * Each song should be on one line and <= 255 characters in length//    * Each song must be in inventory and have the same name as given in the notecard (or bad  things will happen)
// :CODE:
// Copyright (c) 2009, David Lloyd (Jamethiel Wickentower)
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this list
// of conditions and the following disclaimer. Redistributions in binary form must
// reproduce the above copyright notice, this list of conditions and the following
// disclaimer in the documentation and/or other materials provided with the
// distribution.
//
//
// Neither the name of the the author nor the names of any contributor may be
// used to endorse or promote products derived from this software without specific
// prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
// ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

// *********************************************************************************
// Instructions:
//
// 1. Put this script inside of the object you'd like to make a "random" greeter
// 2. Put a notecard called "SAYINGS" inside the script
//    * Each song should be on one line and <= 255 characters in length
//    * Each song must be in inventory and have the same name as given in the notecard (or bad
//      things will happen)
// 3. The script will initialise and then announce to its owner what command
//    channel it is listening on
// 4. Commands are listed below
//
//
// Commands:
//
// "RESET"
//
// This comman causes the script to reset.
//
// "REREAD"
//
// This command causes the list of songs to be read from the notecard again.
//
// "FIXED [number]"
//
// This command sets a fixed delay (i.e. the script will definitely delay this
// number of seconds). Note: you cannot set a fixed delay of less than 0.5
// seconds.
//
// "RANDOM [number]"
//
// This command sets a random delay; this is added to the fixed delay.
//
// "DELAYS"
//
// Reports what the current delays are.
//
// "ON" / "OFF"
//
// Turn the script on or off.
//
// "NOTECARD [name]"
//
// Sets the notecard to a notecard called "name". Make sure that notecard is in
// the object's inventory or the object might stop working.
//
// Known bugs:
//
// There are no known show stoppers. Do note that unless you stop and start the
// player manually, delay/random changes won't be picked up until the next timer()
// event.
//
// 1) User interface is a bit sparse - could do with a dialog
// 2) Notecard reading is quite slow - not much I can do about that though
//
// Feature Requests and Feedback:
//
// Please see my Google Code site:
//
// * http://code.google.com/p/linden-scripting-libraries/

key gOwner;
string gOwnerName;

integer CHANNEL = 0;
integer DEBUG = TRUE;

integer GOING = TRUE;

string gNotecard = "SOUNDS";
key gNotecardKey;

key gQueryID;
integer gLine = 0;

list gSongs;
float gVolume = 1.0;

float gFixedDelay = 5;
float gRandomDelay = 30;

// Trace
//
// If DEBUG is true, then trace it
trace(string msg) {
	if (DEBUG == TRUE) {
		llOwnerSay(msg);
	}
}

// Clean Message
//
// Makes the message lower case and strips leading and trailing white space.
string clean_message(string message) {
	return(llToUpper(llStringTrim(message, STRING_TRIM)));
}

// Discover Owner
//
// Gets detail about the item owner, such as KEY and NAME.
discover_owner() {
	gOwner = llGetOwner();
	gOwnerName = llKey2Name(gOwner);
	llOwnerSay("Rezzed for " + gOwnerName);
}

// Setup the Public Listener
//
// This sets up the public listener.
setup_public_listener()
{
	CHANNEL = llCeil(llFrand(99900)) + 100;
	llOwnerSay("Listening on channel " + (string)CHANNEL);
	llListen(CHANNEL, "", gOwner, "");
}

// Handle Public Message
//
// This handles public messages. This is a bit ham-fisted at the moment as it should
// start some type of IM with the avatar or open up a random chat channel. That will
// be implemented later.
handle_public_message(string message, string name, key id) {
	string theMessage = clean_message(message);

	if (id != gOwner) {
		return;
	}

	// Here we start parsing commands that may have more than one word
	list words = llParseString2List(theMessage, [" ", ","], []);
	integer len = llGetListLength(words);
	string command = clean_message(llList2String(words, 0));

	if (command == "RESET") {
		llResetScript();
		return;
	}

	if (command == "REREAD") {
		gSongs = [];
		gLine = 0;
		read_songs();
		return;
	}

	if (command == "SAYINGS") {
		string message = llDumpList2String(gSongs, "\n");
		llOwnerSay(message);
		return;
	}

	if (command == "FIXED") {
		llOwnerSay("FIXED");
		float fixed_delay = llList2Float(words, 1);
		if (fixed_delay < 0.5) {
			llOwnerSay("You cannot have a fixed delay of less than 1/2 a second!");
			fixed_delay = 0.5;
		}

		gFixedDelay = fixed_delay;
		trace("Fixed delay: " + (string)gFixedDelay);
		return;
	}

	if (command == "RANDOM")  {
		float random_delay = llList2Float(words, 1);
		if (random_delay == 0) {
			llOwnerSay("Possible incorrect value - double check.");
		}

		gRandomDelay = random_delay;
		trace("Random delay: " + (string)gRandomDelay);
		return;
	}

	if (command == "VOLUME") {
		float volume = llList2Float(words, 1);
		if (volume == 0) {
			llOwnerSay("Setting the volume to zero...");
		}

		gVolume = volume;
		trace("Volume: " + (string)gVolume);
		return;
	}

	if (command == "DELAYS") {
		llOwnerSay("Fixed delay: " + (string)gFixedDelay + "\nRandom delay: " + (string)gRandomDelay);
		return;
	}

	if (command == "TOGGLE") {
		if (GOING == TRUE) {
			GOING = FALSE;
			stop_player();
			llOwnerSay("Going is now false.");
		} else {
				GOING = TRUE;
			start_player();
			llOwnerSay("Going is now true.");
		}
		return;
	}

	if (command == "ON") {
		GOING = TRUE;
		start_player();
		return;
	}

	if (command == "OFF") {
		GOING = FALSE;
		stop_player();
		return;
	}

	if (command == "NOTECARD" && len > 1) {
		gNotecard = llList2String(words, 1);

		trace("Setting notecard to " + (string)gNotecard);

		stop_player();
		read_songs();
		return;
	}

	llOwnerSay("None implemented yet...");
}

// Stop Sayer
//
// Simply suspends the timer event.
stop_player() {
	GOING = FALSE;
	llSetTimerEvent(0);
}

// Start Sayer
//
// Starts up the timer event
start_player() {
	GOING = TRUE;
	float delay = gFixedDelay + llFrand(gRandomDelay);
	llSetTimerEvent(delay);
	trace("Initial timer event delay: " + (string)delay);
}

// Read Sayings
//
// Reads the songs from the first note card contained in the inventory.
read_songs() {
	gLine = 0;
	gSongs = [];

	if (gNotecard == "") {
		gNotecard = llGetInventoryName(INVENTORY_NOTECARD, 0);
	}

	gNotecardKey = llGetInventoryKey(gNotecard);

	if (gNotecardKey == NULL_KEY) {
		llOwnerSay("Can't find the notecard for " + gNotecard);
		return;
	}

	llOwnerSay("Reading notecard " + gNotecard);
	gQueryID = llGetNotecardLine((string)gNotecardKey, gLine);
}

// Handle Notecard Response
//
// Reads the list of songs from the notecard.
handle_notecard_response(string data) {
	if (data != EOF) {
		if (data != "") {
			gSongs += data;
		}
		gLine++;
		gQueryID = llGetNotecardLine((string)gNotecardKey, gLine);
		stop_player();
	} else {
			llOwnerSay("Initiated " + (string)llGetListLength(gSongs) + " songs.");
		start_player();
	}
}

default {
	state_entry() {
		discover_owner();
		setup_public_listener();
		read_songs();
	}

	listen(integer channel, string name, key id, string message) {
		if (channel == CHANNEL) {
			handle_public_message(message, name, id);
			return;
		}
	}

	dataserver(key query_id, string data) {
		if (gQueryID == query_id) {
			handle_notecard_response(data);
		}
	}

	touch_start(integer total_number) {
		if (llDetectedKey(0) == gOwner) {
			llOwnerSay("Listening on " + (string)CHANNEL);
		}
	}

	timer() {
		integer length = llGetListLength(gSongs);
		string current_song = llList2String(gSongs, llCeil(llFrand(length - 1)));
		llPlaySound(current_song, gVolume);

		llSetTimerEvent(0);
		float delay = gFixedDelay + llFrand(gRandomDelay);
		llSetTimerEvent(delay);
	}
}

