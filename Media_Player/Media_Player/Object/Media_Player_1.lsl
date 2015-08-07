// :CATEGORY:TV
// :NAME:Media_Player
// :AUTHOR:Regina Public Schools
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:57
// :ID:511
// :NUM:682
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// RPS Media Player Script
// :CODE:

// CONFIG STUFF ********************************************************************************************************* //

// MENUS
integer     Main_Menu_Channel               = 2;
integer     Menu_Listen;
list        Menu_Main                       = ["Help", "Security", "Load Album"];
string      MenuMain_Prompt                 = "Choose an option...\n\n1) Help File\n2) Screen Security\n3) Select an Album";
list        Menu_Security                   = ["Everyone", "Owner", "Group"];
string      MenuSecurity_Prompt             = "Set screen security...\n\n1) Owner Only\n2) Group\n3) Everyone";
list        Menu_Configure                  = ["Cancel", "Manual", "Timed"];
string      MenuConfigure_Prompt            = "Configure viewing options...\n\n1) Manual Slideshow\n2) Timed Slideshow";
list        Menu_Slideshow                  = ["10", "20", "30", "40", "50", "60", "70", "80", "90"];
string      MenuSlideshow_Prompt            = "Choose a time in seconds...";

// ALBUM CHOICE
list        MediaCards;
integer     MaxMediaCards;
list        MediaCardChoices;
integer     MediaCardItems = 5;
string      MediaCard_Prompt                = "Choose a media album...";
integer     FirstMediaCard;
integer     i;
string      Item_Notecard;

// SECURITY
integer Security = 0;

// TIMED SLIDESHOW
integer timed = 0;
string  spacer    = "|";
list slideshowdata;

// DIALOG TEXTS AND ENTRIES
list            All_Entries;
list            All_Entries_Descriptions;
list            Menu_Buttons;

// DIALOG ITEMS
integer         Line_Number                 = 0;
integer         Current_Offset              = 0;
integer         Menu_Button_Items           = 6;
integer         Current_Final_Position      = 5;
integer         Total_Notecard_Entries      = 0;
integer         Menu_Loaded                 = 0;
integer         Current_Item_Number         = -1;
string          Menu_Descriptions           = "";

// DIALOG BUTTONS
string          Next_Button_Text            = "Next >>";
string          Previous_Button_Text        = "<< Prev";
string          Back_Button_Text            = "Cancel";
list            Next_Command                = [">>", "next", "Next", Next_Button_Text];
list            Back_Command                = [Back_Button_Text];
list            Previous_Command            = ["<<", "prev", "Prev", Previous_Button_Text];
string          Current_Set                 = "c";
string          All_Sets                    = "a";

// DATA FROM DIALOG CHOICE
string          Current_Item_URL;
string          Item_Description;
string          Image_Feed                  = "";

// COMMUNICATION CHANNELS
integer         Video_Start                 = 0;
integer         Video_Stop                  = 0;

// HELP MESSAGE WHISPERED AT STARTUP
string          Help_Message                = "Click the remote to select a media file";

// AVATAR DETAILS
key     Avatar_Using;



// USER-DEFINED FUNCTIONS *********************************************************************************************** //

reset()
{
	Video_Start =  (integer) llGetObjectDesc();
	Video_Stop = Video_Start+20;
	Main_Menu_Channel = Video_Start+400;
	llSetObjectName("RPS Media Remote V6.0");
	llListenRemove(Menu_Listen);
	Menu_Listen = llListen(Main_Menu_Channel, "", NULL_KEY, "");
	llSetText("RPS Video\n"+Item_Description,<1.0,1.0,1.0>,1.0);
}

ShowNotecardMenu()
{
	MediaCardChoices = [ ];
	if(FirstMediaCard > 0)
		MediaCardChoices += "<<";
	if(MaxMediaCards > (FirstMediaCard + MediaCardItems))
	{
		MediaCardChoices += ">>";
		MediaCardChoices += "Cancel";
	}
	for(i = 0;i < MediaCardItems;i++)
	{
		integer j = (i + FirstMediaCard);
		string num = (string)j;
		string strname = llList2String(MediaCards,j);
		if( llStringLength(strname) > 0)
		{
			MediaCardChoices = (list)strname + MediaCardChoices;
		}
	}
	llDialog(Avatar_Using, MediaCard_Prompt, MediaCardChoices, Main_Menu_Channel);
}

