// :CATEGORY:Menu
// :NAME:multi_note_card_reading
// :AUTHOR:heskemo oyen
// :CREATED:2010-10-04 01:54:24.070
// :EDITED:2013-09-18 15:38:57
// :ID:530
// :NUM:715
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// reload key is censored.
// :CODE:
integer reload_key = 000000;
integer CALL_DEBUG = 10011111;
//===============================================================
//
//                    menu buttons
//
//===============================================================
string btn_about = "ABOUT";
string btn_load = "LOAD.D";
string btn_close_menu = "BACK";
string btn_permssion = "PERM";
string btn_next = "NEXT";
string btn_prev = "PREV";
string btn_1 = "[1]";
string btn_2 = "[2]";
string btn_3 = "[3]";
string btn_4 = "[4]";
string btn_instruction = "HELP";
string btn_off = "OFF";
string btn_close = "CLOSE";
string btn_group = "GROUP";
string btn_owner = "OWNER";
string btn_public = "PUBLIC";
string btn_debug = "DEBUG";
string btn_on ="ON";
string btn_texture ="TEXTURE";
string btn_sculpt = "SCULPT";
string btn_option ="OPTION";
//
integer MENU_HANDLE;
integer MENU_CHANNEL;
string calllistener;
integer debug=TRUE;
integer isMenuSIMPLE=FALSE;
integer permissionOptions=0;
//
integer group;
key agent;
key objectowner;
string requestagentname;
string textabout="copyright 2010 HKM Gears. \n more to come! www.hkm.com";
string textload ="there are lists of notecards to read";
string textmenu="This is the gear menu with the heavy weapons";
string textoption="Ooops extra functions options but its not neccessary.";
string textdebug="the debug functions is there";
string textpermission="this gives the control of this device.";
//===============================================================
list MAIN_SIMPLE = [btn_about,btn_load];
list MAIN_ADVANCE = [
	btn_about,
	btn_load,
	btn_option
		];
list M_btn_option = [
	btn_permssion,
	btn_debug,
	btn_instruction,
	btn_close_menu
		];
list M_btn_permssion = [
	btn_group,
	btn_owner,
	btn_public,
	btn_close_menu
		];
