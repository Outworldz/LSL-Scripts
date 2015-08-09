// :CATEGORY:Hovertext
// :NAME:SetText_Rotating_Banner
// :AUTHOR:Kex Godel
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:02
// :ID:745
// :NUM:1028
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// SetText Rotating Banner.lsl
// :CODE:

// SetText Rotating Banner
// Original Author: Kex Godel, an avatar in the virtual world Second Life (Linden Labs)
//
// This work is licensed under Creative Commons Attribution-NonCommercial-ShareAlike 1.0 License
// * You are free:
//   - to copy, distribute, display, and perform the work 
//   - to make derivative works
// * Under the following conditions:
//   - Attribution. You must give the original author credit. 
//   - Noncommercial. You may not use this work for commercial purposes.
//   - Share Alike. If you alter, transform, or build upon this work, you may
//     distribute the resulting work only under a license identical to this one. 
// * For any reuse or distribution, you must make clear to others the license
//   terms of this work. 
// * Any of these conditions can be waived if you get permission from the author. 
// * Your fair use and other rights are in no way affected by the above.
// * Details at: http://creativecommons.org/licenses/by-nc-sa/1.0/

string gBanner = "Banner";
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
        gBanner = llKey2Name(llGetOwner()) + ", type /banner help to learn how to use this banner.";
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
