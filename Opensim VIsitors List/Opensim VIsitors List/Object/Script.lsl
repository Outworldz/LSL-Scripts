// :SHOW:
// :CATEGORY:Meter
// :NAME:Visitor Display
// :AUTHOR:Unknown
// :KEYWORDS:Visitor Display
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// Visitor Display using OsDrawText
// :CODE:


list gDetected = [];
list gVisitors = [];
string gTime = "";


display()
{
	string body = "width:512,height:512,aplha:FALSE,bgcolour:black";
	string draw = "";
	string log = "";//~ visitatori ~";
	string ad0 = "   * Welcome to My World * \n";
	string ad1 = "";
	string ad2 = "";

	integer visitors = llGetListLength(gVisitors) / 3;

	while(visitors--)
	{
		log = log + "\n"
			+ llList2String(gVisitors, visitors * 3 + 2) + " - "
			+ llList2String(gVisitors, visitors * 3 + 1) + " - "
			+ llList2String(gVisitors, visitors * 3);
	}

	draw = osSetFontSize(draw, 12);
	draw = osMovePen(draw, 16, 16);
	draw = osSetPenColor(draw, "white");
	draw = osDrawText(draw, ad2 + "\n" + ad0 + "\n"+ ad1 + "\n" + log);

	osSetDynamicTextureDataBlendFace("", "vector", draw, body, FALSE, 2, 0, FALSE, 4);
}

string time()
{   //0123 4 56 7 89 0 12 3 45
	//YYYY - MM - DD T hh : mm:ss.ff..fZ
	string now = llGetTimestamp();
	return llGetSubString(now,0,9) + " " +
		llGetSubString(now,11,15);
}

string duration(string timeIn, string timeOut)
{
	integer came = ((integer)llGetSubString(timeIn,11,12) * 60) + (integer)llGetSubString(timeIn,14,15);
	integer went = ((integer)llGetSubString(timeOut,11,12) * 60) + (integer)llGetSubString(timeOut,14,15);

	if (came == went) if(llGetSubString(timeIn,8,9) != llGetSubString(timeOut,8,9)) went = went + 1440;

	if (came > went) went = went + 1440;
	went = went - came;

	return llGetSubString("00" + (string)((went - (went % 60)) / 60), -2, -1) + ":" +
		llGetSubString("00" + (string)(went % 60), -2, -1);
}

detectVisitorInOut(list avatars)
{
	integer avatar = llGetListLength(avatars);
	string name = "";

	while(avatar--)
	{
		name = llList2String(avatars, avatar);
		if (llSubStringIndex((string)gDetected, name) == -1) gVisitors = gVisitors + [name, "00:00", gTime];

		if (llGetListLength(gVisitors) >= 63) gVisitors = llDeleteSubList(gVisitors, 0, 2);
	}

	avatar = llGetListLength(gDetected);
	name = "";

	while(avatar--)
	{
		name = llList2String(gDetected, avatar);
		if (llSubStringIndex((string)avatars, name) == -1)
		{
			integer position = llListFindList(gVisitors, [name, "00:00"]) + 1;
			string time = duration(llList2String(gVisitors, position + 1), gTime);
			gVisitors = llListReplaceList(gVisitors, [time], position, position);
		}
	}
}

visitorOut()
{
	integer avatar = llGetListLength(gDetected);
	string name = "";

	while(avatar--)
	{
		name = llList2String(gDetected, avatar);
		integer position = llListFindList(gVisitors, [name, "00:00"]) + 1;
		string time = duration(llList2String(gVisitors, position + 1), gTime);
		gVisitors = llListReplaceList(gVisitors, [time], position, position);
	}
}

default
{
	state_entry() { llSetTimerEvent(10.0); }

	timer()
	{
		list avatarList = osGetAgents();

		if ((string)avatarList != (string)gDetected)
		{
			gTime = time();

			if (avatarList != []) detectVisitorInOut(avatarList);
			else visitorOut();

			gDetected = avatarList;
			display();
		}
	}
}