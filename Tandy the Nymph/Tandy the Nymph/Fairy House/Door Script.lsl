// :CATEGORY:Tandy
// :NAME:Tandy the Nymph
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:06
// :ID:867
// :NUM:1211
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tandy
// :CODE:

integer door;

default
{
	state_entry()
	{

	}
	touch_start(integer total_number)
	{
		door = ~ door;
		if (door)
			llMessageLinked(LINK_SET,1,"open","");
		else
			llMessageLinked(LINK_SET,1,"close","");

	}
}
