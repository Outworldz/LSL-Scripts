// :CATEGORY:Special Effects
// :NAME:Splash
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:05
// :ID:827
// :NUM:1155
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Makes the splash effect from a Piers Anthony Book
// :CODE:



default
{
	state_entry()
	{
		llParticleSystem([]);

		llSetPrimitiveParams([PRIM_SIZE , <1.0,1.0,1.0>]);
		llSetAlpha(0.0, ALL_SIDES); // set entire prim 0% visible.
		llTargetOmega(<0.0,1.0,0.0>,TWO_PI,1.0);
		llPreloadSound("thunder1");
		llPreloadSound("thunder2");
		llPreloadSound("thunder3");

		llListen(0, "", "", "");
	}


	listen(integer channel, string name, key id, string message)
	{
		// check if the message corresponds to a predefined string.
		// llToLower converts the message to lowercase.

		list words = llParseString2List(message, [",",".",","," "], []);
		integer count = llGetListLength(words);
		integer total = 0;
		//llOwnerSay("Count = " + (string) count);
		integer j;
		for ( j = 0; j < count; j++)
		{
			string aword = llList2String(words,j);
			if (llToLower(aword) == "thee")
				total++;
		}
		// llOwnerSay("total = " + (string) total);
		integer max;

		if (total> 0 )
		{
			llSetAlpha(0.5, ALL_SIDES); // set entire prim 100% visible.




			if (total == 1 )
			{
				llWhisper(0, "a small ripple of absolute truth spreads throughout the land.....then slowly vanishes.");
				llPlaySound("thunder1",0.4);
				max = 5;

			}
			if (total == 2 )
			{
				llSay(0, "a ripple spreads throughout the land, anticipating.....what?");
				max = 7;
				llPlaySound("thunder3",0.6);
			}
			if (total >= 3  )
			{
				llShout(0, "a ripple of truth,  with the force of an oath spreads throughout the land....and explodes in sound and fury!");
				max =10;
				llPlaySound("thunder2",1.0);
			}


			float  i;


			for ( i = 1; i < max; i += 1)
			{
				vector size;
				size.x = i;
				size.y = i;
				size.z = i;
				llSetPrimitiveParams([PRIM_SIZE , size]);
				llSleep(0.05);
			}

			if (total == 1  )
			{
				llSetAlpha(0.66, ALL_SIDES); // set entire prim 0% visible.
				llSleep(0.5);
				llSetAlpha(0.33, ALL_SIDES); // set entire prim 0% visible.
				llSleep(0.5);
			}

			if (total == 2  )
			{
				llSetAlpha(0.8, ALL_SIDES); // set entire prim 0% visible.
				llSleep(0.5);
				llSetAlpha(0.6, ALL_SIDES); // set entire prim 0% visible.
				llSleep(0.5);
				llSetAlpha(0.4, ALL_SIDES); // set entire prim 0% visible.
				llSleep(0.5);
				llSetAlpha(0.2, ALL_SIDES); // set entire prim 0% visible.
				llSleep(0.5);
			}

			if (total >= 3  )
			{
				llSetAlpha(0.8, ALL_SIDES); // set entire prim 0% visible.
				llSleep(0.5);
				llSetAlpha(0.7, ALL_SIDES); // set entire prim 0% visible.
				llSleep(0.5);
				llSetAlpha(0.6, ALL_SIDES); // set entire prim 0% visible.
				llSleep(0.5);
				llSetAlpha(0.5, ALL_SIDES); // set entire prim 0% visible.
				llSleep(0.5);
				llSetAlpha(0.4, ALL_SIDES); // set entire prim 0% visible.
				llSleep(0.5);
				llSetAlpha(0.3, ALL_SIDES); // set entire prim 0% visible.
				llSleep(0.5);
				llSetAlpha(0.2, ALL_SIDES); // set entire prim 0% visible.
				llSleep(0.5);
				llSetAlpha(0.1, ALL_SIDES); // set entire prim 0% visible.
				llSleep(0.5);
			}



			llSetAlpha(0.0, ALL_SIDES); // set entire prim 0% visible.
			llSetPrimitiveParams([PRIM_SIZE , <0.010,0.010,0.010>]);

		}
	}





	/////////////////////// on_rez() //////////////////////////////

	on_rez(integer start_param)
	{
		llResetScript();
	}

	/////////////////////// changed() ////////////////////////////

	changed(integer mask)
	{
		if (mask & CHANGED_INVENTORY)
		{
			llResetScript();
		}
	}
}

