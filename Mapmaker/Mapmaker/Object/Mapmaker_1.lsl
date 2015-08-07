// :CATEGORY:Map
// :NAME:Mapmaker
// :AUTHOR:Runay Roussel
// :CREATED:2010-11-03 14:41:30.913
// :EDITED:2013-09-18 15:38:57
// :ID:507
// :NUM:678
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// How to use:// // - create a cube (change texture if desired)// - drop the script in it// - resize as needed
// :CODE:
// Mapmaker
//
// History:
//
// - a PHP script was created by Lex Mars (founder of Subnova); it accesses the map tiles and returns a texture UUID
// - a small example script (including the URL) was published in the LSL Wiki Script Library
// - the script uses a HTTP request (I used that as a starting point) to retrieve the texture UUID of the map
//
// Added stuff:
//
// - error checking
// - 24 hour timer
// - change map on touch
// - set object name to "Map of ..." (hover mouse over map to see it)
//
// How to use:
//
// - create a cube (change texture if desired)
// - drop the script in it
// - resize as needed
//
// Author: Runay Roussel
// Released to the public domain on September 14th, 2009

float TIME = 86400.0;  // timer interval = 24 hours
integer lsn = 0;       // handle for listener
key request;           // handle for HTTP request
key user;              // key of user touching the prim
string sim;            // sim
string sim_old;        // previous sim
string URL = "http://www.subnova.com/secondlife/api/map.php";  // URL of PHP script
string full_URL;       // full URL including sim name

string capitalize (string text)
{
	return llToUpper(llGetSubString(text, 0, 0)) + llGetSubString(text, 1, -1);
}

getMap(string sim_name)
{
	full_URL = URL + "?sim=" + llEscapeURL(sim_name);
	request = llHTTPRequest(full_URL, [], "");
	llSetTimerEvent(0);
	llSetTimerEvent(TIME);
}

default
{
	state_entry()
	{
		llSetObjectDesc("Touch to change");
		llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);
		user = llGetOwner();
		sim = capitalize(llGetRegionName());  // default sim = current
		sim_old = sim;
		getMap(sim);  // initial map display
	}

	on_rez(integer start_param)
	{
		llResetScript();
	}

	http_response(key request_id, integer status, list metadata, string body)
	{
		if (status != 200) {
			sim = sim_old;
			if (status == 499) {
				if (user) llInstantMessage(user, "Sim not found.");
			}
			else {
				if (user) {
					llInstantMessage(user, "An unexpected error has occurred. Return code = HTTP " + (string)status);
					llLoadURL(user, "Full error message", full_URL);
				}
			}
		}
		else {
			if ((key)body) {
				llSetTexture(body, 1);
				llSetObjectName("Mapmaker");
				if (user) llInstantMessage(user, "Rendering map of " + sim + "...");
			}
			else if ((key)body == NULL_KEY) {
				sim = sim_old;
				if (user) llInstantMessage(user, "Sim exists but has not yet been mapped. Please try again later.");
			}
			else {
				sim = sim_old;
				if (user) {
					llInstantMessage(user, "An unexpected error has occurred. Return code = HTTP " + (string)status);
					llLoadURL(user, "Full error message", full_URL);
				}
			}
		}
		llSetObjectName("Map of " + sim);
	}

	timer()
	{
		if (lsn) {
			llListenRemove(lsn);
			lsn = 0;
			llSetTimerEvent(0);
			llSetTimerEvent(TIME);
			llInstantMessage(user, "Timeout.");
			llSetObjectName("Map of " + sim);
		}
		else {
			user = "";
			getMap(sim);
		}
	}

	touch_start(integer total_number)
	{
		user = llDetectedKey(0);
		llListenRemove(lsn);
		lsn = llListen(0, "", user, "");
		llSetTimerEvent(0);
		llSetTimerEvent(60);
		llSetObjectName("Mapmaker");
		llInstantMessage(user, "Please type the name of a sim within the next minute.");
	}

	listen(integer channel, string name, key id, string message)
	{
		llListenRemove(lsn);
		lsn = 0;
		sim_old = sim;
		sim = capitalize(message);
		getMap(sim);
	}
}
