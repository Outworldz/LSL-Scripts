// Changed to OpenSim by Rebekka Revnik
// in the OpenSim.ini you have to uncomment the following line under [Network]:
// user_agent = "OpenSim LSL (Mozilla Compatible)"
// and restart your sim

// Script:  Shoutcast - radio controller
// Version: 0.3 - released 10-2-2011
// Logic Scripts (Flennan Roffo)
// (c) 2010 - Flennan Roffo (Logic Scripts)
//
// This script is a remake of a couple of similar script:
// + LandOwnersRadio V2.0 by Scripter Coba  (( menu driven / notecard config script to select the radio station and sets parcel music url ))
// + Raven radio infoboard by Jamie Otis    (( worked at the basis of sis service [sis.slserver.com/sis.php] used Xy text display         ))
// + currentPlaying by Darkie Minotaur      (( used the /7.html info to fetch current song title info, displayed as float text            ))
//
// Purpose:
// * Sets the parcel audio URL and displays the channel info
// * Uses Xytext to display the info.
// * Fetches song title info from the shoutcast url
///////////////////////////////////////////////////////////////////////////////////////
// Extra Features -- 0.1 release
// * On/Off option
// * Allows multiple menus (if options per menu > 12) using a prev/next button
// * Checks if your url is well-formatted
// * Will delete genres for which no stations exist
// * Will skip stations that have same url and same genre (you can however have an identical station url under different genres).
// * New notecard format
//////////////////////////////////////////////////////////////////////////////////////////
// Extra Features -- 0.2 release
// * Configurable button text
// * Gets parcel URL and automatically sets the genre/station and on/off status accordingly (<-- doesn't work)
//////////////////////////////////////////////////////////////////////////////////////////
// Update -- 0.3 release
// * Fixed bug (only first station in genre displayed in menu)
// * Auto reset script when config card updated
// Notes:
// * Expects url to be in the format: <ip>:<port>, where <ip> has the format: xxx.xxx.xxx.xxx  (0 <= xxx <= 255)
// * Deletes entries in category (genre) for which no stations are configured with notice.
// * Skips stations which have identical url AND same category (genre).
//////////////////////////////////////////////////////////////////////////////////////////
// Upcoming release -- 0.4
// * Will add functions for remote controller(s) and remote display(s) using llRegionSay to communicate over a channel.
// * Should relax on the constraints about the input format of URL's (currently requires that URL has format: xxx.xxx.xxx.xxx/yyyy).
// * Fix button placement. Control buttons should be on the first line.
// * Implement script reset on change of owner.
// * Permit station to be put under multiple genres, using a comma-seperated list of genres in the section [STATION]
//   (currently this is only possible by duplicating the entire line and change the genre.)
/////////////////////////////////////////////////////////////////////////////////////////
// Future plans:
// * Individual user preferences that can be stored on seperate note cards. A user has access to his own list of genres and stations and the system available genres/stations.
// * Feature for accessing online playlists (M3U, PLS, other formats) to play a list of songs provided by that playlist.
// * User provided url.
/////////////////////////////////////////////////////////////////////////////////////////
// BUGS & FEATURE REQUESTS
//
// Please inform the author, Logic Scripts (flennan.roffo) about any bugs or annoyances.
// Feature requests can also be submitted to the author.
/////////////////////////////////////////////////////////////////////////////////////////
// LICENCE INFO
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
///////////////////////////////////////////////////////////////////////////////////////////

string info_notecard="Radio Control info";              ///////    EDITABLE  \\\\\\
string config_notecard="Radio Control config";          ///////    EDITABLE  \\\\\\
string comment_char="#";                                ///////    EDITABLE  \\\\\\
list sep_char_list= ["|"];                              ///////    EDITABLE  \\\\\\
float update_time=5.0;                                  ///////    EDITABLE  \\\\\\
string no_title_info="(no title info available)";       ///////    EDITABLE  \\\\\\

// not used currently - for showing info on current song title elsewhere in the region
integer broadcast_channel=-1234;                        ///////    EDITABLE  \\\\\\

// Buttons

string button_MAIN = "MAIN";                            ///////    EDITABLE  \\\\\\
string button_HELP = "HELP";                            ///////    EDITABLE  \\\\\\
string button_NEXT = ">>";                              ///////    EDITABLE  \\\\\\
string button_PREV = "<<";                              ///////    EDITABLE  \\\\\\
string button_ON   = "ON";                              ///////    EDITABLE  \\\\\\
string button_OFF  = "OFF";                             ///////    EDITABLE  \\\\\\
string button_login  = "Login as DJ";                             ///////    EDITABLE  \\\\\\

