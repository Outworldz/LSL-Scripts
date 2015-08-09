// :CATEGORY:Printf
// :NAME:Printf
// :AUTHOR:Vince Bosen
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:00
// :ID:658
// :NUM:895
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Printf
// :CODE:
//Created by: Vince
string format(string text, list args)
{
    integer len=(args!=[]);
    if(len==0)
    {
        return text;
    }
    else{
        string ret=text;
        integer i;
        for(i=0;i<len;i++)
        {
            integer pos=llSubStringIndex(ret,"{"+(string)i+"}");
            if(pos!=-1)
            {
                ret=llDeleteSubString(ret,pos,pos+llStringLength("{"+(string)i+"}")-1);
                ret=llInsertString(ret,pos,llList2String(args,i));
            }
            else
            {
                return "error!!!!onetwothree";
            }
        }
        return ret;
    }
}
printf(string text, list args)
{
    string texxt=format(text,args);
    if(texxt!="error!!!!onetwothree")
        llSay(0,texxt);
    else
        llSay(DEBUG_CHANNEL,"Malformed string given for printf().");
}
default{
    state_entry()
    {
        printf("hello {0}!",[llKey2Name(llGetOwner())] );
    }
}
