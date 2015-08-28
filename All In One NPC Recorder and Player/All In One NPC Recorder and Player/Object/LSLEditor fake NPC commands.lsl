// :SHOW:1
// :CATEGORY:NPC
// :NAME:All In One NPC Recorder and Player
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2013-09-08 18:27:47
// :EDITED:2015-08-02  21:09:13
// :ID:27
// :NUM:1603
// :REV:1.3
// :WORLD:OpenSim
// :DESCRIPTION:
// All in one NPC recorder player set of debug functions. Add these ONLY if you are compileing in LSLEditor.
// :CODE:
// IMPORTANT NOTE 
// DELETE ALL these lines out for Opensim, leave uncommented for testing in LSLEditor

integer OS_NPC_CREATOR_OWNED = 1;
integer OS_NPC_SIT_NOW = 1;
integer OS_NPC_SENSE_AS_AGENT = 2;
integer OS_NPC_NO_FLY = 3;
integer OS_NPC_NOT_OWNED = 4;
integer OS_NPC_RUNNING = 5;
integer  OS_NPC_LAND_AT_TARGET = 6;
integer OS_NPC_FLY = 7;


integer osIsNpc(key id){
    return TRUE;
}

osNpcStand(key npc) {
    llOwnerSay("Standing");
}
vector osNpcGetPos(key id) {
    vector vDestPos;
    vDestPos.x += llFrand(1.0);        // some randomness for debugging
    llOwnerSay("Reached " + (string) vDestPos);
    return vDestPos;
}
osNpcMoveToTarget(key npc, vector target, integer options){
    llSay(0,"Moving to " + (string) target);
}
key osNpcCreate(string firstname, string lastname, vector position, string cloneFrom, integer options) {
    llSay(0,"Creating NPC " + firstname + " " + lastname + " at " + (string) position);
    return (key) "12345000-0000-0000-0000-0000000000002";
}
osNpcLoadAppearance(key npc, string notecard) {
    llSay(0,"Load notecard " + notecard);
}
osNpcPlayAnimation(key npc, string animation) {
    llSay(0,"Playing animation " + animation);
}
osNpcStopAnimation(key npc, string animation) {
    llSay(0,"Stopped animation " + animation);
}
osNpcSay(key npc, integer iChannel, string message) {
    llSay(0,"Saying " + message);
}
osNpcWhisper(key npc, integer iChannel, string message) {
    llSay(0,"Whispering " + message);
}
osNpcShout(key npc, integer iChannel, string message) {
    llSay(0,"Shouting " + message);
}
osNpcSit(key npc, key target, integer options) {
    llSay(0,"Sat on " +target);
}
osNpcSetRot(key npc, rotation rot) {
    llSay(0,"Set rotation of NPC to " + (string) rot);
}
osOwnerSaveAppearance(string notecard) {
    llSay(0,"Created Notecard " + notecard);
}
osAgentSaveAppearance(key avatar, string notecard) {
    llSay(0,"Created Notecard " + notecard);
}
osNpcRemove (key  target) {
    llSay(0,"NPC removed");
}
list osGetAvatarList () {
    list lStuff = [(key) "12345000-0000-0000-0000-0000000000002", vDestPos, "Digit Gorilla"];
    return lStuff;
}
osMakeNotecard(string notecardName, string contents) {
    llOwnerSay("Make Notecard " + notecardName + "Contents:" +  (string) contents);
}
string osGetNotecard(string name) {
    // sample notecard for testing
    string str = "@spawn=Digit Gorilla|<645, 128, 25>\n"
        + "@walk=<645, 120, 25>\n"
        + "REPEAT\n"
        + "@cmd=0|Hello on channel 0\n"
        + "@wander=3|5\n"
        + "@say=say , walking is so tiresome...\n"
        + "@whisper=whisper, walking is so tiresome...\n"
        + "@shout=shout, walking is so tiresome...\n"
        + "@goto=REPEAT\n"
        + "@goto=NEXT\n"
        + "@say=i will never say this...\n"
        + "NEXT\n"
        + "@sound=somesound\n"
        + "@randsound\n"
        + "@pause=5\n"
        + "@rotate=90\n"
        + "@wander=3|1\n"
        + "@say=Uff, I'm done...\n"
        + "@delete\n";
    return str;
}

osAvatarPlayAnimation(key npc, string animation){
    llSay(0,"playing  " + animation);
}

osAvatarStopAnimation(key npc, string animation){
    llSay(0,"Stopping " + animation);
}

osForceOtherSit(key AvatarKey, key UUID) {
    llSay(0,"Sitting");
}


osSetSpeed(key NPC, float speed) {
    llSay(0,"Speed set to " + (string) speed);
}

osNpcTouch(key NPC, key thing, integer where) {;}

osForceAttachToOtherAvatarFromInventory(key npc, string inventory, integer point) {
    llSay(0,"attach " + inventory  + " to " + (string) point);
}


// END commented code for OpenSim vs Editor environments
//*******************************************************************//
// comment this out, is only here for testing in LSLEditor.
// default {}
