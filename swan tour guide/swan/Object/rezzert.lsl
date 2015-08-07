// :CATEGORY:Tour
// :NAME:swan tour guide
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:05
// :ID:854
// :NUM:1187
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tour
// :CODE:


integer counter = 0;
string aname;
default
{
	state_entry()
    {
        aname = llGetInventoryName(INVENTORY_OBJECT,0);
		llListen(3454,"","","");
	}


	listen(integer channel, string name,key id, string msg)
	{
		//llOwnerSay("Heard Egret");
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
		
		rotation rezrot = llEuler2Rot(<0.0,0.0,0.0>) * llGetRot();
		llRezObject(aname, llGetPos() + <0.0,0.0,0.5>,  <0.0,0.0,0.0>, rezrot, 0);
	}
}
