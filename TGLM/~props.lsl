//MPLV2 Version 2.3 by Learjeff Innis, based on 
//MLP MULTI-LOVE-POSE V1.2 - Copyright (c) 2006, by Miffy Fluffy (BSD License)

// v2.2 - rotate all props

// This script handles props (object rezzed for a given pose)

integer Checking = FALSE;       // whether doing consistency check

integer Line;
integer PoseCount;
list    Poses;                  // name of each pose with a prop
list    Positions;              // position of prop, indexed as Poses
list    Props;                  // name of each prop object, indexed as Poses

string  Pose;                   // current pose name

integer ChatChan;               // chan for talking to object

init()
{
    ChatChan = - 1 - (integer)llFrand(-DEBUG_CHANNEL);
    getRefPos();
}

vector RefPos;
rotation RefRot;

getRefPos() {   //reference position
    RefPos = llGetPos();
    RefRot = llGetRot();
    integer z = (integer)llGetObjectDesc();
    RefPos.z = RefPos.z + (float)z/100.0;
}

string plural(string singular, string plural, integer count) {
    if (count != 1) {
        return plural;
    }
    return singular;
}

announce()
{
    llOwnerSay((string)PoseCount
        + plural(" pose", " poses", PoseCount)
        + " with props ("
        + llGetScriptName()
        + ": "
        + (string)llGetFreeMemory()
        + " bytes free)");
}

string adjust(integer doOffset, vector pos, vector erot, vector amt) {
    if (doOffset) {
        pos = pos + amt/100.;
        return (vround(pos) + "/" + vround(erot));
    }
    rotation amount = llEuler2Rot(amt * DEG_TO_RAD);
    erot *= DEG_TO_RAD;
    
    rotation oldrot = llEuler2Rot(erot);
    rotation newrot = oldrot / amount;
    
    erot = llRot2Euler(newrot) * RAD_TO_DEG;
    pos = pos / amount;
    return(vround(pos) + "/" + vround(erot));
}


adjust_all(integer doOffset, vector amt) {
    integer ix;
    integer bx;
    string  data;
    list    ldata;
    vector  pos;
    vector  erot;
    

    for (ix = 0; ix < llGetListLength(Poses); ++ix) {
        data = llList2String(Positions, ix);
        ldata = llParseString2List(data, ["/"], []);
        pos = (vector)llList2String(ldata, 0);
        erot = (vector)llList2String(ldata, 1);
        
        data = adjust(doOffset, pos, erot, amt);
        Positions = llListReplaceList(Positions, (list)data, ix, ix);
    }
    llOwnerSay("Prop rotation complete");
}



string roundData(string data) {
    list ldata = llParseString2List(data, ["/"], []);
    return (vround((vector)llList2String(ldata, 0)) + "/" + vround((vector)llList2String(ldata, 1)));
}

// round a vector's components and return as vector value string
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


add_prop(string pose, string prop, string data) {
    if (llListFindList(Props, (list)pose) != -1) {
        llOwnerSay("Multiple *.PROPS* entries for pose '" + pose + "'");
    }
    if (llGetInventoryType(prop) != INVENTORY_OBJECT) {
        llOwnerSay("Warning: can't find prop '" + prop + "' in inventory");
    }
    Poses = [] + Poses + (list) pose;
    Props = [] + Props + (list) prop;
    Positions = [] + Positions + (list)roundData(data);
    ++PoseCount;
}

string get_pose_data(string pose) {
    integer ix = llListFindList(Poses, (list)pose);

    if (ix == -1) {
        return "";
    }

    return llList2String(Positions, ix);
}

save_prop(string pose, string prop, string data) {
    integer ix = llListFindList(Poses, [pose]);
    if (ix == -1) {
        // llSay(0, "new pose");
        add_prop(pose, prop, data); // don't expect this to happen
        return;
    }
    
    // if the prop object name doesn't match, ignore it -- assume it's noise
    if (llList2String(Props, ix) != prop) {
        return;
    }
    
    // Data is the change in position since we rezzed it, in global coords
    // Convert delta to local axes
    
    list ldata = llParseString2List(data, ["/"], []);
    vector pos = (vector) llList2String(ldata, 0);
    rotation rot = (rotation)llList2String(ldata, 1);
    
    pos = pos / RefRot;
    vector erot = llRot2Euler(rot/RefRot) * RAD_TO_DEG;
    
    // Now add to saved data (since it was a delta)
    ldata = llParseStringKeepNulls(llList2String(Positions, ix), ["/"], []);
    vector oldpos = (vector)llList2String(ldata, 0);
    
    pos = pos + oldpos;
    data = vround(pos) + "/" + vround(erot);

    Props     = llListReplaceList(Props,     (list)prop, ix, ix);
    Positions = llListReplaceList(Positions, (list)data, ix, ix);
    
    string name = llGetObjectName();
    llSetObjectName("");
    llOwnerSay("| " + pose + " | " + prop + " | " + data);
    llSetObjectName(name);
}

