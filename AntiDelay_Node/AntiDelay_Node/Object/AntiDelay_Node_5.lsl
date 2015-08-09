// :CATEGORY:AntiDelay
// :NAME:AntiDelay_Node
// :AUTHOR:Xaviar Czervik
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:43
// :NUM:61
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// AntiDelay Node: 
// :CODE:
 
integer myId;
default {
    link_message(integer send, integer i, string s, key k) {
        if (i == myId && myId) {
            myId = (integer)s;
            state run;
        }
        if (i == -111) {
            myId = (integer)llFrand(0x7FFFFFFF);
            llSleep(llFrand(5));
            llMessageLinked(LINK_SET, -2, (string)myId, "");
        }
    }
}
 
state run {
    link_message(integer send, integer i, string s, key k) {
        list params = llParseString2List(s, ["~~~"], []);
        if (i == myId && myId) {
            if (llToLower(k) == "email") {
                llEmail(llList2String(params, 0),
                    llList2String(params, 1),
                    llList2String(params, 2));
            }
            if (llToLower(k) == "loadurl") {
                llLoadURL((key)llList2String(params, 0),
                    llList2String(params, 1),
                    llList2String(params, 2));
            }
            if (llToLower(k) == "teleportagenthome") {
                llTeleportAgentHome((key)llList2String(params, 0));
            }
            if (llToLower(k) == "remoteloadscriptpin") {
                llRemoteLoadScriptPin((key)llList2String(params, 0),
                    llList2String(params, 1),
                    (integer)llList2String(params, 2),
                    (integer)llList2String(params, 3),
                    (integer)llList2String(params, 4));
            }
            if (llToLower(k) == "remotedatareply") {
                llRemoteDataReply((key)llList2String(params, 0),
                    (key)llList2String(params, 1),
                    llList2String(params, 2),
                    (integer)llList2String(params, 3));
            }
            if (llToLower(k) == "giveinventorylist") {
                llGiveInventoryList((key)llList2String(params, 0),
                    llList2String(params, 1),
                    llCSV2List(llList2String(params, 2)));
            }
            if (llToLower(k) == "setparcelmusicurl") {
                llSetParcelMusicURL(llList2String(params, 0));
            }
            if (llToLower(k) == "instantmessage") {
                llInstantMessage((key)llList2String(params, 0),
                    llList2String(params, 1));
            }
            if (llToLower(k) == "preloadsound") {
                llPreloadSound(llList2String(params, 0));
            }
            if (llToLower(k) == "mapdestination") {
                llMapDestination(llList2String(params, 0),
                    (vector)llList2String(params, 1),
                    (vector)llList2String(params, 2));
            }
            if (llToLower(k) == "dialog") {
                llDialog((key)llList2String(params, 0),
                    llList2String(params, 1),
                    llCSV2List(llList2String(params, 2)),
                    (integer)llList2String(params, 3));
            }
            if (llToLower(k) == "createlink") {
                llCreateLink((key)llList2String(params, 0),
                    (integer)llList2String(params, 1));
            }
            if (llToLower(k) == "setpos") {
                llSetPos((vector)llList2String(params, 0));
            }
            if (llToLower(k) == "setrot") {
                llSetRot((rotation)llList2String(params, 0));
            }
            if (llToLower(k) == "settexture") {
                llSetTexture(llList2String(params, 0),
                    (integer)llList2String(params, 1));
            }
            if (llToLower(k) == "rezobject") {
                llRezObject(llList2String(params, 0),
                    (vector)llList2String(params, 1), 
                    (vector)llList2String(params, 2), 
                    (rotation)llList2String(params, 3), 
                    (integer)llList2String(params, 4));
            }
        }
        if (i == -112) {
            llResetScript();
        }
    }
}
 