//////////////////////////////////
// Don't touch the variables below
/////////////////////////////////

// List of categories (=genres)

list category_list=[];

// List of stations. KEEP THESE LISTS IN SYNCH!

list station_category=[];
list station_name=[];
list station_desc=[];
list station_url=[];

// Last song title played
string last_title_info="";

integer radio_status=0;    // 0 - OFF   1 - ON
string parcel_url="";
integer lineno=0;
key reqid=NULL_KEY;
key httpreq_id=NULL_KEY;
integer config_error=FALSE;
integer flag;
integer section=0;

// Access values. Note that users who are banned can not access the device even when access is public
integer owner_access=TRUE;
integer group_access=TRUE;
integer public_access=FALSE;
list banned_keys=[];

// Channels for menu and user input
integer menu_channel;
integer listen_handle;

// Menu
integer menu_type=0;         // 0 - Main menu (genres)   1 - Station menu (stations)
integer menu_num=0;          // When more menu options need to be selectable then can be displayed on a menu (12), this is the menu number - menu number 0 is the first menu.

// Genres and stations

integer category_index=0;    // Current index in category_list  (genre)
integer station_index=0;     // Current index in station_*      (station)

integer num_categories=0;
integer num_stations=0;
key User;
string ncname;
key ncid;
integer ncline;
string stream;
key texture;
integer picno = 28;    // Link number for picture
key radiopic = "c9e427ae-cd25-4548-86b9-c3fd6bf1aaca";    // UUID for club picture

// Make request for title info using HTTP request
retrieve_titelinfo()
{
	string url=llList2String(station_url,station_index);
	if(User != NULL_KEY) url = stream;
	httpreq_id=llHTTPRequest(url + "/7.html",[],"");
}

// Display a line on an Xytext device linked in
display_line(string line, string message)
{
	// Setup XYtext Variables
	integer DISPLAY_STRING      = 204000;
	//    integer DISPLAY_EXTENDED    = 204001;     (not used)
	//    integer REMAP_INDICES       = 204002;     (not used)
	//    integer RESET_INDICES       = 204003;     (not used)
	//    integer SET_CELL_INFO       = 204004;     (not used)
	//    integer SET_FONT_TEXTURE    = 204005;     (not used)
	//    integer SET_THICKNESS       = 204006;     (not used)
	//    integer SET_COLOR           = 204007;     (not used)

	llMessageLinked(LINK_SET,DISPLAY_STRING,message,line);
}

// Clear the Xytext display
clear_display()
{
	// Clears the display
	display_line("1","Radio Station ID");
	display_line("2","Music Genre....");
	display_line("3","Now Playing....");
}

// Make a menu / dialog
make_menu(key id)
{
	menu_channel=random_channel();

	if (radio_status == 0)
	{
		menu_type=0;
		menu_num=0;

		llDialog(id,"Menu: Status\n\nRadio is OFF", [ "ON", "HELP" ],menu_channel);
	}
	else
	{
		if (menu_type ==0)
		{
			llDialog(id,"Menu: Genres", category_menu(menu_num),menu_channel);
		}
		else
		{
			llDialog(id,"Menu: Stations\nGenre: " + llList2String(category_list,category_index), station_menu(menu_num),menu_channel);
		}
	}

	if (listen_handle != 0)    llListenRemove(listen_handle);
	listen_handle=llListen(menu_channel,"",id,"");
}

// Make the menu option list for menu: catagories (genres)
list category_menu(integer num)
{
	integer len=llGetListLength(category_list);
	list menu=[];

	if (len > 9)   // If more then 9 items (12 minus the 3 buttons for MAIN/HELP and PREV, NEXT)
	{
		integer last_sub=(len-1)/9;   // submenus start at 0. 9th entry is in submenu 0, 10th in 1, etc.

		if (num > last_sub)
		{
			llWhisper(0,"error: wrong submenu number: " + (string) num + ".");
			return [ "MAIN" ];
		}
		else
		{
			integer first=9*num;

			while (--len >= first)
				menu+=(list)llList2String(category_list,len);

			if (num == 0)
				menu+=(list)button_login;
			else
				menu+=(list)button_MAIN;

			if (num == 0)
				menu+=(list)button_OFF;
			else
				menu+=(list)button_PREV;

			if (num != last_sub)
				menu+=(list)button_NEXT;
		}
	}
	else
	{
		while (--len >= 0)
			menu+=(list)llList2String(category_list,len);

		menu+=(list)button_OFF;
		menu+=(list)button_login;
	}

	return menu;    // order_buttons(menu);
}

