// :CATEGORY:Security
// :NAME:Security Orb
// :AUTHOR:DESCRIPTION: []::
// :KEYWORDS:
// :CREATED:2014-09-08 19:10:21
// :EDITED:2014-09-08
// :ID:1043
// :NUM:1651
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// 
// :CODE:
/*

CC-BY-NC-SA

This work by Psyke Phaeton is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
You can read the full licence here: http://creativecommons.org/licenses/by-nc-sa/4.0/

In sumary:

You are free to:

    Share — copy and redistribute the material in any medium or format
    Adapt — remix, transform, and build upon the material

    The licensor cannot revoke these freedoms as long as you follow the license terms.

Under the following terms:

    Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.

    NonCommercial — You may not use the material for commercial purposes.

    ShareAlike — If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.

    No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

In addition:
    You can't use the trade mark "PDS HomeSecurity" or PDS logos.

*/

//integer announce;
integer mlink;
list settings_list;
//need memory for large storage of settings

print_status(integer c) {
    llSay(c,"(9Backup) " + (string)llGetUsedMemory() + "b");    
}

default
{
    state_entry() {
        if (llGetMemoryLimit() < 65536) llSay(DEBUG_CHANNEL,"**** Memory limit too low. Mono disabled? ****");
        if (llGetStartParameter() != -1256203567)  print_status(0);
    }
    
    link_message(integer sn, integer n, string s, key k) {
        
        //if (n==2) announce = (integer)s;
        
        if (n==9100) print_status(0);
        else if (n==9000) { 
            mlink=(integer)s;
            settings_list = [];
            //llSay(DEBUG_CHANNEL,"(Backup) started..");
        }
        
        else if (n==9001) { 
            if (~llSubStringIndex(s,", ")) s = llDumpList2String(llCSV2List(s),","); //NAME FRONT SPACE FIX from buggy v14.000-14.114
            settings_list += s;
            //llOwnerSay("(9D)" + s); //**
            
            if (s=="done") {
                //llSay(DEBUG_CHANNEL,"(Backup) done.");
                llMessageLinked(LINK_THIS,7021,(string)mlink,"");
                //llSay(0,"(Backup) saved " +(string)llGetListLength(settings_list)+ " records");
            }
        }
        
        else if (n==9004) {
            //llSetRemoteScriptAccessPin(0); //turn off script importing
            //llSay(DEBUG_CHANNEL,"(Backup) restore requested");
            if (mlink==(integer)s) {
                integer c;
                integer ll = llGetListLength(settings_list);
                //llSay(0,"**** (9Debug) I have " + (string)llGetListLength(settings_list) + " records. restoring...");
                for (c=0; c < llGetListLength(settings_list); c++) {
                    llMessageLinked(LINK_THIS, mlink, llList2String(settings_list,c),"");
                    //llOwnerSay("**** 9Debug:("+s+") Sending record " + (string)c + ": " + llList2String(settings_list,c)); //**
                    
                    if (c % 30 == 29) llSay(0,"(9Backup) Restoring.. " + (string)(c+1) + " of " + (string)ll + " settings (" + (string)(ll-c) + "s)");
                    llSleep(1);
                }
                if (c>29) llSay(0,"(9Backup) Restored " +(string)(c)+ " settings");
                llMessageLinked(LINK_THIS,7022,(string)mlink,"");
                mlink = -999;
                settings_list = [];
            } else llSay(0,"(Backup) Nothing to restore. 'reset' may be required.");
        }
        //8130, 8230, 9300 store visitors
    }
}
