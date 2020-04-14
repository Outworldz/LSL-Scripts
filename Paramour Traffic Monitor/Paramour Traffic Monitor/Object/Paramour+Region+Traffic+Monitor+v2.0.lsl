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


// Paramour Region Traffic Monitor v2.0
// By Aine Caoimhe (LACM) Sept 2015
// Provided under Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International license.
// Please be sure you read and adhere to the terms of this license: https://creativecommons.org/licenses/by-nc-sa/4.0/
//
// This version of the region greeter is designed to handle potentially extremely high traffic areas where the number of
// unique visitors can exceed the store limits of a single notecard. I have also altered the store logic to make it more
// suitable for high traffic locations as well (much lower load). This new version will still fail if you have more than
// approximately 750 unique visitors in a single month (notecards can hold only 64KB of data and any attempt to write
// more than this fails will result in a blank notecard without generating any error/warning in world or in console).
// The exact failure point depends on the lengths of each visitor's name so it could conceivably fail with fewer than
// this, or succeed with even 1000 unique visitors...it all depends on the total character count.
//
// This version DOES NOT include option to give landmarks or notecards to new visitors since this invokes a rather nasty
// 3-second thread-lock I consider inappropriate for the kind of region this is intended to serve. Instead, I suggest
// putting a separate box nearby that contains those items and is set to touch-to-buy-contents (which results in the
// same thing for the visitor but without the painful thread-lock).
//
// The script tracks user visits by UNIX time (UTC) and uses it for internal calculations so roll-over to a new day
// occurs at midnight UTC in all storage and reports. Someone who visits multiple times in a single month will only
// be listed once in that month's log, using the date/time of their last visit during that period
//
// There is an option to display stats as floaty text above the prim containing the script. These stats update each time
// someone new enters the region, or hourly if there have been no changes during the previous 60 minutes
//
// Set the paramters as desired in the User Settings section below or leave them at their suggested defaults if you wish.
//
// **** REQUIRES OSSL ENABLED IN THE REGION AND SUFFICIENT PERMISSIONS FOR THE SCRIPT OWNER ****
// Uses the following OSSL functions:
// - osGetAvatarList()          used to poll who is in the region
// - osGetNotecard()            to retrive stored data
// - osMakeNotecard()           to presist data reliably
// - osGetGridName()            to find out what grid this script is running in
// - osIsNpc()                  to avoid greeting NPCs
//
// * * * * * * * * * * * *
// * *  USER SETTINGS  * *
// * * * * * * * * * * * *
//
integer enabled=FALSE;
// TRUE = this script is enabled.....FALSE = this script is disabled and you can make other adjustments to the settings without it going through its normal routines
// Set it to TRUE to start using the script
//
// Set the following according to your preferences
float pollRate=30.0;
// how often (in seconds) to check for a new visitor...shorter values induce higher sim load
//
float persistDelay=300.0;
// when there is new data to persist, how long to wait (in seconds) before writing the notecard. If someone else arrives during this time
// the persist timer is reset. This ensures that the action of storing the new notecard doesn't contribute to sim lag during the initial
// heavy hit of a login. Keep in mind when shutting down a
//
string firstGreetMessage="Welcome, $name. Thank you for visiting my region.";
// This message will be shown to the guest only on their very first visit. Use the special wildcard string "$name" which will be replaced
// by the person's actual name when they are greeted. Replace this generic text with anything you like.
//
string repeatGreetMessage="Welcome back, $name. Please enjoy your stay.";
// This message will be shown on all subsequent visits by a guest. Again, $name will be replaced by the guest's actual name.
//
integer notifyOwner=TRUE;
// TRUE = when someone new enters the region tell the owner who arrived (using region chat if possible)
/// FALSE = don't notify the owner
//
// IMPORTANT!!!!!! DO NOT ENABLE THIS NEXT FEATURE IN ANY HIGH TRAFFIC REGION UNLESS YOU WILL ALWAYS BE PRESENT IN THE REGION AT HIGH TRAFFIC TIMES!!!!!!!
// The setting above only notifies you when you're in the region. To be notified when you're in another region requires enabling the next option which will instant-message you
// but the function used to send the message requires the use of a VERY NASTY 2-second threadlock function which can result in severe reduction to the
// performance of the simulator if used too frequently. You can easily use the reporting functions to find out who has visited the region so only enable this if you absolutely need
// to be told immediately when someone arrives, and you should go to that region as soon as possible and remain there if you expect more visitors since each
// new arrival will apply this same hit. I only included it as an option at all due to popular request and I won't be sympathetic if its use lags or even crashes your simulator.
integer messageOwner=FALSE;
// IGNORED if notifyOwner is set to FALSE
// TRUE = if the owner is not in the region, send an instant message to the owner to notify then when someone enters. NOT RECOMMENDED!!!!!!!
// FALSE = don't message the owner
//
integer showFloatyStats=TRUE;
vector floatyColour=<0.0, 1.0, 0.0>;
float floatyAlpha=1.0;
// showFloatyStats = TRUE   - the sim visitor stats will be shown as floaty text above the prim that contains the script
// showFloatyStats = FALSE  - no floaty text stats
// If you turn on floaty stats, the floatyColour and floatyAlpha control the colour and transparancy of the text using the
// standard LSL RGB colour vector (<0,0,0> = black, <1,1,1> = white) and alpha (0.0=invisible, 1.0 = opaque). If off, they're ignored
//
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// DON'T CHANGE ANYTHING BELOW HERE UNLESS YOU KNOW WHAT YOU'RE DOING
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
//
integer thisMonth;
integer thisYear;
list monthList;     // UTC | Name | grid | key
list masterList;    // UTC | Key
list greetedList;   // key
integer lastStatsUpdate;
string thisGrid;