GetNotecardList()
{
	MediaCards = [];
	integer number = llGetInventoryNumber(INVENTORY_NOTECARD);
	while(--number >= 0)
	{
		string name = llGetInventoryName(INVENTORY_NOTECARD, number);
		MediaCards = (MediaCards = []) + MediaCards + [ name ];
	}
}

AddInventoryItem(string line)
{
	if (llGetSubString(line,0,0)=="#")
	{
		return;
	}
	list Notecard_Entry_List = llParseString2List(line, ["|"], []);
	if (llGetListLength(Notecard_Entry_List) < 2)
	{
		return;
	}
	string locationDesc = llList2String(Notecard_Entry_List,0);
	string location = llList2String(Notecard_Entry_List,1);
	All_Entries += [location];
	All_Entries_Descriptions += [locationDesc];
}

DoCurrentEntries()
{
	Menu_Buttons = [Back_Button_Text, Previous_Button_Text, Next_Button_Text];
	integer i;
	Menu_Descriptions = "";
	for (i = Current_Offset; i <= Current_Final_Position; i++)
	{
		if (Current_Item_Number == i)
		{
			Menu_Descriptions += "*";
		}
		else
		{
			Menu_Descriptions += " ";
		}
		Menu_Descriptions += (string) (i + 1) + ") ";
		Menu_Descriptions += llList2String(All_Entries_Descriptions, i);
		Menu_Descriptions += "\n";
		Menu_Buttons += (string)(i + 1);
	}
}

DoNextEntries()
{
	Current_Offset += Menu_Button_Items;
	Current_Final_Position = Current_Offset + (Menu_Button_Items - 1);
	if (Current_Offset >= Total_Notecard_Entries)
	{
		Current_Offset = 0;
		Current_Final_Position = Current_Offset + (Menu_Button_Items - 1);
	}
	if (Current_Final_Position >= Total_Notecard_Entries)
	{
		Current_Final_Position = Total_Notecard_Entries - 1;
	}
}

DoPreviousEntries()
{
	if (Current_Offset > 1 && ((Current_Offset - Menu_Button_Items) < 1))
	{
		Current_Offset = 0;
	}
	else
	{
		Current_Offset -= Menu_Button_Items;
	}
	Current_Final_Position = Current_Offset + (Menu_Button_Items - 1);
	if (Current_Final_Position >= Total_Notecard_Entries)
	{
		Current_Final_Position = Total_Notecard_Entries - 1;
	}
	if (Current_Offset < 0)
	{
		Current_Final_Position = Total_Notecard_Entries - 1;
		Current_Offset = Total_Notecard_Entries - (Menu_Button_Items - 1);
	}
}


// START **************************************************************************************************************** //

default
{
	on_rez(integer start_param)
	{
		reset();
	}

	state_entry()
	{
		reset();
	}

	changed(integer change)
	{
		if ((change & CHANGED_OWNER) || (change & CHANGED_INVENTORY))
		{
			reset();
		}
	}

	touch_start(integer total_number)
	{
		Avatar_Using = llDetectedKey(0);
		if((Security==0 && Avatar_Using==llGetOwner()) || (Security==1 && llSameGroup(Avatar_Using)) || Security==2)
		{
			llDialog(Avatar_Using, MenuMain_Prompt, Menu_Main, Main_Menu_Channel);
		}
		else
		{
			llSay(0, "You don't have permission to use this screen...");
		}
	}

	listen(integer channel, string name, key id, string message)
	{
		if (message == "Help")
		{
			llLoadURL(Avatar_Using, "Web Media User Guide", "http://www.theconsultants-e.com/edunation/edunationtoolsmediaviewer.asp");
		}
		else if (message == "Security")
		{
			state security;
		}
		else if (message == "Load Album")
		{
			state loadshow;
		}
		else
			llSay(0, name + " picked invalid option '" + llToLower(message) + "'.");
	}
}


// ******************** LOAD SHOW STATE ******************** //
// MENU TO CHOOSE A MEDIA SHOW NOTECARD ******************** //

// THIS NEEDS THEM TO SHOW ALHPABETICALLY - ANY IDEAS????

