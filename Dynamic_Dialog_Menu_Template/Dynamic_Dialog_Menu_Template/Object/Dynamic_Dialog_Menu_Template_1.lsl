// :CATEGORY:Dialog
// :NAME:Dynamic_Dialog_Menu_Template
// :AUTHOR:mangowylder
// :CREATED:2011-04-18 15:32:37.273
// :EDITED:2013-09-18 15:38:52
// :ID:266
// :NUM:357
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Dynamic_Dialog_Menu_Template
// :CODE:
// This is a template script that will allow you to dynamically add
// or delete buttons from LLDialog boxes.
// In and of itself it does nothing more than to allow you to add/delete buttons with names
// and click on the buttons to tell you the button name you clicked on.
// However once those buttons are generated and named you can add functions
// to them so that they do usefull stuff.
// Maximum of 21 buttons. llDialog boxes can have a maximum of 12 buttons.
// 10 buttons in gLstChoicesButtons because it will always have the << Back button
// and the dynamicaly generated More button when gIntButtons is reached.
// 11 buttons in gLstChoicesButtons1 because it will always have the <<< Back button
// Max button vales are set at 3 and 4 for testing purposes.

// Written by,
// Mango Wylder //

//Globals//
list    gLstChoices = ["Add Button", "ShowButtons", "Del Button"];
list    gLstChoicesButtons = ["<< Back"];
list    gLstChoicesButtons1 = ["<<< Back"];
// list to prevent the user from deleting the hard coded back buttons
// or the dynamically generated More button
list    gLstForbidden = ["<< Back", "More", "<<< Back"];
integer gIntButtons = 3;
integer gIntButtons1 = 4;
integer gIntChannel_Dialog;
integer gIntChannel_Chat;
integer gIntListen_Id;
integer gIntListen_Id_Chat;
integer gIntAddButton;
integer gIntDelButton;
integer gIntDialog = 0;
string  gStrButton;
key     gKeyToucherID;

