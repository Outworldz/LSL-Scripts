// :CATEGORY:Prim
// :NAME:Puppeteer
// :AUTHOR:Kira Komarov
// :CREATED:2012-03-24 17:21:10.650
// :EDITED:2013-09-18 15:39:00
// :ID:666
// :NUM:907
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// [K] Puppeteer Animator
// :CODE:
//////////////////////////////////////////////////////////
//                 PUPPETEER ANIMATOR                   //
//////////////////////////////////////////////////////////
// Gremlin: Puppeteer Animator, see Puppeteer Recorder
//////////////////////////////////////////////////////////
// [K] Kira Komarov - 2011, License: GPLv3              //
// Please see: http://www.gnu.org/licenses/gpl.html     //
// for legal details, rights of fair usage and          //
// the disclaimer and warranty conditions.              //
//////////////////////////////////////////////////////////
 
string pupData;
key pQuery;
 
integer nDone = 0;
integer itra = 0;
 
init() {
    for(itra=0; itra<llGetInventoryNumber(INVENTORY_NOTECARD); ++itra) {
        if(llGetInventoryName(INVENTORY_NOTECARD, itra) == "Puppet")
            jump found_puppet;
    }
    llOwnerSay("No puppet found, please load the notecard.");
    return;
@found_puppet;
    itra = 0;
    pQuery = llGetNotecardLine("Puppet", itra);
    llSetTimerEvent(1);
}
 
default
{
    state_entry() {
        init();
    }
    on_rez(integer num) {
        init();
    }
    changed(integer change) {
        init();
    }
 
    dataserver(key query_id,string data) {
        if (query_id != pQuery) return;
        if (data == EOF) {
            nDone = 1;
            return;
        }
        pupData += data;
        pQuery = llGetNotecardLine("Puppet", ++itra);
    }
    timer() {
        if(!nDone) return;
        llSetTimerEvent(0);
        state puppet;
    }
}
 
state puppet {
    state_entry() {
        list tPup = llParseString2List(pupData, ["[K]"], [""]);
        pupData = "";
        list pos = llParseString2List(llList2String(tPup, 0), ["#"], [""]);
        list rot = llParseString2List(llList2String(tPup, 1), ["#"], [""]);
@cycle;
        for(itra=0; itra<llGetListLength(pos); ++itra) {
            list tPos = llParseString2List(llList2String(pos, itra), [",", "<", ">"], [""]);
            vector sPos = <llList2Float(tPos, 0), llList2Float(tPos, 1), llList2Float(tPos, 2)>;
            list tRot = llParseString2List(llList2String(rot, itra), [",", "<", ">"], [""]);
            rotation sRot = <llList2Float(tRot, 0), llList2Float(tRot, 1), llList2Float(tRot, 2), llList2Float(tRot, 3)>;
            llSetPos(sPos);
            llSetLocalRot(sRot);
        }
        jump cycle;
    }
    changed(integer change) {
        if(change & CHANGED_INVENTORY) llResetScript();
    }
}