// Returns the number of stations in a certain category
integer stations_in_category(integer cat)
{
	integer count=0;
	integer i;
	integer len=llGetListLength(station_category);
	string category=llList2String(category_list,cat);

	for (i=0; i < len; i++)
		if (category == llList2String(category_list,i))
			count++;

	return count;
}

// Not used currently -- to fix button placement
//list order_buttons(list buttons)
//{
//    integer offset;
//    list fixt;
//    integer flag=0;
//
//    while((offset = llGetListLength(buttons)))
//   {
//       if (offset > 3)
//           flag=1;
//        else
//            flag=0;
//
//       fixt = llList2List(buttons, offset = -3 * flag, -1);
//        buttons = llDeleteSubList(buttons, offset, -1);
//   }

//  return fixt;
//}

// Returns a list of station names in a certain category (genre)
list station_list(integer category)
{
	list s=[];
	integer i;
	string cname=llList2String(category_list,category_index);

	for (i = 0; i < llGetListLength(station_name); i++)
		if (llList2String(station_category,i) == cname)
			s+=(list)llList2String(station_name,i);

	return s;

}

// Returns the list of stations for the station menu, depending on the submenu number
list station_menu(integer num)
{
	list stations=station_list(category_index);
	integer len=llGetListLength(stations);
	list menu=[];

	if (len > 11)       // 12 - 1 for MAIN menu
	{
		integer last_sub=(len-1)/9;

		if (num >= last_sub)
		{
			llWhisper(0,"error: wrong submenu number: " + (string) num + ".");
			return [ "MAIN" ];
		}
		else
		{
			integer first=9*num;
			integer last=9*num+8;

			menu+=(list)button_MAIN;

			if (num > 0)
				menu+=(list)button_PREV;

			if (num < last_sub)
				menu+=(list)button_NEXT;

			if (len > last)
				len =last;

			while (--len >= first)
				menu+=(list)llList2String(stations,len);
		}
	}
	else
	{
		menu+=(list)button_MAIN;

		while (--len >= 0)
			menu+=(list)llList2String(stations,len);
	}

	return menu; // order_buttons(menu);
}

// Returns whether av with key id has access
integer has_access(key id)
{
	if (llListFindList(banned_keys,(list)id) != -1)
		return FALSE;

	if (owner_access && id == llGetOwner())
		return TRUE;

	if (group_access && llSameGroup(id))
		return TRUE;

	if (public_access)
		return TRUE;

	return FALSE;
}

// Gets a random channel -- uses a wide range of big negative channel numbers seldomly used
integer random_channel()
{
	integer min=-2147483647;
	integer max=-1000;

	return (integer) (min + llFrand(max-min));
}

// Check for the format of the url string  -- is very selective about url format
// expects:   xxx.xxx.xxx.xxx:xxxx    (ip adress in number notation with port adress)
// Next release will relax on this constraint.
integer check_url(string url)
{
	return TRUE;
	integer pos=0;

	if (llGetSubString(url,0,6) == "http://")
		pos=7;
	if (llGetSubString(url,0,7) == "https://")
		pos=8;

	if (pos==0)   return FALSE;

	string str_ip_port=llGetSubString(url,pos,-1);
	list list_ip_port=llParseString2List(str_ip_port,[":"],[]);                 // split in ip-adress and port
	list list_ip=llParseString2List(llList2String(list_ip_port,0),["."],[]);    // split ip-adress elements

	if (llGetListLength(list_ip_port) != 2 || llGetListLength(list_ip) != 4)
		return FALSE;

	integer i;
	integer test;

	for (i=0;i<4;i++)
	{
		test=llList2Integer(list_ip,i);
		if (llList2String(list_ip,i) != (string)test)
			return FALSE;
		if (test < 0 || test > 255)
			return FALSE;
	}

	test=llList2Integer(list_ip_port,1);
	if (llList2String(list_ip_port,1) != (string)test)
		return FALSE;

	return TRUE;
}

// Returns a true value depending on the first character in input - anything else is assumed false.
integer true_value(string input)
{
	string value=llToLower(llGetSubString(input,0,0));

	if (value == "y" || value == "t" || value =="1")
		return TRUE;

	return FALSE;
}

