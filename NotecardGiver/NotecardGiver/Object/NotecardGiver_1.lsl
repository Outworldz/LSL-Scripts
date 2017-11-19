// :CATEGORY:Inventory Giver
// :NAME:NotecardGiver with web link
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :ID:565
// :NUM:769
// :REV:2.0
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// NotecardGiver
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
// Mod to give out a web link added by Ferd

// Tuneable things you need to set
integer giveNotecard = TRUE;
integer giveWebSite = TRUE;
string Message = "Visit the Outworldz Website";
string WebLink = "http://www.outworldz.com";
float Distance = 20;
string notecard = "Welcome Notecard";


integer freq = 5;	// how often it scans, Keep this slow.
integer maxList = 100;	// saves the last 100 people to avoid spamming
list given;	// the list of people


default
{
	state_entry()
	{
		llSensorRepeat("", "",AGENT, Distance, PI, freq);
	}

	sensor(integer num_detected)
	{
		integer i;
		key detected;

		for(i=0;i<num_detected;i++)
		{
			detected = llDetectedKey(i);

			if( llListFindList(given, [detected]) < 0 )
			{
				given += llDetectedKey(i);
				if (giveNotecard) {
					llGiveInventory(detected, notecard);
				}
				if (giveWebSite) {
					llLoadURL(detected,Message, WebLink);
				}

				if (llGetListLength(given) >= maxList)
				{
					given = llDeleteSubList(given,0,0);
				}
			}
		}
	}
}