state loadshow
{
	state_entry()
	{
		llListenRemove(Menu_Listen);
		Menu_Listen = llListen(Main_Menu_Channel, "", NULL_KEY, "");
		GetNotecardList();
		MaxMediaCards = llGetListLength(MediaCards);
		FirstMediaCard = 0;
		ShowNotecardMenu();
	}

	listen(integer channel, string name, key id, string message)
	{
		if("<<" == message)
		{
			FirstMediaCard -= MediaCardItems;
			if(FirstMediaCard < 0) FirstMediaCard = 0;
			ShowNotecardMenu();
		}

		else if(">>" == message)
		{
			FirstMediaCard += MediaCardItems;
			if(FirstMediaCard > MaxMediaCards) FirstMediaCard = (MaxMediaCards - MediaCardItems);
			ShowNotecardMenu();
		}
		else if("Cancel" == message)
		{
			state remenu;
		}
		else
		{
			integer index = llListFindList(MediaCards, [message]);
			if(index >= 0)
			{
				string NotecardName = llList2String(MediaCards,index);
				Item_Notecard = NotecardName;
				state configureshow;
			}
		}
	}
}

// ******************** SECURITY STATE ******************** //
// USED TO SET THE SECURITY OF THE SCREEN - 3 LEVEL ACCESS  //

state security
{
	state_entry()
	{
		llListenRemove(Menu_Listen);
		Menu_Listen = llListen(Main_Menu_Channel, "", NULL_KEY, "");
		llDialog(Avatar_Using, MenuSecurity_Prompt, Menu_Security, Main_Menu_Channel);
	}

	listen(integer channel, string name, key id, string message)
	{
		if (message == "Owner")
		{
			Security = 0;
			llInstantMessage(Avatar_Using, "Screen permissions set to Owner...");
			state remenu;
		}
		else if (message == "Group")
		{
			Security = 1;
			llInstantMessage(Avatar_Using, "Screen permissions set to Group...");
			state remenu;
		}
		else if (message == "Everyone")
		{
			Security = 2;
			llInstantMessage(Avatar_Using, "Screen permissions set to Everyone...");
			state remenu;
		}
		else
			llSay(0, name + " picked invalid option '" + llToLower(message) + "'.");
	}
}


// ******************** CONFIGURE STATE ******************** //
// USED TO CONFIGURE EITHER MANUAL OR TIMES SLIDESHOW MODES  //

state configureshow
{
	state_entry()
	{
		llListenRemove(Menu_Listen);
		Menu_Listen = llListen(Main_Menu_Channel, "", NULL_KEY, "");
		llDialog(Avatar_Using, MenuConfigure_Prompt, Menu_Configure, Main_Menu_Channel);
	}

	listen(integer channel, string name, key id, string message)
	{
		if (message == "Manual")
		{
			state manualshow;
		}
		else if (message == "Timed")
		{
			state slideshow;
		}
		else if (message == "Cancel")
		{
			state remenu;
		}
		else
			llSay(0, name + " picked invalid option '" + llToLower(message) + "'.");
	}
}


// ******************** MANUAL SHOW STATE ******************** //
// MANUAL SLIDESHOW MODE - USER CHOOSES WHICH MEDIA TO SHOW    //