// Return if more input should be processed (if not at EOF) - sets ConfigError if any config error found. Reading config card stops at the first error.
integer process_line(string dataline)
{
	string line=llStringTrim(dataline,STRING_TRIM);
	integer index=llSubStringIndex(line,comment_char);

	if (index==0)       // line starts with comment - ignore line
		return TRUE;

	if (index!=-1)
		line=llStringTrim(llGetSubString(line,0,index-1),STRING_TRIM_TAIL);   // skip everything after comment_char and trim tail

	if (line=="")       // Ignore blank lines
		return TRUE;

	if (llToLower(line) == "[access]")
	{
		section = 1;
		return TRUE;
	}
	else if (llToLower(line) == "[banned]")
	{
		section = 2;
		return TRUE;
	}
	else if (llToLower(line) == "[genre]")
	{
		section = 3;
		return TRUE;
	}
	else if (llToLower(line) == "[station]")
	{
		section = 4;
		return TRUE;
	}
	else if (llGetSubString(line,0,0) == "[" && llGetSubString(line,-1,-1) == "]")
	{
		llWhisper(0,"error: malformed section found at line " + (string)lineno + ".\n" + dataline);
		config_error=TRUE;
		return FALSE;
	}

	if (section == 0)
	{
		llWhisper(0,"error: no section found on line: " + (string) lineno);
		config_error = TRUE;
		return FALSE;
	}

	list breakup=llParseString2List(line,["="],[]);
	string field=llStringTrim(llList2String(breakup,0),STRING_TRIM);
	string values=llStringTrim(llList2String(breakup,1),STRING_TRIM);

	if (section == 1)            // access
	{
		field=llToLower(field);

		if (field=="owner")
		{
			owner_access=true_value(values);
			return TRUE;
		}
		else if (field=="group")
		{
			group_access=true_value(values);
			return TRUE;
		}
		else if (field=="public")
		{
			public_access=true_value(values);
			return TRUE;
		}
		else
		{
			llWhisper(0,"error: invalid option on line: " + (string)lineno + ".\n" + dataline);
			config_error=TRUE;
			return FALSE;
		}

	}
	else if (section == 2)         // ban list
	{
		key try=(key) field;

		if (try)
		{
			banned_keys+=(list)((key) field);
			return TRUE;
		}
		else
			return FALSE;
	}
	else if (section == 3)           // categories
	{
		if (llListFindList(category_list,(list)field) == -1)
		{
			category_list+=(list)field;
		}
		else
			llWhisper(0,"genre: '" + field + "' already entered; double entry skipped.");

		return TRUE;
	}
	else if (section == 4)            // stations
	{
		list parse=llParseString2List(line,sep_char_list, []);
		string category=llStringTrim(llList2String(parse,0),STRING_TRIM);
		string name=llStringTrim(llList2String(parse,1),STRING_TRIM);
		string desc=llStringTrim(llList2String(parse,2),STRING_TRIM);
		string url=llStringTrim(llToLower(llList2String(parse,3)),STRING_TRIM);

		if (!available_category(category))
		{
			llWhisper(0,"error: unknown genre on line: " + (string)lineno + ".\n" + dataline);
			config_error=TRUE;
			return FALSE;
		}

		if (check_url(url))
		{
			if (llListFindList(station_url,(list)url) == -1 || llListFindList(station_category,(list)category) == -1)
			{
				num_stations++;
				station_category+=(list)category;
				station_name+=(list)name;
				station_desc+=(list)desc;
				station_url+=(list)url;
				return TRUE;
			}
			else
			{
				llWhisper(0,"This station is already entered under the same genre and same url and is skipped.\nStation: " + name + "\nGenre: '" + category + "'\nURL: " + url);
				return TRUE;
			}
		}
		else
		{
			llWhisper(0,"error: malformed url on line: " + (string)lineno + ".\n" + dataline);
			config_error=TRUE;
			return FALSE;
		}
	}

	return FALSE;
}

// Sets the parcel URL and updates the display
set_parcel_url(string url)
{
	parcel_url=url;
	llSetParcelMusicURL(parcel_url);

	if (parcel_url=="")
	{
		clear_display();
		display_line("1","Radio is OFF");
		display_line("2","");
		display_line("3","");
		User = NULL_KEY;
	}
	else
	{
		if(User == NULL_KEY)
		{
			llWhisper(0,"station now set to " + llList2String(station_desc,station_index) + ".");
			display_line("1","Station: " + llList2String(station_desc,station_index));
			display_line("2","Genre  : " + llList2String(category_list,category_index));
		}
		display_line("3","Now playing.....");
		llSetTimerEvent(update_time);
	}
}

