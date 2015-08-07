// :CATEGORY:Inventory Giver
// :NAME:NotecardGiver
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:565
// :NUM:769
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// NotecardGiver
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

string notecard = "Welcome Notecard";
integer freq = 1;
integer maxList = 100;
list given;


default
{
    state_entry()
    {
        llSensorRepeat("", "",AGENT, 20, PI, freq);
        llSetText("", <1.0, 1.0, 1.0>, 1.0);
    }
    
    sensor(integer num_detected)
    {
        integer i;
        key detected;
        
        for(i=0;i<num_detected;i++)
        {
            detected = llDetectedKey(i);
            
            if( llListFindList(given, [detected]) < 0 )
            {
                given += llDetectedKey(i);
                
                llGiveInventory(detected, notecard);
                if (llGetListLength(given) >= maxList)
                {
                    given = llDeleteSubList(given,0,10);
                }                                
            }
        }                
    }
}
