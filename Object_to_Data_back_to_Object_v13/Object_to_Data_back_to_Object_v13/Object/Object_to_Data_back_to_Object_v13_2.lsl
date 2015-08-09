// :CATEGORY:Building
// :NAME:Object_to_Data_back_to_Object_v13
// :AUTHOR:Xaviar Czervik
// :CREATED:2011-01-22 12:03:27.567
// :EDITED:2013-09-18 15:38:58
// :ID:579
// :NUM:793
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Replicate Main (Script) 
// :CODE:
default {
    state_entry() {
        llOwnerSay("Place the 'Object to Data' script in me.");
    }
    changed(integer num) {
        if (llGetInventoryType("Object to Data") != -1) {
            state run;
        }
    }
}
 
 
state run {
    state_entry() {
        llOwnerSay("Deploying scripts... Please wait. This may take some time.");
        llSetText("Loading...", <1,1,1>, 1);
        integer num = llGetNumberOfPrims();
        list lst;
        integer i = 1;
        while (i <= num) {
            lst += llGetLinkKey(i);
            i++;
        }
        llSetScriptState("Object to Data", 0);
        i = 0;
        while (i < num) {
            llSetText((string)(((float)i*100.0)/((float)num)) + "% finished.", <1,1,1>, 1);
            llGiveInventory(llList2Key(lst, i), "Object to Data");
            i++;
        }
        llSetScriptState("Object to Data", 0);
        llSetText("", <1,1,1>, 1);
        llOwnerSay("Re-Rez this object and then go to 'Tools' -> 'Set Scripts to Running in Selection', and then Re-Rez this object again.");
        llRemoveInventory(llGetScriptName());
    }
}
