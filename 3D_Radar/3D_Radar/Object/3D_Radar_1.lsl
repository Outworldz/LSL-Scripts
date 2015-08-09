// :CATEGORY:Radar
// :NAME:3D_Radar
// :AUTHOR:Jesse Barnett
// :KEYWORDS:
// :CREATED:2010-12-27 12:41:03.763
// :EDITED:2013-09-18 15:38:46
// :ID:4
// :NUM:6
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Rezzes a ball for each avatar in range. Each ball tracks it's on AV and displays distance.
// :CODE:
// 
// This formula: vector avDivPos = (avPos - rPos) * 0.010417; Takes the (avatars position - position of scanner) & multiplies by (radius of the distance you want the balls to go(2 meter sphere = 1 meter radius)/scan range(96meters)):
// 
// 1/96 = approximately 0.010417. 

//////////////////////////////////////////////////////////////////////////////////////////////////////
//				3D Radar 2.5
// 				"Oct 15 2008", "18:43:28"
// 				Creator: Jesse Barnett
//				Released into the Public Domain
//////////////////////////////////////////////////////////////////////////////////////////////////////
 
integer Scan = TRUE;
string avKey;
integer list_pos;
list key_list;
integer key_chan;	//Key channel is generated randomly and passed to the scan ball
integer die_chan = -9423753;	//Hey pick your own channels and be sure to paste them into
						//the scan balls too!
integer key_rem_chan = -49222879;
default {
	state_entry() {
		llSetObjectName("3D Radar");
	}
	touch_start(integer total_number) {
		if (Scan) {
			llSensorRepeat("", "", AGENT, 96, PI, 1);
			key_list =[];
			llListen(key_rem_chan, "", "", "");
			llOwnerSay("on");
			Scan = FALSE;
		}
		else {
			llSensorRemove();
			llRegionSay(die_chan, "die");
			llOwnerSay("off");
			Scan = TRUE;
		}
	}
	sensor(integer iNum) {
		integer p = 0;
		for (p = 0; p < iNum; ++p) {
			avKey = llDetectedKey(p);
			list_pos = llListFindList(key_list, (list)avKey);
			if (list_pos == -1) {
				key_list += (list) avKey;
				key_chan = (integer) llFrand(-1000000) - 1000000;
				llRezObject("scan ball", llGetPos(), ZERO_VECTOR, ZERO_ROTATION, key_chan);
				llSleep(.25);
				llRegionSay(key_chan, avKey);
			}
		}
	}
	listen(integer c, string name, key id, string msg) {
		integer r = llListFindList(key_list,[(key)msg]);
		key_list = llDeleteSubList(key_list, r, r);
	}
}
