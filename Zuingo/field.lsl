vector txtCash = <0.05, -0.25, 0.0>;
vector txt2x   = <0.45, -0.25, 0.0>;

integer ID = 0;
integer iCurrentNum;
integer bTouched;

key player;

ssTouched(integer bool) {
    bTouched = bool;
    if (bTouched) llSetColor(<0.25, 0.25, 0.25>, ALL_SIDES); //dark
    else llSetColor(<1.0, 1.0, 1.0>, ALL_SIDES);
}


default {
    state_entry() {
        ID = (integer)llGetObjectName();
    }

    link_message(integer sender, integer num, string msg, key id) {
        list data = llParseString2List(msg, (list)"~~", []);
        string cmd = llList2String(data, 0);
        string value = llList2String(data, 1);
        
        if (num == -1 && msg == "setTexture") llSetTexture(id, ALL_SIDES);
        if (num == ID) {
            if (cmd == "startGame") {
                player = id;
                ssTouched(FALSE);
                vector offset; vector color;
                
                if ((integer)llList2String(data, 2)) color = <0.0, 1.0, 1.0>; //is blue
                else color = <1.0, 1.0, 1.0>; //not blue
                
                llSetColor(color, ALL_SIDES);
                
                iCurrentNum = (integer)value;
                if (iCurrentNum) {
                    offset.x = (iCurrentNum % 10) / 10.0;
                    offset.y = (iCurrentNum / 10) / 10.0;
                }
                
                
                offset.x += -0.45;
                offset.y = 0.45 - offset.y;
        
        
                llOffsetTexture(offset.x, offset.y, ALL_SIDES);
            } else if (cmd == "useNumber") {
                ssTouched(TRUE);
            } else if (msg == "setTextureCash") {
                llOffsetTexture(txtCash.x, txtCash.y, ALL_SIDES);
            } else if (msg == "setTexture2x") {
                llOffsetTexture(txt2x.x, txt2x.y, ALL_SIDES);
            } else if (msg == "line") {
                llSetColor((vector)((string)id), ALL_SIDES);
                llSleep(1.0);
                llSetColor(<0.25, 0.25, 0.25>, ALL_SIDES);
            }
        }
    }
    
    touch_start(integer n) {
        if (llDetectedKey(0) == player && !bTouched)
            llMessageLinked(LINK_ALL_OTHERS, ID, llDumpList2String(["fieldTouched", iCurrentNum], "~~"), NULL_KEY);
    }
}
