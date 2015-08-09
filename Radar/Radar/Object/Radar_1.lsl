// :CATEGORY:Radar
// :NAME:Radar
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:00
// :ID:671
// :NUM:912
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Radar
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

integer freq = 1;

default
{
    state_entry()
    {
        llSensorRepeat("", "",AGENT, 96, PI, freq);
    }
    
    sensor(integer num_detected)
    {
        integer i;
        string name;
        integer distance;
        string result = "";
        list data = [];
        
        vector pos = llGetPos();
        
        
        for(i=0;i<num_detected;i++)
        {
            name = llKey2Name(llDetectedKey(i));
            vector detPos = llDetectedPos(i);
            distance = (integer)llVecDist(pos, detPos);
            data += distance;
            data += name;
        }
        
        llListSort(data,2,FALSE);
        
        integer listLength = llGetListLength(data);
        for( i=0;i<listLength;i+=2)
        {
            distance = llList2Integer(data,i);
            name = llList2String(data,i+1);
            
            result = result + name + " [" + (string)distance + "m]\n";
        }
        
        llSetText(result,<1,1,1>,1);
    }
}
