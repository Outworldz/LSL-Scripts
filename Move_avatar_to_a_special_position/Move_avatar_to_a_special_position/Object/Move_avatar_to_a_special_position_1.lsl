// :CATEGORY:Movement
// :NAME:Move_avatar_to_a_special_position
// :AUTHOR:whcyc2002
// :CREATED:2013-05-29 03:10:41.293
// :EDITED:2013-09-18 15:38:57
// :ID:526
// :NUM:710
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Rez this object, move it to where you want the avatar's seat prim to end up, and reset the script.  It will say the position across an entire region.
// :CODE:
integer listen_ch= -478312941;

default
{
	state_entry()
	{
		llRegionSay(listen_ch, (string)llGetLocalPos());
	}
	
}
