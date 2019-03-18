// :CATEGORY:Blue Whale
// :NAME:BlueWhale
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:49
// :ID:107
// :NUM:144
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// learning script
// :CODE:

// Open source, GPL license.
// Do not remove the header, do not sell this script.
// ______           _  ______            _           _
// |  ___|         | | |  ___|          | |         (_)
// | |_ ___ _ __ __| | | |_ _ __ ___  __| | ___ _ __ ___  __
// |  _/ _ \ '__/ _` | |  _| '__/ _ \/ _` |/ _ \ '__| \ \/ /
// | ||  __/ | | (_| | | | | | |  __/ (_| |  __/ |  | |>  <
// \_| \___|_|  \__,_| \_| |_|  \___|\__,_|\___|_|  |_/_/\_\
//
// author Fred Beckhusen (Ferd Frederix)

// Prim position root script
// Put this script in the root prim. Put the child script in all prims you wish to move.
// touch the script to start recording

// Reset - wipe out all recording.
// Name  - name a new recording
// Pause - insert a 1 second pause
// PlayBack - play back the current animation
// RemoveAll - removel all child scripts
// Record  - store a new set of child prim positions
//


integer debug = 0;


// notecard reading
integer iIndexLines;
integer i = 0;
integer move = 0;               // N movements rea from the notecard
string NOTECARD = "Movement";   // the notecard
key kNoteCardLines;        // the key of the notecard
key kGetIndexLines;        // the key of the current line

//communications
integer linkchannel = 5001;     // for recording purposes
integer dialogchannel ;         // dialog boxes
integer playchannel = 50003;    // the playback channel
integer nPrims;                 // total number of prims
integer PrimsCounter = 0;       // how many have checked in
integer timercounter = 0;       // how many seconds have gone by
integer wantname;               // flag indicating we are waiting for a name to be chatted

integer pplcounter =0;

// last heard prim params

vector primpos;
rotation primrot;

// the list of coords
list masterlist;

string curranimation;

list Menu;

integer STRIDE = 6;
integer Runtime;   // flag that we are in running mode vs learning mode

string strip( string str)
{
	return llStringTrim(str, STRING_TRIM);
}
string Getline(list Input, integer line)
{
	return strip(llList2String(Input, line));
}
DumpBack ()
{
	integer i;
	integer max = llGetListLength(masterlist);
	integer flag = 0;
	for (i = 0; i < max; i+= STRIDE)
	{
		string aniname2 = llList2String(masterlist,i);
		curranimation = aniname2;

		integer primnum2 = llList2Integer(masterlist,i+1);
		vector  sprimpos2  = llList2Vector(masterlist,i+2);
		rotation sprimrot2 = llList2Rot(masterlist,i+3) ;


		//if (debug) llOwnerSay("aniname:"+ aniname2 + " num:" +(string) primnum2 +  " pos:" + (string) sprimpos2 + " rot:" + (string) sprimrot2);
		llOwnerSay("|"+ aniname2 + "|" + (string) primnum2 + "|" + (string) sprimpos2 + "|" + (string) sprimrot2);
		flag++;
	}
	if (! flag)
		llOwnerSay("No recording!" );
}


