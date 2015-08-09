// :CATEGORY:HoverText
// :NAME:Banner_Text
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:76
// :NUM:103
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Banner Text.lsl
// :CODE:

string gBanner = "...touch to get Female SL avi kit...";
integer gNumChars = 20;
integer gPosition = 0;
vector gColor = <1,1,1>;
float gRefreshRate = 1.0;
float gAlpha = 1.0;
integer gImPublic = FALSE;

sendIM(string s){
    if(gImPublic){
        llWhisper(0,s);
    }else{
        llInstantMessage(llGetOwner(),s);
    }
}

default
{
    state_entry()
    {
        ",...touch to get Female SL avi kit...";
        llListen(0, "", "", "");
        llSetTimerEvent(gRefreshRate);
        gPosition = 0;
    }

    timer(){
        integer len = llStringLength(gBanner);
        integer diff = (gPosition + gNumChars) - len;
        string template = llGetSubString(gBanner,gPosition,gNumChars + gPosition);
        while(llStringLength(template) < gNumChars){
            template += " " + gBanner;
        }
        string sub = llGetSubString(template,0,gNumChars);
        llSetText(sub + "\n.\n.\n.",gColor,gAlpha);
        gPosition++;
        if(gPosition > len){
            gPosition = 0;
        }
    }

    listen(integer number, string name, key id, string msg){
        if(id != llGetOwner()){
            return;
        }
        list argv = llParseString2List(msg, [" "], []);
        integer argc = llGetListLength(argv);
        string cmd = llToLower(llList2String(argv, 0));
        if(cmd == "/banner"){
            string arg = llToLower(llList2String(argv, 1));
            if(arg == "length"){
                gNumChars = llList2Integer(argv, 2);
                if(gNumChars < 1){
                    gNumChars = 20;
                }
            }else if(arg == "speed"){
                gRefreshRate = llList2Float(argv, 2);
                if(gRefreshRate < 0.2){
                    gRefreshRate = 0.2;
                }
            }else if(arg == "rotate"){
                llSetTimerEvent(gRefreshRate);
            }else if(arg == "static"){
                llSetTimerEvent(0);
                llSetText(gBanner + "\n.\n.\n.",<1,1,1>,1);
            }else if(arg == "on"){
                llSetTimerEvent(gRefreshRate);
            }else if(arg == "off"){
                llSetTimerEvent(0);
                llSetText("",<0,0,0>,0);
            }else if(arg=="getrot"){
                llSay(0,(string)llGetRot());
            }else if(arg=="im"){
                gImPublic = !gImPublic;
                sendIM("gImPublic now set to " + (string)gImPublic);
            }else if(arg == "help"){
                sendIM("/banner on / off - enable / disable banner display");
                sendIM("/banner <text> - set banner text to '<text>'");
                sendIM("/banner length - set banner length in characters (for rotation)");
                sendIM("/banner rotate - enable rotation");
                sendIM("/banner static - disable rotation");
            }else{
                gBanner = llGetSubString(msg,8,128);
                llSetText(gBanner + "\n.\n.\n.",<1,1,1>,1);
                gPosition = 0;
            }
        }
    }
}
// END //
