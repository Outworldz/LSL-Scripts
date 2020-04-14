// :SHOW:
// :CATEGORY:Region Traffic Monitor 
// :NAME:Region Traffic Monitor Stats Retriever
// :AUTHOR:Aine Caoimhe
// :KEYWORDS:Region Traffic Monitor 
// :REV:2.0
// :WORLD:Opensim, Second Life
// :DESCRIPTION:
// Paramour Stats Retriever
// :CODE:

// Paramour Stats Retriever for Region Traffic Monitor 2.0
// by Aine Caoimhe (LACM) Setp 2015
// Provided under Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International license.
// Please be sure you read and adhere to the terms of this license: https://creativecommons.org/licenses/by-nc-sa/4.0/
//
// Requires no additional OSSL functions other than the ones that already need to be enabled for the Traffic Monitor
//
// Simply Place this script in the same prim as the Traffic Monitor script (and log notecards) then touch
// Reports are handed to you directly (and very briefly stored in the prim in order to be able to deliver it to you, then deleted)
// Times/dates are converted to SL time and is daylight-savings aware
// original dates/times stored on source cards are UTC so may overlap to next month on final day
// If the floaty text report is sufficient you don't need to put this into the prim at all.
// Don't touch to use this during peak traffic periods as it does invoke a thread-locking function.
//
// There is only 1 user settings for this script to enable or disable it
integer enabled=FALSE;
// FALSE = disable the script....TRUE = the script is enabled
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// DO NOT CHANGE ANYTHING BELOW HERE UNLESS YOU KNOW WHAT YOU'RE DOING
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
//
float timeOut=120.0;        // 2 minutes to respond to a dialog or remove listener
integer myChannel;
integer handle;
string txtDia;
list butDia;
list logs;
integer indLog;
string thisGrid;
list months=["months","January","February","March","April","May","June","July","August","September","October","November","December"];

// ********************** THIS PART COMES FROM SECOND LIFE WIKI: http://wiki.secondlife.com/wiki/Unix2PST_PDT ****************
// Convert Unix Time to SLT, identifying whether it is currently PST or PDT (i.e. Daylight Saving aware)
// Original script: Omei Qunhua December 2013
// Fixed by Aine Caoimhe to work in Opensim Setp 2015
// Returns a string containing the SLT date and time, annotated with PST or PDT as appropriate, corresponding to the given Unix time.
// e.g. Wed 2013-12-25 06:48 PST
//
list weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

string Unix2PST_PDT(integer insecs)
{
	string str = Convert(insecs - (3600 * 8) );   // PST is 8 hours behind GMT
	if (llGetSubString(str, -3, -1) == "PDT")     // if the result indicates Daylight Saving Time ...
		str = Convert(insecs - (3600 * 7) );      // ... Recompute at 1 hour later
	return str;
}

// This leap year test is correct for all years from 1901 to 2099 and hence is quite adequate for Unix Time computations
integer LeapYear(integer year)
{
	return !(year & 3);
}

integer DaysPerMonth(integer year, integer month)
{
	if (month == 2)      return 28 + LeapYear(year);
	return 30 + ( (month + (month > 7) ) & 1);           // Odd months up to July, and even months after July, have 31 days
}

string Convert(integer insecs)
{
	integer w; integer month; integer daysinyear;
	integer mins = insecs / 60;
	integer secs = insecs % 60;
	integer hours = mins / 60;
	mins = mins % 60;
	integer days = hours / 24;
	hours = hours % 24;
	integer DayOfWeek = (days + 4) % 7;    // 0=Sun thru 6=Sat

	integer years = 1970 +  4 * (days / 1461);
	days = days % 1461;                  // number of days into a 4-year cycle

	@loop;
	daysinyear = 365 + LeapYear(years);
	if (days >= daysinyear)
	{
		days -= daysinyear;
		++years;
		jump loop;
	}
	++days;

	month=0;
	w=0;
	while (days > w)
	{
		days -= w;
		w = DaysPerMonth(years, ++month);
	}
	string str =  ((string) years + "-" + llGetSubString ("0" + (string) month, -2, -1) + "-" + llGetSubString ("0" + (string) days, -2, -1) + " " +
		llGetSubString ("0" + (string) hours, -2, -1) + ":" + llGetSubString ("0" + (string) mins, -2, -1) );

	integer LastSunday = days - DayOfWeek;
	string PST_PDT = " PST";                  // start by assuming Pacific Standard Time
	// Up to 2006, PDT is from the first Sunday in April to the last Sunday in October
	// After 2006, PDT is from the 2nd Sunday in March to the first Sunday in November
	if (years > 2006 && month == 3  && LastSunday >  7)     PST_PDT = " PDT";
	if (month > 3)                                          PST_PDT = " PDT";
	if (month > 10)                                         PST_PDT = " PST";
	if (years < 2007 && month == 10 && LastSunday > 24)     PST_PDT = " PST";
	return (llList2String(weekdays, DayOfWeek) + " " + str + PST_PDT);
}
// ***************** END OF FUNCTION FROM SL WIKI ****************************

