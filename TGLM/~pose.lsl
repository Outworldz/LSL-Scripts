 //MPLV2 Version 2.1, Lear Cale, from:
//MLP MULTI-LOVE-POSE V1.2 - Copyright (c) 2006, by Miffy Fluffy (BSD License)

integer MAX_AVS = 6;

integer a;
integer ch;
integer i;
integer swap;
string an1;
string an2;
string an3;
string an4;
string an5;
string an6;
string pose;

list    PRs;    // pos/rot pairs for Save

list anims;     // strided list of anims, indexed by pose*6
vector pos;
rotation rot;
integer BallCount;      // number of balls
integer UpdateCount;    // number of balls we've heard from, for save

string prStr(string str) {
    i = llSubStringIndex(str,">");
    vector p = ((vector)llGetSubString(str,0,i) - pos) / rot;
    vector r = llRot2Euler((rotation)llGetSubString(str,i+1,-1) / rot)*RAD_TO_DEG;
    return "<"+round(p.x, 3)+","+round(p.y, 3)+","+round(p.z, 3)+"> <"+round(r.x, 1)+","+round(r.y, 1)+","+round(r.z, 1)+">";
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

check_anim(string aname) {
    if (aname == "") {
        return;
    }
    if (   aname != "PINK"
        && aname != "BLUE"
        && aname != "stand"
        && aname != "sit_ground") {

        // ignore expression suffix of "*" or "::nnn"
        if (llGetSubString(aname, -1, -1) == "*") {
            aname = llGetSubString(aname, 0, -2);
        } else {
            integer ix = llSubStringIndex(aname, "::");
            if (ix != -1) {
                aname = llGetSubString(aname, 0, ix-1);
            }
        }
        
        if (llGetInventoryType(aname) != INVENTORY_ANIMATION) {
            llSay(0,"animation '"
                + aname
                + "' not in inventory (ok for build-in animations, otherwise check)");
        }
    }
}

getChan() {
    ch = (integer)("0x"+llGetSubString((string)llGetKey(),-4,-1));  //fixed channel for prim
}

default {

    link_message(integer from, integer num, string data, key id) {
        if (num != 9+a) return;

        if (data == "LOADED") state on;
        
        list ldata = llParseString2List(data,["  |  ","  | "," |  "," | "," |","| ","|"],[]);

        an1 = llList2String(ldata,1);
        an2 = llList2String(ldata,2);
        an3 = llList2String(ldata,3);
        an4 = llList2String(ldata,4);
        an5 = llList2String(ldata,5);
        an6 = llList2String(ldata,6);

        if (a>1) {
            check_anim(an1);
            check_anim(an2);
            check_anim(an3);
            check_anim(an4);
            check_anim(an5);
            check_anim(an6);
        } else if (a) { //pose1: set default
            if (an1 == "") an1 = "sit_ground";
            if (an2 == "") an2 = "sit_ground";
            if (an3 == "") an3 = "sit_ground";
            if (an4 == "") an4 = "sit_ground";
            if (an5 == "") an5 = "sit_ground";
            if (an6 == "") an6 = "sit_ground";
        } else {        //pose0: set stand
            if (an1 == "") an1 = "stand";
            if (an2 == "") an2 = "stand";
            if (an3 == "") an3 = "stand";
            if (an4 == "") an4 = "stand";
            if (an5 == "") an5 = "stand";
            if (an6 == "") an6 = "stand";
        }
        anims = [] + anims + [an1] + [an2] + [an3] + [an4] + [an5] + [an6];
        ++a;
    }
    state_exit() {
        llOwnerSay((string)a+" poses loaded ("+llGetScriptName()+": "+(string)llGetFreeMemory()+" bytes free)");
    }
}


state on {
    state_entry() {
        getChan();
    }
    
    on_rez(integer arg) {
        getChan();
    }

    link_message(integer from, integer num, string cmd, key akey) {
        if (cmd == "PRIMTOUCH"){
            return;
        }
        if (num) return;
        if (cmd == "POSE") {
            list parms = llCSV2List((string)akey);
            BallCount = llList2Integer(parms,1);
            a = llList2Integer(parms,0) * 6;
            an1 = llList2String(anims, a);
            an2 = llList2String(anims, a+1);
            an3 = llList2String(anims, a+2);
            an4 = llList2String(anims, a+3);
            an5 = llList2String(anims, a+4);
            an6 = llList2String(anims, a+5);
        } else if (cmd == "SWAP") {
            swap = !swap;
        } else if (cmd == "SAVE") {
            pose = (string)akey;
            state save;
        } else return;
        llMessageLinked(LINK_THIS,ch+swap, an1,(key)"");   //msg to poser 1/2
        llMessageLinked(LINK_THIS,ch+!swap,an2,(key)"");
        llMessageLinked(LINK_THIS,ch+2, an3,(key)"");   //msg to poser 3
        llMessageLinked(LINK_THIS,ch+3, an4,(key)"");   //msg to poser 4
        llMessageLinked(LINK_THIS,ch+4, an5,(key)"");   //msg to poser 4
        llMessageLinked(LINK_THIS,ch+5, an6,(key)"");   //msg to poser 4
    }
}

state save {
    state_entry() {
        llMessageLinked(LINK_THIS,0,"GETREFPOS","");    //msg to pos: ask ref position
        integer ix;
        PRs = [ "", "", "", "", "", "" ];

        for (ix = 0; ix < MAX_AVS; ++ix) {
            llListen(ch+16+ix,  "", NULL_KEY, "");
            llSay(ch+ix,"SAVE");       //msg to balls
        }
        llSetTimerEvent(3);
        UpdateCount = 0;
    }


    listen(integer channel, string name, key id, string pr) {
        channel -= (ch + 16);
        
        if (channel == 0) {
            channel = channel + swap;
        } else if (channel == 1) {
            channel = channel - swap;
        }
        
        PRs = llListReplaceList(PRs, (list)pr, channel, channel);

        if (++UpdateCount == BallCount) {
            pr = "";
            integer ix;
            for (ix = 0; ix < BallCount; ++ix) {
                pr += prStr(llList2String(PRs, ix)) + " ";
            }                    

            llOwnerSay("{"+pose+"} "+pr);
            llMessageLinked(LINK_THIS,1,pose,pr);       //write to memory
            state on;
        }
    }
    link_message(integer from, integer num, string posstr, key rotkey) {
        if (posstr == "PRIMTOUCH"){
            return;
        }
        if (num != 8) return;
        pos = (vector)posstr;                   //revtrieve reference position from pos
        rot = (rotation)((string)rotkey);
    }
    timer() {
        state on;
    } 
     state_exit() {
        llSetTimerEvent(0);
    }   
}