list M_starting_menu(){
	calllistener="";
	return MAIN_ADVANCE;
}
list M_switches(){
	return [M_debug(),btn_close_menu];
}//=================================
//            find the cards
//
string nextface = ">>>";
string prevface = "<<<";
integer cardfaces = 0;
integer cartsetcount = 0;
integer menucards_limit=0;
list all_cards=[];
integer cardnumbers;
detectCards(){
	all_cards=[];
	float i;
	integer j;
	cardnumbers = llGetInventoryNumber(INVENTORY_NOTECARD);
	i = (float) cardnumbers/9;
	cardfaces=llCeil(i)-1;
	for (j=0; j<cardnumbers;j++)
	{
		all_cards+=[(string)llGetInventoryName(INVENTORY_NOTECARD,j)];
	}
	//if(debug)say(llList2CSV(all_cards));
}
list findcards(){
	list this=[];
	integer containingbuttons = 9;
	integer j;
	menucards_limit = cardnumbers-cartsetcount*containingbuttons;
	if(cardnumbers==0){
		//  if(debug)say("there is no notecards detected.");
		this = [btn_close_menu];
		return this;
	}
	for (j=0; j<containingbuttons;j++)
	{
		integer index = j+cartsetcount*containingbuttons;
		//if(debug)say("index :"+(string)index);
		//if(debug)say("j:"+(string)j);
		if(j<menucards_limit){
			this+=llList2List(all_cards,index,index);
		}
		else if(j>=menucards_limit){
			this+=["--"];
		}
	}
	if(cardfaces>0){
		this+=[prevface,btn_close_menu,nextface];
	}else{
			this+=["--",btn_close_menu,"--"];
	}
	//if(debug)say("menucards_limit:"+(string)menucards_limit+"\n  \\"+(string)cartsetcount+" / "+(string)cardfaces);
	//if(debug)say(llList2CSV(this));
	return this;
}
//==========================================end
string touchstarttitle(){
	string b;
	if(isMenuSIMPLE){
		b= "this is a simple standalone menu";}else{b= "this is the advance heavy geared menu";};
	return b;
}
string MENU_TEXT="";
ccommand(string cmd){
	if(debug)llSay(0,"call = "+calllistener);
	if(calllistener==""){
		if(cmd==btn_about){
			MENU_TEXT=textabout;
			TD([btn_close_menu],"menu_about_");
		}
		if(cmd==btn_load){
			MENU_TEXT=textload;
			detectCards();
			TD(findcards(),"menu_reload_");
		}
		if(cmd==btn_option){
			MENU_TEXT=textoption;
			TD(M_btn_option,"menu_option_");
		}
	}
	if(calllistener=="menu_about_"){
		if(cmd ==btn_close_menu){
			MENU_TEXT=textmenu;
			TD(M_starting_menu(),"");
		}
	}
	if(calllistener=="menu_reload_"){
		if(cmd ==btn_close_menu){
			MENU_TEXT=textmenu;
			TD(M_starting_menu(),"");
		}else if (cmd==nextface){
				cartsetcount++;
			if(cartsetcount>cardfaces){
				cartsetcount=0;
			}TD(findcards(),"menu_reload_");
		}else if (cmd==prevface){
				cartsetcount--;
			if(cartsetcount<0){
				cartsetcount=cardfaces;
			}
			TD(findcards(),"menu_reload_");
		}else if(cmd =="--"){
				TD(M_starting_menu(),"");
		}
		if(cmd !="--"
			&& cmd!=btn_close_menu
				&& cmd!=btn_load
					&& cmd!=nextface
						&& cmd!=prevface){
							llMessageLinked(LINK_ROOT, reload_key, cmd, NULL_KEY);
							//checking_other_users();
						}
	}
	if(calllistener=="menu_option_"){
		if(cmd==btn_permssion){
			MENU_TEXT=textpermission;
			TD(M_btn_permssion,"menu_option_permission");
		}
		if(cmd==btn_close_menu){
			MENU_TEXT=textmenu;
			TD(M_starting_menu(),"");
		}
		if(cmd==btn_instruction){
			TD(M_starting_menu(),"");
		}
		if(cmd==btn_debug){
			MENU_TEXT=textdebug;
			TD(M_switches(),"menu_option_debug");
		}
	}
	if(calllistener=="menu_option_debug"){
		if(cmd==btn_close_menu){
			MENU_TEXT=textoption;
			TD(M_btn_option,"menu_option_");
		}
		if(cmd=="d FALSE"){
			debug=TRUE;
			llMessageLinked(LINK_SET, CALL_DEBUG, "TRUE","");
			TD(M_switches(),"menu_option_debug");
		}
		if(cmd=="d TRUE"){
			debug=FALSE;
			llSay(0,"debug => false");
			llMessageLinked(LINK_SET, CALL_DEBUG, "","");
			TD(M_switches(),"menu_option_debug");
		};
	}
	if(calllistener=="menu_option_permission"){
		if(cmd==btn_group){TD(M_btn_permssion,"menu_option_permission");permissionOptions=1;
			llSay(0,"set to GROUP only");}
		if(cmd==btn_owner){TD(M_btn_permssion,"menu_option_permission");permissionOptions=0;
			llSay(0,"set to OWNER only");}
		if(cmd==btn_public){TD(M_btn_permssion,"menu_option_permission");permissionOptions=2;
			llSay(0,"set to PUBLIC only");}
		if(cmd==btn_close_menu){
			MENU_TEXT=textoption;
			TD(M_btn_option,"menu_option_");
		}
	}
}
integer uuidBaseChannel(){
	integer chNumber;
	string s = (string)llGetKey();
	chNumber = (integer)("0x"+llGetSubString(s, 0, 7)) +(integer)("0x"+llGetSubString(s, 9, 12) + llGetSubString(s, 14, 17)) + (integer)("0x"+llGetSubString(s, 19, 22) + llGetSubString(s, 24, 27)) + (integer)("0x"+llGetSubString(s, 28, 35));
	if (chNumber > 0){chNumber = -chNumber;
	}else if (chNumber == 0){
			chNumber = -1;
	}
	return chNumber;
}
string M_debug(){
	string bbde_bug;
	if(!debug){
		bbde_bug="d FALSE";
	}else{
			bbde_bug="d TRUE";
	}
	return bbde_bug;
}
TD(list menu, string call){
	llListenRemove(MENU_HANDLE);
	MENU_CHANNEL = uuidBaseChannel();
	calllistener=call;
	if(debug)llSay(0,(string)MENU_CHANNEL);
	MENU_HANDLE = llListen(MENU_CHANNEL,"","","");
	if(debug)llSay(0,"at this "+(string)agent+" CHANNEL: "+(string)MENU_CHANNEL+" change call: "+calllistener);
	llDialog(agent, MENU_TEXT, menu, MENU_CHANNEL);
}

integer getPermUser(){
	group = llDetectedGroup(0); // Is the Agent in the objowners group?
	//agent = llDetectedKey(0);    // Agent's key
	objectowner = llGetOwner(); // objowners key
	requestagentname = llKey2Name(agent);
	llSay(0,requestagentname+" has the menu");
	integer A= FALSE;
	integer B= FALSE;
	integer C= FALSE;
	if(permissionOptions==0){// 0 for owner only
		A =(objectowner == agent);
	}
	if(permissionOptions==1){// 1 for group only
		B=group;
	}
	if(permissionOptions==2){// 2 for the public
		C = TRUE;
	}
	return A||B||C;
}
open_a_lisntener(){
	MENU_CHANNEL = llFloor(llFrand(-99999.0 - -100));
	MENU_HANDLE = llListen(MENU_CHANNEL,"","","");
}
startmenu(){
	if (getPermUser()){
		//iListenTimeout = llGetUnixTime() + llFloor(fListenTime);
		open_a_lisntener();
		llDialog(agent, touchstarttitle(), M_starting_menu(), MENU_CHANNEL);
	}else{
			llSay(0,requestagentname+" is not allow to use the menu. sorry.");
	}
}
default{
	on_rez(integer rez)
	{
		// llResetScript();
	}
	link_message(integer sender_num, integer num, string msg, key idk) {
		if(msg =="MENU"){
			if(debug)llSay(0, "conversation starts to :"+(string)idk);
			agent = idk;
			startmenu();
		}
	}
	listen(integer channel, string name, key id, string message){
		ccommand(message);
	}
}
