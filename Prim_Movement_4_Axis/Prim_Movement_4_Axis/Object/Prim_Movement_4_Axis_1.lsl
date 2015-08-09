// :CATEGORY:Movement
// :NAME:Prim_Movement_4_Axis
// :AUTHOR:mangowylder
// :CREATED:2012-05-07 18:34:44.200
// :EDITED:2013-09-18 15:39:00
// :ID:653
// :NUM:889
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Try it on a prim with the following dimensions// X = .01 Y = 5.0 Z =5.0
// :CODE:
// Move a prim on four axis
// Z = Up Down, X = Forward Back, Y = Left Right, Rotate Left & Right around Z axis
// Moves .2 meters X, Y and Z
// Rotates 5 degrees around the Z axis
// Persistent LLDialog until user cancel

// Best illustrated using a flat board with the following dimensions
// Z = 5, X = .01, Y = 5
// Anyone that has played the now (05/07/12) defunct Byngo Bonus game
// will recognize this type of board movement

// Written by Mango Wylder

list    gLstChoices = ["MoveDown", "MoveRight", "MoveBack", "MoveUp", "MoveLeft", "MoveForward", "RotateLeft", "RotateRight", "Cancel"];
integer gIntChannel_Dialog;
integer gIntListen_Id;
integer gIntMove = 1;
integer gIntVr;
key     gKeyToucherID;
float   gFltX;
float   gFltY;
float   gFltZ;
vector  gVecPos;
vector  gEul = <0,0,0>;


default
{
	state_entry()
	{
		gIntChannel_Dialog = ( -1 * (integer)("0x"+llGetSubString((string)llGetKey(),-5,-1)) ); // set a negative integer chat channel for the dialog box
	}

	touch(integer total_number){
		gKeyToucherID = llDetectedKey(0);
		llDialog(gKeyToucherID, "Please make a choice.", gLstChoices, gIntChannel_Dialog);
		gIntListen_Id = llListen(gIntChannel_Dialog, "", gKeyToucherID, "");
		llSetTimerEvent(20); // set a time limit to llListen
		// Adding .x .y or .z after the vector name can be used to get the float value of just that axis.
		gVecPos = llGetPos();
		gFltX = gVecPos.x; // <--- Like this.
		gFltY = gVecPos.y;
		gFltZ = gVecPos.z;
	}
	listen(integer channel, string name, key id, string choice) {
		if(channel == gIntChannel_Dialog) {
			if (~llListFindList(gLstChoices, [choice])) { // verify dialog choice
				if (choice == "Cancel"){
					llListenRemove(gIntListen_Id);
				}
				else if (choice == "MoveUp"){
					gFltZ = gFltZ + .2;
					llSetPos (< gFltX,gFltY,gFltZ>);
					llDialog(gKeyToucherID, "Please make a choice.", gLstChoices, gIntChannel_Dialog);
				}
				else if (choice == "MoveDown"){
					gFltZ = gFltZ - .2;
					llSetPos (< gFltX,gFltY,gFltZ>);
					llDialog(gKeyToucherID, "Please make a choice.", gLstChoices, gIntChannel_Dialog);
				}
				else if (choice == "MoveLeft"){
					gFltY = gFltY - .2;
					llSetPos (< gFltX,gFltY,gFltZ>);
					llDialog(gKeyToucherID, "Please make a choice.", gLstChoices, gIntChannel_Dialog);
				}
				else if (choice == "MoveRight"){
					gFltY = gFltY + .2;
					llSetPos (< gFltX,gFltY,gFltZ>);
					llDialog(gKeyToucherID, "Please make a choice.", gLstChoices, gIntChannel_Dialog);
				}
				else if (choice == "MoveForward"){
					gFltX = gFltX + .2;
					llSetPos (< gFltX,gFltY,gFltZ>);
					llDialog(gKeyToucherID, "Please make a choice.", gLstChoices, gIntChannel_Dialog);
				}
				else if (choice == "MoveBack"){
					gFltX = gFltX - .2;
					llSetPos (< gFltX,gFltY,gFltZ>);
					llDialog(gKeyToucherID, "Please make a choice.", gLstChoices, gIntChannel_Dialog);
				}
				else if (choice == "RotateLeft"){
					gIntVr = gIntVr - 5;
					gEul = <0,0,gIntVr>; //5 degrees around the z-axis, in Euler form
					gEul *= DEG_TO_RAD; //convert to radians
					rotation quat = llEuler2Rot(gEul); //convert to quaternion
					llSetRot(quat); //rotate the object
					llDialog(gKeyToucherID, "Please make a choice.", gLstChoices, gIntChannel_Dialog);
				}
				else if (choice == "RotateRight"){
					gIntVr = gIntVr + 5;
					gEul = <0,0,gIntVr>; //5 degrees around the z-axis, in Euler form
					gEul *= DEG_TO_RAD; //convert to radians
					rotation quat = llEuler2Rot(gEul); //convert to quaternion
					llSetRot(quat); //rotate the object
					llDialog(gKeyToucherID, "Please make a choice.", gLstChoices, gIntChannel_Dialog);
				}
			}
		}
	}
	timer() { //TIME’S UP!
		llListenRemove(gIntListen_Id);
		llSetTimerEvent(0); //Stop the timer from being called repeatedly
	}
}


