// :CATEGORY:Translator
// :NAME:Open_BabelFish_Translator
// :AUTHOR:falados
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:59
// :ID:587
// :NUM:805
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Open BabelFish
// :CODE:
//	This file is part of Open Babel Fish.
//
//	Open Babel Fish is free software: you can redistribute it and/or modify
//	it under the terms of the GNU General Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//
//	Open Babel Fish is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU General Public License for more details.
//
//	You should have received a copy of the GNU General Public License
//	along with Open Babel Fish.  If not, see <http://www.gnu.org/licenses/>
//
//	  Author: Falados Kapuskas
//	  Date: 7/20/2008
//	  Version: 1.4


//CONSTANT PARAMETERS

float AUTO_TRANSLATE_POLL_TIME = 40.0;	//Amount of time between auto-translation announcements
string NATIVE_LANGUAGE;
integer AUTO;
string MY_NAME = "Babel Fish";

integer LANGUAGE_ANNOUNCE = 234235;	//Please keep this standard amongs all revisions
//If you dont, then the auto-detect language wont work for you.

integer CONTROL_CHANNEL = 55;		//This is the channel on which you chat commands
//This can be changed to whatever

//Globals
key owner;
string PARTIAL;				//Partial name for 'tr' command
integer FIRST = TRUE;			//First run of the translator state
string USAGE;
integer master_listen;

//Listeners
list listeners = [];

//Function: translate
//Description: Sends a message out for translation.
translate(string data, string langpair, string name) {
	llMessageLinked(LINK_THIS,-10,data,langpair + "," + name);
}

//Function: add_listener
//Description: Adds a listener to the translate list by name.
add_listener( string name, string pair ) {
	if( pair == NATIVE_LANGUAGE + "|" + NATIVE_LANGUAGE ) {
		return;
	}
	integer i = llListFindList( listeners, [name,pair]);
	integer j = llListFindList( listeners, [name]);
	if( j == -1 ) {
		listeners += [name,pair];
		string text;
		//Tell the user a new listener was added
		if( name == llKey2Name(owner) ) {
			text = "Your language changed";
		} else {
				text = name + " added";
		}
		translate(
			text,
			"en|" + NATIVE_LANGUAGE,
			MY_NAME
				);
	} else if( i == -1) {
			listeners = llListReplaceList( listeners , [pair] , j+1 , j+1 );
	}
}

//Funciton: remove_name
//Description: Remove a listener from the list
remove_name( string name ){
	integer i = llListFindList( listeners , [name]);
	if( i != -1 ) {
		translate(
			name + " removed",
			"en|" + NATIVE_LANGUAGE,
			MY_NAME
				);
		listeners = llDeleteSubList( listeners, i,i+1);
	}
}

// ------ STATES ------- //

//Setup State
default
{
	on_rez(integer p) { if(llGetOwner() != owner) llResetScript(); }
	state_entry()
	{
		owner = llGetOwner();
		llMessageLinked(LINK_THIS,-3,"setup","root");
	}
	link_message(integer sender_number, integer number, string message, key id)
	{
		if( number == 0 && message == "init" && id == "dialog" ) {
			llSetTimerEvent(0.0);
			state setup;
		}
	}
	timer() {
		llMessageLinked(LINK_THIS,-3,"setup","root");
	}
}

//State: setup
//Description: Attempts to retrieve the native langauge of the current user
state setup {
	on_rez(integer p) {llResetScript();}
	state_entry() {
		llMessageLinked(LINK_THIS,0,"ask_lang",owner);
	}
	link_message(integer sender_number, integer number, string message, key id)
	{
		if( number == -1 && id == owner) {
			NATIVE_LANGUAGE = message;
			state translator;
		}
		if( number == -4 && message == "timeout" && id == owner ) {
			llMessageLinked(LINK_THIS,0,"ask_lang",owner);
		}
	}
}

