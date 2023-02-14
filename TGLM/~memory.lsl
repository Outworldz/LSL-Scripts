 //MPLV2 Version 2.2 by Learjeff Innis, based on
//MLP MULTI-LOVE-POSE V1.2 - Copyright (c) 2006, by Miffy Fluffy (BSD License)

// v2.2 - rotate all poses, cleaner dump

integer Checking = FALSE;       // whether doing consistency check

integer line;
integer PosCount;
list    Poses;              // list of pose names

// indexed by same index as Poses, entry contains text string of pos/rot pairs, one for each ball in pose

// list    Positions;

list Positions0;
list Positions1;
list Positions2;
list Positions3;


vector  Pos1;
vector  Pos2;
vector  Pos3;
vector  Pos4;
vector  Pos5;
vector  Pos6;
vector  Rot1;
vector  Rot2;
vector  Rot3;
vector  Rot4;
vector  Rot5;
vector  Rot6;
integer Ballcount;

announce()
{
    llOwnerSay((string)PosCount
        + " positions stored ("
        + llGetScriptName()
        + ": "
        + (string)llGetFreeMemory()
        + " bytes free)");
}

getPosePos(string pdata) {
    list    plist = llParseString2List(pdata,[" "],[]);
    
    Ballcount = llGetListLength(plist) / 2;

    Pos1 = (vector)llList2String(plist, 0);
    Rot1 = (vector)llList2String(plist, 1);
    Pos2 = (vector)llList2String(plist, 2);
    Rot2 = (vector)llList2String(plist, 3);
    Pos3 = (vector)llList2String(plist, 4);
    Rot3 = (vector)llList2String(plist, 5);
    Pos4 = (vector)llList2String(plist, 6);
    Rot4 = (vector)llList2String(plist, 7);
    Pos5 = (vector)llList2String(plist, 8);
    Rot5 = (vector)llList2String(plist, 8);
    Pos6 = (vector)llList2String(plist, 10);
    Rot6 = (vector)llList2String(plist, 11);
}


string adjust(integer doOffset, vector pos, vector erot, vector amt) {
    if (doOffset) {
        pos += amt/100.;
        return (vround(pos) + " " + vround(erot));
    }
    
    rotation amount = llEuler2Rot(amt * DEG_TO_RAD);
    erot *= DEG_TO_RAD;
    
    rotation oldrot = llEuler2Rot(erot);
    rotation newrot = oldrot / amount;
    
    erot = llRot2Euler(newrot) * RAD_TO_DEG;
    pos = pos / amount;
    return(vround(pos) + " " + vround(erot));
}

adjust_all(integer doOffset, vector amt) {
    integer ix;
    integer bx;
    string  data;
    for (ix = 0; ix < PosCount; ++ix) {
        data = get_pose_by_index(ix);
        getPosePos(data);
        
        list parms = [ Pos1, Rot1, Pos2, Rot2, Pos3, Rot3, Pos4, Rot4, Pos5, Rot5, Pos6, Rot6 ];
        
        data = adjust(doOffset, Pos1, Rot1, amt);
        integer ballix = 1;
        while (ballix < Ballcount) {
            string stuff = adjust(doOffset, llList2Vector(parms, 2*ballix), llList2Vector(parms, 2*ballix+1), amt);
            data += " " + stuff;
            ++ballix;
        }
        store_pose(data, ix);
    }
}


string get_pose_data(string name) {
    integer ix = llListFindList(Poses, [name]);
    
    // if not found, use default positions
    if (ix == -1) {
        ix = 0;
    }
    
    return (get_pose_by_index(ix));
}


string get_pose_by_index(integer ix) {
    if ((ix & 3) == 0) {
        return llList2String(Positions0, ix>>2);
    } else if ((ix & 3) == 1) {
        return llList2String(Positions1, ix>>2);
    } else if ((ix & 3) == 2) {
        return llList2String(Positions2, ix>>2);
    }
    return llList2String(Positions3, ix>>2);
}

store_pose(string data, integer ix) {
    if ((ix & 3) == 0) {
        Positions0 = llListReplaceList(Positions0,[ data ],ix>>2,ix>>2);
    } else if ((ix & 3) == 1) {
        Positions1 = llListReplaceList(Positions1,[ data ],ix>>2,ix>>2);
    } else if ((ix & 3) == 2) {
        Positions2 = llListReplaceList(Positions2,[ data ],ix>>2,ix>>2);
    } else if ((ix & 3) == 3) {
        Positions3 = llListReplaceList(Positions3,[ data ],ix>>2,ix>>2);
    }
}


save_pose(string name, string data) {
    integer ix = llListFindList(Poses, [name]);
    if (ix == -1) {
        add_pose(name, data);
    } else {
        store_pose(data, ix);
    }
}

add_pose(string name, string data) {
    integer ix = llListFindList(Poses, (list)name);
    if (ix != -1) {
        llOwnerSay("===> WARNING: Multiple .POSITIONS* entries for '" + name + "'");
    } else {
        Poses = [] + Poses + (list) name;
        ix = ++PosCount;
    }   
    store_pose(data, ix-1);
}

