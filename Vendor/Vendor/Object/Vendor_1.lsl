// :CATEGORY:Vendor
// :NAME:Vendor
// :AUTHOR:Encog Dod
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:09
// :ID:947
// :NUM:1364
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Vendor
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

integer index;

// for loading notecard
string notecardName;
key notecardQuery;
integer notecardIndex;
list notecardList;
integer price;
string itemName;

displayItem()
{
    string textureName = llList2String(notecardList,index*3);
    itemName = llList2String(notecardList,(index*3)+1);
    string p = llList2String(notecardList,(index*3)+2);
    price = (integer)p;
    string display = itemName + "\nL$" + p;
    llMessageLinked(LINK_ALL_OTHERS , 0, ":"+display, NULL_KEY);
    llSetLinkPrimitiveParams(5,[PRIM_TEXTURE, 1, textureName, <1,1,1>, <0,0,0>, 0 ]);
    llSetPayPrice(PAY_HIDE, [price, PAY_HIDE, PAY_HIDE, PAY_HIDE]);
}

default
{
    state_entry()
    {
        if( llGetListLength(notecardList)==0 )
        {
            notecardName = "Config";
            state loading;
        }
        else
        {
            index = 0;
            displayItem();
        }
    }
    
    link_message(integer sender_num, integer num, string str, key id)
    {
        if( str=="back" )
        {
            index--;
        }
        
        if( str=="forward" )
        {
            index++;
        }
        
            
        if(index>=(llGetListLength(notecardList)/3) )
            index = 0;
        
        if(index<0 )
        {
            index = (llGetListLength(notecardList)/3);
            index--;
        }
        
        displayItem();
    }
    
    money(key id, integer amount)
    {
        if( amount>=price )
        {
            llGiveInventory(id,itemName);
            llSay(0,"Thanks for your purchase!");
        }
    }
    
}

state loading
{
    state_entry()
    {
        llSay(0,"Loading product data...");
        notecardIndex = 0;
        notecardQuery = llGetNotecardLine(notecardName,notecardIndex++);    
    }
    
    dataserver(key query_id, string data) 
    {
        if ( notecardQuery == query_id) 
        {
            // this is a line of our notecard
            if (data == EOF) 
            {    
                llSay(0,"Products loaded...");
                state default;

            } else 
            {
                notecardList += [data];
                notecardQuery = llGetNotecardLine(notecardName,notecardIndex++); 
            }
        }
    }
}
