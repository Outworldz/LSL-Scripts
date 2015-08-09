// :CATEGORY:Tour
// :NAME:TourCopter
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:08
// :ID:909
// :NUM:1306
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tour
// :CODE:

﻿// useless, delete this crap

// Voice - whispers the ID number on channel 0 !!!


default
{
	link_message(integer sender, integer num, string str, key id)
	{
		if (str == "llWhisper") {
			llWhisper(0, id);
		}
	}
}