PlayBack (string name)
{
	integer i;
	integer max = llGetListLength(masterlist);

	integer linknum = 0;

	for (i = 0; i < max; i+= STRIDE)
	{
		string aniname2 = llList2String(masterlist,i);
		if (aniname2 == name)
		{
			integer primnum2 = llList2Integer(masterlist,i+1);
			vector  sprimpos2  = llList2Vector(masterlist,i+2);
			rotation sprimrot2 = llList2Rot(masterlist,i+3) ;
			string  msg = llList2String(masterlist,i+4);
			string UUID = llList2String(masterlist,i+5);
			if (llStringLength(msg) > 0)
				llSay(0,msg);
			if (llStringLength(UUID) > 0)
				llPlaySound(UUID,1.0);

			if (primnum2 < 0)
			{
				llSleep(.5);
			}
			else
			{
				sprimrot2 /=  llGetRot();       // Add in the local rot
				//if (debug) llOwnerSay("|"+ aniname2 + " num:" +(string) primnum2 +  " pos:" + (string) sprimpos2 + " rot:" + (string) sprimrot2);

				if (primnum2 !=0)
					//llSetLinkPrimitiveParamsFast(primnum2,[PRIM_POSITION,sprimpos2,PRIM_ROTATION,sprimrot2]);
					llSetLinkPrimitiveParams(primnum2,[PRIM_POSITION,sprimpos2,PRIM_ROTATION,sprimrot2]);
				else
					//llSetPrimitiveParams([PRIM_POSITION,sprimpos2,PRIM_ROTATION,sprimrot2]);
					llSetPrimitiveParams([PRIM_POSITION,sprimpos2,PRIM_ROTATION,sprimrot2]);

			}
			//llOwnerSay((string) primnum2);
		}

	}
}
MakeMenu()
{
	list amenu = ["Reset","Record","PlayBack","Name","Dump","RemoveAll","Pause"];
	amenu += Menu;
	llDialog(llGetOwner(), "Pick a command",amenu,dialogchannel);
}
default
{
	state_entry()
	{

		nPrims = llGetNumberOfPrims();
		llOwnerSay(" Total Prims = " + (string) nPrims);

		kNoteCardLines = llGetNumberOfNotecardLines(NOTECARD);
		kGetIndexLines = llGetNotecardLine(NOTECARD,0);
		dialogchannel = (integer) (llFrand(100) +600);
		llListen(dialogchannel,"","","");
		llMessageLinked(LINK_SET,0,"Reset","");
	}

	// read notecard on bootup
	dataserver(key queryid, string data)
	{

		if (queryid == kNoteCardLines)
		{
			iIndexLines = (integer) data;
		}

		if (queryid == kGetIndexLines)
		{
			if (data != EOF)
			{

				//if (debug) llOwnerSay("Line");

				queryid = llGetNotecardLine(NOTECARD, i);
				list lLine = (llParseString2List(data, ["|"], []));
				// if (_debug )    llOwnerSay("Line = " + llDumpList2String(lLine,":"));
				string junk = llList2String(lLine,0);
				string aniname = llList2String(lLine,1);
				integer Num = (integer)Getline(lLine,2);
				vector Pos = (vector) Getline(lLine,3);
				rotation Rot = (rotation) Getline(lLine,4);
				string msg = llList2String(lLine,5);
				string UUID = llList2String(lLine,6);


				if(Num>=0)
				{
					if (llStringLength(msg) > 0)
						llSay(0,msg);
					if (llStringLength(UUID) > 0)
						llPlaySound(UUID,1.0);

					masterlist += [aniname];
					masterlist += [Num];
					masterlist += [Pos];
					masterlist += [Rot];
					masterlist += [msg];
					masterlist += [UUID];
					Rot /= llGetRot();

					llSetLinkPrimitiveParams(Num,[PRIM_POSITION,Pos,PRIM_ROTATION,Rot]);

					//llSetLinkPrimitiveParamsFast(Num,[PRIM_POSITION,Pos,PRIM_ROTATION,Rot]);
					move++;

				}
				i++;
				integer     InitPerCent = (integer) llRound(( (i+1) / (float) iIndexLines) * 100);
				llSetText("Initialising... \n" + (string) InitPerCent + "%" , <1,1,1>, 1.0);
				if (InitPerCent == 100)
					llSetText(""  , <1,1,1>, 1.0);
				kGetIndexLines = llGetNotecardLine(NOTECARD,i);
			}
			else
			{
				llOwnerSay("initialized with " + (string) move + " movements");
				llSetText(""  , <1,1,1>, 1.0);
				llMessageLinked(LINK_THIS, playchannel, "bird", "");
			}


		}
	}


	touch_start(integer total_number)
	{
		if (! Runtime && llDetectedKey(0) == llGetOwner())
		{
			MakeMenu();
		}
	}

	listen( integer channel, string name, key id, string message )
	{

		if (channel == dialogchannel)
		{
			if (message == "Reset")
			{
				masterlist = [];
				MakeMenu();
			}
			else if (message =="Pause")
			{
				masterlist += [curranimation];
				masterlist += [-1];
				masterlist += [<0,0,0>];
				masterlist += [<0,0,1>];
				masterlist += ["Pause"];
				masterlist += [""];
				MakeMenu();
			}
			else if (message == "RemoveAll")
			{
				llMessageLinked(LINK_SET,0,"Remove","");
				Runtime++;
			}
			else if (message == "Record")
			{
				PrimsCounter = 0;
				timercounter  = 0;
				llSetTimerEvent(1.0);
				llMessageLinked(LINK_SET,0,"Set","");
				MakeMenu();
			}
			else if (message == "Name")
			{
				llOwnerSay("Type the current animation name on channel /" + (string) dialogchannel);
				wantname++;
				MakeMenu();
			}
			else if (message == "PlayBack")
			{
				PlayBack(curranimation);
				MakeMenu();
			}
			else if (message == "Dump")
			{
				DumpBack();
				MakeMenu();
			}
			else if (wantname)
			{
				curranimation = message;
				MakeMenu();
				Menu += [message];
				llOwnerSay("Recording is ready for animation '" + curranimation + "'");
				llOwnerSay("Position all child  prims, then select the Menu item 'Record'. When finished, click 'PlayBack' to play back the animation, or click 'Name' to record a new animation, or click 'RemoveAll' to finish and shut down all child scripts");
				wantname = 0;
				PrimsCounter = 0;
				llMessageLinked(LINK_SET,0,"All","");
				timercounter  = 0;
				llSetTimerEvent(1.0);

			}
			else
			{
				if (debug)  llOwnerSay("Possible Animations:" + llDumpList2String(Menu,","));
				if (llListFindList(Menu,[message]) > -1)
				{
					//if (debug) llOwnerSay("Playing back animation " + message);
					PlayBack(message);
				}
			}

		}
	}

	on_rez(integer param)
	{
		llListen(dialogchannel,"","","");
	}

	link_message(integer sender_num, integer num, string message, key id)
	{


		//llOwnerSay((string) sender_num);
		if (num == 1) // They sat
		{
			if (debug) llOwnerSay(message);
			if (message == "R1" || message == "L1")
			{
				pplcounter++;
				llMessageLinked(LINK_THIS, playchannel, "stand", "");
				llSleep(0.5);
				llMessageLinked(LINK_THIS, playchannel, "down", "");
			}

			if (message == "L0"|| message == "R0")
			{
				pplcounter--;
			}
			if (pplcounter < 0)
			{
				llMessageLinked(LINK_THIS, playchannel, "stand", "");
				llSleep(1.0);
				llMessageLinked(LINK_THIS, playchannel, "bird", "");
				pplcounter = 0;
			}
		}

		else if (num == playchannel)
		{
			if (debug) llOwnerSay("playback animation " + message);
			PlayBack(message);
		}

		else if (num == linkchannel)
		{
			PrimsCounter++;
			//if(debug) llOwnerSay("link message :" + message);
			list my_list = llParseString2List(message,["|"],[""]);
			if (debug) llOwnerSay(llDumpList2String(my_list,","));

			string sprimpos  = llList2String(my_list,0);
			string sprimrot = llList2String(my_list,1);
			primpos = (vector) sprimpos;
			primrot = (rotation) sprimrot;
			if (llStringLength(curranimation) > 0)
			{

				//if (debug) llOwnerSay("Adding ani:"+ curranimation + " num:" +(string) sender_num +  " pos:" + (string) primpos + " rot:" + (string) primrot);
				masterlist += curranimation;
				masterlist += sender_num;
				masterlist += primpos;
				masterlist += primrot;
				masterlist += ""; // sounds
				masterlist += "";
				integer count = llGetListLength(masterlist) / STRIDE;
				//llOwnerSay("Recorded " + (string) count + " coords");
			}

		}
	}


	timer()
	{
		integer left = nPrims - PrimsCounter; // how many left to report in
		if (left)
			llOwnerSay((string) left + " remaining of " + (string) nPrims);
		else
		{
			llSetTimerEvent(0.0);
			llOwnerSay("Ready");
		}

		if (timercounter++ > 10)
		{
			timercounter = 0;
			PrimsCounter = 0;
			llOwnerSay("Giving up");
			llSetTimerEvent(0);
		}
	}

}