doFloatyUpdate()
{
	lastStatsUpdate=llGetUnixTime();
	if (!showFloatyStats) return;
	string stats=llGetRegionName()+" visitor stats\n ";
	integer visDay;
	integer day=24*60*60;   // how many seconds in a day
	integer visWeek;
	integer week=day*7;     // how many seconds in a week
	integer visMonth;
	integer month=day*30;   // how many seconds in 30 days
	integer i;
	integer l=llGetListLength(masterList);
	while (i<l)
	{
		integer thisDeltaTime=lastStatsUpdate-llList2Integer(masterList,i);
		if (thisDeltaTime<=day) visDay++;
		if (thisDeltaTime<=week) visWeek++;
		if (thisDeltaTime<=month) visMonth++;
		// because list is sorted in descending order if we are more than this we can stop
		if (thisDeltaTime>month) i=l;
		else i+=2;
	}
	stats+="\nIn Region Now: "+(string)llGetListLength(greetedList);
	stats+="\nLast 24 hours: "+(string)visDay;
	stats+="\nLast 7 days: "+(string)visWeek;
	stats+="\nLast 30 days: "+(string)visMonth;
	stats+="\nAll Time: "+(string)(l/2);
	stats+="\n(all counts are unique visitors)";
	llSetText(stats,floatyColour,floatyAlpha);
}
integer updatePresence()
{
	// returns TRUE if someone new has arrived in the region, else FALSE
	integer isChanged=FALSE;
	integer ownerPresent=FALSE;
	if (llGetAgentSize(llGetOwner())!=ZERO_VECTOR) ownerPresent=TRUE;
	integer now=llGetUnixTime();
	list inRegion=osGetAvatarList(); // key, position, name
	if (llGetAgentSize(llGetOwner())!=ZERO_VECTOR) inRegion=[]+inRegion+[llGetOwner(),ZERO_VECTOR]+llGetObjectDetails(llGetOwner(),[OBJECT_NAME]);
	integer i;
	integer l=llGetListLength(inRegion);
	while (i<l)
	{
		key who=llList2Key(inRegion,i);
		if (!osIsNpc(who)) // don't greet NPCs
		{
			// have we already greeted this person?
			if (llListFindList(greetedList,[who])==-1)
			{
				// this is a new arrival so now we need to great them and flag the update
				isChanged=TRUE;
				// either way we need to figure out their name and grid
				string name=llList2String(inRegion,i+2);
				string grid=thisGrid;
				integer sep=llSubStringIndex(name," @");
				if (sep>-1)
				{
					// this person is from another grid so extract that and trim it from the name
					grid =llGetSubString(name,sep+2,-1);
					name=""+llGetSubString(name,0,sep-1);
					// a hypergrid name is also using a dot as a separator so fix that
					sep=llSubStringIndex(name,".");
					name=""+llGetSubString(name,0,sep-1)+" "+llGetSubString(name,sep+1,-1);
				}
				// grid and name are now correct so find out if this is a new visitor and greet them
				string greeting=repeatGreetMessage; // default to this
				integer visit=llListFindList(masterList,[who]);
				if (visit==-1)
				{
					// first time visitor we need to add to both master list and monthly list
					greeting=""+firstGreetMessage; // switch to first time greeting message instead
					masterList=[]+masterList+[now,who];
					monthList=[]+monthList+[now,name,grid,who];
				}
				else
				{
					// return visitor...update master first
					masterList=[]+llListReplaceList(masterList,[now],visit-1,visit-1);
					// see if they're also already in this month's list
					integer monIndex=llListFindList(monthList,[who]);
					if (monIndex==-1) monthList=[]+monthList+[now,name,grid,who];   // add new to list
					else monthList=[]+llListReplaceList(monthList,[now],monIndex-3,monIndex-3); // update return to list
				}
				// greet the visitor but first subsitute $name with user's name
				integer swapInd=llSubStringIndex(greeting,"$name");
				while (swapInd>-1)
				{
					greeting=""+llGetSubString(greeting,0,swapInd-1)+name+llGetSubString(greeting,swapInd+5,-1);
					swapInd=llSubStringIndex(greeting,"$name");
				}
				llRegionSayTo(who,0,greeting);
				// notify owner
				if (notifyOwner)
				{
					if(ownerPresent) llRegionSayTo(llGetOwner(),0,name+" entered the region");
					else if (messageOwner) llInstantMessage(llGetOwner(),name+" entered your "+llGetRegionName()+" region");
				}
				// add to the greeted list
				greetedList=[]+greetedList+[who];
			}
		}
		i+=3;   // next person
	}
	// update greetedList to reflect anyone who has left
	l=llGetListLength(greetedList);
	while (--l>=0)
	{
		if(llListFindList(inRegion,[llList2Key(greetedList,l)])==-1) greetedList=[]+llDeleteSubList(greetedList,l,l);
	}
	// if there have been any changes we need to do a few further things
	if (isChanged)
	{
		// sort both lists in descending order
		masterList=[]+llListSort(masterList,2,FALSE);
		monthList=[]+llListSort(monthList,4,FALSE);
		llSensorRepeat("THIS_SHOULD_NEVER_EVER_RETURN_A_SENSOR_RESULT",NULL_KEY,SCRIPTED,0.1,PI,persistDelay);
		return TRUE;
	}
	else return FALSE;
}
persistData()
{
	// whenever data has changed and new persist needs to happen
	// clear sensor if there is one
	llSensorRemove();
	string cardName="log: "+(string)thisYear+"-";
	if (thisMonth<10) cardName+="0";
	cardName+=(string)thisMonth;
	if (llGetInventoryType(cardName)==INVENTORY_NOTECARD)
	{
		llRemoveInventory(cardName);
		llSleep(0.25);  // have to sleep to give it time to register
	}
	integer i;
	integer l=llGetListLength(monthList);
	string data;
	while (i<l)
	{
		data+=llDumpList2String(llList2List(monthList,i,i+3),"|")+"\n";
		i+=4;
	}
	if (llStringLength(data)>0) osMakeNotecard(cardName,data);
}
doMonthRollOver(list today)
{
	// triggered by first tick of the timer after month changes so force a persist to close out previous month first
	persistData();
	// set new date
	thisYear=llList2Integer(today,0);
	thisMonth=llList2Integer(today,1);
	// put anyone currently in the region into the new month list - build it using previous month's list then replace
	list newMonthList=[];
	integer now=llGetUnixTime();
	integer i=llGetListLength(greetedList);
	while (--i>-1)
	{
		integer index=llListFindList(monthList,[llList2Key(greetedList,i)]);
		newMonthList=[]+newMonthList+[now]+llList2List(monthList,index-2,index);
	}
	monthList=[]+newMonthList;
	// need to force persist of this new month too
	persistData();
}
loadData()
{
	monthList=[];
	masterList=[];
	greetedList=[];
	integer i=llGetInventoryNumber(INVENTORY_NOTECARD);
	while (--i>-1)
	{
		string card=llGetInventoryName(INVENTORY_NOTECARD,i);
		if (llSubStringIndex(card,"log: ")==0)
		{
			integer year=(integer)llGetSubString(card,5,8);
			integer month=(integer)llGetSubString(card,10,11);
			list thisData=llParseString2List(osGetNotecard(card),["|","\n"],[]);
			if ((year==thisYear) && (month==thisMonth)) monthList=[]+thisData;
			integer e;
			integer l=llGetListLength(thisData);
			while (e<l)
			{
				key who=llList2Key(thisData,e+3);
				integer when=llList2Integer(thisData,e);
				integer index=llListFindList(masterList,[who]);
				if (index==-1) masterList=[]+masterList+[when,who];
				else if (llList2Integer(masterList,index-1)<when) masterList=llListReplaceList(masterList,[when],index-1,index-1);
				e+=4;
			}
		}
	}
}

