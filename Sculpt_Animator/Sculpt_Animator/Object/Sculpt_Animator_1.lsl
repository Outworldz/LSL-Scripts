// :CATEGORY:Sculpt
// :NAME:Sculpt_Animator
// :AUTHOR:Ferd Frederix
// :CREATED:2010-09-09 14:59:20.333
// :EDITED:2013-09-18 15:39:01
// :ID:726
// :NUM:994
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Change the timer constant for different playback speeds.   You can put as many sculpt maps as you want, it will play them back in order.
// :CODE:
integer nItems=0;
integer currentItem = 0;

default
{
	state_entry()
	{
		llSetTimerEvent(.10);
		nItems =llGetInventoryNumber(INVENTORY_TEXTURE);
	}

	timer()
	{
		string name = llGetInventoryName(INVENTORY_TEXTURE,currentItem);
		if (++currentItem >= nItems)
			currentItem = 0;


		llSetPrimitiveParams([PRIM_TYPE,PRIM_TYPE_SCULPT,name,PRIM_SCULPT_TYPE_PLANE]);
	}

	changed(integer type)
	{
		if (type & CHANGED_INVENTORY)
			llResetScript();
	}
}