// Returns if a category (genre) exists.
integer available_category(string category)
{
	integer i;
	integer len=llGetListLength(category_list);

	for (i=0;i<len;i++)
		if (llToLower(category) == llToLower(llList2String(category_list,i)))
			return TRUE;

	return FALSE;
}

// Returns if a category (genre) is empty (i.e. there are no stations for this catagory (genre))
integer empty_category(string category)
{
	integer i;
	integer len=llGetListLength(station_category);

	for (i=0; i < len; i++)
		if (llToLower(category) == llToLower(llList2String(station_category,i)))
			return FALSE;

	return TRUE;
}

// Removes categories (genres) for which no station is known.
skip_empty_categories()
{
	integer i=0;

	while (i<llGetListLength(category_list))
	{
		if (empty_category(llList2String(category_list,i)))
		{
			llWhisper(0,"Warning: Genre '" + llList2String(category_list,i) + "' contains no stations and is deleted.");
			category_list=llDeleteSubList(category_list,i,i);
		}
		else
			i++;
	}

	num_categories=llGetListLength(category_list);
}

/////////////////////////////////////////////
// state default
////////////////////////////////////////////

default
{
	state_entry()
	{
		flag=FALSE;
		lineno=1;
		config_error=FALSE;
		num_stations=0;
		num_categories=0;
		radio_status=0;
		menu_num=0;
		menu_type=0;
		User = NULL_KEY;
		llSetLinkTexture(picno, radiopic, 3);
		if (llGetInventoryType(config_notecard) == INVENTORY_NOTECARD)
		{
			reqid=llGetNotecardLine(config_notecard,lineno++);
			llWhisper(0, "Reading config notecard...");
			display_line("1","Reading configuration.");
			display_line("2","Wait....");
			display_line("3","");
		}
		else
		{
			llWhisper(0,"No config notecard '" +  config_notecard + "' present.");
			state offline;
		}
	}

	on_rez(integer param)
	{
		llResetScript();
	}

	dataserver(key id, string data)
	{
		if (reqid==id)
		{
			if (data==EOF)
			{
				skip_empty_categories();
				llWhisper(0,"Configuration ok.\n" + (string)num_categories + " genres and " + (string)num_stations + " stations.");
				display_line("1","Configuration OK");
				display_line("2","Genres  : " + (string)num_categories);
				display_line("3","Stations: " + (string)num_stations);
				state menu;
			}
			else
			{
				if (process_line(data))
					reqid=llGetNotecardLine(config_notecard,lineno++);
				else if (config_error)
				{
					llWhisper(0,"errors found in configuration. please correct them.");
					state offline;
				}
			}
		}
	}

	touch_start(integer total_num)
	{
	}

	changed(integer ch)
	{
		if (ch & CHANGED_INVENTORY)
			llResetScript();
	}
}

/////////////////////////////////////////////
// state offline
////////////////////////////////////////////

state offline
{
	state_entry()
	{
		llWhisper(0,"Reset on owner touch or when notecard updated.");
	}

	touch_start(integer t)
	{
		if (llDetectedKey(0)==llGetOwner())
			llResetScript();
	}

	changed(integer ch)
	{
		if (ch & CHANGED_INVENTORY)
			llResetScript();
	}
}

/////////////////////////////////////////////
// state menu
////////////////////////////////////////////

