// :CATEGORY:Animal
// :NAME:mooFerd
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:57
// :ID:520
// :NUM:704
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// a mooving cow script
// :CODE:

// ______           _  ______            _           _
// |  ___|         | | |  ___|          | |         (_)
// | |_ ___ _ __ __| | | |_ _ __ ___  __| | ___ _ __ ___  __
// |  _/ _ \ '__/ _` | |  _| '__/ _ \/ _` |/ _ \ '__| \ \/ /
// | ||  __/ | | (_| | | | | | |  __/ (_| |  __/ |  | |>  <
// \_| \___|_|  \__,_| \_| |_|  \___|\__,_|\___|_|  |_/_/\_\
//
// fred@mitsi.com
//
// author Fred Beckhusen (Ferd Frederix) Copyright 2009
//
//
float difficulty = 7.0;  // higher = more difficult

string q1;
string q2;
string q3;
string q4;

////////////////////////////////////////////
// Follow Me Script
//
// Written by Xylor Baysklef
// Adapted and added by Garth Fairlight
// More mods by Fred Beckhusen (Ferd Frederix)
////////////////////////////////////////////

/////////////// CONSTANTS ///////////////////
string  FWD_DIRECTION   = "-y";
vector POSITION_OFFSET  = <0.0, 0.0, 0.0>; // Local coords
float   SCAN_REFRESH    = 1.0;
float   MOVETO_INCREMENT    = 6.0;
///////////// END CONSTANTS /////////////////

float LastPositionX = 0;
float LastPositionY = 0;

///////////// GLOBAL VARIABLES ///////////////
rotation gFwdRot;
float   gTau;
float   gMass;
integer count;

/////////// END GLOBAL VARIABLES /////////////

key AviKey;

integer blows = 0;


Tell (string story) {
	integer ind=llSubStringIndex (story, " ");
	if (ind>-1) {
		string oldname=llGetObjectName ();
		llSetObjectName (llGetSubString (story, 0, ind-1));
		llWhisper(0,"/me "+llGetSubString (story, ind+1, -1));
		llSetObjectName (oldname);
	} else {
			llWhisper( 0,story);
	}
}



StartScanning()
{
	llSensorRepeat("", "", AGENT, 40.0, PI, SCAN_REFRESH);
}


// Move to a position far away from the current one.
MoveTo(vector target)
{
	vector Pos = llGetPos();

	while (llVecDist(Pos, target) > MOVETO_INCREMENT)
	{
		Pos += llVecNorm(target - Pos) * MOVETO_INCREMENT;
		llSetPos(Pos);
	}
	llSetPos(target);

}

rotation GetFwdRot()
{
	// Special case... 180 degrees gives a math error
	if (FWD_DIRECTION == "-x")
	{
		return llAxisAngle2Rot(<0, 0, 1>, PI);
	}

	string Direction = llGetSubString(FWD_DIRECTION, 0, 0);
	string Axis = llToLower(llGetSubString(FWD_DIRECTION, 1, 1));

	vector Fwd;
	if (Axis == "x")
		Fwd = <1, 0, 0>;
	else if (Axis == "y")
		Fwd = <0, 1, 0>;
	else
		Fwd = <0, 0, 1>;

	if (Direction == "-")
		Fwd *= -1;

	return llRotBetween(Fwd, <1, 0, 0>);
}

rotation GetRotation(rotation rot)
{
	vector Fwd;
	Fwd = llRot2Fwd(rot);

	float Angle = llAtan2( Fwd.y, Fwd.x );
	return gFwdRot * llAxisAngle2Rot(<0, 0, 1>, Angle);
}

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * The real start of the universe.
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *


default
{
	state_entry()
	{
		llSetStatus(STATUS_PHYSICS, TRUE);
		q1 = llGetInventoryName(INVENTORY_SOUND,0);
		q2 = llGetInventoryName(INVENTORY_SOUND,1);
		q3 = llGetInventoryName(INVENTORY_SOUND,2);
		q4 = llGetInventoryName(INVENTORY_SOUND,3);

		difficulty = llFrand(6.0) + 3;  // from 3 to 8.99999

		llSetStatus(STATUS_PHANTOM, TRUE);
		gFwdRot = GetFwdRot();
		gMass = llGetMass();
		gTau = llFrand(5.0) + 5;
		//if (debug) llOwnerSay("tau:" + (string) gTau);
		llMoveToTarget(llGetPos(), gTau);

		AviKey = llGetOwner();
		llCollisionFilter( "", "", TRUE);
		llVolumeDetect(TRUE);
		StartScanning();
	}


	collision_start(integer total_number)
	{
		llSleep(1.0);
	}

	sensor(integer num_detected)
	{
		integer avi ;
		integer i;

		avi = -1;
		for (; i< num_detected; i++)
		{
			string Avatar = llDetectedName(i);
			//llOwnerSay(Avatar);
			if ( Avatar == llGetObjectDesc())
			{
				avi = i;
				llSetStatus(STATUS_PHYSICS, TRUE);
			}
		}

		if (avi < 0)
			return;


		// vector LastPos;
		rotation TargetRot;
		vector Pos = llDetectedPos(avi);
		rotation Rot = llDetectedRot(avi);
		vector size = llGetAgentSize(llDetectedKey(avi));
		TargetRot = llEuler2Rot( <0, 0, 0> * DEG_TO_RAD) * GetRotation(Rot);

		float offsety = -llFrand(2.0)+1;

		float dist = llVecDist(Pos,llGetPos());
		//llOwnerSay("Pos = " + (string) dist);
		if (dist < 1.3)
		{
			llPlaySound(q1,1.0);
			llSleep(10.0);
		}


		POSITION_OFFSET  = <offsety,0.0,   (-size.z / 2) + 1.0>;
		vector Offset = POSITION_OFFSET * Rot;
		Pos += Offset;
		float newrand = llFrand(5.0) + 2;
		llRotLookAt(TargetRot, 2.0, 0.2);

		llMoveToTarget(Pos, newrand);

		if (Pos.y != LastPositionY)
		{
			LastPositionY = Pos.y;
			float  r = llFrand(20);
			if ( r < 1 )          {llPlaySound(q1, 1);  }
			if (r > 1 &&  r < 2 ) {llPlaySound(q2, 1);  }
			if (r > 2 &&  r < 3 ) {llPlaySound(q3, 1);  }
			if (r > 3 &&  r < 4 ) {llPlaySound(q4, 1);  }
		}

		LastPositionX = Pos.x;
		if (Pos.x != LastPositionX)
		{
			LastPositionX = Pos.x;
			float  r = llFrand(20);
			if ( r < 1 )          {llPlaySound(q1, 1);  }
			if (r > 1 &&  r < 2 ) {llPlaySound(q2, 1);  }
			if (r > 2 &&  r < 3 ) {llPlaySound(q3, 1);  }
			if (r > 3 &&  r < 4 ) {llPlaySound(q4, 1);  }

		}
		count=0;
	}

	no_sensor()
	{
		count += 1;
		if(count > 120)
		{
			llPlaySound(q1,1);
			count = 0;
		}
		llSleep(1.0);
	}


	touch_start(integer num)
	{
		integer choice = (integer)llFrand(difficulty);
		if(choice == 1)
		{
			Tell("You hurt the "  + llGetObjectName());
			llPlaySound(q2,1);
			blows++;
		}

		else if(choice == 3)
		{
			Tell("You whacked a huge blow to the" + llGetObjectName());
			llPlaySound(q3,1);
			blows++;
			blows++;
		}
		else
		{
			Tell("You miss the "+ llGetObjectName());
		}

		if (blows > difficulty)
		{
			Tell("You killed the " + llGetObjectName());
			llPlaySound(q3,1);
			llSleep(1);
			llDie();
		}
	}

	on_rez(integer p)
	{
		llResetScript();
	}

}

