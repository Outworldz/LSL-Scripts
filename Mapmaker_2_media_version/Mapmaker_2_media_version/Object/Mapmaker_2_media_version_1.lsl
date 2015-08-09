// :CATEGORY:Map
// :NAME:Mapmaker_2_media_version
// :AUTHOR:Runay Roussel
// :CREATED:2010-11-03 15:07:47.300
// :EDITED:2013-09-18 15:38:57
// :ID:508
// :NUM:679
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Make sure the media stream is active by either setting it to play automatically or by clicking the start button in your SL viewer.
// :CODE:
// Mapmaker 2
//
// Unlike Mapmaker 1, this version does not retrieve texture UUIDs from Subnova but jpeg images from Amazon S3
//
// Upside: these are the "official" SL map tiles
// Downside: jpeg images can only be displayed as media and can therefore only be used on owned/rented land
// Future: HTTP Texture?
//
// Author: Runay Roussel
// Released to the public domain on September 14th, 2009

float TIME = 43200.0;                        // timer interval = 12 hours
string URL = "http://map.secondlife.com/";   // Amazon S3
vector DA_BOOM = <256000.0, 256000.0, 0.0>;  // global region coordinates of Da Boom

integer dlgChannel;      // dialog channel
integer dlgHandle;       // handle for dialog channel
integer lsn;             // handle for listener
integer map_teleport;    // teleport on touch (TRUE or FALSE)
integer touchFace;       // map face has been touched
integer waiting;         // waiting for data
integer zoom_level = 1;  // zoom level (1-8)
integer zoom_level_old;  // previous zoom level
key media_texture;       // media texture
key owner;               // owner
key query;               // dataserver query
key request;             // handle for HTTP request
key user;                // key of user touching the prim
string full_URL;         // full URL including sim offset and zoom level
vector map_coord;        // global region coordinates returned by dataserver event
vector map_coord_old;    // previous region coordinates returned by dataserver event

showMap(vector sim_coord, integer z)
{
	integer x = (integer)(sim_coord.x / 256.0);
	integer y = (integer)(sim_coord.y / 256.0);
	x = x - (x % (integer)llPow(2.0, (float)z - 1.0));
	y = y - (y % (integer)llPow(2.0, (float)z - 1.0));
	map_coord_old = map_coord;    // global
	zoom_level_old = zoom_level;  // global
	map_coord = <(float)x * 256.0, (float)y * 256.0, 0.0>;  // global
	full_URL = URL + "map-" + (string)z + "-" + (string)x + "-" + (string)y + "-objects.jpg";
	if (user) {
		if (z == 1) llInstantMessage(user, "Requesting map...");
		else llInstantMessage(user, "Requesting level " + (string)z + " map...");
	}
	llSetTimerEvent(0);
	llSetTimerEvent(TIME);
	request = llHTTPRequest(full_URL, [], "");
}

showZoom(vector sim_coord, integer z, vector touch_pos)
{
	touchFace = TRUE;
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
	full_URL = URL + "map-1-" + (string)x + "-" + (string)y + "-objects.jpg";
	if (user) llInstantMessage(user, "Requesting map...");
	llSetTimerEvent(0);
	llSetTimerEvent(TIME);
	request = llHTTPRequest(full_URL, [], "");
}

teleport (vector sim_coord)
{
	map_teleport = FALSE;
	llSetObjectDesc("Touch for menu");
	vector dest = sim_coord - DA_BOOM + <128.0, 128.0, 0.0>;
	llMapDestination("Da Boom", dest, dest);
	llMapDestination("Da Boom", dest, dest);
}

menuDialog(key id)
{
	string message = "\nTo change the zoom level, click on a number";
	list menuButtons;
	if (zoom_level == 1) menuButtons =
		[ "On", "Off", "Reset", "6", "7", "8", "3", "4", "5", "Change map", "Teleport", "2" ];
	else menuButtons = [ "On", "Off", "Reset", "6", "7", "8", "3", "4", "5", "Change map", "1", "2" ];
	dlgChannel = (integer)(llFrand(-1000000000.0) - 1000000000.0);
	llListenRemove(dlgHandle);
	dlgHandle = llListen(dlgChannel, "", id, "");
	llSetTimerEvent(0);
	llSetTimerEvent(120);
	llDialog(id, message, menuButtons, dlgChannel);
}

