// :CATEGORY:Tandy
// :NAME:Tandy the Nymph
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:06
// :ID:867
// :NUM:1209
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tandy
// :CODE:

//////////////////////////////////////////////////////////
//   (C) Wizardry and Steamworks 2011, license: GPLv3   //
// Please see: http://www.gnu.org/licenses/gpl.html     //
// for legal details, rights of fair usage and          //
// the disclaimer and warranty conditions.              //
//////////////////////////////////////////////////////////
// Mods for hovering flight by Ferd Frederix
// Link messages and reduction in complexity by eliminating redundant states

integer _debug = FALSE;// set to TRUE tio see what is going on in owner chat
integer ready = FALSE;    // set to TRUE when ready to animate
integer granted = FALSE;    // TRUE is AO permissions granted
key _owner = NULL_KEY;
key nQuery = NULL_KEY;
integer xLine = 0;
integer agentInfo = 0;
string _lastAnim = "";
string _lastAnimName = "";

string stream = "";
list sList = [];

//pragma inline
string xName = "XAO";

list walk_list = [];
list fly_list = [];
list sit_list = [];
list hover_list = [];
list stand_list = [];
list run_list = [];
list type_list = [];
list sitobj_list = [];

//pragma inline
list ANIMATION_NODES = [
    "walking",
    "hovering",
    "flying",
    "sitting",
    "standing",
    "running",
    "typing",
    "sitobject"
        ];

debug(string msg)
{
    if (_debug)
        llOwnerSay(msg);
}


//pragma inline
string wasStaX_GetNodeValue(string node) {
    list StaX = [];
    string value = "";
    xLine = 0;
    do {
        string current = llList2String(sList, xLine);
        string lookback = llList2String(sList, xLine-1);

        if(current != "/" && lookback == "<") {
            StaX += current;
            jump next_tag;
        }
        integer len = llGetListLength(StaX)-1;
        if(lookback == "/") {
            StaX = llDeleteSubList(StaX, len, len);
            jump next_tag;
        }
        if(current != ">" && current != "/" && current != "<")
            if(llList2String(StaX,len) == node)
                value += current + " ";
        @next_tag;
    } while(++xLine<agentInfo);

    if(llGetListLength(StaX) != 0) {
        llSay(DEBUG_CHANNEL, "The following tags may be unmatched: " + llDumpList2String(StaX, ",") + ". Please check your file.");
    }
    return value;
}

//pragma inline
changeAnimation(string animation) {

    debug("Setting: " + animation);
    string nAnim;
    if(animation == "walking") {
        nAnim = llList2String(walk_list, (integer)llFrand(llGetListLength(walk_list)));
        jump set_anim;
    }
    if(animation == "sitting") {
        nAnim = llList2String(sit_list, (integer)llFrand(llGetListLength(sit_list)));
        jump set_anim;
    }
    if(animation == "flying") {
        nAnim = llList2String(fly_list, (integer)llFrand(llGetListLength(fly_list)));
        jump set_anim;
    }
    if(animation == "hovering") {
        nAnim = llList2String(hover_list, (integer)llFrand(llGetListLength(hover_list)));
        jump set_anim;
    }
    if(animation == "standing") {
        nAnim = llList2String(stand_list, (integer)llFrand(llGetListLength(stand_list)));
    }
    if(animation == "running") {
        nAnim = llList2String(run_list, (integer)llFrand(llGetListLength(run_list)));
    }
    if(animation == "typing") {
        nAnim = llList2String(type_list, (integer)llFrand(llGetListLength(type_list)));
    }
    if(animation == "sitobject") {
        nAnim = llList2String(sitobj_list, (integer)llFrand(llGetListLength(sitobj_list)));
    }
    @set_anim;

    debug("Start: " + nAnim);
    llStartAnimation(nAnim);
    llStopAnimation(_lastAnimName);
    _lastAnimName = nAnim;
    _lastAnim = animation;
}

//pragma inline
integer commute() {
    string ani = llGetAnimation(_owner);
    if (ani  == "Hovering" || ani == "Hovering Down"  || ani == "Hovering Up" ) {
        debug("hover");
        return 6;
    }

    agentInfo = llGetAgentInfo(_owner);

    if(agentInfo & AGENT_WALKING) {
        debug("walk");
        return 0;
    }
    if(agentInfo & AGENT_FLYING) {
        debug("fly");
        return 1;
    }
    if(agentInfo & AGENT_ON_OBJECT) {
        debug("on object");
        return 2;
    }
    if(agentInfo & AGENT_SITTING) {
        debug("sit");
        return 3;
    }
    if(agentInfo & AGENT_ALWAYS_RUN) {
        debug("running");
        return 4;
    }
    if(agentInfo & AGENT_TYPING) {
        debug("type");
        return 5;
    }
    return 7;
}

