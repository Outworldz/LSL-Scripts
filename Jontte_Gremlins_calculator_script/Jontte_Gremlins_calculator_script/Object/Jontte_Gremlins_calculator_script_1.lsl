// :CATEGORY:Calculator
// :NAME:Jontte_Gremlins_calculator_script
// :AUTHOR:Nitsuj Kidd
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:411
// :NUM:567
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Jontte_Gremlins_calculator_script
// :CODE:
//Created by Jontte Gremlin
//All rights reserved
//Open sourced with permission by Alpha Zaius and tag written by Alpha himself.
list datalist;
list temporary;
list templist;
string start;
integer i;
integer number;
integer number2;
integer greturn;
list variables;
calculate()
{
    greturn=0;
    if(llListFindList(datalist,["("])!=-1)
    {
        for(i=0;i<llGetListLength(datalist);i++)
        {
            if(llList2String(datalist,i)=="(")
            {
                number=i;
            }
            if(llList2String(datalist,i)==")")
            {
                number2=i;
                i=llGetListLength(datalist);
            }
        }
        templist=datalist;
        if(number2<number)
        {
            llOwnerSay("Could not calculate.");
            datalist=[];
            return;
        }
        datalist=llList2List(datalist,number + 1 ,number2 - 1 );
        greturn=1;
    }
    if(llListFindList(datalist,["^"])!=-1)
    {
        temporary=[];
        for(i=0;i<llGetListLength(datalist);i++)
        {
            if(llList2String(datalist,i + 1)=="^")
            {
                temporary+=(string)(  llPow(((float)llList2String(datalist,i)),((float)llList2String(datalist,i + 2)) ));
                i+=2;
            }
            else
            {
                temporary+=llList2String(datalist,i);
            }
        }   
        datalist=temporary;
    }
    
    if(llListFindList(datalist,["/"])!=-1)
    {
        temporary=[];
        for(i=0;i<llGetListLength(datalist);i++)
        {
            if(llList2String(datalist,i + 1)=="/")
            {
                if((float)llList2String(datalist,i + 2)==0)
                {
                    llOwnerSay("Could not calculate.");
                    datalist=[];
                    temporary=[];
                    return;
                }
                temporary+=(string)(  (((float)llList2String(datalist,i))/((float)llList2String(datalist,i + 2)) ));
                i+=2;
            }
            else
            {
                temporary+=llList2String(datalist,i);
            }
        }
        datalist=temporary;
    }
    
    if(llListFindList(datalist,["*"])!=-1)
    {
        temporary=[];
        for(i=0;i<llGetListLength(datalist);i++)
        {
            if(llList2String(datalist,i + 1)=="*")
            {
                temporary+=(string)(  (((float)llList2String(datalist,i))*((float)llList2String(datalist,i + 2)) ));
                i+=2;
            }
            else
            {
                temporary+=llList2String(datalist,i);
            }
        }
        datalist=temporary;
    }
    
    if(llListFindList(datalist,["-"])!=-1)
    {
        temporary=[];
        for(i=0;i<llGetListLength(datalist);i++)
        {
            if(llList2String(datalist,i + 1)=="-")
            {
                temporary+=(string)(  (((float)llList2String(datalist,i)) - ((float)llList2String(datalist,i + 2)) ));
                i+=2;
            }
            else
            {
                temporary+=llList2String(datalist,i);
            }
        }
        datalist=temporary;
    }
    if(llListFindList(datalist,["+"])!=-1)
    {
        temporary=[];
        for(i=0;i<llGetListLength(datalist);i++)
        {
            if(llList2String(datalist,i + 1)=="+")
            {
                temporary+=(string)(  (((float)llList2String(datalist,i)) + ((float)llList2String(datalist,i + 2)) ));
                i+=2;
            }
            else
            {
                temporary+=llList2String(datalist,i);
            }
        }
        datalist=temporary;
    }
    if(greturn==1)
    {
        temporary=[];
        if(number - 1 > 0)
        {
            temporary+=llList2List(templist,0,number - 1);
        }
        temporary+=datalist;
        if(number2 + 1 < llGetListLength(templist))
        {
            temporary+=llList2List(templist,number2+1,-1);
        }
        datalist=temporary;
    }
}
default
{
    link_message(integer sender_num, integer num, string msg, key id)
    {
        datalist=llParseString2List(msg,[" "],[]);
        if(llList2String(datalist,0)=="hdfdfuureihue")
        {
            if(llListFindList(variables,[llList2String(datalist,1)])==-1)
            {
                variables+=llList2String(datalist,1);
                variables+=llList2String(datalist,2);
                
                
                llOwnerSay(llDumpList2String(variables,"\n"));
                return;
            }
            else
            {
                i=llListFindList(variables,[llList2String(datalist,1)]);
                variables=llListReplaceList(variables,[llList2String(datalist,2)],i +1 ,i +1);
                
                
                llOwnerSay(llDumpList2String(variables,"\n"));
                return;
            }
        }
        if(msg=="var")
        {
            llOwnerSay(llDumpList2String(variables,"\n"));
            return;
        }
        if(llList2String(datalist,0)!="/calc")return;
        msg=llGetSubString(msg,5,-1);
        start=msg;
        datalist=llParseString2List(msg,[],["+","-","*","/","^","(",")"]);
        number = 0;
        number2 =0;
        for(i=0;i<llGetListLength(datalist);i++)
        {
            if(llList2String(datalist,i)=="(")
            {
                number++;
            }
            if(llList2String(datalist,i)==")")
            {
                number2++;
            }
        }
        if(number!=number2)
        {
            llOwnerSay("Could not calculate.");
            return;
        }
        for(i=0;i<llGetListLength(variables);i+=2)
        {
            number=llListFindList(datalist,[llList2String(variables,i)]);
            if(number!=-1)
            {
                datalist=llListReplaceList(datalist,[(float)llList2String(variables,i + 1)],number,number);
            }
        }
        while(llGetListLength(datalist)>1)
        {
            calculate();
        }
        if(llGetListLength(datalist)!=0)
        {
            llOwnerSay(start+" = "+llList2String(datalist,0));
        }
    }
}
