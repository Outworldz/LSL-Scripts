// MLPV2 Version 2.2, by Learjeff Innis, based on
//MLP MULTI-LOVE-POSE V1.2 - Copyright (c) 2006, by Miffy Fluffy (BSD License)
// 15-color balls by Lizz Silverstar
// autoback, multi-contin menu fixed

integer MAX_BALLS   = 6;

// Multicolor ball patch by Lizz Silverstar
// The colors var used to store the color values is a 32 bit integer (0x00000000)
// This is broken up into 8 nibbles of which we will currently use the lower 4 nibbles
// the first ball color is in the lower 4 bits, the second in the next 4 bits, etc
// Masks and shifting are used to store and extract the data.
// 4 bits gives us 15 colors.  0 = no ball, 1-15 = color
// these index values are then used by the ~ball code to set the correct color
// 1st ball mask is 0x0000000F,  no shift
// 2nd ball mask is 0x000000F0,  shift of 4
// 3rd ball mask is 0x00000F00,  shift of 8
// 4th ball mask is 0x0000F000,  shift of 12

list Colornames = [
    "HIDE", "PINK", "BLUE", "PINK2",
    "BLUE2", "GREEN", "MAGENTA", "RED",
    "ORANGE", "WHITE", "BLACK", "YELLOW",
    "CYAN", "RED2", "TEAL", "GREEN2"];


integer PoseIx;

integer CurButtonIx;        // index of current button
integer b0;                 // index of current button from start of current menu

integer AutoBack;
integer chat = TRUE;
integer redo = TRUE;
integer menuusers;
integer group;
integer ballusers;
integer SaneMenuOrder;
integer ReloadOnRez = FALSE;

string cmd;
string pose;
string pose0;

list buttons;
list buttonindex;
list commands;
list menus;
list balls;
list users;

list SoundNames;
list Sounds;
list LMButtons;
list LMParms;


// Globals for reading card config
integer ConfigLineIndex;
list    ConfigCards;        // list of names of config cards
string  ConfigCardName;     // name of card being read
integer ConfigCardIndex;    // index of next  card to read
key     ConfigQueryId;

integer next_card()
{
    if (ConfigCardIndex >= llGetListLength(ConfigCards)) {
        ConfigCards = [];
        return (FALSE);
    }
    
    ConfigLineIndex = 0;
    ConfigCardName = llList2String(ConfigCards, ConfigCardIndex);
    ConfigCardIndex++;
    ConfigQueryId = llGetNotecardLine(ConfigCardName, ConfigLineIndex);
    llOwnerSay("Reading " + ConfigCardName);
    return (TRUE);
}

default {
    state_entry() {
        // ch = (integer)("0x"+llGetSubString((string)llGetKey(),-4,-1));  //fixed channel for prim
        llMessageLinked(LINK_THIS,1,"OK?",(key)"");                    //msg to memory: ask if ready
    }
    link_message(integer from, integer num, string str, key id) {
        if (num == 2 && str == "OK") state load;                                //memory ready
    }
}


