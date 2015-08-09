// :CATEGORY:Prim Calculator
// :NAME:Prim_counterscanner
// :AUTHOR:Rolig Loon
// :CREATED:2012-08-10 15:09:17.267
// :EDITED:2013-09-18 15:39:00
// :ID:652
// :NUM:888
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Copyright © 2009 Linden Research, Inc. Licensed under Creative Commons Attribution-Share Alike 3.0, from the Wiki at http://community.secondlife.com/t5/LSL-Library/Sim-Prim-Count/td-p/1603611
// :CODE:
//Sim Prim Scanner -- Rolig Loon -- July 2012 

// I find that a 0.5m white sphere makes a nice container for this scanner script, 
// but anything will do. It's just that the particle glow looks nice on that 
// sphere. Your choice.

list gPrclID;           // List of unique parcel UUIDs
integer gTotPrims;      // Total prims detected
float gX;               // X coordinate of curren scan target
float gY;               // Y coordinate of current scan target
string gObjName;        // This scanner's name
integer gNUM;           // Sequence number of unique parcels scans

default
{
    state_entry()
    {
        llSetColor(<1.0,1.0,1.0>,ALL_SIDES);
        gPrclID = [];
        gTotPrims = 0;
        // Start scan in the SW corner of the sim
        gX = 4.0;
        gY = 4.0;
    }
    
    on_rez(integer start)
    {
        llSetPos(llGetPos() + <0.0,0.0,0.5>);
        llSetText("Touch to start scan",<1.0,1.0,0.0>,1.0);
    }

    touch_start(integer total_number)
    {
        llSetText("Scanning ....",<1.0,1.0,0.0>,1.0);
        // Cheesy visiual effects ........
        llSetColor(<1.0,1.0,0.0>,ALL_SIDES);
        llParticleSystem([
           PSYS_SRC_TEXTURE, llGetInventoryName(INVENTORY_TEXTURE, 0),
           PSYS_PART_START_SCALE, <0.02, 0.02, FALSE>, PSYS_PART_END_SCALE, <3.0, 3.0, FALSE>, 
           PSYS_PART_START_COLOR, <1.00,1.00,0.00>,    PSYS_PART_END_COLOR, <1.00,1.00,0.00>, 
           PSYS_PART_START_ALPHA, (float) .5,         PSYS_PART_END_ALPHA, (float) 0.0,     
           PSYS_SRC_BURST_PART_COUNT, (integer)    1, 
           PSYS_SRC_BURST_RATE,         (float) 0.05,  
           PSYS_PART_MAX_AGE,           (float) 0.75, 
           PSYS_SRC_PATTERN, (integer) 1, 
           PSYS_PART_FLAGS, (integer) ( 0     
                                | PSYS_PART_INTERP_COLOR_MASK   
                                | PSYS_PART_INTERP_SCALE_MASK   
                                | PSYS_PART_EMISSIVE_MASK   
                                | PSYS_PART_FOLLOW_SRC_MASK     
                                | PSYS_PART_TARGET_POS_MASK     
                            )]);
        gObjName = llGetObjectName();
        gNUM = 0;
        llRegionSayTo(llGetOwner(),0,"Scan started on " + llGetRegionName());
        llSetTimerEvent(0.1);
    }
        
    timer()
    {
        list parcel = llGetParcelDetails(<gX,gY,100.0>,[PARCEL_DETAILS_ID,PARCEL_DETAILS_NAME]);
        key temp = llList2Key(parcel,0);                // The parcel's UUID
        string parcel_name = llList2String(parcel,1);   // The parcel's name
        if (parcel_name == "")
        {
            parcel_name = "(no name)";
        }
        if (!~llListFindList(gPrclID,[temp]))   // Have we scanned this parcel before? If not ...
        {
            ++gNUM;
            llSetObjectName((string)gNUM);
            integer Count = llGetParcelPrimCount(<gX,gY,100>,PARCEL_COUNT_TOTAL,FALSE);
            gTotPrims += Count;
            llRegionSayTo(llGetOwner(),0, "/me "+ parcel_name + " @ <"+(string)gX+","+(string)gY+",Z> = " + (string)Count);
            gPrclID += [temp];
        }
        if (gX < 256.0)     // Increment X but don't let X go outside the sim borders
        {
            gX +=8.0;
        }
        if (gX > 256.0)     // If it does, reset X and increment Y
        {
            gY += 8.0;
            gX = 4.0;
        }
        if (gY > 256.0)     // Don't let Y go outside the sim boders. If it does, wrap up the scan ....
        {
            llSetObjectName(gObjName);
            llRegionSayTo(llGetOwner(),0,"Scan finished. Total Prims = " + (string)gTotPrims + " in " + (string)llGetListLength(gPrclID) + " parcels (not counting temp rez prims).");
            llParticleSystem([]);
            llSetText("Touch to start scan",<1.0,1.0,0.0>,1.0);
            llResetScript();
        }
    }            
}
