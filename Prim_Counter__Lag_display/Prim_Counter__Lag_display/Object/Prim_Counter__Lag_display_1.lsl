// :CATEGORY:Prim Calculator
// :NAME:Prim_Counter__Lag_display
// :AUTHOR:Jamie Galliard
// :CREATED:2011-12-10 03:10:41.670
// :EDITED:2013-09-18 15:39:00
// :ID:651
// :NUM:887
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Prim_Counter__Lag_display
// :CODE:
// Author: Jamie Galliard

// This program is free software; you can redistribute it and/or modify it.
// License information must be included in any script you give out or use.
// by [[Jamie Galliard]], code released to the public domain under GNU GPL version 3.0 license.
// you are free to use, but not sell this script. If included in your product, the script
// must me full perm.

// Please leave any authors credits intact in any script you use or publish.
////////////////////////////////////////////////////////////////////
//
// May not be sold with explicit permission from Jamie Galliard.
// script may not be modified without permission from Jamie Galliard
//
// Most of this comes from the Second Life LSL Portal [ http://wiki.secondlife.com/wiki/LSL_Portal ]

// And I am sure this could be all be optimized.

integer decimals_accuracy = 2;
integer prim_ammount;
float   prim_used;
float   prim_max;
integer switch;
list parcel;
string parcel_owner;

string Lag()
{
    float lag=1-llGetRegionTimeDilation();
    lag*=100;
    string lagStr=(string)lag;
    list cheat=llParseString2List(lagStr,["."],[]);
    lagStr=llList2String(cheat,0);
    string text = lagStr + "%";
    return text;
}

string FPS()
{
    float fps=llGetRegionFPS();
    string str=(string)fps;
    list cheat=llParseString2List(str,["."],[]);
    str=llList2String(cheat,0);
    string decimals=llGetSubString(llList2String(cheat,1),0,1);
    string text = str + "." + decimals;
    return text;
}

string getFPS()
{
    float fps = llGetRegionTimeDilation();
    string str = (string)fps;
    list cheat = llParseString2List(str, ["."], []);
    str = llList2String(cheat, 0);
    string decimals = llGetSubString(llList2String(cheat, 1), 0, 1);
    string text = str + "." + decimals;
    return text;
}

string percent(float in)
{
    string str = (string)in;
    list cheat = llParseString2List(str, ["."], []);
    str = llList2String(cheat, 0); 
    return str;    
}

light(integer on) // Set between Green and Black for On and Off.
{
    if (on)
    {
        llSetLinkPrimitiveParamsFast(-2,[PRIM_POINT_LIGHT, TRUE, <0, 1, 0>, 1.0, 0.5, 0.75, PRIM_FULLBRIGHT, ALL_SIDES, TRUE, PRIM_COLOR, ALL_SIDES, <0,1,0>, 1]);
    }
    else
    {  
        llSetLinkPrimitiveParamsFast(-2,[PRIM_POINT_LIGHT, FALSE, <1, 1, 1>, 1.0, 0.5, 0.75, PRIM_FULLBRIGHT, ALL_SIDES, FALSE, PRIM_COLOR, ALL_SIDES, <0,0,0>, 1]);
    } 
}

off()
{
    llSetTimerEvent(0.0); 
    llSetText(" ",<0,0,0>,0.);
    light(FALSE);
}

default
{
    state_entry()
    {
        llSetTimerEvent(10.0);
        light(FALSE);
        llSetText("Initializing..",<1,1,1>,1);    
    }
    
    touch_start(integer total_number)
    {
        //if(llDetectedKey(0)!=llGetOwner())return;//work only for owner
        switch =! switch;
        if(switch)
        {
            llSetTimerEvent(1.0);  
        }
        else
        {
            off();
        }
    }
        
    timer()
    {
        prim_max = llGetParcelMaxPrims(llGetPos(),FALSE);
        prim_ammount = llGetParcelMaxPrims(llGetPos(),FALSE) - llGetParcelPrimCount(llGetPos(),PARCEL_COUNT_TOTAL,FALSE);
        prim_used = llGetParcelPrimCount(llGetPos(),PARCEL_COUNT_TOTAL,FALSE); 
        parcel = llGetParcelDetails(llGetPos(),[PARCEL_DETAILS_NAME,PARCEL_DETAILS_OWNER]);
        parcel_owner = llKey2Name(llList2Key(parcel,1));  
        
        float percent_used = (prim_used / prim_max) * 100; 
        
        if (percent_used > 90.0) // Set to max percent used before changing color.
        {
            llSetLinkPrimitiveParamsFast(-2,[PRIM_POINT_LIGHT, TRUE, <0, 1, 0>, 1.0, 0.5, 0.75, PRIM_FULLBRIGHT, ALL_SIDES, TRUE, PRIM_COLOR, ALL_SIDES, <1,0,0>, 1]); // RED
        }
        else
        {
            light(TRUE);
        }
                 
        if(parcel_owner == "")
        {
            parcel_owner = "(Group Owned)";
        }
                                        "\nParcel Owner: " + parcel_owner + " \n" + 
                                        "Lag: " + Lag() + 
                                        "\nFPS: " + FPS() + "\n" + 
                                        "Time Dilation: " + getFPS() + "\n" + 
                                        "Max Prims Allowed: " + percent(prim_max) + "\n" + 
                                        "Prims Used: " + percent(prim_used) + "\n" + 
                                        "Prims Un-used: " + (string)prim_ammount + "\n" +
                                        "Percent Used: " + percent(percent_used) + "%",<1.0,1.0,1.0>,1);
    }
}