state load {
    state_entry() {
        string item;
        ConfigCards = [];
        integer n = llGetInventoryNumber(INVENTORY_NOTECARD);
        while (n-- > 0) {
            item = llGetInventoryName(INVENTORY_NOTECARD, n);
            if (llSubStringIndex(item, ".MENUITEMS") != -1) {
                ConfigCards = [] + ConfigCards + (list)item;
            }
        }

        ConfigCardIndex = 0;
        ConfigCards = llListSort(ConfigCards, 1, TRUE);
        next_card();
    }

    dataserver(key query_id, string data) {
        if (query_id != ConfigQueryId) {
            return;
        }                             
        if (data == EOF) {
            if (next_card()) {
                return;
            }
            state on;
        }

        integer ix = llSubStringIndex(data,"//");                       //remove comments
        if (ix != -1) {
            if (ix == 0) data = "";
            else data = llGetSubString(data, 0, ix - 1);
        }

        data = llStringTrim(data, STRING_TRIM_TAIL);
        if (data != "") {
            ix = llSubStringIndex(data," ");
            cmd = data;                      
            if (ix != -1) {                                             //split command from data
                cmd = llGetSubString(data, 0, ix - 1);
                data = llGetSubString(data, ix+1, -1);
            }
            list ldata = llParseStringKeepNulls(data,["  |  ","  | "," |  "," | "," |","| ","|"],[]);
            string arg1 = llList2String(ldata, 0);
            //llSay(0, cmd + ":" + data);
            if (cmd == "MENU") {
                integer auth;

                if (PoseIx < 2) {
                    llOwnerSay("warning: first two items in .MENUITEMS must be: POSE stand / POSE default");
                }
                llOwnerSay("loading '"+arg1+"' menu");
                if (llList2String(ldata, 1) == "GROUP") auth = 1;       //access to submenus
                else if (llList2String(ldata, 1) != "OWNER") auth = 2;  //0=owner 1=group 2=all

                integer colors;
                string ball_color;
                integer colorIx;
                integer ix1;
                for (ix1=0; ix1 < MAX_BALLS; ++ix1) { // for each possible ball
                    ball_color = llList2String(ldata, ix1 + 2); // get next color name from config
                    colorIx = llListFindList(Colornames, (list)ball_color);
                    if (colorIx != -1) {
                        colors += (colorIx << (4 * ix1));    // 4 = bits per color (16 colors)
                    }
                }
                menus = [] + menus + (list) arg1;
                balls = [] + balls + (list) colors;
                buttonindex = [] + buttonindex + (list) CurButtonIx;
                users = [] + users + (list) auth;
                if (llListFindList(buttons, (list)arg1) == -1) {
                    integer jx = llListFindList(buttons, (list) "-");
                    if (jx != -1) {
                        buttons = llListReplaceList(buttons, (list)arg1, jx, jx);
                        // "TOMENU" is already in commands list from the 'TOMENU -'
                    } else if (CurButtonIx > 2) {
                        llOwnerSay("No unused 'TOMENU -' for " + arg1);
                    }
                }

                b0 = 0;
            } else if (cmd == "AUTOBACK") {
                AutoBack = (arg1 != "0");
            } else if (cmd == "NORELOAD") {
                ReloadOnRez = (arg1 != "0");        // whether to reload menu on rez
            } else if (cmd == "MENUORDER") {
                SaneMenuOrder = (arg1 != "0");       // keep menu buttons in same order as in file
            } else {
                
                // automatic menu extension (don't do for main menu)
                if (b0 == 12 && llGetListLength(menus) > 1) {
                    // Add a "more" button before last item
                    integer ix1 = -1;
                    if (AutoBack) {
                        ix1 = -2;
                         // Add a "BACK" button
                        buttons  = llListInsertList(buttons, (list)"BACK", ix1);
                        commands = llListInsertList(commands, (list)"BACK", ix1);
                        ++CurButtonIx;
                    }
                    buttons  = llListInsertList(buttons, (list)"More-->", ix1);
                    commands = llListInsertList(commands, (list)"MORE", ix1);
                    ++CurButtonIx;
                    b0 = -ix1;
                }
                if (cmd == "POSE") {
                    llMessageLinked(LINK_THIS,9+PoseIx,data, (key)"");
                    if (!PoseIx) pose0 = arg1;
                    cmd = (string)PoseIx;
                    ++PoseIx;
                } else if (cmd == "REDO") {
                    if (llList2String(ldata, 1) != "OFF") redo = 1;
                } else if (cmd == "CHAT") {
                    if (llList2String(ldata, 1) != "OFF") chat = 1;
                } else if (cmd == "BALLUSERS") {
                    if (llList2String(ldata, 1) == "GROUP") ballusers = 1;
                } else if (cmd == "MENUUSERS") {
                    if (llList2String(ldata, 1) == "GROUP") menuusers = 1;
                    else if (llList2String(ldata, 1) != "OWNER") menuusers = 2;
                } else if (cmd == "LINKMSG") {
                    LMButtons = [] + LMButtons + arg1;
                    LMParms = [] + LMParms + llList2String(ldata, 1);
                } else if (cmd == "SOUND") {
                    SoundNames += (list) arg1;
                    Sounds += (list) llList2String(ldata, 1);
                }
                commands = [] + commands + (list) cmd;
                buttons = [] + buttons + (list) arg1;
                ++CurButtonIx;
                ++b0;
            }
        }
        ++ConfigLineIndex;
        ConfigQueryId = llGetNotecardLine(ConfigCardName, ConfigLineIndex);         //read next line of menuitems notecard
    }
    state_exit() {
        buttonindex = [] + buttonindex + (list) CurButtonIx;    //enter last buttonindex
        commands = [] + commands + (list) "";            //empty command for undefined buttons (-1)

        integer ix;
        integer count;
        while ((ix = llListFindList(buttons, (list)"-")) != -1) {
            ++count;
            buttons = llDeleteSubList(buttons, ix, ix);
            commands = llDeleteSubList(commands, ix, ix);
        }
        if (count) {
            for (ix = 1; ix < llGetListLength(buttonindex); ++ix) {
                buttonindex = llListReplaceList(buttonindex,
                    (list)(llList2Integer(buttonindex, ix) - count), ix, ix);
            }
        }
        // llMessageLinked(LINK_THIS,1,"LOADED",(string)PoseIx);                //msg to memory
        llMessageLinked(LINK_THIS,9+PoseIx,"LOADED",(key)"");               //msg to pose
    }
}

state on {
    state_entry() {
        // llSay(0, llList2CSV(buttons));
        llMessageLinked(LINK_THIS, -3, llList2CSV(menus),       (key)""); menus = [];
        llMessageLinked(LINK_THIS, -4, llList2CSV(buttonindex), (key)""); buttonindex = [];
        llMessageLinked(LINK_THIS, -5, llList2CSV(balls),       (key)""); balls = [];
        llMessageLinked(LINK_THIS, -6, llList2CSV(users),       (key)""); users = [];
        llMessageLinked(LINK_THIS, -7, llList2CSV(LMButtons),   (key)""); LMButtons = [];
        
        llMessageLinked(LINK_THIS, -8, llDumpList2String(LMParms, "|"), (key)""); LMParms = [];
        
        llMessageLinked(LINK_THIS, -9,  llList2CSV(SoundNames), (key)""); SoundNames = [];
        llMessageLinked(LINK_THIS, -10, llList2CSV(Sounds),     (key)""); Sounds = [];

        llMessageLinked(LINK_THIS, -2, llList2CSV(commands),    (key)""); commands = [];
        llMessageLinked(LINK_THIS, -1, llList2CSV(buttons),     (key)""); buttons = [];

                        
        // finally, scalars (signals 'done' as well)
        llMessageLinked(LINK_THIS, -20,
            llList2CSV([ redo, chat, ballusers, menuusers, SaneMenuOrder, ReloadOnRez ]), (key)"");

        llOwnerSay((string)CurButtonIx+" menuitems loaded ("+llGetScriptName()+": "+(string)llGetFreeMemory()+" bytes free)");
    }
}
