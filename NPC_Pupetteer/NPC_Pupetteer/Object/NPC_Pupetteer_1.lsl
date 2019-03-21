// :CATEGORY:OpenSim NPC
// :NAME:NPC_Pupetteer
// :AUTHOR:Wizardy and Steamworks
// :CREATED:2013-07-30 13:53:09.060
// :EDITED:2013-09-18 15:38:58
// :ID:573
// :NUM:786
// :REV:1.0
// :WORLD:OpenSim
// :DESCRIPTION:
// Bug fixes by Fred Beckhusen (Ferd Frederix) 7-30-2013//
// Note: @wander will only wander around the rez point.  
// :CODE:
// original from http://was.fm/opensim:npc
///////////////////////////////////////////////////////////////////////////
//    Copyright (C) 2013 Wizardry and Steamworks - License: GNU GPLv3    //
///////////////////////////////////////////////////////////////////////////


//  Please see: http://www.gnu.org/licenses/gpl.html for legal details,  //
//  rights of fair usage, the disclaimer and warranty conditions.        //
///////////////////////////////////////////////////////////////////////////

// Mods by Fred Beckhusen (Ferd Frederix)

// 7-29-2013
// llSensor  had two params swapped
// There was no 'no_sensor' event in sit, so if a @sit failed, the NPC got stuck
// The animation and walks always stopped old, then started new.  It should be start new, then stop old so the default stand would be suppressed
// Added OS_NPC_SENSE_AS_AGENT so NPCs can be sensed as avatars by other scripts.
 
//////////////////////////////////////////////////////////
//                  CONFIGURATION                       //
//////////////////////////////////////////////////////////
 
// How much time, in seconds, does a standing animation 
// cycle take? 
float ANIMATION_CYCLE_TIME = 10;
 
///////////////////////////////////////////////////////////////////////////
//                              INTERNALS                                //
///////////////////////////////////////////////////////////////////////////
 

vector wasCirclePoint(float radius) {
    float x = llPow(-1, 1 + (integer) llFrand(2)) * llFrand(radius*2);
    float y = llPow(-1, 1 + (integer) llFrand(2)) * llFrand(radius*2);
    if(llPow(x,2) + llPow(y,2) <= llPow(radius,2))
        return <x, y, 0>;
    return wasCirclePoint(radius);
}
 
///////////////////////////////////////////////////////////////////////////
//    Copyright (C) 2013 Wizardry and Steamworks - License: GNU GPLv3    //
///////////////////////////////////////////////////////////////////////////
string wasKeyValueGet(string var, string kvp) {
    list dVars = llParseString2List(kvp, ["&"], []);
    do {
        list data = llParseString2List(llList2String(dVars, 0), ["="], []);
        string k = llList2String(data, 0);
        if(k != var) jump continue;
        return llList2String(data, 1);
@continue;
        dVars = llDeleteSubList(dVars, 0, 0);
    } while(llGetListLength(dVars));
    return "";
}
 
///////////////////////////////////////////////////////////////////////////
//    Copyright (C) 2013 Wizardry and Steamworks - License: GNU GPLv3    //
///////////////////////////////////////////////////////////////////////////
string wasKeyValueSet(string var, string val, string kvp) {
    list dVars = llParseString2List(kvp, ["&"], []);
    if(llGetListLength(dVars) == 0) return var + "=" + val;
    list result = [];
    do {
        list data = llParseString2List(llList2String(dVars, 0), ["="], []);
        string k = llList2String(data, 0);
        if(k == "") jump continue;
        if(k == var && val == "") jump continue;
        if(k == var) {
            result += k + "=" + val;
            val = "";
            jump continue;
        }
        string v = llList2String(data, 1);
        if(v == "") jump continue;
        result += k + "=" + v;
@continue;
        dVars = llDeleteSubList(dVars, 0, 0);
    } while(llGetListLength(dVars));
    if(val != "") result += var + "=" + val;
    return llDumpList2String(result, "&");
}

