// :CATEGORY:Inventory Giver
// :NAME:Landmark__Notecard_Giver__Group_Inv
// :AUTHOR:mangowylder
// :CREATED:2012-10-23 18:15:59.673
// :EDITED:2013-09-18 15:38:56
// :ID:455
// :NUM:611
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Landmark__Notecard_Giver__Group_Inv
// :CODE:
// This script will give a notecard and landmark to the user that touches it.
// If the user is not in the same group as the object they will be offered to
// join the group.
// This script is written to give one notecard and one landmark.
// If you put more than one of any item in the objects contents
// only the first alphabetically sorted item will be given.

// Mango Wylder

// Globals
string gStrUUID;

GiveInventory(key vKeyToucherId)
{
	string vStrNotecard = llGetInventoryName(INVENTORY_NOTECARD,0);
	string vStrLandmark = llGetInventoryName(INVENTORY_LANDMARK,0);
	llGiveInventory(vKeyToucherId, vStrNotecard);
	llGiveInventory(vKeyToucherId, vStrLandmark);
}

default
{
	state_entry()
	{
		gStrUUID = llList2String(llGetObjectDetails(llGetKey(), ([OBJECT_GROUP])), 0);
	}
	touch_start(integer total_number)
	{
		if (llSameGroup(llDetectedKey(0)))
		{
			GiveInventory(llDetectedKey(0));
		}
		else
		{
			GiveInventory(llDetectedKey(0));
			llRegionSayTo(llDetectedKey(0),0,"Want to join the group? Please click the link!"
				+"\n secondlife:///app/group/"+gStrUUID+"/about");
		}
	}
}
