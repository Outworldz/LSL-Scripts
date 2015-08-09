// :CATEGORY:Notecard Reader
// :NAME:NotecardReader
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:566
// :NUM:770
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// NotecardReader
// :CODE:
// From the book:
//
// Scripting Recipes for Second Life
// by Jeff Heaton (Encog Dod in SL)
// Copyright 2007 by Heaton Research, Inc.
//
// This script may be freely copied and modified so long as this header
// remains unmodified.
//
// For more information about this book visit the following web site:
//
// http://www.heatonresearch.com/articles/series/22/

integer index;
key query;


default
{
    state_entry()
    {
        llSetText("Touch me to\nHear me read from a notecard.",<0,1,1>,1);
    }

    touch_start(integer total_number)
    {
        index = 0;
        query = llGetNotecardLine("MarkAntony",index++);
        llSetTimerEvent(10);
    }
    
    timer()
    {
        query = llGetNotecardLine("MarkAntony",index++);
    }
    
    dataserver(key query_id, string data) 
    {
        if (query == query_id) 
        {
            // this is a line of our notecard
            if (data == EOF) 
            {    
                llSetTimerEvent(0);

            } else 
            {
            // increment line count
                llSay(0, data);
            }
        }
    }
}
