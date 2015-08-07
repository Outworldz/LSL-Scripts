// :CATEGORY:IM
// :NAME:Email_to_IM
// :AUTHOR:DoteDote Edison
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:52
// :ID:280
// :NUM:378
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The script
// :CODE:
// Email-to-IM
// DoteDote Edison

///////// constants /////////
// how often to check for new email when owner is online (seconds)
float FAST = 60.0;
// how often to check owner online status when owner is offline (seconds)
float SLOW = 300.0;
// timezone offset from UTC
integer OFFSET = -4;

////////// globals //////////
key request;
key owner;
integer owner_online;

string GetStamp(string time) {
list weekdays = ["THU", "FRI", "SAT", "SUN", "MON", "TUE", "WED"];
integer a = (integer)time + (OFFSET*3600);
integer hours = a/3600;
integer mins = a/60;
string day = llList2String(weekdays, (hours/24)%7);
return (string)(hours%24) + ":" + (string)(mins%60) + " " + day;
}

default {
state_entry() {
owner = llGetOwner();
string address = (string)llGetKey() + "@lsl.secondlife.com";
llSetText("Email Server\nOnline", <0.25, 1.0, 0.25>, 1.0);
llOwnerSay("Now online. The Email-to-IM address for " + llKey2Name(owner) + " is:\n" + address);
llSetTimerEvent(FAST);
}
on_rez(integer start_param) {
llResetScript();
}
touch_start(integer num_detect) {
if (llDetectedKey(0) == owner) state off;
}
email(string time, string sender, string subject, string body, integer num_remain) {
llInstantMessage(owner, "Email Received from: " + sender + " -- " + GetStamp(time));
llInstantMessage(owner, body);
if (num_remain > 0) llGetNextEmail("", "");
}
dataserver(key query, string data) {
if (query == request) {
request = "";
if (data == "1") {
owner_online = TRUE;
llSetTimerEvent(FAST);
}
else {
owner_online = FALSE;
llSetTimerEvent(SLOW);
}
}
}
timer() {
request = llRequestAgentData(owner, DATA_ONLINE);
if (owner_online) llGetNextEmail("", "");
}
state_exit() {
llSetTimerEvent(0.0);
llSetText("Email Server\nOffline", <1.0, 0.25, 0.25>, 1.0);
}
}

state off {
touch_start(integer num_detect) {
if (llDetectedKey(0) == owner) state default;
}
on_rez(integer start_param) {
llResetScript();
}
}
