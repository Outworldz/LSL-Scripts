// :CATEGORY:Translator
// :NAME:1337_Translator
// :AUTHOR:Davy Maltz
// :KEYWORDS:
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2014-02-15
// :ID:994
// :NUM:1489
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Leet speak translator
// :CODE:
list alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"," "];
list encode;

list leet = ["4","8","(","|)","3","ƒ","6","#","|","]","|<","1","]V[","/\/","0","¶","0_","®","5","7","(_)","\/","vv","×","`/","2"," "];

list haxxorz = ["4","b","c","d","e","f","g","h","i","j","k","|","m","n","0","p","q","r","5","t","u","v","w","x","y","2"," "];

list sounds = ["ayh","bee","cey","dey","eey","eff","gee","ehch","eye","jay","kay","el","em","en","oh","pee","quew","are","ehs","tey","yoo","vee","double-yew","ecks","wayh","zee"," "];
string convertedtext;
default
{
    on_rez(integer start_parm)
    {
        llOwnerSay("Talk on channel '777' to encode text. Say '.1337', '.h4xx0r2', or '.sounds' To change the type of text encoding.");
        llResetScript();   
    }
    state_entry()
    {
        if(llGetObjectDesc() == "leet")
        {
        encode = leet;
        }
         if(llGetObjectDesc() == "haxxorz")
        {
        encode = haxxorz;
        }
         if(llGetObjectDesc() == "sounds")
        {
        encode = sounds;
        }
        else
        {
            encode = haxxorz;
        }
        llListen(777,"",llGetOwner(),"");
        llListen(0,"",llGetOwner(),"");
    }
    listen(integer channel, string name, key id, string message)
    {
        convertedtext = "";
        if(channel == 777)
        {
            integer i;
            for(i == 0; i < llStringLength(llToLower(message)); ++ i)
            {
                if(llListFindList(alphabet,[llGetSubString(llToLower(message),i,i)]) != -1)
                {
                    convertedtext = convertedtext + llList2String(encode,llListFindList(alphabet,[llGetSubString(llToLower(message),i,i)]));
                }
                else
                {
                    convertedtext = convertedtext + llGetSubString(llToLower(message),i,i);
                }
            }
    
            llSay(0,convertedtext);
        }
        if(channel == 0)
        {
            if(message == ".1337")
            {
                llOwnerSay("Encoding Now Set To '1337'.");
                encode = leet;
                llSetObjectDesc("leet");
            }
            if(message == ".h4xx0r2")
            {
                llOwnerSay("Encoding Now Set To 'h4xx0r2'.");
                encode = haxxorz;
                llSetObjectDesc("haxxorz");
            }
            if(message == ".sounds")
            {
                llOwnerSay("Encoding Now Set To 'Sounds'.");
                encode = sounds;
                llSetObjectDesc("sounds");
            }
        }
    }
}
