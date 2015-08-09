// :CATEGORY:Teleport
// :NAME:Teleport_Hud
// :AUTHOR:mangowylder
// :CREATED:2012-07-04 13:29:42.623
// :EDITED:2013-09-18 15:39:06
// :ID:872
// :NUM:1232
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Drop this script into a hud
// :CODE:
// Teleport Hud script
//
// This script grabs your postion, with the name you set, in the form of a SL teleport app URL.
// No notecard. Teleport anywhere.
// It is designed to be used in a hud and will open an llDialog box to grab SLurls and show SLurls
// in local chat. Just click on the generated SLurl in the chat window to teleport anywhere.
// Uses llTextBox for user input to enter the names of the SLurls to add or delete.
// As always try to keep the names between 10-12 characters because of the dialog box size limitation.
// As written it will store and show 21 SLurls. 10 in the first llDialog box and 11 in the second LLDialog box.
// If you have SLurls in the second dialog box list and delete a SLurl from the first dialog box list
// the first entry from the second list will be moved to the last entry of the first list.
// List SLurls in case you make the name too long for the dialog box to display and you need
// the correct name to delete the SLurl. Names are case sensitive.

// Note - With llTextbox input do not hit the enter key! Just type in the name and click submit.

// Written by Mango Wylder except where noted.

// Mango Wylder //

//Globals//
list    gLstChoices = ["Grab SLurl", "Show SLurls", "Del SLurl", "Cancel", "Reset", "ListSlurls"];
list    gLstChoicesMore = ["<< Back"];
list    gLstChoicesMore1 = ["<<< Back"];
list    gLstForbidden = ["<< Back", "More", "<<< Back"];
list    gLstSLurls;
list    gLstSLurls1;
key     gKeyToucherID;
integer gIntSlurls = 10;
integer gIntSlurls1 = 11;
integer gIntChannel_Dialog;
integer gIntChannel_Dialog1;
integer gIntListen_Id;
integer gIntListen_Id_Chat;
integer gIntGrabSlurl;
integer gIntDelSLurl;
integer gIntDialog = 0;
integer gIdxLst;
integer gIdxLstDel;
string  gStrPlace;
string  gStrPlacePos;
string  gStrGenSLurl;

// This function was snagged from http://wiki.secondlife.com/wiki/SLURL_HUD //
// and modified with three hashes for the teleport app URL //
// Mango Wylder //

string gen_slurl() {
	string regionname = llDumpList2String(llParseString2List(llGetRegionName(),[" "],[]),"%20");
	vector pos = llGetPos();
	integer x = (integer)pos.x;
	integer y = (integer)pos.y;
	integer z = (integer)pos.z;
	return "secondlife:///app/teleport/"+regionname+"/"+(string)x+"/"+(string)y+"/"+(string)z+"/";
}