state menu
{
	state_entry()
	{
		menu_type=0;
		menu_num=0;
		listen_handle=0;
		if(User != NULL_KEY)
		{
			set_parcel_url(stream);
		}
	}

	on_rez(integer param)
	{
		llResetScript();
	}

	touch_start(integer total_num)
	{
		key toucher=llDetectedKey(0);

		if (has_access(toucher))
		{
			make_menu(toucher);
		}
		else
			llWhisper(0,"sorry, no access.");
	}

	listen(integer chan, string name,key id,string msg)
	{
		integer index;
		if(msg == button_login)
		{
			//if(User != NULL_KEY)
			//{
			//    llWhisper(0, "Sorry, but the board is already in use.");
			//    return;
			//}
			string s = "@" + llKey2Name(id);
			if(llGetInventoryType(s) != INVENTORY_NOTECARD)
			{
				llWhisper(0, "Only DJ's are allowed to log in.");
				return;
			}
			User = id;
			state login;
		}
		else if (menu_type == 0)          // main menu
		{
			if (msg == button_MAIN)
			{
				menu_type=0;
				menu_num =0;
				make_menu(id);
			}
			else if (msg == button_NEXT)
			{
				menu_num++;
				make_menu(id);
			}
			else if (msg == button_PREV)
			{
				menu_num--;
				make_menu(id);
			}
			else if (msg == button_ON)
			{
				radio_status=1;
				set_parcel_url(parcel_url);
				display_line("1","Radio is ON");
				menu_num=0;
				User = NULL_KEY;
				llRegionSay(-7848, "button_ON");
				llWhisper(0,"Radio now turned on.");
				make_menu(id);
			}
			else if (msg == button_OFF)
			{
				radio_status=0;
				set_parcel_url("");
				User = NULL_KEY;
				llSetTimerEvent(0.0);
				llRegionSay(-7848, "button_OFF");
				llWhisper(0,"Radio now turned off.");
			}
			else if (msg == button_HELP)
			{
				if (llGetInventoryType(info_notecard) == INVENTORY_NOTECARD)
				{
					llGiveInventory(id,info_notecard);
				}
				else
					llWhisper(0,"sorry, help not available.");
			}  else if (radio_status == 1)
		{
			index = llListFindList(category_list, (list)msg);

			if (index == -1)
				llWhisper(0,"error: genre not found: " + msg);
			else
			{
				category_index=index;
				llWhisper(0,"Genre now set to " + llList2String(category_list,category_index) + ".");
				menu_type=1;
				menu_num=0;
				make_menu(id);
			}
		}
		}
		else if (menu_type == 1 && radio_status == 1)     // station menu
		{
			if (msg == button_MAIN)
			{
				menu_type=0;
				menu_num =0;
				make_menu(id);
			}
			else if (msg == button_NEXT)
			{
				menu_num++;
				make_menu(id);
			}
			else if (msg == button_PREV)
			{
				menu_num--;
				make_menu(id);
			}
			else
			{
				index = llListFindList(station_name, (list)msg);

				if (index == -1)
					llWhisper(0,"error: station not found: " + msg);
				else
				{
					station_index=index;
					string new_url=llList2String(station_url,station_index);
					User = NULL_KEY;
					llSetLinkTexture(picno, radiopic, 3);
					if (new_url != parcel_url)
					{
						set_parcel_url(new_url);
					}
				}
			}
		}
	}

	timer()
	{
		retrieve_titelinfo();
		llSetTimerEvent(update_time);
	}

	http_response(key id, integer status, list meta, string body)
	{
		if (id == httpreq_id)
		{
			//llSay(0, body);
			if (status == 200)
			{
				string feed = llGetSubString(body,llSubStringIndex(body, "<body>") + llStringLength("<body>"), llSubStringIndex(body,"</body>") - 1);
				list feed_list = llParseString2List(feed,[","],[]);
				string current_title_info= llList2String(feed_list,6);
				integer length = llGetListLength(feed_list);

				if(llList2String(feed_list,7))
				{
					integer a = 7;
					for(; a<length; ++a)
					{
						current_title_info += ", " + llList2String(feed_list,a);
					}
				}

				if (current_title_info != last_title_info)
				{
					last_title_info = current_title_info;
					display_line("3","Title  : " + current_title_info);
				}
			}
			else
			{
				display_line("3","");
			}
		}
	}

	changed(integer ch)
	{
		if (ch & CHANGED_INVENTORY)
			llResetScript();
	}
}

state login
{
	state_entry()
	{
		texture = NULL_KEY;
		stream = "";
		ncname = "@" + llKey2Name(User);
		ncline = 0;
		ncid = llGetNotecardLine(ncname, ncline++);
	}
	dataserver(key requested, string data)
	{
		if(requested == ncid)
		{
			if(data != EOF)
			{
				list l = llParseString2List(data, ["="], []);
				string s1 = llToLower(llStringTrim(llList2String(l, 0), STRING_TRIM));
				string s2 = llStringTrim(llList2String(l, 1), STRING_TRIM);
				if(s1 == "texture") texture = (key)s2;
				else if(s1 == "stream") stream = s2;
				ncid = llGetNotecardLine(ncname, ncline++);
			} else
		{
			//set_parcel_url(stream);
			display_line("1","--> Live DJ <--");
			display_line("2","Your DJ: " + llKey2Name(User));
			if(texture != NULL_KEY) llSetLinkTexture(picno, texture, 3);
			state menu;
		}
		}
	}
}

//////////////////////////////
// end of script
//////////////////////////////