rez_prop(string pose) {
    llSay(ChatChan, "DIE");
    integer ix = llListFindList(Poses, [pose]);
    if (ix == -1) {
        Pose = "";
        llSetTimerEvent(0.0);
        return;
    }
    string prop = llList2String(Props, ix);
    string data = llList2String(Positions, ix);
    list ldata = llParseString2List(data, ["/"], []);
    vector pos = (vector)llList2String(ldata, 0);
    vector erot = (vector)llList2String(ldata, 1);

    pos = pos * RefRot + RefPos;
    rotation rot = llEuler2Rot(erot*DEG_TO_RAD) * RefRot;
    
    // llSay(0, "rezzing '" + prop + "' at " + (string) pos);
    llRezAtRoot(prop, pos, <0.,0.,0.>, rot, ChatChan);
    llSetTimerEvent(60.0);
    Pose = pose;
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
        llSleep(0.25);       // give ~run a chance to shut us down
        string item;
        ConfigCards = [];
        integer n = llGetInventoryNumber(INVENTORY_NOTECARD);
        while (n-- > 0) {
            item = llGetInventoryName(INVENTORY_NOTECARD, n);
            if (llSubStringIndex(item, ".PROPS") != -1) {
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

        data = llStringTrim(data, STRING_TRIM);
        if (llGetSubString(data,0,0) != "/" && llStringLength(data)) {          // skip comments and blank lines

            list ldata = llParseStringKeepNulls(data, ["  |  ","  | "," |  "," | "," |","| ","|"], []);
            if (llGetListLength(ldata) != 4) {
                llOwnerSay(llGetScriptName() + ": error in " + ConfigCardName + ":" + (string)ConfigLineIndex
                    + " - need exactly 3 vertical bars - line ignored");
            } else {
                string pose = llList2String(ldata, 1);
                string prop = llList2String(ldata, 2);
                string data1 = llStringTrim(llList2String(ldata, 3), STRING_TRIM);
                if (data1 == "") {
                    data1 = "<0,0,1>/<0,0,0>";
                }
                add_prop(pose, prop, data1);
            }
        }
        ++ConfigLineIndex;
        ConfigQueryId = llGetNotecardLine(ConfigCardName, ConfigLineIndex);       //read next line of positions notecard
    }

    state_exit() {
        // do one save to indicate actual amount of available memory
        string position = llList2String(Positions, 0);
        Positions = llListReplaceList(Positions, [position],0,0);

        llMessageLinked(LINK_THIS, 2, "OK", (key)""); //msg to menu, in case it's waiting for loading
        announce();
    }
}

state re_on
{
    state_entry() {
        state on;
    }
}

state on {
    state_entry() {
        init();
        llListen(ChatChan, "", NULL_KEY, "");
    }

    on_rez(integer arg) {
        state re_on;
    }
    
    listen(integer chan, string name, key id, string msg) {
        // llSay(0, name + ": " + msg);
        if (Pose == "") {
            return;
        }
        save_prop(Pose, name, msg);
        announce();
    }

    link_message(integer from, integer num, string str, key dkey) {

        if (str == "PRIMTOUCH" || num < 0) {
            return;
        }
        
        if (num == 0) {
            if (str == "POSEB") {
                rez_prop((string)dkey);
                return;
            }
            if (str == "REPOS") {
                getRefPos();
                return;
            }
            return;
        }

        if (num != 1) {
            return;
        }
        
        if (str == "STOP") {
            llSay(ChatChan, "DIE");
            Pose = "";
            llSetTimerEvent(0.0);
        }

        if (str == "DUMPPROPS") {
            dashes();
            llOwnerSay("Copy to .PROPS; delete any other *.PROPS* cards");
            dashes();
            string name = llGetObjectName();
            llSetObjectName("");

            integer ix;
            for (ix = 0; ix < PoseCount; ++ix) {
                string pose = llList2String(Poses, ix);
                string prop = llList2String(Props, ix);
                llOwnerSay("| " + pose + " | " + prop + " | " + get_pose_data(pose));
            }
            llSetObjectName(name);
            dashes();
        } else if (llSubStringIndex(str, "REORIENT=") == 0) {
            // Reorient command (LINKMENU command from .MENUITEMS file)
            // str format: REORIENT=OFF=<x,y,z> or REORIENT=ROT=<x,y,z> (in degrees)
            list    parms = llParseString2List(str, ["="], []);
            vector  amount  = (vector)llList2String(parms, 2);
            llWhisper(0, "Adjusting props, please wait");
            
            if (llList2String(parms, 1) == "OFF") {
                adjust_all(TRUE, amount);
            } else {
                adjust_all(FALSE, amount);
            }
            llMessageLinked(LINK_THIS, 0, "AGAIN", (key)"");
            llWhisper(0, "Prop adjustment complete");
        } else if (str == "SAVEPROP") {
            llSay(ChatChan, "SAVE");
        }
    }

    timer() {
        llSay(ChatChan, "LIVE");
    }
        
}