state manualshow
{
	state_entry()
	{
		llListenRemove(Menu_Listen);
		Current_Offset = 0;
		Current_Final_Position = 5;
		Line_Number = 0;
		Menu_Loaded = 0;
		All_Entries = [];
		All_Entries_Descriptions = [];
		Total_Notecard_Entries = 0;
		Current_Item_Number = -1;
		Menu_Descriptions = "";
		llGetNotecardLine(Item_Notecard, Line_Number);
	}

	dataserver(key query_id, string data)
	{
		if (data != EOF)
		{
			AddInventoryItem(data);
			Line_Number++;
			llGetNotecardLine(Item_Notecard, Line_Number);
			return;
		}
		llListen(Main_Menu_Channel, "", NULL_KEY, "");
		Total_Notecard_Entries = llGetListLength(All_Entries);
		llSay(0, Help_Message);
		Menu_Loaded = 1;
	}

	touch_start(integer touchNumber)
	{
		DoCurrentEntries();
		Avatar_Using = llDetectedKey(0);
		llDialog(Avatar_Using, Menu_Descriptions, Menu_Buttons, Main_Menu_Channel);
	}

	listen(integer channel, string name, key id, string message)
	{
		if (Menu_Loaded == 0)
		{
			llWhisper(0, " ... still loading ...");
			return;
		}
		Avatar_Using = id;
		list Notecard_Entry_List = llParseString2List(message, [" ", " ", "|"], []);
		list testFind = llList2List(Notecard_Entry_List, 0, 0);
		if (message == "")
		{
			message = "cur";
		}
		if (llListFindList(Next_Command, testFind) != -1)
		{
			DoNextEntries();
			DoCurrentEntries();
			llDialog(id, Menu_Descriptions, Menu_Buttons, Main_Menu_Channel);
			return;
		}
		else if (llListFindList(Previous_Command, testFind) != -1)
		{
			DoPreviousEntries();
			DoCurrentEntries();
			llDialog(id, Menu_Descriptions, Menu_Buttons, Main_Menu_Channel);
			return;
		}
		else if (llListFindList(Back_Command, testFind) != -1)
		{
			state remenu;
		}

		else if ((integer)message > 0 && (integer)message < 256)
		{
			llSay(Video_Stop,"Stop video");
			Current_Item_Number = (integer)message - 1;
			Current_Item_URL = llList2String(All_Entries, Current_Item_Number);
			Item_Description = llList2String(All_Entries_Descriptions, Current_Item_Number);
			Image_Feed = "";
			llSleep(0.25);
			llSay(Video_Start,Current_Item_URL);
			llSetText("RPS Video\n"+Item_Description,<1.0,1.0,1.0>,1.0);
		}

		else
			state remenu;
	}
}


// ******************** SLIDESHOW STATE ******************** //
// USED TO CONFIGURE TIMED SLIDESHOW - INCREMENT 10 SECONDS  //

// THIS NEEDS TO START IMMEDIATELY RATHER THAN AFTER THE FIRST TMER EVENT - ANY IDEAS?????

state slideshow
{
	state_entry()
	{
		llListenRemove(Menu_Listen);
		Menu_Listen = llListen(Main_Menu_Channel, "", NULL_KEY, "");
		llDialog(Avatar_Using, MenuSlideshow_Prompt, Menu_Slideshow, Main_Menu_Channel);
	}

	listen(integer channel, string name, key id, string message)
	{
		if ((integer)message > 0 && (integer)message < 100)
		{
			llSay(0, "Slideshow starting. Frequency: " +message + " seconds...");
			llSetTimerEvent((integer)message);
		}
		else
			llSay(0, name + " picked invalid option '" + llToLower(message) + "'.");
	}

	timer()
	{
		llGetNotecardLine(Item_Notecard, Line_Number);
	}

	dataserver(key id, string data)
	{
		if (data==EOF)
		{
			Line_Number=1;
		}

		else
		{
			llSay(Video_Stop,"Stop video");
			slideshowdata = llParseString2List(data,[spacer],[]);
			Current_Item_URL = llList2String(slideshowdata,1);
			llSay(0, Current_Item_URL);
			llSay(Video_Start,Current_Item_URL);
			llSetText("RPS Video\n"+Item_Description,<1.0,1.0,1.0>,1.0);
			++Line_Number;
		}
	}

	touch_start(integer touchNumber)
	{
		state remenu;
	}
}


// ******************** REMENU STATE ******************** //
// SIMPLE RECALL OF THE ORIGINAL MENU WITH NO TOUCH START //

state remenu
{
	state_entry()
	{
		llListenRemove(Menu_Listen);
		Menu_Listen = llListen(Main_Menu_Channel, "", NULL_KEY, "");
		llDialog(Avatar_Using, MenuMain_Prompt, Menu_Main, Main_Menu_Channel);
	}

	listen(integer channel, string name, key id, string message)
	{
		if (message == "Help")
		{
			llLoadURL(Avatar_Using, "Web Media User Guide", "http://www.theconsultants-e.com/edunation/edunationtoolsmediaviewer.asp");
		}
		else if (message == "Security")
		{
			state security;
		}
		else if (message == "Load Album")
		{
			state loadshow;
		}
		else
			llSay(0, name + " picked invalid option '" + llToLower(message) + "'.");
	}
}