///////////////////////////////////////////////////////////////////////////
//    Copyright (C) 2013 Wizardry and Steamworks - License: GNU GPLv3    //
///////////////////////////////////////////////////////////////////////////
string wasKeyValueDelete(string var, string kvp) {
    list dVars = llParseString2List(kvp, ["&"], []);
    list result = [];
    list added = [];
    do {
        list data = llParseString2List(llList2String(dVars, 0), ["="], []);
        string k = llList2String(data, 0);
        if(k == var) jump continue;
        string v = llList2String(data, 1);
        if(v == "") jump continue;
        if(llListFindList(added, (list)k) != -1) jump continue;
        result += k + "=" + v;
        added += k;
@continue;
        dVars = llDeleteSubList(dVars, 0 ,0);
    } while(llGetListLength(dVars));
    return llDumpList2String(result, "&");
}
 
// Vector that will be filled by the script with
// the initial starting position in region coordinates.
vector iPos = ZERO_VECTOR;
// Storage for destination position.
vector dPos = ZERO_VECTOR;
// Storage for the NPC script.
list npcScript = [];
// Storage for the next action.
string npcAction = "";
string npcParams = "";
// Storage for talking on local chat.
string npcSay = "";
 
 
stop()
{
    osNpcRemove(wasKeyValueGet("key", llGetObjectDesc()))   ;
} 

default {
    state_entry() {
        osNpcRemove(wasKeyValueGet("key", llGetObjectDesc()));
        llSetTimerEvent(5);
    }
    timer() {
        npcScript = llParseString2List(osGetNotecard("Script"), ["\n"], []);
        if(llGetListLength(npcScript) == 0) {
            llSay(DEBUG_CHANNEL, "No script notecard found.");
            llSetTimerEvent(0);
            return;
        }
        llSetTimerEvent(0);
        state script;
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START) llResetScript();
    }
    on_rez(integer num) {
        llResetScript();
    }
}
 
state script
{
    state_entry() {
@ignore;
        string next = llList2String(npcScript, 0);
        npcScript = llDeleteSubList(npcScript, 0, 0);
        npcScript += next;
        if(llGetSubString(next, 0, 0) != "@") jump ignore;
        list data  = llParseString2List(next, ["="], []);
        npcAction = llToLower(llStringTrim(llList2String(data, 0), STRING_TRIM));
        npcParams = llStringTrim(llList2String(data, 1), STRING_TRIM);
        llSetTimerEvent(1);
    }
    timer() {
        llSetTimerEvent(0);
@commands;
        if(npcAction == "@spawn") {
            integer lastIdx = llGetListLength(npcScript)-1;
            npcScript = llDeleteSubList(npcScript, lastIdx, lastIdx);
            list spawnData = llParseString2List(npcParams, ["|"], []);
            llSetObjectDesc(wasKeyValueSet("name", llList2String(spawnData, 0), llGetObjectDesc()));
            list spawnDest = llParseString2List(llList2String(spawnData, 1), ["<", ",", ">"], []);
            iPos.x = llList2Float(spawnDest, 0);
            iPos.y = llList2Float(spawnDest, 1);
            iPos.z = llList2Float(spawnDest, 2);
            state spawn;
        }
        if(npcAction == "@goto") {
            integer lastIdx = llGetListLength(npcScript)-1;
            npcScript = llDeleteSubList(npcScript, lastIdx, lastIdx);
            // Wind commands till goto label.
@wind;
            string next = llList2String(npcScript, 0);
            npcScript = llDeleteSubList(npcScript, 0, 0);
            npcScript += next;
            if(next != npcParams) jump wind;
            // Wind the label too.
            next = llList2String(npcScript, 0);
            npcScript = llDeleteSubList(npcScript, 0, 0);
            npcScript += next;
            // Get next command.
            list data  = llParseString2List(next, ["="], []);
            npcAction = llToLower(llStringTrim(llList2String(data, 0), STRING_TRIM));
            npcParams = llStringTrim(llList2String(data, 1), STRING_TRIM);
            // Reschedule.
            jump commands;
        }
        if(npcAction == "@walk") {
            list dest = llParseString2List(npcParams, ["<", ",", ">"], []);
            dPos.x = llList2Float(dest, 0);
            dPos.y = llList2Float(dest, 1);
            dPos.z = llList2Float(dest, 2);
            state walk;
        }
        if(npcAction == "@say") {
            npcSay = npcParams;
            state say;
        }
        if(npcAction == "@pause") {
            llSetObjectDesc(wasKeyValueSet("pause", npcParams, llGetObjectDesc()));
            state pause;
        }
        if(npcAction == "@wander") {
            list wanderData = llParseString2List(npcParams, ["|"], []);
            llSetObjectDesc(wasKeyValueSet("wd", llList2String(wanderData, 0), llGetObjectDesc()));
            llSetObjectDesc(wasKeyValueSet("wc", llList2String(wanderData, 1), llGetObjectDesc()));
            iPos = llGetPos();
            state wander;
        }
        if(npcAction == "@rotate") {
            llSetObjectDesc(wasKeyValueSet("rot", npcParams, llGetObjectDesc()));
            state rotate;
        }
        if(npcAction == "@sit") {
            llSetObjectDesc(wasKeyValueSet("sit", npcParams, llGetObjectDesc()));
            state sit;
        }
        if(npcAction == "@stand") {
            state stand;
        }
        if(npcAction == "@stop") {
            state stop;
        }
        if(npcAction == "@delete") {
            state delete;
        }
        if(npcAction == "@animate") {
            list animateData = llParseString2List(npcParams, ["|"], []);
            llSetObjectDesc(wasKeyValueSet("an", llList2String(animateData, 0), llGetObjectDesc()));
            llSetObjectDesc(wasKeyValueSet("at", llList2String(animateData, 1), llGetObjectDesc()));
            state animate;
        }
        llSay(DEBUG_CHANNEL, "ERROR: Unrecognized script line: " + npcAction + "=" + npcParams);
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START) llResetScript();
    }
    on_rez(integer num) {
        llResetScript();
    }
}
 