doFetch(string cardName)
{
	integer year=(integer)llGetSubString(cardName,5,8);
	integer month=(integer)llGetSubString(cardName,10,11);
	list data=llParseString2List(osGetNotecard(cardName),["|","\n"],[]);
	string details;
	list grids;
	integer visCount;
	integer localCount;
	integer hgCount;
	integer i;
	integer l=llGetListLength(data);
	while (i<l)
	{   // UTC | Name | Grid | Key
		string date=Unix2PST_PDT(llList2Integer(data,i));
		string name=llList2String(data,i+1);
		string grid=llList2String(data,i+2);
		key who=llList2Key(data,i+3);
		details=date+" "+name+" from "+grid+"\n"+details;   // prepend so the list order ends up being from start of month to end
		visCount++;
		if (grid==thisGrid) localCount++;
		else hgCount++;
		if (llListFindList(grids,[grid])==-1) grids=[]+grids+[grid];
		i+=4;
	}
	string stats="Statistics for the month "+llList2String(months,month)+" "+(string)year;
	stats+="\n-------------------------------------------------------";
	stats+="\nTotal unique visitors: "+(string)visCount;
	stats+="\nLocal users: "+(string)localCount;
	stats+="\nHypergrid users: "+(string)hgCount;
	stats+="\nUnique grids: "+(string)llGetListLength(grids);
	stats+="\n-------------------------------------------------------\n";
	stats+=details;
	string cardToGive="Stats for "+llGetRegionName()+" for "+llList2String(months,month)+" "+(string)year;
	osMakeNotecard(cardToGive,stats);
	llSleep(0.25);  // give it time to be stored
	llGiveInventory(llGetOwner(),cardToGive);
	llRemoveInventory(cardToGive);
}
showMenuMain()
{
	txtDia="Select a log to analyse and convert";
	butDia=[]+llList2List(logs,indLog,indLog+8);
	while (llGetListLength(butDia)<9) {butDia=[]+butDia+["-"];}
	butDia=[]+butDia+["< PREV","DONE","NEXT >"];
	startListening();
}
doPrebuild()
{
	integer i=llGetInventoryNumber(INVENTORY_NOTECARD);
	logs=[];
	indLog=0;
	while (--i>=0)
	{
		string name=llGetInventoryName(INVENTORY_NOTECARD,i);
		if (llSubStringIndex(name,"log: ")==0) logs=[]+logs+[llGetSubString(name,5,-1)];
	}
}
startListening()
{
	llSetTimerEvent(timeOut);
	handle=llListen(myChannel,"",llGetOwner(),"");
	llDialog(llGetOwner(),txtDia,llList2List(butDia,9,11)+llList2List(butDia,6,8)+llList2List(butDia,3,5)+llList2List(butDia,0,2),myChannel);
}
stopListening()
{
	llSetTimerEvent(0.0);
	llListenRemove(handle);
}

default
{
	state_entry()
	{
		thisGrid=osGetGridName();
		myChannel=0x80000000|(integer)("0x"+(string)llGetKey());
	}
	changed (integer change)
	{
		if (change & CHANGED_OWNER) llResetScript();
		else if (change & CHANGED_REGION_START) llResetScript();
	}
	on_rez(integer foo)
	{
		llResetScript();
	}
	touch_start(integer num)
	{
		if (llDetectedKey(0)!=llGetOwner()) return; // owner only can retrieve stats
		if (enabled)
		{
			doPrebuild();
			showMenuMain();
		}
		else llOwnerSay("The stats retriever script is currently set to disabled. To enable to change line 15 to enabled=TRUE and save");
	}
	timer()
	{
		stopListening();
	}
	listen(integer channel, string name, key who, string message)
	{
		stopListening();
		if (message=="DONE") return;
		else if (message=="-") startListening();
		else if ((message=="< PREV") || (message=="NEXT >"))
		{
			if (message=="NEXT >") indLog+=9;
			else indLog-=9;
			if (indLog>=llGetListLength(logs)) indLog=0;
			if (indLog<=-9) indLog=llGetListLength(logs)-9;
			if (indLog<0) indLog=0;
			showMenuMain();
		}
		else
		{
			string logToFetch="log: "+message;
			if (llGetInventoryType(logToFetch)!=INVENTORY_NOTECARD)
			{
				llOwnerSay("ERROR: could not find that card....rebuilding card list");
				doPrebuild();
				showMenuMain();
			}
			else doFetch(logToFetch);
			startListening();
		}
	}

}