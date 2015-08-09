// :CATEGORY:Online Indicator
// :NAME:Excellent_Online_Indicator_Child_Sc
// :AUTHOR:mangowylder
// :CREATED:2011-03-09 17:29:59.527
// :EDITED:2013-09-18 15:38:52
// :ID:289
// :NUM:387
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Make these changes to Kristy Fanshaw's Excellent Online Indicator  script// Added this after line 99// llMessageLinked(2, 16, "Turn On", "");// Added this after line 105// llMessageLinked(2, 16, "Turn Off", "");
// :CODE:
integer MyNumber = 16;
default
{
	state_entry()
	{
		llSetTexture("7692b444-83db-90af-fe08-e602ca618ade", ALL_SIDES);
	}
	link_message(integer sender, integer num, string msg, key id)
	{
		if (num == MyNumber)
		{
			if (msg == "Turn On")
			{
				llSetColor (<0.0, 1.0, 0.0>, 4);
			}
			if (msg == "Turn Off")
			{
				llSetColor (<1.0, 0.0, 0.0>, 4);
			}
		}

	}
}
