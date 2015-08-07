// :CATEGORY:Security
// :NAME:Remove_Imposters_Revisted
// :AUTHOR:mangowylder
// :CREATED:2011-04-25 12:30:44.300
// :EDITED:2013-09-18 15:39:01
// :ID:693
// :NUM:947
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Remove_Imposters_Revisted
// :CODE:
// Inspired by Zena Juran's Remove Imposters script
// Which can be found here
// http://www.outworldz.com//freescripts.plx?ID=1535
// Ok first things first:)
// Don't bug me about using llDialog for turning it on and off
// This is just a small snippet of the script I wrote to illustrate
// a point about llOverMyLand
// llOverMyLand is buggy and should always be used with some cross checking
// with llGetParcelDetails or some other method of your choosing.
// This script is designed to work on a parcel and uses llGetParcelDetails
// to get the key of the parcel the object is on and compare it to key of the
// parcel the detected avatar is on before it takes any action.

//Mango Wylder

list    gLstParcelDetails;
list    gLstChoices = ["Turn On", "Turn Off"];
key     gKeyOwner;
key     gKeyParcel;
integer gIntChannel_Dialog;
integer gIntListen_Id;
integer gIntActive;
string  gStrOwnerName;
float   gFltRange = 96;
float   gFltScanRate = 5;


default{
	state_entry (){
		gIntChannel_Dialog = ( -1 * (integer)("0x"+llGetSubString((string)llGetKey(),-5,-1)) ); // set a negative integer chat channel for the dialog box
		gLstParcelDetails = (llGetParcelDetails(llGetPos(), [PARCEL_DETAILS_ID]));
		gKeyOwner = llGetOwner();
		gKeyParcel = llList2Key(gLstParcelDetails,0);
		gStrOwnerName = llToLower(llKey2Name(llGetOwner()));
	}

	on_rez(integer param){
		llResetScript();
	}

	touch_start(integer total_number){
		if(llDetectedKey(0) == llGetOwner()){
			llDialog(gKeyOwner, "Please make a choice.", gLstChoices, gIntChannel_Dialog);
			gIntListen_Id = llListen(gIntChannel_Dialog, "", gKeyOwner, "");
			llSetTimerEvent(20); //set a time limit to llListen
		}
		else{
			llSay (0, "You are not authorized");
		}
	}
	listen(integer channel, string name, key id, string choice){
		if(channel == gIntChannel_Dialog){
			if (~llListFindList(gLstChoices, [choice])) {  // verify dialog choice
				if (choice == "Turn On"){
					if (gIntActive == 1){
						llOwnerSay("Imposter Scanner is already armed and scanning" );
					}
					else{
						gIntActive = 1;
						llOwnerSay("Imposter Scanner is on and scanning");
						llSensorRepeat( "", "", AGENT, gFltRange, PI, gFltScanRate );
					}
					llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
				}
				if (choice == "Turn Off"){
					llSensorRemove();
					gIntActive = 0;
					llOwnerSay("Imposter Scanner is turned off");
					llListenRemove(gIntListen_Id); //remove the listen on channel_dialog

				}
			}
		}
	}

	timer()
	{ //TIME’S UP!
		llListenRemove(gIntListen_Id);
		llSetTimerEvent(0); //Stop the timer from being called repeatedly
	}

	sensor(integer nr){
		if (gIntActive == 1) {
			integer i;
			do{
				list vLstParcelDetailsI = (llGetParcelDetails(llDetectedPos(i), [PARCEL_DETAILS_ID]));
				key vKeyParcelI = llList2Key(vLstParcelDetailsI,0);
				key vKeyAvatar = llDetectedKey(i);
				string vStrAvatarName = llToLower(llGetDisplayName(vKeyAvatar));
				if((vStrAvatarName == gStrOwnerName) && (vKeyAvatar != gKeyOwner) && (gKeyParcel == vKeyParcelI)){
					llEjectFromLand(llDetectedKey(i));
				}
			}while ((++i) < nr);
		}
	}
}
