//MPLV2 Version 2.3 by Learjeff Innis, based on 
//MLP MULTI-LOVE-POSE V1.2 - Copyright (c) 2006, by Mi ffy Fluffy (BSD License)

// Allow programmed sequences of poses

// This script resets whenever any of its config cards change.

integer MAX_AVS = 6;

list    SeqNames;           // name of each sequence
list    SeqSteps;           // CSV of steps for each seq, indexed as SeqNames
list    CurSeqSteps;

string  CurSeqName;
integer CurSeqStepIx;
string  CurMenu;
string  CurPose;

// debugs:
// 1 = sequence start/stop
// 2 = echo each step as executed
// 4 = av hop on/off
// 8 = avwait check
// 0x10 = debug config


integer Debug;

list    DELIMS = ["  |  ","  | "," |  "," | "," |","| ","|"];

list    COMMANDS = [
      "MENU"
    , "POSE"
    , "WAIT"
    , "REPEAT"
    , "LABEL"
    , "GOTO"
    , "STOP"
    , "WHISPER"
    , "SAY"
    , "AVWAIT"
    ];

config_init() {
    SeqNames    = [];
    SeqSteps    = [];
    Debug       = 0;
}

config_done() {
    seq_save();             // save last sequence, if any
    debug(0x10, "Names: " + llList2CSV(SeqNames));
}

parse_config_line(string data) {
    if (llGetSubString(data,0,0) == "/" || llStringLength(data) == 0) {          // skip comments and blank lines
        return;
    }

    list    ldata = llParseStringKeepNulls(data, DELIMS, []);
    string  cmd     = llList2String(ldata, 0);
    string  arg1    = llList2String(ldata, 1);
    string  arg2    = llList2String(ldata, 2);
    string  arg3    = llList2String(ldata, 3);

    if (cmd == "SEQUENCE") {
        seq_save();         // save previous sequence, if any
        CurSeqName = arg1;        
        CurSeqSteps = [];
    } else if (llListFindList(COMMANDS, (list)cmd) >= 0) {
        if (cmd == "LABEL") {
            CurSeqSteps += (list) (cmd + "|" + arg1);
        } else {
            CurSeqSteps += (list) (cmd + "|" + arg1 + "|" + arg2 + "|" + arg3);
        }
    } else if (cmd == "debug") {
        Debug += (integer)arg1;
    } else {
        llWhisper(0, "Unknown sequence command: '" + cmd + "' - ignoring");
    }
}


list    Avnames;    // one for each ball
integer Avwait;
list    AvwaitBalls;

// List of avatar names per ball: adding/removing/checking

addAv(string name, integer ballIx) {
    Avnames = llListReplaceList(Avnames, (list)name, ballIx, ballIx);
    if (Avwait && avs_seated()) {
        Avwait = FALSE;
        llSetTimerEvent(0.1);
    }
}

removeAv(integer ballIx) {
    addAv("", ballIx);
}

integer avs_seated() {
    integer ix;
    integer ball;
    for (ix = llGetListLength(AvwaitBalls) - 1; ix >= 0; --ix) {
        ball = llList2Integer(AvwaitBalls, ix);
        if (llList2String(Avnames, ball) == "") {
            debug(8, "Nobody on ball " + (string) ball);
            return FALSE;
        }
    }
    debug(8, "All avs seated");
    return TRUE;
}


// In 'src', replace 'target' string with 'replacement' string,
// and return the result.

string replace_text(string src, string target, string replacement)
{
    string  text = src;
    integer ix;

    ix = llSubStringIndex(src, target);

    if (ix >= 0) {
        text = llDeleteSubString(text, ix, ix + llStringLength(target) - 1); 
        text = llInsertString(text, ix, replacement);
    }        
    
    return (text);
}

string firstname(string name) {
    return llList2String(llParseString2List(name, [" "], []), 0);
}

string customize(string src) {
    integer avix;
    string avname;
    for (avix = 0; avix < MAX_AVS; ++avix) {
        avname = firstname(llList2String(Avnames, avix));
        if (avname == "") avname = "somebody";
        src = replace_text(src, "/"+(string)avix, avname);
    }
    return src;
}


send_cmd(string cmd) {
    llMessageLinked(LINK_THIS, -12002, cmd, (key)"");
}


seq_save() {
    if (CurSeqName ==  "") {
        return;
    }
    SeqNames += CurSeqName;
    SeqSteps += llList2CSV(CurSeqSteps);
}

seq_start(string name) {
    Avwait = FALSE;
    integer ix = llListFindList(SeqNames, (list)name);
    if (ix < 0) {
        llWhisper(0, "No such sequence: '" + name + "'");
        CurSeqSteps = [];
        CurSeqStepIx = -1;
        return;
    }
    debug(1, "Start sequence " + name);
    
    CurSeqStepIx = 0;
    CurSeqSteps = llCSV2List(llList2String(SeqSteps, ix));
    seq_execute();
}

seq_advance() {
    if (++CurSeqStepIx >= llGetListLength(CurSeqSteps)) {
        seq_stop();
    }
}

