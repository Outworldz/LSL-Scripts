// :CATEGORY:Tour Guide
// :NAME:Valentines_Day_tour_bird
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2011-02-04 22:42:15.247
// :EDITED:2014-03-11
// :ID:946
// :NUM:1361
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Rezzer script.   Put a copy of your finished tour into a prim with this script and then touch it.
// :CODE:
integer counter = 0;
string aname = "Name of your tour prim"; // fill this in, and add the tour bird to the objects inventory.

default
{
	state_entry()
	{
		llListen(3454,"","","");
	}


	listen(integer channel, string name,key id, string msg)
	{

		llSleep(10);
		llSensor(aname,"",PASSIVE|SCRIPTED,5,PI);
	}

	touch_start(integer who)
	{
		if (llDetectedKey(0) == llGetOwner())
			llOwnerSay((string) counter + " tours given");

		llSleep(10);
		llSensor(aname,"",PASSIVE|SCRIPTED,5,PI);
	}

	sensor(integer num)
	{

		llSensorRemove();
	}

	no_sensor()
	{
		llOwnerSay("Rezzing " + aname);
		counter++;
		string aname = llGetInventoryName(INVENTORY_OBJECT,0);
		rotation rezrot = llEuler2Rot(<0.0,0.0,0.0>) * llGetRot();
		llRezObject(aname, llGetPos() + <0.0,0.0,0.5>,  <0.0,0.0,0.0>, rezrot, 0);
	}
}
