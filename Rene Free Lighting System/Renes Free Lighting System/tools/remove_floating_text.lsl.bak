// :SHOW:1
// :CATEGORY:Light
// :NAME:Rene's Free Lighting System
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting light
// :CREATED:2015-06-11 14:41:54
// :EDITED:2015-06-12  16:41:14
// :ID:1079
// :NUM:1788
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// Removes floating text and then removes itself
// :CODE:
// :LICENSE: CC0 (Public Domain)

// Removes floating text and then removes itself

default
{
	state_entry()
	{
		llSetLinkPrimitiveParamsFast(LINK_SET, [PRIM_TEXT, "", ZERO_VECTOR, 0.0]);
		llRemoveInventory(llGetScriptName());
	}
}
