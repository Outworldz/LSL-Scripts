// :CATEGORY:Map
// :NAME:Map_on_a_Prim
// :AUTHOR:Honoured Resident
// :CREATED:2013-06-14 07:57:45.040
// :EDITED:2013-09-18 15:38:57
// :ID:506
// :NUM:677
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This script uses the "Media on a Prim" feature. The following requirements should be met:// // - Viewer 2 or higher (or similar third-party viewer like Firestorm)// - Auto-play enabled in Preferences, Sound & Media// // FEATURES
// 
// - Menu-controlled
// - Display any region map
// - Map updates every 12 hours
// - Zoom in or out
// - Map teleporter
// - Access control: owner, group, world
// 
// LIMITATIONS
// 
// - Media prims may cause performance problems if not used sparingly
// - Because of several unsupported hacks, the script cannot be guaranteed to work forever
// - If something does break, the script may temporarily or permanently disable the zoom feature
// - If the requested map tile does not exist on map.secondlife.com (but the region exists and is online),
//   the server will return a "NoSuchKey" error and display it on the prim. The map tile should be available
//   within 24-48 hours
// 
// PUTTING IT ALL TOGETHER
// 
// A media prim cannot be touched in the usual way, so a bit of trickery is needed to make it work.
// 
// 1. Create two plywood cubes (Shift+drag), link them and leave some space in between
// 2. Drop the script on the linked object and read the instructions
// 3. Resize and/or texture as needed
// 
// The end result should be like a painting covered by a sheet of glass. If you decide to add a frame, make
// sure the media prim is the last one you touch before linking. That way, it will always end up as the root.
// The map will always be displayed on face 1 of the root prim, no matter where the script is.
// :CODE:
// Map on a Prim
//
// Sim map displayed as "media on a prim"
//
// Author: Honoured Resident
// Date: 01-12-2012
//
// This work is licensed under the Creative Commons Attribution-NonCommercial 3.0 Unported License (CC BY-NC 3.0).
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc/3.0/.
//
// Author and license headers must be left intact.

string title = "Map on a Prim";  // title
string version = "1.0";          // version

// Timer constants
//
// Will be assigned to variable "time" and checked in timer event
// Important: this only works if all timer intervals are different!
//
// Always remember to destroy or reassign the timer when:
// - the timed event has occurred within the allotted time (success)
// - the timer has expired (failure)

float cDialogTime = 300.0;       // dialog timeout = 5 minutes
float cListenTime = 60.0;        // listener timeout = 1 minute
float cRequestTime = 10.0;       // dataserver timeout = 10 seconds
float cUpdateTime = 43200.0;     // map update = 12 hours

// Access constants

integer cOwner = 4;              // owner access bit
integer cGroup = 2;              // group access bit
integer cWorld = 1;              // world access bit

// Other constants

integer cDebug = FALSE;          // show/hide debug messages
integer cPrim = LINK_ROOT;       // prim for displaying media
integer cPrimFace = 1;           // prim face for media
string cProxy = "http://anonymouse.org/cgi-bin/anon-www.cgi/"; // anonymouse proxy
string cSLURL = "http://slurl.com/get-region-name-by-coords?var=region"; // slurl.com
string cURL = "http://map.secondlife.com/"; // amazon S3

// Variables

float time;              // timer interval for various timers (see timer constants above)
float vRequestTime;      // variable timeout for dataserver event, ranging from 10 to 20 sec.
integer advanced;        // disable or enable advanced features (TRUE or FALSE)
integer allow_touch;     // disable or enable touching (TRUE or FALSE)
integer dlgChannel;      // dialog channel
integer dlgHandle;       // handle for dialog channel
integer lsn;             // handle for listener
integer map_teleport;    // teleport on touch (TRUE or FALSE)
integer menu_access;     // access level for menu
integer seqnr;           // sequence number for unique URLs
integer zoom_level;      // zoom level (1-8)
integer zoom_level_old;  // previous zoom level
key owner;               // owner
key query_pos;           // dataserver query, retrieves sim position
key query_status;        // dataserver query, retrieves sim status
key request;             // handle for HTTP request
key user;                // key of user touching the prim
string full_URL;         // full URL including sim offset and zoom level
string sim_name;         // simulator name
string sim_name_old;     // previous simulator name
vector map_coord;        // global region coordinates returned by dataserver event
vector map_coord_old;    // previous region coordinates returned by dataserver event

