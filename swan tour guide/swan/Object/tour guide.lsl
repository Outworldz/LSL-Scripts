// :CATEGORY:Tour
// :NAME:swan tour guide
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:05
// :ID:854
// :NUM:1188
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tour
// :CODE:

// Poseball script for both pose balls
// Author: Fred Beckhusen (Ferd Frederix)
integer _debug = 0;
integer REZ = 3454;
list Line = [];
list lCoordinate = [];
list lDescriptions = [];
list lSounds = [];
list lCommands = [];
list lLinks = [];


// notecard reading
integer iIndexLines;
string NOTECARD = "Route";        // the notecard for configuring

key kNoteCardLines;        // the key of the notecard
key kGetIndexLines;        // the key of the current line
integer i = 0;
integer count = 0;
integer timeout = 0;


float DAMPING = .2;   // .3

vector TargetLocation;


float INTERVAL = .050; // seconds to move

string SpeakThis;  // what is to be said
string PlayThis;  // what is to be Played

string strip( string str)
{
	string out;
	integer i;

	for ( ; i < llStringLength(str); i++)
	{
		out += llGetSubString(str,i,i);
		out = llStringTrim(out, STRING_TRIM);
	}
	return out;

}

string Getline(list Input, integer line)
{
	return strip(llList2String(Input, line));
}


default
{
	on_rez(integer param)
	{
		llResetScript();
	}


	state_entry()
	{
		llSetPrimitiveParams([PRIM_PHYSICS, FALSE]);
		llSetBuoyancy(1);
		kNoteCardLines = llGetNumberOfNotecardLines(NOTECARD);
		kGetIndexLines = llGetNotecardLine(NOTECARD,0);

		llSay (0, "Tour guide initialising. Please wait.");
	}

	// read notecard on bootup
	dataserver(key queryid, string data)
	{

		vector TempLocation;
		if (queryid == kNoteCardLines)
		{
			iIndexLines = (integer) data;
		}

		if (queryid == kGetIndexLines)
		{
			if (data != EOF)
			{
				queryid = llGetNotecardLine(NOTECARD, i);
				list lLine = (llParseString2List(data, ["|"], []));

				float X = (float) Getline(lLine,1);
				if (X > 0)
				{
					float Y = (float)Getline(lLine,2);
					float Z = (float)Getline(lLine,3);
					string Msg = llList2String(lLine,4);
					string sUUID = Getline(lLine,5);
					string sCommand = Getline(lLine,6);
					string sLink = Getline(lLine,7);

					TempLocation.x = X;
					TempLocation.y = Y;
					TempLocation.z = Z;

					if (_debug) llOwnerSay((string)TempLocation);

					lCoordinate = lCoordinate + [TempLocation];
					lDescriptions = lDescriptions + [Msg];
					lSounds +=  [sUUID];
					lCommands += [sCommand];
					lLinks += [sLink];

					integer locationLength = (llGetListLength(lCoordinate));
					integer     InitPerCent = (integer) llRound(((float) locationLength / (float) iIndexLines) * 100);
					llSetText("Initialising... \n" + (string) InitPerCent + "%" , <1,1,1>, 1.0);
					if (InitPerCent == 100)
					{
						state Paused;
					}

				}
				else
				{
					state Paused;
				}
				i++;
			}
			kGetIndexLines = llGetNotecardLine(NOTECARD,i);

		}
	}


	touch_start(integer total_number)
	{
		integer check = llGetListLength(lCoordinate);

		if (_debug)
			llOwnerSay("List is " + (string) check + " destinations long");

		if (check >= iIndexLines)
		{
			state Paused;
		}

		if (check < iIndexLines)
		{
			llSay(0, "Hang on a sec, still initialising...");
		}
	}

	state_exit()
	{
		llSetText("", <1,1,1>, 1.0);
		TargetLocation = (vector) llList2String(lCoordinate, 0);  // Look at 0th

		if (_debug)
			llOwnerSay("Looking at Target Location = " + (string) TargetLocation);

	}
}


state Paused
{
	state_entry()
	{
		llSay(0,"Ready");
	}

	link_message(integer sender,integer num,string msg, key id)
	{
		if (msg =="sit")
		{
			llWhisper(0,"Please stay seated. Waiting 10 seconds for a passenger");
			llSleep(10.0);
			state moving;
		}
	}

	changed(integer change)
	{
		if (change & CHANGED_INVENTORY)
		{
			llResetScript();
		}
	}




}

