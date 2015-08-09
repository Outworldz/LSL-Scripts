// :CATEGORY:Pose Balls
// :NAME:MultiLove_Pose
// :AUTHOR:Miffy Fluffy
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:541
// :NUM:728
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This is one of seven scripts in the base object, along with the script in the rezzable poseball.
// :CODE:
//MLP MULTI-LOVE-POSE V1.1 - Copyright (c) 2006, by Miffy Fluffy (BSD License)
integer PINK1 = 1;  //0001 binary
integer BLUE1 = 2;  //0010 binary
integer PINK2 = 4;  //0100 binary
integer BLUE2 = 8;  //1000 binary
integer a;
integer all;
integer b;
integer b0;
integer c;
integer ch;
integer chat;
integer hear;
integer i;
integer line;
integer menu;
integer redo;
integer rez;
integer swap;
integer visible;
float alpha;
string cmd;
string pose;
string pose0;
key owner;
key user;
list buttons;
list buttonindex;
list commands;
list mbuttons;
list menus;
list balls;
list users;

//menu partly based on Menu Engine by Zonax Delorean (BSD License)
//llDialog(user, menuname, buttons(from index to nextindex-1), channel)  
doMenu() {
    b0 = llList2Integer(buttonindex, menu);         //position of first button for this (sub)menu
    b = llList2Integer(buttonindex, menu+1);        //position of first button for next (sub)menu
    mbuttons = llList2List(buttons, b0, b - 1);     //buttons for this (sub)menu
    llListenRemove(hear);
    hear = llListen(ch - b0, "", user, "");         //listen for pressed buttons
    llDialog(user, llList2String(menus,menu), mbuttons, ch - b0);
    c = llList2Integer(balls,menu);         //ballcolors
    if (c) {                                //if submenu includes ballcolor(s):
        if (!rez) rezBalls();               //if no balls present: create balls
        llSay(ch,(string)(c & 3));          //ball1color: mask with 3 = 0011 binary
        llSay(ch+1,(string)(c >> 2));       //ball2color: shift 2 bits to the right
    }
    if (user != owner) llOwnerSay("("+llKey2Name(user)+" selects "+llList2String(menus,menu)+")");
}
say(string str) {
    if (all) llWhisper(0,str);
    else llOwnerSay(str);
}
setBalls(string cmd) {
    llSay(ch,cmd);      //msg to balls
    llSay(ch+1,cmd);
}
rezBalls() {
    setBalls("DIE");
    llRezObject("~ball",llGetPos(),ZERO_VECTOR,ZERO_ROTATION,ch);
    llRezObject("~ball",llGetPos(),ZERO_VECTOR,ZERO_ROTATION,ch+1);
    llMessageLinked(LINK_THIS,0,"REPOS",NULL_KEY);  //msg to pos
    llMessageLinked(LINK_THIS,0,"POSE","0");        //msg to pos/pose
    rez = 1;
    pose = pose0;
    llSetTimerEvent(60);
    if (chat) say("Balls ready");
}

