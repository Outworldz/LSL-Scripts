// :CATEGORY:Building
// :NAME:Object_to_Data_back_to_Object_v13
// :AUTHOR:Xaviar Czervik
// :CREATED:2011-01-22 12:03:27.567
// :EDITED:2013-09-18 15:38:58
// :ID:579
// :NUM:795
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Holo Box (Script) 
// :CODE:
string meta;
list data = ["", "", "", "", "", "", "", "", "", "", "", "", "", ""];
 
 
setLink() {
    list m = llParseString2List(meta, ["-=-"], []);
    llSetObjectName(llList2String(m, 0));
    llSetObjectDesc(llList2String(m, 1));
 
    list l = llParseString2List((string)data, ["-=-"], []);
    list real;
    integer i = 0;
    while (i < llGetListLength(l)) {
        string this = llList2String(l, i);
        string thisPart = llGetSubString(this, 0, 1);
        if (thisPart == "#S") {
            real += (string)llGetSubString(this, 2, -1);
        } else if (thisPart == "#K") {
            real += (key)llGetSubString(this, 2, -1);
        } else if (thisPart == "#I") {
            real += (integer)llGetSubString(this, 2, -1);
        } else if (thisPart == "#F") {
            real += (float)llGetSubString(this, 2, -1);
        } else if (thisPart == "#V") {
            real += (vector)llGetSubString(this, 2, -1);
        } else if (thisPart == "#R") {
            real += (rotation)llGetSubString(this, 2, -1);
        }
        i++;
    }
    llSetPrimitiveParams(real);
}
 
 
default {
    on_rez(integer i) {
        llListen(i, "", "", "");
    }
    listen(integer i, string n, key id, string m) {
        if (m == "Finish") {
            setLink();
            llSleep(.5);
            llRemoveInventory(llGetScriptName());
        }
        integer num = (integer)llGetSubString(m, 0, 0);
        if (num == 0) {
            meta = llGetSubString(m, 1, -1);
        } else {
            num--;
            data = llListReplaceList(data, [llGetSubString(m, 1, -1)], num, num);
        }
    }
}