check_pose(string name) {
    integer ix;
    
    // if this is the last pose, report results
    if (name == "CHECK2") {
        string name1;
        for (ix = 0; ix < llGetListLength(Poses); ++ix) {
            name1 = llList2String(Poses, ix);
            if (get_pose_data(name1) != "") {
                if (name1 != "default" && name1 != "stand") {
                    llOwnerSay("No .MENUITEMS* entry for '" + name1 + "'.");
                }
            }
        }
        llOwnerSay("Checks complete, resetting.");
        llResetScript();
    }

    ix = llListFindList(Poses, [name]);
    if (ix == -1) {
        llOwnerSay("No .POSITIONS* entry for '" + name + "'.");
        return;
    }
    save_pose(name, "");
}


string vround(vector vec) {
    return ("<"+round(vec.x, 3)+","+round(vec.y, 3)+","+round(vec.z, 3)+">");
}

string round(float number, integer places) {
    float shifted;
    integer rounded;
    string s;
    shifted = number * llPow(10.0,(float)places);
    rounded = llRound(shifted);
    s = (string)((float)rounded / llPow(10.0,(float)places));
    s = llGetSubString(s,0,llSubStringIndex(s, ".")+places);
    return s;
}

dashes() {
    llOwnerSay("_______________________________________________________________________________");
    llOwnerSay("");
}


// Globals for reading card config
integer ConfigLineIndex;
list    ConfigCards;        // list of names of config cards
string  ConfigCardName;     // name of card being read
integer ConfigCardIndex;    // index of next card to read
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
        string item;
        ConfigCards = [];
        integer n = llGetInventoryNumber(INVENTORY_NOTECARD);
        while (n-- > 0) {
            item = llGetInventoryName(INVENTORY_NOTECARD, n);
            if (llSubStringIndex(item, ".POSITIONS") != -1) {
                ConfigCards = [] + ConfigCards + (list) item;
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
        if (llGetSubString(data,0,0) != "/") {              // skip comments
            integer ix = llSubStringIndex(data, "{");       //split name from positions, remove junk
            integer jx = llSubStringIndex(data, "} <");
            if (ix != -1 && jx != -1) {
                add_pose(llGetSubString(data, ix+1, jx-1), llGetSubString(data, jx+2, -1));
            }
        }
        ++ConfigLineIndex;
        ConfigQueryId = llGetNotecardLine(ConfigCardName, ConfigLineIndex);       //read next line of positions notecard
    }

    state_exit() {
        if (PosCount < 1) {
            add_pose("stand", "<-0.7,0.0,0.9> <0.0,0.0,0.0> <0.7,0.0,0.9> <0.0,0.0,-180.0>");
        }
        if (PosCount < 2) {
            add_pose("default", "<-0.7,0.0,0.7> <0.0,0.0,0.0> <0.7,0.0,0.7> <0.0,0.0,-180.0>");
        }

        // do one save to indicate actual amount of available memory
        string position = llList2String(Positions1, 0);
        Positions1 = llListReplaceList(Positions1, [position],0,0);

        if (llGetInventoryType("~props") == INVENTORY_SCRIPT) {
            llSetScriptState("~props", TRUE);
            llResetOtherScript("~props");
            llSleep(1.0);       // give props a chance to run -- doesn't really matter if not enough
        }
    }
}


state on {
    state_entry() {
        llMessageLinked(LINK_THIS, 2, "OK", (key)""); //msg to menu, in case it's waiting for loading
        announce();
    }

    link_message(integer from, integer num, string str, key dkey) {
        if (str == "PRIMTOUCH" || num < 0) {
            return;
        }

        if (num == 0 && str == "POSEB") {
            string name = (string)dkey;
            if (name == "CHECK1") {
                Checking = TRUE;
            } else if (Checking) {
                check_pose((string)dkey);
            } else {
                llMessageLinked(LINK_THIS, 0, "POSEPOS", (key)get_pose_data((string)dkey));  // to ~pos
            }
            return;
        }

        if (num != 1) {
            return;
        }

        if (str == "OK?") {                                 //question from menu, before loading menu
            llMessageLinked(from, 2, "OK", (key)"");          //answer to menu
        } else if (str == "DUMP") {
            dashes();
            llOwnerSay("Copy to .POSITIONS; delete any other *.POSITIONS* cards");
            dashes();
            string name1 = llGetObjectName();
            llSetObjectName("");

            integer ix;
            for (ix = 0; ix < PosCount; ++ix) {
                string name2 = llList2String(Poses, ix);
                llOwnerSay("{" + name2 + "} " + get_pose_data(name2));
            }
            
            llSetObjectName(name1);
            dashes();
        } else if (llSubStringIndex(str, "REORIENT=") == 0) {
            // Reorient command (LINKMENU command from .MENUITEMS file)
            // str format: REORIENT=OFF=<x,y,z> or REORIENT=ROT=<x,y,z> (in degrees)
            list    parms = llParseString2List(str, ["="], []);
            vector  amount  = (vector)llList2String(parms, 2);
            llWhisper(0, "Adjusting Poses, please wait");
            
            if (llList2String(parms, 1) == "OFF") {
                adjust_all(TRUE, amount);
            } else {
                adjust_all(FALSE, amount);
            }
            llMessageLinked(LINK_THIS, 0, "AGAIN", (key)"");
            llWhisper(0, "Pose adjustment complete");
        } else {
            if (llGetSubString((string)dkey, 0, 0) == "<") {    //SAVE
                save_pose(str, (string)dkey);
                announce();
            }
        }        
    }
}


