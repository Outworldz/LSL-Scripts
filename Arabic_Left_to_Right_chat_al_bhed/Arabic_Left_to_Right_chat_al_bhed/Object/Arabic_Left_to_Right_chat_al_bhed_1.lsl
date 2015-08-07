// :CATEGORY:Chat
// :NAME:Arabic_Left_to_Right_chat_al_bhed
// :AUTHOR:Renmiri Writer
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:47
// :ID:49
// :NUM:67
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Left to right rendering of Chat (for Arabic) and also Al Bhed translation// added a few lines to read the string backwards (for left to right rendering), on the al bhed and english "if" and added a section for unaltered chat (except for left to right rendering).
// :CODE:

integer AChan=5;
vector red = <1,0,0>;
vector green = <0,1,0>;
string Apipe = "@";
string Epipe = "&";
string Arabic = " ابتثجحخدذرزسشصضطظعغفقكلمنهويyou";
string AlBhed = " ﺍﺑﺘﺜﺠﺤﺨﺪﺫﺭﺯﺳﺸﺼﻀﻄﻈﻌﻐﻔﻘﻜﻠﻤﻨﻬﻮﻱoui"; 
// to use any other cypher besides al bhed, just replace the string "al bhed" value with unique charaters
// Arabic al bhed by Khaled Dix, code by Renmiri Writer
//you and oui are here just for testing, if like me, you can't read arabic :p -- Ren
//

default
{
    state_entry()
    {
        llListen(AChan, "","", "" );
        llSetText(".",green,1.0);
        llSetText("speak on channel "+ (string) AChan +" to get it left to right \n To get Al Bhed chat preface Arabic text with "+ Epipe +"  \n To translate Al Bhed use preface"+ Apipe +" ",green,1.0);
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
        integer fstop = llSubStringIndex(AlBhed,lcode);
        if (fstop > 0)
           lcodet = llGetSubString(Arabic,fstop,fstop);
        else
           lcodet = lcode;
           
        newmessage += lcodet;
        }
            message1 = llGetSubString(message,1,c-1);
            integer ar = 0;
            integer c1 = llStringLength(newmessage);
            string message2="";
            for (ar=1;ar <=c1;++ar){
                message2 += llGetSubString(message1,0-ar,0-ar);
                //llSay(0,message2);
            }
            string message3="";
            for (ar=1;ar <=c1;++ar){
                message3 += llGetSubString(newmessage,0-ar,0-ar);
                //llSay(0,message3);
            }
            llOwnerSay("("+name+" says secretly in al bhed) "+message3);
            llSay(0,"("+name+" says in al bhed) "+message2);
            
    } else {
           if (k>=0)
    {
       for (; i < c; ++i)
        {
        lcode = llGetSubString(message,i,i);
        integer fstop = llSubStringIndex(Arabic,lcode);
        if (fstop > 0)
           lcodet = llGetSubString(AlBhed,fstop,fstop);
        else
           lcodet = lcode;
           
        newmessage += lcodet;
        }
            message1 = llGetSubString(message,1,c+1);
            integer ar = 0;
            integer c1 = llStringLength(newmessage);
            string message2="";
            for (ar=1;ar <=c1;++ar){
                message2 += llGetSubString(message1,0-ar,0-ar);
                //llSay(0,message2);
            }
            string message3="";
            for (ar=1;ar <=c1;++ar){
                message3 += llGetSubString(newmessage,0-ar,0-ar);
                //llSay(0,message3);
            }
            llOwnerSay("("+name+" says secretly in al bhed) "+message2);
            llSay(0,"("+name+" says in al bhed) "+message3);
            
} else {
    //llSay(0,"message --"+message+"-- by "+name+" on chanel "+AChan+" ignored");
    string message3="";
    integer ar = 0;
    integer c1 = llStringLength(message);
    for (ar=1;ar <=c1;++ar){
                message3 += llGetSubString(message,0-ar,0-ar);
                //llSay(0,message3);
            }
            llSay(0,"("+name+" says left to right) "+message3);
}
    }
}
}

   