seq_execute() {
    list    step;
    string  cmd;
    string  arg1;
    string  arg2;
    string  arg3;

    while (CurSeqStepIx >= 0) {
        step = llParseString2List(llList2String(CurSeqSteps, CurSeqStepIx), DELIMS, []);
        cmd     = llList2String(step, 0);
        arg1    = llList2String(step, 1);
        arg2    = llList2String(step, 2);
        arg3    = llList2String(step, 3);

        debug(2, cmd + "|" + arg1);
        
        if (cmd == "MENU") {
            CurMenu = arg1;
            send_cmd(CurMenu);
            seq_advance();
        } else if (cmd == "POSE") {
            // llSleep(.5);
            CurPose = arg1;
            send_cmd(arg1);
            if (arg3 != "") {
                llWhisper((integer)arg2, customize(arg3));
            }
            seq_advance();
        } else if (cmd == "WAIT") {
            llSetTimerEvent((float) arg1);
            seq_advance();
            return;
        } else if (cmd == "REPEAT") {
            CurSeqStepIx = 0;
        } else if (cmd == "LABEL") {
            seq_advance();
        } else if (cmd == "GOTO") {
            CurSeqStepIx = llListFindList(CurSeqSteps, (list)("LABEL|" + arg1));
            if (CurSeqStepIx < 0) {
                llWhisper(0, "No such sequence label: '" + arg1 + "'");
                seq_stop();
                return;
            }
        } else if (cmd == "WHISPER") {
            llWhisper((integer)arg1, customize(arg2));
            seq_advance();
        } else if (cmd == "SAY") {
            llSay((integer)arg1, customize(arg2));
            seq_advance();
        } else if (cmd == "AVWAIT") {
            integer argix;
            integer ballix;
            AvwaitBalls = [];
            list balls = llParseString2List(arg1, [" "], []);
            for (argix = llGetListLength(balls) - 1; argix >= 0; --argix) {
                ballix = (integer)llList2String(balls, argix);
                AvwaitBalls += (list)(ballix);
            }   

            seq_advance();
            if (! avs_seated()) {
                llSetTimerEvent(0.);        // just to be sure
                if (arg2 != "") {
                    llWhisper(0, arg2);
                }
                Avwait = TRUE;
                return;
            }
        } else {
            send_cmd(cmd);
            seq_advance();
        }
    }
}

seq_stop() {
    Avwait = FALSE;
    debug(1, "stopping sequence");
    CurSeqStepIx = -1;
    llSetTimerEvent(0.);
}

debug(integer level, string txt) {
    if (Debug & level) {
        llWhisper(0, llGetScriptName() + ": " + txt);
    }
}

string plural(string singular, string plural, integer count) {
    if (count != 1) {
        return plural;
    }
    return singular;
}

announce()
{
    integer count = llGetListLength(SeqNames);
    llOwnerSay((string)count
        + plural(" sequence (", " sequences (", count)
        + llGetScriptName()
        + ": "
        + (string)llGetFreeMemory()
        + " bytes free)");
}


// Globals for reading card config
integer ConfigLineIndex;
list    ConfigCards;        // list of names of config cards
string  ConfigCardName;     // name of card being read
integer ConfigCardIndex;    // index of next card to read
key     ConfigQueryId;
string  ConfigCardKeys;     // to see if anything changed

string get_cards() {
    ConfigCards = [];
    string keys = "";
    string item;

    integer ix = llGetInventoryNumber(INVENTORY_NOTECARD);
    while (ix-- > 0) {
        item = llGetInventoryName(INVENTORY_NOTECARD, ix);
        if (llSubStringIndex(item, ".SEQUENCES") >= 0) {
            ConfigCards += (list) item;
            keys += (string)llGetInventoryKey(item);
        }
    }
    return keys;
}

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
        ConfigCardKeys = get_cards();
        ConfigCardIndex = 0;
        ConfigCards = llListSort(ConfigCards, 1, TRUE);
        if (! next_card()) {
            state on;
        }
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

        parse_config_line(llStringTrim(data, STRING_TRIM));
        ++ConfigLineIndex;
        ConfigQueryId = llGetNotecardLine(ConfigCardName, ConfigLineIndex);       //read next line of positions notecard
    }

    state_exit() {
        config_done();
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
        Avnames = [];
        integer ix;
        for (ix = 0; ix < MAX_AVS; ++ix) {
            Avnames += (list)"";
        }
    }

    on_rez(integer arg) {
        state re_on;
    }
    
    link_message(integer from, integer num, string str, key dkey) {

        if (str == "PRIMTOUCH") {
            return;
        }
        
        if (num == 0 && str == "POSEB") {
            if ((string)dkey != CurPose) {
                seq_stop();
            }
            return;
        }

        if (num == 1 && str == "STOP") {
            seq_stop();
            return;
        }

        if (num == -11000) {
            // av hopped on
            list parms = llParseStringKeepNulls(str, ["|"], []);
            integer ballnum = (integer)llList2String(parms, 0);
            // string anim = llList2String(parms, 1);     // anim name parameter, if desired
            debug(4, llKey2Name(dkey) + ": on ball " + (string)ballnum);
            addAv(llKey2Name(dkey), ballnum);
            return;

        } else if (num == -11001) {
            // av hopped off
            debug(4, llKey2Name(dkey) + ": off ball " + str);
            removeAv((integer)str);
            return;

        } else if (num != -12001) {
            return;
        }
        
        list ldata = llParseString2List(str, [" "], []);
        string cmd = llList2String(ldata, 0);
        if (cmd == "SEQUENCE") {
            seq_start(llList2String(ldata, 1));
        } else if (cmd == "PAUSE") {
            debug(1, "pausing");
            llSetTimerEvent(0.);
        } else if (cmd == "RESUME") {
            debug(1, "resuming");
            llSetTimerEvent(.1);
        }
    }

    timer() {
        seq_execute();
    }
    
    changed(integer change) {
        if (change & CHANGED_INVENTORY) {
            if (get_cards() != ConfigCardKeys) {
                llResetScript();
            }
        }
    }
}