default
{
	state_entry()
	{
		owner = llGetOwner();
		user = owner;
		llSetObjectDesc("Touch for menu");
		llSetPrimitiveParams([PRIM_FULLBRIGHT, ALL_SIDES, TRUE]);
		llInstantMessage(user, "Requesting data...");
		waiting = TRUE;
		llSetTimerEvent(0);
		llSetTimerEvent(10);
		query = llRequestSimulatorData(llGetRegionName(), DATA_SIM_POS);  // initial map display
	}

	on_rez(integer start_param)
	{
		llResetScript();
	}

	http_response(key request_id, integer status, list metadata, string body)
	{
		key media_texture_old = media_texture;
		list media_data = llParcelMediaQuery([PARCEL_MEDIA_COMMAND_TEXTURE]);
		media_texture = llList2Key(media_data, 0);

		if (media_data == []) {
			if (user) llInstantMessage(user, "No permission to set or query parcel media.");
			return;
		}

		if (status != 200 && status != 415 && status != 404) {
			map_coord = map_coord_old;
			zoom_level = zoom_level_old;
			if (user) {
				llInstantMessage(user,
					"An unexpected error has occurred. Return code = HTTP " + (string)status + ".");
				llLoadURL(user, "Full error message", full_URL);
			}
		}
		else if (status == 404) {
			map_coord = map_coord_old;
			zoom_level = zoom_level_old;
			if (user) {
				if (touchFace) llInstantMessage(user, "There is no sim at this location.");
				else llInstantMessage(user, "There is no map tile for this location.");
			}
		}
		else {
			if (media_texture == NULL_KEY) {
				media_texture = TEXTURE_MEDIA;
				llParcelMediaCommandList([PARCEL_MEDIA_COMMAND_TEXTURE, media_texture]);
				if (user) llInstantMessage(user,
					"Parcel has no media texture. Setting parcel media texture to \"Default Media Texture\"...");
			}
			if (media_texture != media_texture_old) {
				llSetTexture(media_texture, 1);
				if (user) llInstantMessage(user, "Applying media texture to prim...");
			}
			llParcelMediaCommandList([
				PARCEL_MEDIA_COMMAND_TYPE, "image/jpeg",
				PARCEL_MEDIA_COMMAND_AUTO_ALIGN, TRUE,
				PARCEL_MEDIA_COMMAND_URL, full_URL
			]);
			if (zoom_level == 1) llSetObjectDesc("Touch for menu");
			else llSetObjectDesc("Touch the map to select a region");
		}
		touchFace = FALSE;
	}

	timer()
	{
		if (dlgHandle) {  // dialog timeout
			llListenRemove(dlgHandle);
			dlgHandle = 0;
			llSetTimerEvent(0);
			llSetTimerEvent(TIME);
		}
		else if (lsn) {  // listener timeout
			llListenRemove(lsn);
			lsn = 0;
			llSetTimerEvent(0);
			llSetTimerEvent(TIME);
			llInstantMessage(user, "Timeout.");
		}
		else if (waiting) {  // dataserver timeout
			waiting = FALSE;
			llSetTimerEvent(0);
			llSetTimerEvent(TIME);
			llInstantMessage(user, "Sim not found.");
		}
		else {  // map update
			user = "";
			showMap(map_coord, zoom_level);
		}
	}

	touch_start(integer total_number)
	{
		vector touchedpos = llDetectedTouchST(0);
		user = llDetectedKey(0);

		if (zoom_level == 1) {
			if (map_teleport) teleport(map_coord);
			else menuDialog(user);
		}
		else {
			if (llDetectedTouchFace(0) == -1) {
				llInstantMessage(user, "Viewer does not support touched faces. Displaying menu...");
				menuDialog(user);
			}
			else if (llDetectedTouchFace(0) != 1) {
				llInstantMessage(user, "Wrong side. The map is on the front.");
			}
			else if (touchedpos == TOUCH_INVALID_TEXCOORD) {
				llInstantMessage(user, "Touch position could not be determined. Displaying menu...");
				menuDialog(user);
			}
			else {
				showZoom(map_coord, zoom_level, touchedpos);
			}
		}
	}

	listen(integer channel, string name, key id, string msg)
	{
		if (channel == dlgChannel) {
			llListenRemove(dlgHandle);
			dlgHandle = 0;
			if (msg == "Change map") {
				zoom_level = 1;
				llListenRemove(lsn);
				lsn = llListen(0, "", id, "");
				llSetTimerEvent(0);
				llSetTimerEvent(60);
				llInstantMessage(id, "Please type the name of a sim within the next minute.");
			}
			else if (msg == "Teleport") {
				map_teleport = TRUE;
				llSetObjectDesc("Touch for map teleport");
				llInstantMessage(id, "Touch the map to display the World Map, then click \"Teleport\"");
			}
			else if (msg == "On") {
				llParcelMediaCommandList([PARCEL_MEDIA_COMMAND_PLAY]);
			}
			else if (msg == "Off") {
				llParcelMediaCommandList([PARCEL_MEDIA_COMMAND_STOP]);
			}
			else if (msg == "Reset") {
				llResetScript();
			}
			else {
				zoom_level = (integer)msg;
				showMap(map_coord, zoom_level);
			}
		}
		else {
			llListenRemove(lsn);
			lsn = 0;
			waiting = TRUE;
			llInstantMessage(id, "Requesting data...");
			llSetTimerEvent(0);
			llSetTimerEvent(10);
			query = llRequestSimulatorData(msg, DATA_SIM_POS);
		}
	}

	dataserver(key requested, string data)
	{
		waiting = FALSE;
		map_coord = (vector)data;
		showMap(map_coord, zoom_level);
	}
}
