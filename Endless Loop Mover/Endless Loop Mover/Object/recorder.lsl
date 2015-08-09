// :SHOW:1
// :CATEGORY:Telepad
// :NAME:Endless Loop Mover
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2015-08-05 09:56:03
// :EDITED:2015-08-05  10:12:51
// :ID:1084
// :NUM:1818
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// Route Recorder Script - touch to make a route
// :CODE:
// Open Source CC-BY-NC

// Recorder script - put this in the touring prim, rez thre #10 prims, and then touch the tour prim to record a route
// the route prim will follow the route. Fix any issues by replacing, removing or adding the numbered prims, and touch to save
// When finished, delete this script as it is not needed.

integer debugger = FALSE;
list prims;

debug(string message)
{
    if (debugger)
        llOwnerSay(message);
}



string left(string src, string divider) {
    integer index = llSubStringIndex( src, divider );
    if(~index)
        return llDeleteSubString( src, index , -1);
    return src;
}

string right(string src, string divider) {
    integer index = llSubStringIndex( src, divider );
    if(~index)
        return llDeleteSubString( src, 0, index + llStringLength(divider) - 1);
    return src;
}


list lines;

default
{
    state_entry()
    {
        llSetText("Click after setting up all tour prims.  \nShout on channel '/300 die' to clear all prims", <1.0, 1.0, 1.0>, 2.0);
        
    }

    touch_start(integer n)
    {
        if (llDetectedKey(0) == llGetOwner()) {
            llOwnerSay("Looking for Route Prims, please wait");
            prims = [];

            lines = [];

            llListen(300,"","","");
            llRegionSay(300,"where");
        }    
    }

    listen(integer channel,string name, key id, string message)
    {
        debug(llGetObjectName() + " heard  " + message);
        list parts = llParseString2List(message,["|"],[]);
        
        integer l = (integer) llList2String(parts,0);
        vector  p = (vector) llList2String(parts,1);
        rotation r = (rotation) llList2String(parts,2);
        string text = llList2String(parts,3);
        
        integer  isthere = llListFindList(prims,[(integer) l]);
        
        if (isthere > -1)
        {
            llOwnerSay("Error, there are two prims named " + l + ".  Please make sure each prim is uniquely numbered from - to N in sequence from the start prim to the finish prim. Gaps in the sequence are allowed.");
        }
        prims += (integer) l;
        prims += (vector) p;
        prims += (rotation) r;
        prims += text;
        llSetTimerEvent(5.0);
    
    }
    
    timer()
    {
        llSetTimerEvent(0);
        integer i = 0;
        
        prims = llListSort(prims,4,1);
        
        for (i = 0; i < llGetListLength(prims); i+=4)
        {
            integer primnum = llList2Integer(prims,i);
            vector loc = llList2Vector(prims,i+1);
            rotation rot = llList2Rot(prims,i+2);
            string text = llList2String(prims,i+3);
            lines += [(string) primnum + "|" + (string) loc + "|" + (string) rot + "|" + text];
 
        }
        if (llGetInventoryType("Route") == INVENTORY_NOTECARD)
            llRemoveInventory("Route");
            
        osMakeNotecard("Route",lines);  
        llOwnerSay("Route updated");  
        llResetOtherScript("Walker");    
        llSetText("",<1,1,1>,1.0);                        
    }

    on_rez(integer p)
    {
        llResetScript();
    }
}