default {
    state_entry() {
        llSetScriptState("~run", TRUE);
        llResetOtherScript("~pos");
        llResetOtherScript("~pose");
        llResetOtherScript("~pose1");
        llResetOtherScript("~pose2");
        ch = (integer)("0x"+llGetSubString((string)llGetKey(),-4,-1));  //fixed channel for prim
        setBalls("DIE");
        owner = llGetOwner();
        alpha = llGetAlpha(0);                                          //store object transparancy (alpha)
        if (alpha < 0.1) alpha = 0.5; else visible = 1;                 //if invisible store a visible alpha
        llMessageLinked(LINK_THIS,1,"OK?",NULL_KEY);                    //msg to memory: ask if ready
    }
    link_message(integer from, integer num, string str, key id) {
        if (num == 2) state load;                                       //memory ready
    }
}           
state load {
    state_entry() {
        llGetNotecardLine(".MENUITEMS",0);                              //read first line of menuitems notecard
    }
    dataserver(key query_id, string data) {                                 
        if (data == EOF) state on;
        i = llSubStringIndex(data,"//");                                //remove comments
        if (i != -1) {
            if (i == 0) data = "";
            else data = llGetSubString(data, 0, i - 1);
        }
        while (llGetSubString(data, -1, -1) == " ") data = llDeleteSubString(data, -1, -1); //remove spaces from end
        if (data != "") {
            i = llSubStringIndex(data," ");
            cmd = data;                      
            if (i != -1) {                                              //split command from data
                cmd = llGetSubString(data, 0, i - 1);
                data = llGetSubString(data, i+1, -1);
            }
            list ldata = llParseString2List(data,["  |  ","  | "," |  "," | "," |","| ","|"],[]);
            data = llList2String(ldata, 0);
            if (cmd == "MENU") {
                llOwnerSay("loading data for '"+data+"'");
                if (!menu) {                                            //main menu
                    if (!a) llOwnerSay("warning: first item in .MENUITEMS must be: POSE stand");
                    if (a<=1) llOwnerSay("warning: second item in .MENUITEMS must be: POSE default");
                } else {                   
                    if (llList2String(ldata, 1) == "OWNER") menu = 0;   //0 = owner only, 1 = all users
                    pose = llList2String(ldata, 2);
                    if (pose == "PINK") rez = PINK1;
                    else if (pose == "BLUE") rez = BLUE1;
                    pose = llList2String(ldata, 3);
                    if (pose == "PINK") rez += PINK2;
                    else if (pose == "BLUE") rez += BLUE2;
                }
                menus += [ data ];
                balls += [ rez ];
                buttonindex += [ b ];
                users += [ menu ];
                rez = 0;
                b0 = 0;
                menu = 1;
            } else if (b0 < 12) {                                       //maximum 12 buttons per menu
                if (cmd == "POSE") {
                    llMessageLinked(LINK_THIS,1,data,(string)a);        //msg to memory
                    llMessageLinked(LINK_THIS,9+a,llList2String(ldata, 1),llList2String(ldata, 2));  //msg to pose
                    if (!a) pose0 = data;
                    cmd = (string)a;
                    ++a;
                } else if (cmd == "REDO") {
                    if (llList2String(ldata, 1) == "ON") redo = 1;
                } else if (cmd == "CHAT") {
                    if (llList2String(ldata, 1) == "ON") chat = 1;
                } else if (cmd == "USERS") {
                    if (llList2String(ldata, 1) == "ON") all = 1;
                }   
                commands += [ cmd ];
                buttons += [ data ];
                ++b;
                ++b0;
            }
        }
        ++line;
        llGetNotecardLine(".MENUITEMS",line);                           //read next line of menuitems notecard
    }
    state_exit() {
        buttonindex += [ b ];                                           //enter last buttonindex
        llOwnerSay("READY");
        llOwnerSay((string)b+" menuitems loaded ("+llGetScriptName()+": "+(string)llGetFreeMemory()+" bytes free)");
        llMessageLinked(LINK_THIS,1,"LOADED",(string)a);                //msg to memory
        llMessageLinked(LINK_THIS,9+a,"LOADED",NULL_KEY);               //msg to pose
    }
}
state on {
    state_entry() {
        llSetTimerEvent(60);
    }
    touch_start(integer i) {
        user = llDetectedKey(0);
        if (user == owner || all) {
            menu = 0; doMenu();                                         //mainmenu
        }                 
    }
    listen(integer channel, string name, key user, string button) {
        if (button == "DIE") { menu = 0; rez = 0; return; }             //suicide msg from ball
        b = b0 + llListFindList(mbuttons,[ button ]);                   //find position of cmd
        string cmd = llList2String(commands,b);                         //get command
        //llSay(0,button+" "+cmd);                                      //debug
        if (cmd == "TOMENU") {                                             
            menu = llListFindList(menus,[ button ]);                    //find submenu
            if (menu == -1) return;                                       
            if (user == owner || llList2Integer(users, menu)) {
                doMenu(); return;
            }
            llWhisper(0,button+" menu deactivated (access by owner only)");
            menu = 0;
        } else if (cmd == "BACK") {
            menu = 0; doMenu();                                         //mainmenu
            return;
        } else if ((integer)cmd > 0) {                                  //POSE
            llMessageLinked(LINK_THIS,0,"POSE",cmd);                    //msg to pos/pose
            if (chat) say(button);
            pose = button;
        } else if (cmd == "SWAP") {
            llMessageLinked(LINK_THIS,0,"SWAP",NULL_KEY);               //msg to pos/pose
            swap = !swap;
        } else if (cmd == "STOP") {
            llMessageLinked(LINK_THIS,0,"POSE","0");                    //STAND msg to pos/pose
            if (chat) say(button);
            if (pose == pose0) {    //Balls OFF
                setBalls("DIE");
                if (chat && rez) say("Balls removed");
                rez = 0;
                llSetTimerEvent(0);
            }
            menu = 0;
            pose = pose0;
        } else if (cmd == "ADJUST") {
            setBalls("ADJUST");
        } else if (cmd == "HIDE") {
            setBalls("0");
        } else if (cmd == "SHOW") {
            setBalls("SHOW");
        } else if (cmd == "DUMP") {
            llMessageLinked(LINK_THIS,1,"DUMP",NULL_KEY);
        } else if (cmd == "INVISIBLE") {
            visible = !visible;
            llSetAlpha((float)visible*alpha, ALL_SIDES);
        } else if (cmd == "REDO") {
            redo = !redo;
            if (redo) say(button+" ON"); else say(button+" OFF");
        } else if (cmd == "CHAT") {
            chat = !chat;
            if (chat) say(button+" ON"); else say(button+" OFF");
        } else if (cmd == "USERS") {
            if (user == owner) {
                all = !all;
                if (all) llOwnerSay(button+" ON"); else llOwnerSay(button+" OFF");
            } else llWhisper(0,button+" ON (can be switched by owner only)");
        } else if (cmd == "OFF" || cmd == "RESET") {
            llMessageLinked(LINK_THIS,0,"POSE","0");                    //STAND msg to pos/pose
            if (chat) llOwnerSay(button);
            setBalls("DIE");
            llSleep(0.5);
            if (user == owner) {          
                if (cmd == "OFF") llResetOtherScript("~run");
                llResetScript();
            }
            llWhisper(0,button+" deactivated (owner only)");
            rez = 0;
            llSetTimerEvent(0);
        } else {    //SAVE //Z-adjust
            if (user == owner) {
                llMessageLinked(LINK_THIS,0,cmd,pose);                  //msg to pose
                doMenu(); return;
            } llWhisper(0,button+" deactivated (owner only)");
        }
        if (redo) doMenu();
    }
    on_rez(integer r) {
        rez = 0;
        llSetTimerEvent(0);
    }
    timer() {
        llWhisper(ch,"LIVE");   //msg to balls: stay alive
        llWhisper(ch+1,"LIVE");
    }
}
