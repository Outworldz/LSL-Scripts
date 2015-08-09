// :CATEGORY:Movement
// :NAME:Parachute_Platform
// :AUTHOR:mangowylder
// :CREATED:2012-05-07 13:12:54.403
// :EDITED:2013-09-18 15:38:59
// :ID:605
// :NUM:829
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Parachute Platform Script// Mango Wylder
// :CODE:
// Parachute platform script (updated)
//
// Max height is 4000 meters.
// Uses LLDialog for menu and LLTextBox for user input
// Click the home button to return to original rez position
// When the last avi leaves the platform it will return to it's
// home postion

// Written by Mango Wylder except where noted
//
// function AvCount by Donjr Spiegelblatt
//
// Replaced warpos function with llSetRegionPos as
// suggested by Donjr Spiegelblatt

// changed all "Say/IM's" to llRegionSayTo
// Added sanity check so that an avi has to be on the platform
// to move it



list    gLstChoices = ["MoveUp", "Home", "Cancel"];
integer gIntChannel_Dialog;
integer gIntChannel_Dialog1;
integer gIntListen_Id;
integer gIntListen_Id_Chat;
key     gKeyToucherID;
vector  gCurrentPos;
vector  gHomePos;
vector  destPos;
float   gZv;
float   X;
float   Y;
float   Z;


integer AvCount()
{
	// returns the number of avatars sitting on the object
	return llGetNumberOfPrims() - llGetObjectPrimCount(llGetLinkKey(!!llGetLinkNumber()));
}

default{
	on_rez(integer start_param){
		llResetScript();
	}
	state_entry(){
		gHomePos = llGetPos();
		gIntChannel_Dialog = ( -1 * (integer)("0x"+llGetSubString((string)llGetKey(),-5,-1)) ); // set a negative integer chat channel for the dialog box
		gIntChannel_Dialog1 = ( -1 * (integer)("0x"+llGetSubString((string)llGetKey(),-8,-1)) ); //set a negative integer chat channel for the text box
	}
	changed(integer change){ // determine when the last avi stands up and send platform home
		if (change & CHANGED_LINK) {
			if(AvCount() == 0){
				destPos = gHomePos;
				llSetRegionPos(destPos);
			}
		}
	}

	touch_start(integer total_number){
		gKeyToucherID = llDetectedKey(0);
		llDialog(gKeyToucherID, "Please make a choice.", gLstChoices, gIntChannel_Dialog);
		gIntListen_Id = llListen(gIntChannel_Dialog, "", gKeyToucherID, "");
		llSetTimerEvent(20); // set a time limit to llListen
		// Adding .x .y or .z after the vector name can be used to get the float value of just that axis.
		gCurrentPos = llGetPos();
		X = gCurrentPos.x;
		Y = gCurrentPos.y;
		Z = gCurrentPos.z; // <--- Like this
	}

	listen(integer channel, string name, key id, string choice) {
		if(channel == gIntChannel_Dialog) {
			if (~llListFindList(gLstChoices, [choice])) { // verify dialog choice
				if (choice == "Cancel"){
					llListenRemove(gIntListen_Id);
				}
				else if (choice == "MoveUp"){
					if(AvCount() == 0){
						llRegionSayTo(gKeyToucherID, 0,"I'm not going anywhere until someone sits on me!");
						llRegionSayTo(gKeyToucherID, 0,"MoveUp operation aborted. Please try again");
						llListenRemove(gIntListen_Id_Chat);
						return;
					}
					gIntListen_Id_Chat = llListen(gIntChannel_Dialog1, "", gKeyToucherID, "");
					llTextBox(gKeyToucherID,"Please enter a height in meters",gIntChannel_Dialog1 );
					llListenRemove(gIntListen_Id);
				}
				else if (choice == "Home"){
					llSetRegionPos(gHomePos);
				}
			}
		}

		if(channel == gIntChannel_Dialog1){
			if (choice == "") { // Check for user input // Alpha character input will be ignored
				llRegionSayTo(gKeyToucherID, 0,"Please enter a height!");
				llRegionSayTo(gKeyToucherID, 0,"MoveUp operation aborted. Please try again");
				llListenRemove(gIntListen_Id_Chat);
			}
			else{
				gZv = (float) (choice); // Typecast string to float
				Z = Z + gZv;
				if (Z >= 4000){ // 4000 meters is max height for this script
					Z = 4000;
					llRegionSayTo(gKeyToucherID, 0, "That height exceeds the limit of 4000 meters!" + " Setting height to 4000 meters.");
					destPos = (<X,Y,Z>);
					llSetRegionPos(destPos);
				}
				else{
					destPos = (<X,Y,Z>);
					llSetRegionPos (destPos);
				}
			}
		}
	}

	timer() { //TIME’S UP!
		llListenRemove(gIntListen_Id);
		llSetTimerEvent(0); //Stop the timer from being called repeatedly
	}
}
