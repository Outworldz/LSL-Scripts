// :CATEGORY:Chat
// :NAME:cypher__Al_Bhed_chat_encryption
// :AUTHOR:Renmiri Writer
// :CREATED:2010-09-11 20:10:32.303
// :EDITED:2014-01-17 11:51:34
// :ID:209
// :NUM:283
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// // The Al Bhed language is a fictional language that is spoken only by the Al Bhed people on the video game Final Fantasy X .  The "Al Bhed language" is actually a simple substitution cipher, an encryption system of transposing certain letters for others. Sherlock Holmes used a similar cipher to decode the "dancing man" letters and solve the case. The code below comes with Al Bhed predefined, but any other cipher works. Just define your own string of unique characters. 
// :CODE:
// 
// For example, "You are cute" in English is rendered as "Oui yna lida" in Al Bhed:
// 
// You--> Oui  (* Y --> O , * O --> U , * U --> I)
//  
// are --> yna  (* A --> Y, * R --> N, * E --> A)
// 
// cute --> lida  (*C --> L , * O --> U, *T --> D, * E --> A)
// 
// Usage:
// Change channel 7576 for your preferred channel. Paste this script on a prim you own, give copies of the prim to all friends you want to chat al bhed with (translations are only viewed by prim owners)
// 
// To say "You are cute" and get al bhed:
// /7576 &You are cute
// (prim says "Oui yna lida" on normal chat. You and all other script owners using the same channel will see a second message with the translation "You are cute")
// 
// To talk directly in al bhed:
// /7576 @Oui yna lida
// (prim will repeat "Oui yna lida" in normal chat and translate it to "You are cute" to all script  owners on the same channel). This allows people talking al bhed on different channels to understand each other. Just repeat the message to translate to your own channel, with an @ before it, prim will give you a private translation.
// 
// Any message not starting with the Al Bhed tag "@" or the "normal" tag "&" will be ignored. This is good in case someone else or some other script is using the same channel you are. The tags can be replaced by your own tags (Apipe, Epipe)
// 
// This script works to translate any language to al bhed (or other cipher). Can work with kanji too, just change the "english" string to kanji and the "al bed" string to the equivalent kanji.
// 
// It actually is a very flexible,  lightning fast cipher encoder / decoder. Hope you enjoy it!

integer AChan=7576;
vector red = <1,0,0>;
vector green = <0,1,0>;
string Apipe = "@";
string Epipe = "&";
string english = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
string albhed = " ypltavkrezgmshubxncdijfqowYPLTAVKREZGMSHUBXNCDIJFQOW"; 
// to use any other cypher besides al bhed, just replace the string "al bhed" value with unique charaters

default
{
    state_entry()
    {
        llListen(AChan, "","", "" );
        llSetText(".",green,1.0);
        llSetText("speak on channel "+ (string) AChan +"  prefaced with "+ Epipe +" to get al bhed, \n you can say albhed text on channel "+ (string) AChan +" but prefaced with "+ Apipe +" to get it translated back to normal",green,1.0);
    }

    listen( integer channel, string name, key id, string message )
    {

            integer c = llStringLength(message);
            string newmessage = "" ; 
            string lcode="";
            string lcodet="";
            integer j= 0;
            integer k= 0;
            integer i = 1;
            j=llSubStringIndex(message,Apipe);
            string message1="";
            k=llSubStringIndex(message,Epipe);
    if (j>=0)
    {
       for (; i < c; ++i)
        {
        lcode = llGetSubString(message,i,i);
        integer fstop = llSubStringIndex(albhed,lcode);
        if (fstop > 0)
           lcodet = llGetSubString(english,fstop,fstop);
        else
           lcodet = lcode;
           
        newmessage += lcodet;
        }
            message1 = llGetSubString(message,1,c-1);
            llOwnerSay("("+name+" says secretly in al bhed) "+newmessage);
            llSay(0,"("+name+" says in al bhed) "+message1);
            
    } else {
           if (k>=0)
    {
       for (; i < c; ++i)
        {
        lcode = llGetSubString(message,i,i);
        integer fstop = llSubStringIndex(english,lcode);
        if (fstop > 0)
           lcodet = llGetSubString(albhed,fstop,fstop);
        else
           lcodet = lcode;
           
        newmessage += lcodet;
        }
            message1 = llGetSubString(message,1,c-1);
            llOwnerSay("("+name+" says secretly in al bhed) "+message1);
            llSay(0,"("+name+" says in al bhed) "+newmessage);
            
} else {
    llSay(0,"message --"+message+"-- by "+name+" on chanel "+(string) AChan+" ignored");
}
    }
}
}