default{
	state_entry() {
		gIntChannel_Dialog = ( -1 * (integer)("0x"+llGetSubString((string)llGetKey(),-5,-1)) ); // set a negative integer chat channel for the dialog box
		gIntChannel_Dialog1 = ( -1 * (integer)("0x"+llGetSubString((string)llGetKey(),-8,-1)) ); // set a negative integer chat channel for the text box
	}

	touch_start(integer total_number) {
		gKeyToucherID = llDetectedKey(0);
		llDialog(gKeyToucherID, "Please make a choice.\n Clicking on Reset will reset the script\n and you will loose all save SLURLS!\n Please select Cancel instead of Ignore", gLstChoices, gIntChannel_Dialog);
		gIntListen_Id = llListen(gIntChannel_Dialog, "", gKeyToucherID, "");
		llSetTimerEvent(20); //set a time limit to llListen
	}

	listen(integer channel, string name, key id, string choice) {
		if(channel == gIntChannel_Dialog) {
			if (~llListFindList(gLstChoices, [choice])) { // verify dialog choice
				if (choice == "Show SLurls")
					if (llGetListLength(gLstChoicesMore) == 1)  {
						llOwnerSay("There are no SLurls to show. Try adding a SLurl first!");
					}
				else
					llDialog(gKeyToucherID, "Clicking on a SLurl will open a \n teleport link in Local Chat (CTRL H)", gLstChoicesMore, gIntChannel_Dialog);

				else if (choice == "Grab SLurl") {
					if (gIntDialog == 0) { // ensure we should be here
						if (llGetListLength(gLstSLurls) >= gIntSlurls) { //  Max of 10 Slurls in list one reached so add the More button
							gLstChoicesMore =  gLstChoicesMore + ["More"]; // add the More button to the end of the first SLurl name list
							// set condition to check the size of the second SLurls list and allow adding to it
							gIntDialog = 1;
						}
						else {
							gIntGrabSlurl = 1; // set condition to check if allowed to add to SLurl lists
							gIntListen_Id_Chat = llListen(gIntChannel_Dialog1, "", gKeyToucherID, "");
							llTextBox(gKeyToucherID,"Please enter a name for this Slurl",gIntChannel_Dialog1 );
							llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
						}
					}
					if (gIntDialog == 1) { // ensure we should be here
						if (llGetListLength(gLstSLurls1) >= gIntSlurls1) { //max of 21 SLurls reached
							llOwnerSay("You have reached the maximum allowed SLurls!");
							llOwnerSay("Please delete a SLurl if you would like to add another.");
						}
						else {
							gIntGrabSlurl = 1; // set condition to check if allowed to add to SLurl lists
							gIntListen_Id_Chat = llListen(gIntChannel_Dialog1, "", gKeyToucherID, "");
							llTextBox(gKeyToucherID,"Please enter the name of the Slurl you want to Add",gIntChannel_Dialog1 );
							llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
						}
					}
				}
				else if (choice == "Del SLurl") {
					if (gLstSLurls == []) {
						llOwnerSay("There are no SLurls to delete");
					}
					else {
						gIntListen_Id_Chat = llListen(gIntChannel_Dialog1, "", gKeyToucherID, "");
						llTextBox(gKeyToucherID,"Please enter the name of the Slurl you want to Delete",gIntChannel_Dialog1 );
						gIntDelSLurl = 1; // set condition to check if allowed to delete from SLurl lists
						llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
					}
				}
				else if (choice == "ListSlurls") {
					if (llGetListLength(gLstSLurls) == 0 ) {
						llOwnerSay("There are no Slurls to list");
					}
					else if (llGetListLength(gLstSLurls) >= 0 ) {
						if (~llListFindList(gLstChoicesMore, ["More"])){
							list vlstTempList = llList2List(gLstChoicesMore, 1, -2);
							llOwnerSay(llList2CSV(vlstTempList));
							vlstTempList = [];
						}

						else {
							list vlstTempList = llList2List(gLstChoicesMore, 1, -1);
							llOwnerSay(llList2CSV(vlstTempList));
							vlstTempList = [];
						}
						if (llGetListLength(gLstSLurls1) >=1 ) {
							list vlstTempList1 = llList2List(gLstChoicesMore1, 1, -1);
							llOwnerSay(llList2CSV(vlstTempList1));
							vlstTempList1 = [];
						}
					}
				}
				else if (choice == "Cancel") { // user cancels so kill the listen
					llListenRemove(gIntListen_Id);
				}
				else if (choice == "Reset") { // reset the script
					llListenRemove(gIntListen_Id);
					llResetScript();
				}
			}

			if (~llListFindList(gLstChoicesMore, [choice])){ // find the index of choice in the first list
				gIdxLst = (llListFindList(gLstChoicesMore, [choice]));
				gStrPlace = (llList2String(gLstChoicesMore, gIdxLst));
				// - 1 from the index found in the name list because the name list will always have a back button
				gStrPlacePos = llList2String(gLstSLurls, gIdxLst - 1);
				if (choice == "<< Back") {
					llDialog(gKeyToucherID, "Please make a choice.\n Clicking on Reset will reset the script\n and you will loose all save SLURLS!\n Please select Cancel instead of Ignore", gLstChoices, gIntChannel_Dialog); // present main menu on request to go back
				}
				else if (choice == "More") {
					llDialog(gKeyToucherID, "Clicking on a SLurl will open a \n teleport link in Local Chat (CTRL H)", gLstChoicesMore1, gIntChannel_Dialog); // present submenu on request
				}
				else {
					llOwnerSay("Click here to teleport to " + gStrPlace + ":  " + gStrPlacePos);
					llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
				}
			}

			else if (~llListFindList(gLstChoicesMore1, [choice])){ // find the index of choice in the second list
				gIdxLst = (llListFindList(gLstChoicesMore1, [choice]));
				gStrPlace = (llList2String(gLstChoicesMore1, gIdxLst));
				// - 1 from the index found in the name list because the name list will always have a back button
				gStrPlacePos = llList2String(gLstSLurls1, gIdxLst - 1);
				if (choice == "<<< Back") {
					llDialog(gKeyToucherID, "Clicking on a SLurl will open a \n teleport link in Local Chat (CTRL H)", gLstChoicesMore, gIntChannel_Dialog); // present main menu on request to go back
				}
				else {
					llOwnerSay("Click here to teleport to " + gStrPlace + ":  " + gStrPlacePos);
					llListenRemove(gIntListen_Id); //remove the listen on channel_dialog
				}
			}
		}

		// end channel dialog
		// start channel dialog1

		if(channel == gIntChannel_Dialog1){
			// here's where we grab the SLurl info
			if (gIntGrabSlurl == 1){ // ensure we should be here
				if (choice == ""){
					llOwnerSay("You must enter a name for this SLurl!");
					llOwnerSay("Add SLurl operation aborted. Please try again");
					llListenRemove(gIntListen_Id_Chat);
				}
				else if (gIntDialog == 0) { // check to see if we should be adding to the first SLurl list
					gLstChoicesMore = gLstChoicesMore + [choice]; // add the SLurl name to the end of the list
					gStrGenSLurl = (gen_slurl());
					gLstSLurls =  gLstSLurls + [gStrGenSLurl] ; // add the SLurl pos to the end of the list
					gIntGrabSlurl = 0; // done grabbling the SLurl so let's not end up here agian unless Grab SLurl is clicked
					llOwnerSay("SLurl " + choice + " Saved!");
					llListenRemove(gIntListen_Id_Chat);
				}
				else  if (gIntDialog == 1) { // check to see if we should be adding to the second SLurl list
					gLstChoicesMore1 = gLstChoicesMore1 + [choice]; // add the SLurl name to the end of the list
					gStrGenSLurl = (gen_slurl());
					gLstSLurls1 =  gLstSLurls1 + [gStrGenSLurl] ; // add the SLurl pos to the end of the list
					gIntGrabSlurl = 0; // done grabbling the SLurl so let's not end up here agian unless Grab SLurl is clicked
					llOwnerSay("SLurl " + choice + " Saved!");
					llListenRemove(gIntListen_Id_Chat);
				}
			}
			// here's where we delete the SLurl info
			if  (gIntDelSLurl == 1) { // ensure we should be here
				if (choice == ""){
					llOwnerSay("You must enter a name for this SLurl!");
					llOwnerSay("Delete SLurl operation aborted. Please try again");
					llListenRemove(gIntListen_Id_Chat);
					return;
				}
				gIdxLstDel = (llListFindList(gLstChoicesMore + gLstChoicesMore1, [choice]));
				if (gIdxLstDel == -1) {
					llOwnerSay ("That SLurl isn't in the list. Please try Again");
					gIntDelSLurl = 0;
					llListenRemove(gIntListen_Id_Chat);
				}
				if (~llListFindList(gLstForbidden, [choice])){ // prevent the user from deleting navigation buttons
					llOwnerSay("Naughty, Naughty!. You can't remove that button!)");
					gIntDelSLurl = 0;
				}
				else if (~llListFindList(gLstChoicesMore, [choice])){ // look for the name in the first SLurl list
					gIdxLstDel = (llListFindList(gLstChoicesMore, [choice]));
					gLstChoicesMore = llDeleteSubList(gLstChoicesMore, gIdxLstDel,gIdxLstDel);
					// index below is -1 because the SLurl name list will always have the Back button
					gLstSLurls = llDeleteSubList(gLstSLurls, gIdxLstDel - 1 ,gIdxLstDel - 1);
					// We deleted the SLurl from the first SLurl list so check if there are SLurls in the second list
					// and move the first one to the end of the first SLurl list
					if (llGetListLength(gLstChoicesMore1) >= 1) { // there is more than the Back button so a SLurl is in the list
						string vStrTemp1 = llList2String(gLstChoicesMore1, 1);
						// Insert the SLurl name before the More button on the first SLurl list
						gLstChoicesMore = llListInsertList(gLstChoicesMore, [vStrTemp1], -1);
						string vStrTemp2 = llList2String(gLstSLurls1, 0);
						// Insert the SLurl position at the end of the first SLurl postion list
						gLstSLurls = llListInsertList(gLstSLurls, [vStrTemp2], gIntSlurls);
						// delete the SLurl name and postion from the second SLurl lists
						// using the first position in the lists for each
						gLstSLurls1 = llDeleteSubList(gLstSLurls1, 0 , 0);
						// index 1 because of the Back button
						gLstChoicesMore1 = llDeleteSubList(gLstChoicesMore1, 1, 1);
					}
					// only the back button is in the second list so we can delete the More button in the first list
					if (llGetListLength(gLstChoicesMore1) == 1) {
						if  (~llListFindList(gLstChoicesMore, ["More"])){
							gIdxLstDel = (llListFindList(gLstChoicesMore, ["More"]));
							gLstChoicesMore = llDeleteSubList(gLstChoicesMore, gIdxLstDel,gIdxLstDel);
							// no SLurls in the second list so set condition to add to first list on next Grab SLurl click
							gIntDialog = 0;
						}
					}
					llOwnerSay ("SLurl " + choice + " removed");
					gIntDelSLurl = 0;
					llListenRemove(gIntListen_Id_Chat);
				}
				else if  (~llListFindList(gLstChoicesMore1, [choice])){ // look for the name in the second SLurl list
					gIdxLstDel = (llListFindList(gLstChoicesMore1, [choice]));
					gLstChoicesMore1 = llDeleteSubList(gLstChoicesMore1, gIdxLstDel,gIdxLstDel);
					gLstSLurls1 = llDeleteSubList(gLstSLurls1, gIdxLstDel - 1 ,gIdxLstDel - 1);
					// we have deleted the last SLurl in the second list so no need for the More button in the first list
					if (llGetListLength(gLstChoicesMore1) == 1) {
						if  (~llListFindList(gLstChoicesMore, ["More"])){
							gIdxLstDel = (llListFindList(gLstChoicesMore, ["More"]));
							gLstChoicesMore = llDeleteSubList(gLstChoicesMore, gIdxLstDel,gIdxLstDel);
							// no SLurls in the second list so set condition to add to first list on next Grab SLurl click
							gIntDialog = 0;
						}
					}
					llOwnerSay ("SLurl " + choice + " removed");
					gIntDelSLurl = 0;
					llListenRemove(gIntListen_Id_Chat);
				}
			}
		}
	}

	timer() { //TIMES UP!
		llListenRemove(gIntListen_Id_Chat);
		llListenRemove(gIntListen_Id);
		llSetTimerEvent(0); //Stop the timer from being called repeatedly
	}
}