default {
    state_entry() {
        _owner = llGetOwner();
        integer itra;
        for(itra=0, xLine=0, stream = ""; itra<llGetInventoryNumber(INVENTORY_NOTECARD); ++itra) {
            if(llGetInventoryName(INVENTORY_NOTECARD, itra) == xName)
                jump read;
        }
        llInstantMessage(llGetOwner(), "AO failed to find notecard XAO.");
        return;
        @read;
        nQuery = llGetNotecardLine(xName, xLine);
    }
    dataserver(key id, string data) {
        if(id != nQuery) return;
        if(data == EOF) {
            llOwnerSay("Readng AO Notecard ...");
            sList = llParseString2List(stream, [" "], ["<", ">", "/"]);
            stream = "";
            agentInfo = llGetListLength(sList);
            integer itra = llGetListLength(ANIMATION_NODES)-1;
            do {
                if(llList2String(ANIMATION_NODES, itra) == "walking") {
                    walk_list = llParseString2List(wasStaX_GetNodeValue("walking"), [" "], []);
                    jump anim_type;
                }
                if(llList2String(ANIMATION_NODES, itra) == "flying") {
                    fly_list = llParseString2List(wasStaX_GetNodeValue("flying"), [" "], []);
                    jump anim_type;
                }
                if(llList2String(ANIMATION_NODES, itra) == "sitting") {
                    sit_list = llParseString2List(wasStaX_GetNodeValue("sitting"), [" "], []);
                    jump anim_type;
                }
                if(llList2String(ANIMATION_NODES, itra) == "standing") {
                    stand_list = llParseString2List(wasStaX_GetNodeValue("standing"), [" "], []);
                }
                if(llList2String(ANIMATION_NODES, itra) == "running") {
                    run_list = llParseString2List(wasStaX_GetNodeValue("running"), [" "], []);
                }
                if(llList2String(ANIMATION_NODES, itra) == "typing") {
                    type_list = llParseString2List(wasStaX_GetNodeValue("typing"), [" "], []);
                }
                if(llList2String(ANIMATION_NODES, itra) == "hovering") {
                    hover_list = llParseString2List(wasStaX_GetNodeValue("hovering"), [" "], []);
                }
                if(llList2String(ANIMATION_NODES, itra) == "sitobject") {
                    sitobj_list = llParseString2List(wasStaX_GetNodeValue("sitobject"), [" "], []);
                }
                @anim_type;
            } while(--itra>=0);

            ready = TRUE;
            llRequestPermissions(_owner, PERMISSION_TRIGGER_ANIMATION);
            return;
        }
        if(data == "") jump next_line;
        stream += data;
        @next_line;
        nQuery = llGetNotecardLine(xName, ++xLine);
    }

    run_time_permissions(integer perm) {

        //debug(llDumpList2String(hover_list,","));

        if(perm & PERMISSION_TRIGGER_ANIMATION) {
            granted = TRUE;
            sList = llParseString2List(llDumpList2String(sList, ""), ["<", ">", "/"], []);
            integer itra=llGetListLength(sList)-1;
            do {
                llStopAnimation(llList2String(sList, itra));
            } while(--itra>=0);
            llOwnerSay("Starting AO");
            llSetTimerEvent((1.02-llGetRegionTimeDilation()));
        }
    }

    changed(integer change) {
        if(change & CHANGED_OWNER || change & CHANGED_INVENTORY) {
            llResetScript();
        }
    }

    on_rez(integer param) {
        if (! ready)
            llResetScript();
        else
           llRequestPermissions(_owner, PERMISSION_TRIGGER_ANIMATION);

    }

    timer() {
        // Get next state.
        agentInfo = commute();

        if(agentInfo == 0 && _lastAnim != "walking") { changeAnimation("walking"); }
        else if(agentInfo == 1 && _lastAnim != "flying") { changeAnimation("flying");  }
        else if(agentInfo == 2 && _lastAnim != "sitobject") { changeAnimation("sitobject"); }
        else if(agentInfo == 3 && _lastAnim != "sitting") { changeAnimation("sitting"); }
        else if(agentInfo == 4 && _lastAnim != "running") { changeAnimation("running"); }
        else if(agentInfo == 5 && _lastAnim != "typing") { changeAnimation("typing"); }
        else if(agentInfo == 6 && _lastAnim != "hovering") { changeAnimation("hovering"); }
        else if(agentInfo == 7 && _lastAnim != "standing") { changeAnimation("standing"); }
    }

    link_message(integer sender_number, integer number, string message, key id)
    {
        if (message == "AO On") {
            llRequestPermissions(_owner, PERMISSION_TRIGGER_ANIMATION);
        }
        else if (message == "AO Off") {
            llOwnerSay(message);
            llSetTimerEvent(0);
            if (granted) {
                llStopAnimation(_lastAnimName);
            }
        }

    }
}