// Functions

integer accessGranted(key user, integer access)
{
	integer bitmask = cWorld;
	if (user == owner) bitmask += cOwner;
	if (llSameGroup(user)) bitmask += cGroup;
	return (bitmask & access);
}

string capWords (string name)
{
	integer i;
	string word;
	string newname;
	list lst = llParseString2List(name, [" "], []);
	integer len = llGetListLength(lst);

	for (i = 0; i < len; i++) {
		word = llList2String(lst, i);
		newname += llToUpper(llGetSubString(word, 0, 0)) + llGetSubString(word, 1, -1) + " ";
	}

	return llStringTrim(newname, STRING_TRIM_TAIL);
}

float setTimer(float sec)
{
	llSetTimerEvent(0.0);
	llSetTimerEvent(sec);
	return sec;
}

key getSimulatorData(string name, integer data)
{
	allow_touch = FALSE;
	float pctlag = 100.0 * (1.0 - llGetRegionTimeDilation());     // try to work around time dilation
	vRequestTime = cRequestTime + cRequestTime / 100.0 * pctlag;  // (more lag = longer timeout)
	time = setTimer(vRequestTime);
	return llRequestSimulatorData(name, data);
}

setPrimImage(integer prim, integer face, string image)
{
	llSetLinkMedia(prim, face, [
		PRIM_MEDIA_CURRENT_URL, image,
		PRIM_MEDIA_AUTO_PLAY, TRUE,
		PRIM_MEDIA_AUTO_SCALE, FALSE,
		PRIM_MEDIA_WIDTH_PIXELS, 256,
		PRIM_MEDIA_HEIGHT_PIXELS, 256,
		PRIM_MEDIA_PERMS_CONTROL, PRIM_MEDIA_PERM_NONE,
		PRIM_MEDIA_PERMS_INTERACT, PRIM_MEDIA_PERM_NONE
	]);

	if (zoom_level == 1) llSetLinkPrimitiveParamsFast(prim, [PRIM_DESC, sim_name + " (touch for menu)"]);
	else llSetLinkPrimitiveParamsFast(prim, [PRIM_DESC, "Touch the map to select a region"]);

	allow_touch = TRUE;
}

setPrimText(integer prim, integer face, string text)
{
	llSetLinkMedia(prim, face, [
		PRIM_MEDIA_CURRENT_URL, "data:text/html," + text,
		PRIM_MEDIA_AUTO_PLAY, TRUE,
		PRIM_MEDIA_AUTO_SCALE, FALSE,
		PRIM_MEDIA_WIDTH_PIXELS, 256,
		PRIM_MEDIA_HEIGHT_PIXELS, 256,
		PRIM_MEDIA_PERMS_CONTROL, PRIM_MEDIA_PERM_NONE,
		PRIM_MEDIA_PERMS_INTERACT, PRIM_MEDIA_PERM_NONE
	]);
}

