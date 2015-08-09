// :CATEGORY:Radar
// :NAME:3D_Radar
// :AUTHOR:Jesse Barnett
// :KEYWORDS:
// :CREATED:2010-12-27 12:41:03.763
// :EDITED:2013-09-18 15:38:46
// :ID:4
// :NUM:7
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// DESCRIPTION: []::Rezzes a ball for each avatar in range. Each ball tracks it's on AV and displays distance
// :CODE:
// Place this script in a prim and then place the prim into the inventory of the Scanner/Rezzer. It will automatically name itself.// // Suggestion; Create a sphere prim of 0.05 diameter with glow set about .80. 
//////////////////////////////////////////////////////////////////////////////////////////////////////
//				3D Radar 2.5
// 				"Oct 15 2008", "18:44:36"
// 				Creator: Jesse Barnett
//				Released into the Public Domain
//////////////////////////////////////////////////////////////////////////////////////////////////////
 
string avName;
integer avDistance;
key avKey;
integer avListen;
integer key_chan;
integer die_chan = -9423753;
integer key_rem_chan = -49222879;
vector avPos;
vector rPos;
default {
	state_entry() {
		llSetObjectName("scan ball");
	}
	on_rez(integer start_param) {
		rPos = llGetPos();
		key_chan = start_param;
		llListen(die_chan, "", "", "");
		avListen = llListen(key_chan, "", "", "");
	}
	listen(integer c, string n, key id, string msg) {
		if (c == die_chan)
			llDie();
		else {
			avKey = (key) msg;
			avName = llKey2Name(avKey);
			llSensorRepeat("", avKey, AGENT, 96, PI, 1.0);
			llListenRemove(avListen);
		}
	}
	sensor(integer n) {
		avPos = llDetectedPos(0);
		vector avDivPos = (avPos - rPos) / (96 / 1);	//Scan range/Radius of large sphere
		avDistance = (integer) llVecDist(rPos, llDetectedPos(0));
		llSetPos(rPos + avDivPos);
		llSetText(avName + "[" + (string) avDistance + "]", <1, 1, 1 >, 1);
	}
	no_sensor() {
		llRegionSay(key_rem_chan, avKey);
		llDie();
	}
}