state rotate {
    state_entry() {
        osNpcSetRot(wasKeyValueGet("key", llGetObjectDesc()), llEuler2Rot(<0,0,(float)wasKeyValueGet("rot", llGetObjectDesc())> * DEG_TO_RAD));
        llSetTimerEvent(2);
    }
    link_message(integer sender, integer num, string str, key id) {
        if(id == "@npc_say") 
            osNpcSay(wasKeyValueGet("key", llGetObjectDesc()), str);
        else if(id == "@npc_stop") 
        {
            stop();        
            state stopped;
        }
    }
    timer() {
        llSetObjectDesc(wasKeyValueDelete("rot", llGetObjectDesc()));
        state script;
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START) 
            llResetScript();
    }
    on_rez(integer num) {
        llResetScript();
    }
}
 
state sit {
    state_entry() {
        llSensorRepeat(wasKeyValueGet("sit", llGetObjectDesc()), "", PASSIVE|ACTIVE,  96, TWO_PI, 1);
    }
    sensor(integer num) {
        llSensorRemove();
        osNpcSit(wasKeyValueGet("key", llGetObjectDesc()), llDetectedKey(0), OS_NPC_SIT_NOW);
        llSetTimerEvent(2);
    }
    no_sensor()
    {
        llSetObjectDesc(wasKeyValueDelete("sit", llGetObjectDesc()));
        state script;

    }
    timer() {
        llSetObjectDesc(wasKeyValueDelete("sit", llGetObjectDesc()));
        state script;
    }
     link_message(integer sender, integer num, string str, key id) {
        if(id == "@npc_say") 
            osNpcSay(wasKeyValueGet("key", llGetObjectDesc()), str);
        else if(id == "@npc_stop") 
        {
            stop();        
            state stopped;
        }
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START) llResetScript();
    }
    on_rez(integer num) {
        llResetScript();
    }
}
 
state stand {
    state_entry() {
        osNpcStand(wasKeyValueGet("key", llGetObjectDesc()));
        state script;
    }
     link_message(integer sender, integer num, string str, key id) {
        if(id == "@npc_say") 
            osNpcSay(wasKeyValueGet("key", llGetObjectDesc()), str);
        else if(id == "@npc_stop") 
        {
            stop();        
            state stopped;
        }
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START) llResetScript();
    }
    on_rez(integer num) {
        llResetScript();
    }
}
 
