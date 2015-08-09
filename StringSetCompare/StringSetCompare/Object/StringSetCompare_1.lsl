// :CATEGORY:Strings
// :NAME:StringSetCompare
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:842
// :NUM:1170
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// StringSetCompare
// :CODE:
// From the book:
//
// Scripting Recipes for Second Life
// by Jeff Heaton (Encog Dod in SL)
// ISBN: 160439000X
// Copyright 2007 by Heaton Research, Inc.
//
// This script may be freely copied and modified so long as this header
// remains unmodified.
//
// For more information about this book visit the following web site:
//
// http://www.heatonresearch.com/articles/series/22/

string CHARS = "!\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~";


integer compareLen(string a, string b,integer len)
{
    integer result = 0;
    if(a != b)
    {
        integer index = 0;
        do
        {
            string chara = llGetSubString(a,index,index);
            string charb = llGetSubString(b,index,index);
             
            integer posa = llSubStringIndex(CHARS ,chara);
            integer posb = llSubStringIndex(CHARS ,charb);
             
            if((posa >= 0) && (posb >= 0))
            {
                result = posa - posb;
            }
            else if(posa >= 0)
            {
                result = 1;
            }
            else if(posb >= 0)
            {
                result = -1;
            }
             
            if(result != 0) index = len;
            ++index;
                 
        }
        while(index < len);
    }
         
    return result;
}

integer compareNoCaseLen(string a, string b,integer len)
{
    string stra = llToLower(a);
    string strb = llToLower(b);
    return compareLen(stra,strb,len);
}

integer compare(string a, string b)
{
    integer lena = llStringLength(a);
    integer lenb = llStringLength(b);
    integer result;
    if(lena < lenb)
        result =  compareLen(a,b,lena);
    else
        result =  compareLen(a,b,lenb);
     
    return result;
}


integer compareNoCase(string a, string b)
{
    integer la = llStringLength(a);
    integer lb = llStringLength(b);
    string stra = llToLower(a);
    string strb = llToLower(b);
    integer result;
    if(la < lb)
        result =  compareNoCaseLen(stra,strb,la);
    else
        result =  compareNoCaseLen(stra,strb,lb);
     
    return result;
}

// Some test uses
default
{
    state_entry()
    {
        llSay(0, "compareNoCase(hello,HELLO): " + (string)compareNoCase("jeff","Jeff") );   
        llSay(0, "compare(hello,HELLO): " + (string)compare("jeff","Jeff") );   
        llSay(0, "compare(aaa,bbb): " + (string)compare("aaa","bbb") );   
        llSay(0, "compare(aaa,bbb): " + (string)compare("bbb","aaa") ); 
    }
} 