showMap(integer prim, integer face, vector sim_coord, integer z)
{
	integer x = (integer)(sim_coord.x / 256.0);
	integer y = (integer)(sim_coord.y / 256.0);
	x = x - (x % (integer)llPow(2.0, (float)z - 1.0));
	y = y - (y % (integer)llPow(2.0, (float)z - 1.0));
	map_coord_old = map_coord;    // global
	zoom_level_old = zoom_level;  // global
	map_coord = <(float)x * 256.0, (float)y * 256.0, 0.0>;  // global
	seqnr++;
	if (seqnr == DEBUG_CHANNEL) seqnr = 1;  // debug channel = max. int.
	full_URL = cURL + "map-" + (string)z + "-" + (string)x + "-" + (string)y + "-objects.jpg?" + (string)seqnr;

	if (z == 1) {
		string proxy_URL = cProxy + cSLURL + "&grid_x=" + (string)x + "&grid_y=" + (string)y;
		if (user) llInstantMessage(user, "Requesting map tile...");
		if (advanced) request = llHTTPRequest(proxy_URL, [], "");  // will reset timer (dataserver timeout)
		else query_status = getSimulatorData(sim_name, DATA_SIM_STATUS);  // request sim status
	}
	else {
		if (user) llInstantMessage(user, "Loading level " + (string)z + " map tile...");
		setPrimImage(prim, face, full_URL);  // will reset timer (map update)
	}
}

showZoom(vector sim_coord, integer z, vector touch_pos)
{
	float tiles = llPow(2.0, (float)z - 1.0);
	integer tile_x = llCeil(tiles * touch_pos.x);
	integer tile_y = llCeil(tiles * touch_pos.y);
	integer x = (integer)(sim_coord.x / 256.0);
	integer y = (integer)(sim_coord.y / 256.0);
	x = x + tile_x - 1;
	y = y + tile_y - 1;
	map_coord_old = map_coord;    // global
	zoom_level_old = zoom_level;  // global
	map_coord = <(float)x * 256.0, (float)y * 256.0, 0.0>;  // global
	zoom_level = 1;  // global
	seqnr++;
	if (seqnr == DEBUG_CHANNEL) seqnr = 1;  // debug channel = max. int.
	full_URL = cURL + "map-" + (string)z + "-" + (string)x + "-" + (string)y + "-objects.jpg?" + (string)seqnr;
	full_URL = cURL + "map-1-" + (string)x + "-" + (string)y + "-objects.jpg";
	string proxy_URL = cProxy + cSLURL + "&grid_x=" + (string)x + "&grid_y=" + (string)y;
	if (user) llInstantMessage(user, "Requesting map tile...");
	request = llHTTPRequest(proxy_URL, [], "");  // will reset timer (dataserver timeout)
}

teleport (integer prim, string region, vector pos)
{
	map_teleport = FALSE;
	vector dest = <pos.x * 255.0, pos.y * 255.0, 0.0>;
	llSetLinkPrimitiveParamsFast(prim, [PRIM_DESC, region + " (touch for menu)"]);
	llMapDestination(region, dest, dest);
	llMapDestination(region, dest, dest);
}

menuDialog(key id)
{
	string message;
	list menuButtons;

	if (advanced) {
		message = "\nYou can change the map,\nteleport to the region\nor zoom out to level 2-8";
		menuButtons = [ "6", "7", "8", "3", "4", "5", "Change map", "Teleport", "2" ];
	}
	else {
		message = "\n";
		menuButtons = [ "Change map", "Teleport", "Advanced"];
	}

	if (id == owner) menuButtons = llListInsertList(menuButtons, ["Owner", "Group", "World"], 0);

	dlgChannel = (integer)(llFrand(-1000000000.0) - 1000000000.0);
	llListenRemove(dlgHandle);
	dlgHandle = llListen(dlgChannel, "", id, "");
	time = setTimer(cDialogTime);
	llDialog(id, message, menuButtons, dlgChannel);
}