//State: translator(_loop)
//Description: This is the main loop where all the magic happens.
//This state accepts user commands, adds listeners, and does the translations
//The main HTTP request line is in here.
//This state also does the setup to determining the user's native language
//The NATIVE_LANGUAGE variable is extremely important when it comes to most
//functions, especially automatic translation.
state translator_loop { state_entry() { state translator;}}
state translator {
	on_rez(integer p) { if(llGetOwner() != owner) llResetScript(); }
	state_entry() {
		//If this is the first run through, say the usage line
		if(FIRST) {
			string tr = "|";
			if(NATIVE_LANGUAGE == "en") tr = "";
			//TODO: This usage line should be updated when new functions come out
			USAGE += "\nType /" + (string)CONTROL_CHANNEL + " " + tr + "autotrans" + tr + " <name> to automatically translate someone.";
			USAGE += "\nType /" + (string)CONTROL_CHANNEL + " " + tr + "translate" + tr + " <name> to ask for translation.";
			USAGE += "\nType /" + (string)CONTROL_CHANNEL + " " + tr + "remove" + tr + " <name> to remove a translated person.";
			USAGE += "\nType /" + (string)CONTROL_CHANNEL + " " + tr + "remove all" + tr + " to remove all translated people.";
			USAGE += "\nType /" + (string)CONTROL_CHANNEL + " " + tr + "speak" + tr + " to speak another language through " + MY_NAME;
			USAGE += "\nType /" + (string)CONTROL_CHANNEL + " " + tr + "list" + tr + " to display the people who are now translated.";
			USAGE += "\nType /" + (string)CONTROL_CHANNEL + " " + tr + "help" + tr + " to display this message.";
			USAGE += "\nType /" + (string)CONTROL_CHANNEL + " " + tr + "reset" + tr + " to reset Open Babel Fish.";

			translate(
				USAGE,
				"en|" + NATIVE_LANGUAGE,
				MY_NAME
					);
			FIRST = FALSE;
		}

		//Listen for Auto-Language Detection
		llListen(LANGUAGE_ANNOUNCE,"",NULL_KEY,"");

		//Listen for Commands
		master_listen = llListen(CONTROL_CHANNEL,"",llGetOwner(),"");

		//Listen to all the people who need to be translated

		//Listen For All People
		if( llGetListLength(listeners) )
			llListen(0,"","","");

		//Set time between announcing your native language to others
		llSetTimerEvent(AUTO_TRANSLATE_POLL_TIME);
	}
	//Commands and auto-translate in here
	listen ( integer channel, string name, key id, string message )
	{
		message = llStringTrim( message, STRING_TRIM);

		//Chat commands
		if( channel == CONTROL_CHANNEL ) {
			llSetObjectName( MY_NAME );
			integer i = llSubStringIndex(message," ");
			string command = llGetSubString(message,0,i-1);
			string param = llGetSubString(message,i+1,-1);
			integer len = llStringLength( message );
			if( command == "autotrans") {
				PARTIAL = param;
				AUTO=TRUE;
				llSensor("",NULL_KEY,AGENT,30,TWO_PI);
			}
			if( command == "translate" ) {	//Ask for Translation
				AUTO = FALSE;
				PARTIAL = param;
				llSensor("",NULL_KEY,AGENT,30,TWO_PI);
			}
			if( command == "remove" ) {	//Remove Name
				if( param == "all" ) {
					listeners = [];
					translate(
						"All listeners removed",
						"en|" + NATIVE_LANGUAGE,
						MY_NAME
							);
					state translator_loop;
				} else {
						remove_name( param );
				}
				//Reset Listens
				state translator_loop;
			}
			if( message == "help" ) {
				translate(
					USAGE,
					"en|" + NATIVE_LANGUAGE,
					MY_NAME
						);
			}
			if( message == "list" ) {
				integer nl = llGetListLength(listeners)/2;
				integer j;
				for( j = 0; j < nl; ++j) {
					llOwnerSay(llList2String(listeners,j*2) + " : " + llList2String(listeners,j*2+1) );
				}
			}
			if( message == "speak" ) {
				llMessageLinked(LINK_THIS,0,"ask_lang",owner);
			}
			if( message == "reset") llResetScript();
		}
		//Listen for translations
		if( channel == 0 ) {
			integer i = llListFindList( listeners , [name] );
			if( i != -1) {
				//Langpair found, translate the message
				translate(
					message,
					llList2String( listeners , i+1),
					name
						);
			}
		}
		//Auto-translate messagse
		if( channel == LANGUAGE_ANNOUNCE ) {
			llMessageLinked(LINK_THIS,-2,message,id);
		}
	}


	//This event is mainly for partial-name matching
	//PARTIAL is set with the partial name.  if the partial name is found.
	//The user gets asked the "What language?" dialog.  Upon their response, they will
	//be added to the listeners list.
	sensor(integer tn) {
		integer i = 0;
		string announce;
		string p;
		string n;
		p = llToLower(PARTIAL);
		for( i = 0; i < tn; ++i) {
			n = llToLower(llDetectedName(i));
			if(llSubStringIndex(n,p) != -1) {	//Partial name locate inside fullname
				//Ask them for their language
				if( AUTO ) {
					add_listener( llDetectedName(i), "auto|" + NATIVE_LANGUAGE );
					announce = "Automatically Translating: " + llDetectedName(i);
					translate(
						announce,
						"en|" + NATIVE_LANGUAGE,
						MY_NAME
							);
				} else {
						announce = "Asking " + llDetectedName(i) + " for translation";
					translate(
						announce,
						"en|" + NATIVE_LANGUAGE,
						MY_NAME
							);
					llMessageLinked(LINK_THIS,0,"ask_lang",llDetectedKey(i));
				}
				return;
			}
		}
		//If for loop exits, must be nothing found
		announce = "None found";
		translate(
			announce,
			"en|" + NATIVE_LANGUAGE,
			MY_NAME
				);
	}
	no_sensor()
	{
		string announce = "None found";
		translate(
			announce,
			"en|" + NATIVE_LANGUAGE,
			MY_NAME
				);
	}
	timer()
	{
		llSetObjectName(llKey2Name(llGetOwner()));
		llSay(LANGUAGE_ANNOUNCE,NATIVE_LANGUAGE);
	}

	link_message(integer sender_number, integer number, string message, key id)
	{
		if( number == -1 ) {	//Is this a translation addition from the dialog?
			//from this: llMessageLinked(LINK_THIS,-1,llList2String(language_names,i),id);
			if( id == owner ) //Self Translate
				add_listener( llKey2Name(id), NATIVE_LANGUAGE + "|" + message );
			else	//Translate Other
				add_listener( llKey2Name(id), message + "|" + NATIVE_LANGUAGE);
			state translator_loop;
		}
		if( number == -4 && message == "timeout") {
			translate(
				"Language request timeout - " + llKey2Name(id),
				"en|" + NATIVE_LANGUAGE,
				MY_NAME
					);
		}
	}
}