default
{
	state_entry()
	{
		if (!enabled)
		{
			llOwnerSay("The main Paramour Traffic Monitor script is currently disabled. To enable it, change line 39 of the script to say enabled=TRUE and save");
			return;
		}
		thisGrid=osGetGridName();
		if (!showFloatyStats) llSetText("",ZERO_VECTOR,0.0);
		list today=llParseString2List( llGetTimestamp(), ["-", "T", ":", "."], [] );
		thisYear=llList2Integer(today,0);
		thisMonth=llList2Integer(today,1);
		loadData();
		llSetTimerEvent(pollRate);
	}
	changed (integer change)
	{
		if (change & CHANGED_OWNER) llResetScript();
		else if (change & CHANGED_REGION_START) llResetScript();
	}
	on_rez (integer foo)
	{
		llResetScript();
	}
	sensor(integer num)
	{
		llOwnerSay("This should never, ever return a result");
		llSensorRemove();
	}
	no_sensor()
	{
		// expected result of there being a change that needs to be persisted
		llSensorRemove();
		persistData();
	}
	timer()
	{
		// check for month roll-over
		list today=llParseString2List( llGetTimestamp(), ["-", "T", ":", "."], [] );
		integer newMonth=llList2Integer(today,1);
		if (newMonth!=thisMonth) doMonthRollOver(today);
		// update presence list and see if anyone new has arrived or it's time to do a floaty update
		if (updatePresence()) doFloatyUpdate();     // returns TRUE if there has been a change
		else if ((llGetUnixTime()-lastStatsUpdate) > 3600) doFloatyUpdate();
	}
}