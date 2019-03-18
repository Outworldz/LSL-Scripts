// :CATEGORY:Flying Bee
// :NAME:Flying Bee and Hive
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-08 12:59:45
// :EDITED:2013-09-18 15:38:53
// :ID:995
// :NUM:1491
// :REV:2
// :WORLD:Second Life
// :DESCRIPTION:
// A free flying bee that gathers pollen and takes it to his hive
// :CODE:
// Simple Bee script to locate and gather pollen from all prims named "Flower" then returns to the Beehive"
// Requires 2 sounds buzz1 and buzz2

string FLOWER_NAME = "Flower";
string HIVE_NAME = "Beehive";
vector offset = <0,.10,.1>;
vector hive_offset = <0,.5,0>;


// This is an OpenSim compatible llLookAt()


default
{
	state_entry()
	{
		llSetTimerEvent(5);	// move every 5 seconds
	}

	on_rez(integer p)
	{
		llSetTimerEvent(5); // move every 5 seconds
	}

	timer()
	{
		llSensor(FLOWER_NAME, NULL_KEY, ACTIVE|PASSIVE, 15.0,PI);
		llSetTimerEvent(0);
	}

	sensor(integer numDetected)
	{
		//llOwnerSay((string) numDetected);
		integer i;
		string name = llDetectedName(0);


		if (name == FLOWER_NAME)
		{
			for (i = 0; i < numDetected; i++)
			{
				llPlaySound("buzz1",1.0);

				vector new = <90,0,0> * DEG_TO_RAD;
				rotation r = llEuler2Rot(new);

				llLookAt(llDetectedPos(i),1,0.1);

				llSetPos(llDetectedPos(i) + <0,0.1,0>);
				llSetRot(llDetectedRot(i) * r);
				llSleep(4);
			}
			llSensor(HIVE_NAME,NULL_KEY,ACTIVE|PASSIVE,15.0,PI);

		} else {
				llPlaySound("buzz1",1.0);
			vector pos = llDetectedPos(0);
			llLookAt(llDetectedPos(0),1,0.1);      // face beehive

			llSetPos(pos + hive_offset);
			vector new = <90,0,0> * DEG_TO_RAD;
			rotation r = llEuler2Rot(new);

			llSetRot(llDetectedRot(0)  * r);    // orient to it
			llSleep(1);
			llSetPos(pos );         // move in

			llSleep(10);
			llSetTimerEvent(2);
			llSetPos(pos + hive_offset);     //move out
			llSleep(1);
		}
	}

	no_sensor()
	{
		llSetTimerEvent(15);
	}
}
