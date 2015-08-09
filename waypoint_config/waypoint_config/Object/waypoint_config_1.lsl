// :CATEGORY:Tour Guide
// :NAME:waypoint_config
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:967
// :NUM:1389
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// waypoint_config.lsl
// :CODE:

list waypoints = [];
integer waypoint = 0;
integer chat_listener = 0;

string replaceString(string pattern, string replace, string source, integer count) {
    while(count-- != 0) {
        integer index = llSubStringIndex(source, pattern);
        if(index < 0)
            return source;
        source = llInsertString(llDeleteSubString(source, index, (index + llStringLength(pattern) - 1)), index, replace);
    }
    return source;
}
string ce(integer c, string t, string f) {
    if(c == TRUE)
        return t;
    else
        return f;
}
show_dialog(key user) {
    integer wpcount = llGetListLength(waypoints) >> 1;
    llDialog(user,"We are at waypoint " + ((string)(waypoint+1)) + "/" + ((string)wpcount) + "\nPosition: " + (string)llList2Vector(waypoints,waypoint<<1) + "\nRotation: " + (string)llList2Rot(waypoints,(waypoint<<1)+1),[ce(waypoint > 0, "<", " "),"save",">","clear","load"],-19923);
}
save() {
    if(waypoint >= llGetListLength(waypoints) >> 1)
        waypoints = (waypoints=[]) + waypoints + [llGetPos(),llGetRot()];
    else {
        waypoints = llListReplaceList(waypoints, [llGetPos(), llGetRot()], waypoint << 1, (waypoint << 1) + 1);
    }
}
unsave() {
    if(waypoint >= llGetListLength(waypoints) >> 1)
        save();
    else {
        llSetPos(llList2Vector(waypoints, waypoint << 1));
        llSetRot(llList2Rot(waypoints, (waypoint << 1) + 1));
        //llMoveToTarget(llList2Vector(waypoints, waypoint << 1),0.25);
        //llRotLookAt(llList2Rot(waypoints, (waypoint << 1) + 1), 1, 0.25);
    }
}
say() {
    list tmp = [];
    integer i = llGetListLength(waypoints);
    vector sp = llList2Vector(waypoints, 0);
    while(i>=2) {
        tmp = (tmp=[]) + [llList2Vector(waypoints, i - 2) - sp, llList2Rot(waypoints, i - 1)] + tmp;
        i-=2;
    }
    string str = "vector start = " + (string)sp + "; list waypoints = [" + llDumpList2String(tmp, ", ") + "];";
    llSay(0, str);
}
default {
    touch_start(integer num) {
        llListen(-19923,"","","");
        save();
        show_dialog(llDetectedKey(0));
    }
    listen(integer chan, string name, key user, string msg) {
        if(chan == 0) {
            if(llGetSubString(msg,0,4) != "load ")
                return;
            llListenRemove(chat_listener);
            chat_listener = 0;

            save();
            say();

            list tmp = llCSV2List(llGetSubString(msg,5,-1));
            waypoints = [];
            waypoint = 0;
            while(waypoint<llGetListLength(tmp)) {
                vector v = (vector)llList2String(tmp, waypoint++);
                rotation r = (rotation)llList2String(tmp, waypoint++);
                llOwnerSay((string)v);
                waypoints = (waypoints=[]) + waypoints + [v,r];
            }
            
            waypoint = 0;
            unsave();
        }
        else if(msg == "<") {
            save();
            if(waypoint > 0)
                waypoint--;
            unsave();
        }
        else if(msg == ">") {
            save();
            waypoint++;
            unsave();
        }
        else if(msg == "save") {
            save();
            say();
            return;
        }
        else if(msg == "clear") {
            save();
            say();
            waypoint = 0;
            waypoints = [];
            save();
        }
        else if(msg == "load") {
            llSay(0,"Type \"load <x,y,z>,<x,y,z,s>,...\" in chat...");
            chat_listener = llListen(0,"","","");
            return;
        }
        else
            llOwnerSay((string)name+"("+(string)chan+"): "+msg);
        show_dialog(user);
    }
}
// END //
