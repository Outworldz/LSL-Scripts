// :CATEGORY:Animal
// :NAME:The_Blue_Whale_project
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2010-05-28 12:46:01.023
// :EDITED:2013-09-18 15:39:07
// :ID:883
// :NUM:1246
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Whale global movement script.    This moves a fish ( or a whale) in a circular pattern with a inner circle. It moves the animal up 1/4 of the time in a sine wave pattern so it appears above the water.  It also control splash and sound and water spoits
// :CODE:
integer counter;

integer running;

rotation myrot ;
integer up = FALSE;

string  FWD_DIRECTION   = "-y";

float INTERVAL = 0.4;

vector Destination;
float   gTau;

float DAMPING = .4;           // the damping rate we turn at
list coords = [<193.8728,92.04382,23.0>,
	<171.5811,62.16372,23.0>,
	<148.1316,61.04683,23.0>,
	<131.8011,72.83285,23.0>,
	<131.0652,93.61875,23.0>,
	<144.7105,105.3626,23.0>,
	<153.7658,76.02143,23.0>,
	<156.0498,48.00506,23.0>,
	<150.5392,30.20997,23.0>,
	<132.014,23.05155,23.0>,
	<101.8122,40.96667,23.0>,
	<50.86587,108.4027,23.0>,
	<52.58804,123.5606,23.0>,
	<79.25145,161.9644,23.0>,
	<107.1218,173.8963,23.0>,
	<145.8562,178.8377,23.0>,
	<178.8875,159.3154,23.0>,
	<193.4482,147.1552,23.0>,
	<196.4373,116.8217,23.0>
		];

integer swim = 0;
float calc (float i)
{
	float val = llSin((i-20)*40 / PI) * 4;
	return val;

}

run()
{

	llMessageLinked(LINK_SET,0,"on",NULL_KEY);
	llSetStatus(STATUS_PHYSICS, TRUE);
}

stop()
{

	llSetStatus(STATUS_PHYSICS, FALSE);
	llMessageLinked(LINK_SET,0,"off",NULL_KEY);
}
default
{
	state_entry()
	{
		counter = 0;
		Destination = llList2Vector(coords,counter);
		// llOwnerSay((string) Destination);
		llSetStatus(STATUS_PHANTOM, TRUE);
		llMessageLinked(LINK_SET,0,"off",NULL_KEY);
		llSetAlpha( 1.0, ALL_SIDES);
		gTau = 10.0;

		llSetStatus(STATUS_PHYSICS, FALSE);

	}


	timer()
	{

		vector newdest = (llVecNorm(Destination - llGetPos()) * 3) + llGetPos();
		swim++ ;
		if (swim == 20)
			llMessageLinked(LINK_SET,0,"on",NULL_KEY);


		if (swim == 27)
			llMessageLinked(LINK_SET,0,"off",NULL_KEY);


		if (swim == 35)
			llMessageLinked(LINK_SET,0,"on",NULL_KEY);


		if (swim > 37)
			llMessageLinked(LINK_SET,0,"off",NULL_KEY);

		if (swim > 20 && swim < 40)
			newdest.z = calc((float) swim) + 20;
		else
			newdest.z = 20;


		llLookAt(newdest, 1, 1.);




		if (swim == 80)
		{
			swim = 0;
		}


		float dist = llVecDist(Destination,llGetPos());




		if (dist > 5.0)
			llMoveToTarget(newdest, DAMPING);
		else
		{
			llMoveToTarget(newdest, DAMPING);
			counter++;
			if (counter >=  llGetListLength(coords))
				counter = 0;

			Destination = llList2Vector(coords,counter);

			//llMoveToTarget(Destination, DAMPING);

			// llOwnerSay((string) Destination);
		}


	}

	touch_start(integer p)
	{
		key x = llDetectedKey(0);

		if (x == llGetOwner())
		{
			if (running)
			{
				llOwnerSay("Orca stopped");
				running = FALSE;
				llSetAlpha( 1.0, ALL_SIDES);
				stop();
				llSetTimerEvent(0.0);
				llSetStatus(STATUS_PHYSICS, FALSE);
			}
			else
			{
				llOwnerSay("Orca running");
				myrot = llGetRot();
				llSetAlpha( 0.0, ALL_SIDES);
				running = TRUE;
				llSetTimerEvent(INTERVAL);
				llSetStatus(STATUS_PHYSICS, TRUE);
				llMessageLinked(LINK_SET,0,"off",NULL_KEY);
				run();
			}

		}


	}


	on_rez(integer p)
	{
		llResetScript();
	}

}