state moving
{

	state_entry()
	{
		llSetPrimitiveParams([PRIM_PHYSICS, TRUE]);


		llLookAt(TargetLocation, 2, 1);

		SpeakThis =  llList2String(lDescriptions, count);
		if (_debug) llOwnerSay("Speaking:" + SpeakThis);

		if (llStringLength(SpeakThis) > 1)
			llSay(0,SpeakThis);

		PlayThis =  llList2String(lSounds, count);
		if (_debug) llOwnerSay("Playing:" + PlayThis);
		if (llStringLength(PlayThis) > 1)
			llPlaySound(PlayThis,1.0);

		llSetTimerEvent(INTERVAL);
	}

	changed(integer change)
	{
		if (change & CHANGED_LINK)
		{
			key av = llAvatarOnSitTarget();
			if (av) //evaluated as true if not NULL_KEY or invalid
			{
				state moving;
			}
			else
			{

				state end;
			}
		}

	}


	on_rez(integer param)
	{
		llResetScript();
	}


	timer()
	{
		timeout ++;

		if (llVecMag(llGetPos() - TargetLocation) > .49999)
		{
			if (timeout > 30/INTERVAL) // Time Out to contingency
			{
				if (_debug)    llOwnerSay("Timeout!");
				state setposition;
			}
			llMoveToTarget((llVecNorm(TargetLocation - llGetPos()) * 1) + llGetPos(), DAMPING);
		}

		if (llVecMag(llGetPos() - TargetLocation) < .49999)
		{
			if (_debug) llOwnerSay("At location: " + (string) llGetPos());
			state speaking;
		}


	}

	state_exit()
	{
		llSetTimerEvent(0);
		timeout = 0;
		i = 0;
	}

}

state setposition //contingency
{
	state_entry()
	{
		llSetPrimitiveParams([PRIM_PHYSICS, FALSE]);

		llSetTimerEvent(INTERVAL);
	}

	changed(integer change)
	{
		if (change & CHANGED_LINK)
		{
			key av = llAvatarOnSitTarget();
			//llWhisper(0,"Sit by " + (string) av);
			if (av) //evaluated as true if not NULL_KEY or invalid
			{
				llWhisper(0,"Please stay seated");
			}
			else
			{
				state end;
			}
		}
		if (change & CHANGED_INVENTORY)
		{
			//  llResetScript();
		}
	}


	timer()
	{
		if (llVecMag(llGetPos() - TargetLocation) > .49999)
		{
			llSetPos((llVecNorm(TargetLocation - llGetPos()) * 0.5) + llGetPos());
			llLookAt(TargetLocation, 10, 10);
		}

		if (llVecMag(llGetPos() - TargetLocation) < .49999)
		{
			if (_debug)
				llOwnerSay("At location: " + (string) llGetPos());
			state speaking;
		}

	}
	state_exit()
	{
		llSetTimerEvent(0);
	}

}

state speaking
{

	state_entry()
	{
		count ++;

		if (count > (iIndexLines - 1))
			state end;

		if (count <= (iIndexLines - 1))
		{
			TargetLocation = (vector) llList2String(lCoordinate, count);
			if (_debug) llOwnerSay("New Target: " + (string) TargetLocation);
			state moving;
		}
	}


	state_exit()
	{
		llSetTimerEvent(0);
	}

}

state end
{
	state_entry()
	{
		llMessageLinked(LINK_SET,0,"SIT","");
		llSetAlpha(1.0,ALL_SIDES);
		llSetTimerEvent(0);
		llSetPrimitiveParams([PRIM_PHYSICS, FALSE]);
		key av = llAvatarOnSitTarget();
		if (av) {//evaluated as true if not NULL_KEY or invalid
			llWhisper(0, llKey2Name(av) +" thank you for taking the tour");
			llStopAnimation("sit knees up2");
			llUnSit(av);
		}


		llSay(0, "Tour stopped.  It will disappear in one minute");
		llSetTimerEvent(60);

	}

	changed(integer change)
	{
		if (change & CHANGED_LINK)
		{
			key av = llAvatarOnSitTarget();
			//llWhisper(0,"Sit by " + (string) av);
			if (av) //evaluated as true if not NULL_KEY or invalid
			{
				llWhisper(0,"Please stay seated");
				state moving;
			}

		}
		if (change & CHANGED_INVENTORY)
		{
			//   llResetScript();
		}

	}
	on_rez(integer param)
	{
		llResetScript();
	}


	timer()
	{
		llDie();
	}

}