state animate {
    state_entry() {
        if(llGetInventoryType(wasKeyValueGet("an", llGetObjectDesc())) == INVENTORY_ANIMATION) osNpcPlayAnimation(wasKeyValueGet("key", llGetObjectDesc()), wasKeyValueGet("an", llGetObjectDesc()));
        llSetTimerEvent((integer)wasKeyValueGet("at", llGetObjectDesc()));
    }
     link_message(integer sender, integer num, string str, key id) {
        if(id == "@npc_say") 
            osNpcSay(wasKeyValueGet("key", llGetObjectDesc()), str);
        else if(id == "@npc_stop") 
        {
            stop();        
            state stopped;
        }
    }
    timer() {
        if(llGetInventoryType(wasKeyValueGet("an", llGetObjectDesc())) == INVENTORY_ANIMATION) osNpcStopAnimation(wasKeyValueGet("key", llGetObjectDesc()), wasKeyValueGet("an", llGetObjectDesc()));
        llSetObjectDesc(wasKeyValueDelete("an", llGetObjectDesc()));
        llSetObjectDesc(wasKeyValueDelete("at", llGetObjectDesc()));
        state script;
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START) llResetScript();
    }
    on_rez(integer num) {
        llResetScript();
    }
}
 
state spawn
{
    state_entry() {
        list name = llParseString2List(wasKeyValueGet("name", llGetObjectDesc()), [" "], []);
        llSetObjectDesc(wasKeyValueSet("key", osNpcCreate(llList2String(name, 0), llList2String(name, 1), iPos, "appearance",OS_NPC_SENSE_AS_AGENT), llGetObjectDesc()));
        osNpcLoadAppearance(wasKeyValueGet("key", llGetObjectDesc()), "appearance");
        if(llGetInventoryType("Stand") == INVENTORY_ANIMATION) osNpcPlayAnimation(wasKeyValueGet("key", llGetObjectDesc()), "Stand");
        llSetTimerEvent(10);
    }
     link_message(integer sender, integer num, string str, key id) {
        if(id == "@npc_say") 
            osNpcSay(wasKeyValueGet("key", llGetObjectDesc()), str);
        else if(id == "@npc_stop") 
        {
            stop();        
            state stopped;
        }
    }
    timer() {
        llSetTimerEvent(0);
        if(llGetInventoryType("Stand") == INVENTORY_ANIMATION) osNpcStopAnimation(wasKeyValueGet("key", llGetObjectDesc()), "Stand");
        llSetObjectDesc(wasKeyValueDelete("name", llGetObjectDesc()));
        state script;
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START) llResetScript();
    }
    on_rez(integer num) {
        llResetScript();
    }
 
}
 
state delete {
    state_entry() {
        osNpcRemove(llGetObjectDesc());
        llResetScript();
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START) llResetScript();
    }
    on_rez(integer num) {
        llResetScript();
    }
}
 
state stop {
    state_entry() {
        if(llGetInventoryType("Stand") == INVENTORY_ANIMATION) osNpcPlayAnimation(wasKeyValueGet("key", llGetObjectDesc()), "Stand");
    }
    link_message(integer sender, integer num, string str, key id) {
        if(id == "@npc_say") 
            osNpcSay(wasKeyValueGet("key", llGetObjectDesc()), str);
        else if(id == "@npc_stop") 
        {
            stop();        
            state stopped;
        }
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START) llResetScript();
    }
    on_rez(integer num) {
        llResetScript();
    }
}
 
state walk {
    state_entry() {
        if(llGetInventoryType("Walk") == INVENTORY_ANIMATION) osNpcPlayAnimation(wasKeyValueGet("key", llGetObjectDesc()), "Walk");
        osNpcMoveToTarget(wasKeyValueGet("key", llGetObjectDesc()), dPos, OS_NPC_NO_FLY);
        llSetTimerEvent(1);
    }
    link_message(integer sender, integer num, string str, key id) {
        if(id == "@npc_say") 
            osNpcSay(wasKeyValueGet("key", llGetObjectDesc()), str);
        else if(id == "@npc_stop") 
        {
            stop();        
            state stopped;
        }
    }
    timer() {
        if (llVecDist(osNpcGetPos(wasKeyValueGet("key", llGetObjectDesc())), dPos) > 2) return;
        llSetTimerEvent(0);
        if(llGetInventoryType("Walk") == INVENTORY_ANIMATION) osNpcStopAnimation(wasKeyValueGet("key", llGetObjectDesc()), "Walk");
        state script;
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START) llResetScript();
    }
    on_rez(integer num) {
        llResetScript();
    }
}
 
