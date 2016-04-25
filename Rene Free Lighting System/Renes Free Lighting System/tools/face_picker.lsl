// :SHOW:1
// :CATEGORY:Light
// :NAME:Rene Free Lighting System
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting light
// :CREATED:2015-06-11 14:41:53
// :EDITED:2016-03-30  20:29:28
// :ID:1079
// :NUM:1787
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Face picker: identify face numbers by touch
// :CODE:
// :LICENSE: CC0 (Public Domain)

// Face picker: identify face numbers by touch

default
{
	touch_start(integer total_number)
	{
		integer face = llDetectedTouchFace(0);
		if (face == TOUCH_INVALID_FACE) llOwnerSay("Viewer does not support touched faces");
		else llOwnerSay("Face " + (string)face);
	}
}