default
{
	state_entry()
	{
		if (llGetLinkNumber() == 0) {
			llOwnerSay("Not a linkset, removing script");
			llRemoveInventory(llGetScriptName());
			return;
		}
		if (llGetLinkNumber() == 1) {
			llOwnerSay("Root prim, removing script");
			llOwnerSay("Marking map location with media texture");
			llOwnerSay("1. Use EDIT LINKED to drop the script in any other prim (not the media prim)");
			llOwnerSay("2. Press Ctrl+Alt+T to see transparent prim");
			llOwnerSay("3. Rotate the media prim so the map faces the transparent prim");
			llOwnerSay("4. Make sure the transparent prim has the same rotation");
			llOwnerSay("5. Shape both prims into flat panels and place the transparent prim in front of the map");
			llSetColor(<1,1,1>, cPrimFace);
			llSetPrimitiveParams([PRIM_FULLBRIGHT, cPrimFace, TRUE]);
			llSetTexture(TEXTURE_MEDIA, cPrimFace);
			llRemoveInventory(llGetScriptName());
			return;
		}
		llSetAlpha(0.0, ALL_SIDES);
		llSetLinkColor(cPrim, <1,1,1>, cPrimFace);
		llSetLinkPrimitiveParamsFast(cPrim, [PRIM_FULLBRIGHT, cPrimFace, TRUE]);
		llSetLinkPrimitiveParamsFast(cPrim, [PRIM_DESC, "(No Description)"]);
		string html = "<body bgcolor=lightblue><center><p>&nbsp;</p><h2>Welcome to<br>Map-on-a-Prim!" +
			"<p>Loading region map...</p></h2></center></body>";
		setPrimText(cPrim, cPrimFace, html);
		advanced = TRUE;
		allow_touch = TRUE;
		menu_access = cWorld;
		zoom_level = 1;
		sim_name = llGetRegionName();
		owner = llGetOwner();
		user = owner;
		key creator = llGetInventoryCreator(llGetScriptName());
		if (owner != creator) llSay(0, llBase64ToString("RG93bmxvYWRlZCBmcm9tIHd3dy5mcmVlLWxzbC1zY3JpcHRzLmNvbQ=="));
		llInstantMessage(user, title + " " + version + " (" + (string)llGetFreeMemory() + " bytes free)");
		llInstantMessage(user, "Requesting simulator data...");
		query_pos = getSimulatorData(sim_name, DATA_SIM_POS);  // initial map display
	}

	on_rez(integer start_param)
	{
		llResetScript();
	}

	http_response(key request_id, integer status, list metadata, string body)
	{
		integer regIndex = llSubStringIndex(body, "var region = \"");
		integer errIndex = llSubStringIndex(body, "var region = {error: true};");
		string region;

		// expected body format: var region = "Simulator Name";
		// expected error format: var region = {error: true};

		if (regIndex > -1) {
			region = llGetSubString(body, regIndex + 12, -1);
			list lst = llParseString2List(region, ["\""], []);
			sim_name = llList2String(lst, 1);
			query_status = getSimulatorData(sim_name, DATA_SIM_STATUS);  // request sim status
		}
		else if (errIndex > -1) {
			map_coord = map_coord_old;
			zoom_level = zoom_level_old;
			if (user) llInstantMessage(user, "There is no region at this location");
		}
		else {
			advanced = FALSE;
			zoom_level = 1;
			if (user) llInstantMessage(user, "No response from server. Disabling advanced features...");
			if (cDebug) llOwnerSay(body);
			query_pos = getSimulatorData(sim_name, DATA_SIM_POS);
		}
	}

	timer()
	{
		if (time == cDialogTime) {  // dialog timeout
			if (cDebug) llOwnerSay("Dialog timeout");
			llListenRemove(dlgHandle);
			time = setTimer(cUpdateTime);
		}
		else if (time == cListenTime) {  // listener timeout
			if (user) llInstantMessage(user, "Timeout: no region name was entered in the last 60 seconds");
			llListenRemove(lsn);
			time = setTimer(cUpdateTime);
		}
		else if (time == vRequestTime) {  // dataserver timeout (variable!)
			if (user) llInstantMessage(user, "Region does not exist: " + sim_name);
			sim_name = sim_name_old;
			allow_touch = TRUE;
			time = setTimer(cUpdateTime);
		}
		else if (time == cUpdateTime) {  // map update
			if (cDebug) llOwnerSay("Map update");
			user = "";  // unattended
			showMap(cPrim, cPrimFace, map_coord, zoom_level);
		}
		else {
			if (cDebug) llOwnerSay("Timer out of range: " + (string)time);
			allow_touch = TRUE;
			time = setTimer(cUpdateTime);
		}
	}

	touch_start(integer total_number)
	{
		if (!allow_touch) return;

		user = llDetectedKey(0);
		vector touchedpos = llDetectedTouchST(0);

		if (zoom_level == 1) {
			if (map_teleport) {
				teleport(cPrim, sim_name, touchedpos);
			}
			else {
				if (accessGranted(user, menu_access)) menuDialog(user);
				else llInstantMessage(user, "Access denied");
			}
		}
		else {
			if (llDetectedTouchFace(0) == -1) {
				advanced = FALSE;
				zoom_level = 1;
				llInstantMessage(user, "Viewer does not support touched faces. Disabling advanced features...");
				query_pos = getSimulatorData(sim_name, DATA_SIM_POS);
			}
			else if (touchedpos == TOUCH_INVALID_TEXCOORD) {
				advanced = FALSE;
				zoom_level = 1;
				llInstantMessage(user, "Touch position could not be determined. Disabling advanced features...");
				query_pos = getSimulatorData(sim_name, DATA_SIM_POS);
			}
			else if (llDetectedTouchFace(0) != cPrimFace) {
				llInstantMessage(user, "The map is on the front");
			}
			else {
				showZoom(map_coord, zoom_level, touchedpos);
			}
		}
	}

	listen(integer channel, string name, key id, string msg)
	{
		time = setTimer(cUpdateTime);

		if (channel == dlgChannel) {
			llListenRemove(dlgHandle);
			if (msg == "Change map") {
				zoom_level = 1;
				llListenRemove(lsn);
				lsn = llListen(0, "", id, "");
				time = setTimer(cListenTime);
				llInstantMessage(id, "Type the name of a region within the next minute");
			}
			else if (msg == "Teleport") {
				map_teleport = TRUE;
				llSetLinkPrimitiveParamsFast(cPrim, [PRIM_DESC, "Touch for map teleport"]);
				llInstantMessage(id, "Touch the map to display the World Map, then click \"Teleport\"");
			}
			else if (msg == "Advanced") {
				advanced = TRUE;
				menuDialog(id);
			}
			else if (msg == "Owner") {
				menu_access = cOwner;
				llInstantMessage(id, "Menu access: Owner");
			}
			else if (msg == "Group") {
				if (cDebug) {
					menu_access = cGroup;
					llInstantMessage(id, "Menu access: Group");
				}
				else {
					menu_access = cGroup + cOwner;
					llInstantMessage(id, "Menu access: Group + Owner");
				}
			}
			else if (msg == "World") {
				menu_access = cWorld;
				llInstantMessage(id, "Menu access: World");
			}
			else if (llStringLength(msg) == 1) {
				zoom_level = (integer)msg;
				showMap(cPrim, cPrimFace, map_coord, zoom_level);
			}
		}
		else if (channel == PUBLIC_CHANNEL) {
			if (id != user) return;  // ignore other avatars
			llListenRemove(lsn);
			llInstantMessage(id, "Requesting simulator data...");
			sim_name = llStringTrim(msg, STRING_TRIM);
			if (!advanced) sim_name = capWords(sim_name);  // capitalize words (e.g. "da boom" = "Da Boom")
			query_pos = getSimulatorData(sim_name, DATA_SIM_POS);
		}
	}

	dataserver(key request, string data)
	{
		time = setTimer(cUpdateTime);

		if (request == query_pos) {
			sim_name_old = sim_name;
			map_coord = (vector)data;
			showMap(cPrim, cPrimFace, map_coord, zoom_level);
		}
		else if (request == query_status) {
			if (data == "up") {
				if (user) llInstantMessage(user, "Loading map of " + sim_name + "...");
				setPrimImage(cPrim, cPrimFace, full_URL);
			}
			else {
				allow_touch = TRUE;
				map_coord = map_coord_old;
				zoom_level = zoom_level_old;
				if (user) llInstantMessage(user, "Region " + data + ": " + sim_name);
			}
		}
	}
}
