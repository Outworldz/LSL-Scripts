// :CATEGORY:Strings
// :NAME:StringParse
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:841
// :NUM:1169
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// StringParse
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



string text;

string pop()
{
    string result;
    integer i = llSubStringIndex(text, " ");
    
    if( i!=-1 )
    {
        i -=1;
        result = llGetSubString(text,0,i);
        text = llGetSubString(text,i+2,-1);
        return result;
    }
    else
    {
        result = text;
        text = "";
    }
    
    text = llStringTrim(text, STRING_TRIM);
    result = llStringTrim(result, STRING_TRIM);
    
    return result;
}



default
{
    state_entry()
    {
        text = "Now is the time for all good men to come to the aid of their country.";
        string str;
        
        while( (str=pop())!="" )
        {
            llSay(0,str);
        }
    }
}