state say {
    state_entry() {
        osNpcSay(wasKeyValueGet("key", llGetObjectDesc()), npcSay);
        npcSay = "";
        state script;
    }
    
    link_message(integer sender, integer num, string str, key id) {
        if(id == "@npc_say") 
            osNpcSay(wasKeyValueGet("key", llGetObjectDesc()), str);
        else if(id == "@npc_stop") 
        {
            stop();        
            state stopped;
        }
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START) llResetScript();
    }
    on_rez(integer num) {
        llResetScript();
    }
}
 
state wander
{
    state_entry() {
        dPos = iPos + wasCirclePoint((integer)wasKeyValueGet("wd", llGetObjectDesc()));
        if(llGetInventoryType("Walk") == INVENTORY_ANIMATION) osNpcPlayAnimation(wasKeyValueGet("key", llGetObjectDesc()), "Walk");
        osNpcMoveToTarget(wasKeyValueGet("key", llGetObjectDesc()), dPos, OS_NPC_NO_FLY);
        llSetTimerEvent(0.1);
    }
     link_message(integer sender, integer num, string str, key id) {
        if(id == "@npc_say") 
            osNpcSay(wasKeyValueGet("key", llGetObjectDesc()), str);
        else if(id == "@npc_stop") 
        {
            stop();        
            state stopped;
        }
    }
    timer() {
        if (llVecDist(osNpcGetPos(wasKeyValueGet("key", llGetObjectDesc())), dPos) > 2) return;
        llSetTimerEvent(0);
        if(llGetInventoryType("Walk") == INVENTORY_ANIMATION) osNpcStopAnimation(wasKeyValueGet("key", llGetObjectDesc()), "Walk");
        if(wasKeyValueGet("wc", llGetObjectDesc()) == "0") {
            llSetObjectDesc(wasKeyValueDelete("wc", llGetObjectDesc()));
            llSetObjectDesc(wasKeyValueDelete("wd", llGetObjectDesc()));
            state script;
        }
        llSetObjectDesc(wasKeyValueSet("wc", (string)((integer)wasKeyValueGet("wc", llGetObjectDesc())-1), llGetObjectDesc()));
        state wait;
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START) llResetScript();
    }
    on_rez(integer num) {
        llResetScript();
    }
}
 
state wait {
    state_entry() {
        if(llGetInventoryType("Stand") == INVENTORY_ANIMATION) osNpcPlayAnimation(wasKeyValueGet("key", llGetObjectDesc()), "Stand");
        llSetTimerEvent(ANIMATION_CYCLE_TIME);
    }
    link_message(integer sender, integer num, string str, key id) {
        if(id == "@npc_say") 
            osNpcSay(wasKeyValueGet("key", llGetObjectDesc()), str);
        else if(id == "@npc_stop") 
        {
            stop();        
            state stopped;
        }
    }
    timer() {
        llSetTimerEvent(0);
        if(llGetInventoryType("Stand") == INVENTORY_ANIMATION) osNpcStopAnimation(wasKeyValueGet("key", llGetObjectDesc()), "Stand");
        state wander;
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START) llResetScript();
    }
    on_rez(integer num) {
        llResetScript();
    }
}
 
state pause {
    state_entry() {
        if(llGetInventoryType("Stand") == INVENTORY_ANIMATION) osNpcPlayAnimation(wasKeyValueGet("key", llGetObjectDesc()), "Stand");
        llSetTimerEvent(ANIMATION_CYCLE_TIME * 1+llFrand((integer)wasKeyValueGet("pause", llGetObjectDesc())-1));
    }
    link_message(integer sender, integer num, string str, key id) {
        if(id == "@npc_say") 
            osNpcSay(wasKeyValueGet("key", llGetObjectDesc()), str);
        else if(id == "@npc_stop") 
        {
            stop();        
            state stopped;
        }
    }
    timer() {
        llSetTimerEvent(0);
        if(llGetInventoryType("Stand") == INVENTORY_ANIMATION) osNpcStopAnimation(wasKeyValueGet("key", llGetObjectDesc()), "Stand");
        llSetObjectDesc(wasKeyValueDelete("pause", llGetObjectDesc()));
        state script;
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START) llResetScript();
    }
    on_rez(integer num) {
        llResetScript();
    }
}


state stopped {
    state_entry(){
        osNpcRemove(wasKeyValueGet("key", llGetObjectDesc()))   ;
    }
    
    link_message(integer sender, integer num, string str, key id) {
        if(id == "@npc_start") 
        {
            llResetScript();
        }
    }
}
