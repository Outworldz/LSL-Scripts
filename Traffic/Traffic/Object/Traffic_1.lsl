// :CATEGORY:Traffic
// :NAME:Traffic
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:08
// :ID:910
// :NUM:1307
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Traffic
// :CODE:
// From the book:
//
// Scripting Recipes for Second Life
// by Jeff Heaton (Encog Dod in SL)
// ISBN: 160439000X
// Copyright 2007 by Heaton Research, Inc.
//
// This script may be freely copied and modified so long as this header
// remains unmodified.
//
// For more information about this book visit the following web site:
//
// http://www.heatonresearch.com/articles/series/22/

list known;
string parcelName;

integer DAYSEC = 86400;
integer visitorsYesterday;

setTimer()
{
	float now = llGetWallclock();
	integer secondsLeft = (DAYSEC - (integer)now);
	llSetTimerEvent(secondsLeft);
}

default
{
	on_rez(integer i)
	{
		llResetScript();
	}

	state_entry()
	{
		llSensorRepeat("", "", AGENT, 20.0, PI, 1.0);
		list lstParcelDetails = [PARCEL_DETAILS_NAME];

		list lstParcelName=llGetParcelDetails(llGetPos(),lstParcelDetails);

		parcelName =(string)lstParcelName;
		setTimer();
	}

	sensor(integer detected) //A sensor returns the first 16 items detected.
	{
		integer i;

		// Say the names of everyone the sensor detects
		for(i=0;i<detected;i++)
		{
			string name = llDetectedName(i);

			if( llListFindList(known,[name]) == -1 )
			{
				llSay(0,"Hello " + name + " welcome to " + parcelName + "." );
				known += [name];
			}
		}
	}

	touch_start(integer total_number)
	{
		key owner = llGetOwner();
		key who = llDetectedKey(0);
		if( who==owner )
		{
			llSay(0, "Number of unique visitors today: " + (string)llGetListLength(known) );
			llSay(0, "Number of unique visitors yesterday: " + (string)visitorsYesterday );
			string l = llList2CSV(known);
			llSay(0,"Visitors today:" + l );
		}
	}

	timer()
	{
		llSleep(60);
		visitorsYesterday = llGetListLength(known);
		setTimer();
		known = [];
		llInstantMessage(llGetOwner(),"You had " + (string)visitorsYesterday + " today at " + parcelName );
	}
}
