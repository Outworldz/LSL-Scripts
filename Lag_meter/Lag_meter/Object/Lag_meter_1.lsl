// :CATEGORY:Lag Meter
// :NAME:Lag_meter
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:56
// :ID:451
// :NUM:607
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The script
// :CODE:
float lag;
string lagStr;
integer decimalsAccuracy = 3;

string percentageLag()
{
lag = 1 - llGetRegionTimeDilation();
lag *= 100;
lagStr = (string)lag;
list cheat = llParseString2List(lagStr, ["."], []);
lagStr = llList2String(cheat, 0);
string decimals = llGetSubString(llList2String(cheat, 1), 0, decimalsAccuracy - 1);
string text = lagStr+"."+decimals+"%";
return text;
}

string getFPS()
{
float fps = llGetRegionFPS();
string str = (string)fps;
list cheat = llParseString2List(str, ["."], []);
str = llList2String(cheat, 0);
string decimals = llGetSubString(llList2String(cheat, 1), 0, 1);
string text = str+"."+decimals;
return text;
}

default
{
state_entry()
{
llSetTimerEvent(.05);
llListen(0, "", "", "");
}

listen(integer c, string n, key id, string msg)
{
if (msg == "report")
{
llSay(0, " -- "+llGetRegionName()+" --");
llSay(0, "Frames Per Second: "+getFPS());
llSay(0, "The sim lag is currently "+percentageLag()+"..");
}
if (msg == "lagtrace.on") llSetTimerEvent(.2);
if (msg == "lagtrace.off")
{
llSetTimerEvent(0);
llSetText("", <0,0,0>, 0.0);
}
}

timer()
{
llSetText("Lag: "+percentageLag(), <1,.5,.5>, 1.0);
}
}