default{
	state_entry() {
		gIntChannel_Dialog = ( -1 * (integer)("0x"+llGetSubString((string)llGetKey(),-5,-1)) ); // set a negative integer chat channel for the dialog box
		gIntChannel_Chat = 7; // Set a chat channel to listen to owners commands
	}

	touch_start(integer total_number) {
		gKeyToucherID = llDetectedKey(0);
		llDialog(gKeyToucherID, "Please make a choice.", gLstChoices, gIntChannel_Dialog);
		gIntListen_Id = llListen(gIntChannel_Dialog, "", gKeyToucherID, "");
		llSetTimerEvent(20); // set a time limit to llListen
	}

	listen(integer channel, string name, key id, string choice) {
		if(channel == gIntChannel_Dialog) {
			if (~llListFindList(gLstChoices, [choice])) { // verify dialog choice
				if (choice == "ShowButtons"){
					// we know there are no buttons because list length is 1 and
					// that's the << Back button
					if (llGetListLength(gLstChoicesButtons) == 1)  {
						llOwnerSay("There are no Buttons to show. Try adding a button first!");
					}
					else
						llDialog(gKeyToucherID, "What do you want to do?", gLstChoicesButtons, gIntChannel_Dialog);
				}
				if (choice == "Add Button") {
					if (gIntDialog == 0) {
						if (llGetListLength(gLstChoicesButtons) >= gIntButtons) {
							// we have reached the maximum amount of buttons allowed in
							// gLstChoicesButtons so we add a More button so we can
							// see what's on gLstChoicesButtons1
							gLstChoicesButtons =  gLstChoicesButtons + ["More"];
							gIntDialog = 1;
						}
						else {
							gIntAddButton = 1;
							llOwnerSay ("Please enter a name for this Button in Local Chat on Channel /7");
							gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, "");
							llListenRemove(gIntListen_Id); // remove the listen on channel_dialog
						}
					}
					if (gIntDialog == 1) {
						if (llGetListLength(gLstChoicesButtons1) >= gIntButtons1) {
							llOwnerSay("You have reached the maximum allowed Buttons!");
							llOwnerSay("Please Delete a Button if you would like to add another.");
						}
						else {
							gIntAddButton = 1;
							llOwnerSay ("Please enter a name for this Button");
							gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, "");
							llListenRemove(gIntListen_Id); // remove the listen on channel_dialog
						}
					}
				}
				if (choice == "Del Button") {
					// we know there are no buttons to delete because list length is 1
					// and that's the << Back button
					if (llGetListLength(gLstChoicesButtons) == 1)  {
						llOwnerSay("There are no Buttons to delete");
					}
					else {
						llOwnerSay ("Please enter a name for Button you want to Delete on Channel /7");
						gIntListen_Id_Chat = llListen(gIntChannel_Chat, "", gKeyToucherID, "");
						gIntDelButton = 1;
						llListenRemove(gIntListen_Id); // remove the listen on channel_dialog
					}
				}
			}

			if (~llListFindList(gLstChoicesButtons, [choice])){ // is choice here? 10 choices can be here
				integer x = (llListFindList(gLstChoicesButtons, [choice]));
				gStrButton = (llList2String(gLstChoicesButtons, x));
				if (choice == "<< Back") {
					llDialog(gKeyToucherID, "What do you want to do?", gLstChoices, gIntChannel_Dialog);
				}
				else if (choice == "More") {
					llDialog(gKeyToucherID, "What do you want to do?", gLstChoicesButtons1, gIntChannel_Dialog);
				}
				else {
					//Do something useful here//
					llOwnerSay("You have pushed the " + gStrButton+ " button");
				}
			}

			if (~llListFindList(gLstChoicesButtons1, [choice])){ // or is choice here? 11 choices can be here
				integer y = (llListFindList(gLstChoicesButtons1, [choice]));
				gStrButton = (llList2String(gLstChoicesButtons1, y));
				if (choice == "<<< Back") {
					llDialog(gKeyToucherID, "What do you want to do?", gLstChoicesButtons, gIntChannel_Dialog);
				}
				else {
					//Do something useful here//
					llOwnerSay("You have pushed the " + gStrButton+ " button");

				}
			}
		}
		// end channel dialog

		if(channel == gIntChannel_Chat){
			// Add Buttons section
			if (gIntAddButton == 1){
				if (gIntDialog == 0) {
					gLstChoicesButtons = gLstChoicesButtons + [choice];
					gIntAddButton = 0;
					llOwnerSay("Button " + choice + " Saved!");
					llListenRemove(gIntListen_Id_Chat);
				}
				if (gIntDialog == 1) {
					gLstChoicesButtons1 = gLstChoicesButtons1 + [choice];
					gIntAddButton = 0;
					llOwnerSay("Button " + choice + " Saved!");
					llListenRemove(gIntListen_Id_Chat);
				}
			}
			// Delete Buttons section
			if  (gIntDelButton == 1) {
				integer i = (llListFindList(gLstChoicesButtons + gLstChoicesButtons1, [choice]));
				if (i == -1) {
					llOwnerSay ("That Button doesn't exist!. Please try again.");
					gIntDelButton = 0;
					llListenRemove(gIntListen_Id_Chat);
				}
				// prevent the user from deleting the hard coded back buttons
				// or the dynamically generated More button
				if (~llListFindList(gLstForbidden, [choice])){
					llOwnerSay("Naughty, Naughty!. You can't remove that button!)");
					gIntDelButton = 0;
				}
				else if (~llListFindList(gLstChoicesButtons, [choice])){
					//if ((gIdxLstDel = (~llListFindList(gLstChoicesMore, [choice])))){
					integer j = (llListFindList(gLstChoicesButtons, [choice]));
					gLstChoicesButtons = llDeleteSubList(gLstChoicesButtons, j,j);
					llOwnerSay ("Button " + choice + " removed");
					gIntDelButton = 0;
					llListenRemove(gIntListen_Id_Chat);
				}
				else if  (~llListFindList(gLstChoicesButtons1, [choice])){
					integer k = (llListFindList(gLstChoicesButtons1, [choice]));
					gLstChoicesButtons1 = llDeleteSubList(gLstChoicesButtons1, k,k);
					// if only the <<< Back button exists in gLstChoicesButtons1
					// we have no need for the More button in gLstChoicesButtons
					// so if it's there, delete it.
					if (llGetListLength(gLstChoicesButtons1) == 1) {
						if  (~llListFindList(gLstChoicesButtons, ["More"])){
							integer l = (llListFindList(gLstChoicesButtons, ["More"]));
							gLstChoicesButtons = llDeleteSubList(gLstChoicesButtons, l,l);
							gIntDialog = 0;
						}
					}
					llOwnerSay ("Button " + choice + " removed");
					gIntDelButton = 0;
					llListenRemove(gIntListen_Id_Chat);
				}
			}
		}
	}

	timer() { //TIME’S UP!
		llListenRemove(gIntListen_Id_Chat);
		llListenRemove(gIntListen_Id);
		llSetTimerEvent(0); //Stop the timer from being called repeatedly
	}
}
