// :CATEGORY:Security
// :NAME:Security Orb
// :AUTHOR:Psyke Phaeton
// :KEYWORDS:
// :CREATED:2014-09-08 19:10:59
// :EDITED:2014-09-08
// :ID:1043
// :NUM:1652
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

integer announce;
float script_memory_teleport = -1;
integer script_count_teleport = -1;
float script_time_teleport = -1;
integer script_time_teleport_maxcount = -1;
float script_memory_warn = -1;
integer script_count_warn = -1;
float script_time_warn = -1;
integer script_time_warn_maxcount = -1;
list script_time_high_list;
integer script_time_monitor = 1;
float sensor_scan_timer;
integer values_set;

print_status() {
    if (values_set)
    llSay(announce,"(22AvScripts) "+(string)llGetUsedMemory()+"b Announce:" + (string)announce + " SLTeleport: Mem="+(string)script_memory_teleport + " ScriptCount="+(string)script_count_teleport
                                        +"Time="+(string)script_time_teleport+" TimeCount="+(string)script_time_teleport_maxcount
                                        + "; SLWarn: Mem="+(string)script_memory_warn + " ScriptCount="+(string)script_count_warn
                                        +"Time="+(string)script_time_warn+" TimeCount="+(string)script_time_warn_maxcount + " ScriptTimeMonitor:" + (string)script_time_monitor);
    else llSay(0,"(22AvScripts) "+(string)llGetUsedMemory()+"b Ready");
}

default
{
    state_entry()
    {
        print_status();
    }

    link_message(integer sn, integer i, string s, key k)
    {
        if (i == 100) print_status();
                                        
        if (i == 21000) { //subset of settings from 2Scanner
            //llSay(0, "21000:debug: " + str);
            list l = llParseString2List(s,["¢"],[]);
            sensor_scan_timer   = llList2Float(l,2);
            script_memory_teleport = llList2Float(l,19);
            script_count_teleport = llList2Integer(l,20);
            script_time_teleport = llList2Float(l,21);
            script_time_teleport_maxcount = llList2Integer(l,22);
            script_time_monitor = llList2Integer(l,23);
            script_time_warn = llList2Float(l,24);
            script_time_warn_maxcount = llList2Integer(l,25);
            script_memory_warn = llList2Float(l,26);
            script_count_warn = llList2Integer(l,27);
            announce = llList2Integer(l,28);
            if (sensor_scan_timer==0.0) script_time_high_list = []; //when orb turned off forget who was high script time
            values_set = TRUE;
            //l = [];
        }
        
        else if (i == 22000) {
            //"0scriptmem,1scriptcount,2scripttime,3username,4intruder_pos",userkey
            //llOwnerSay(s);
            list ls = llCSV2List(s);
            //string intruder_username = llList2String(ls,3);
            //string intruder_pos = llList2String(ls,4);
            
            //* Check if in script time high list, add if over or increase count, attack if over
            integer script_time_high_count;
            integer x = llListFindList(script_time_high_list,[llList2String(ls,3)]);
            string st_trigger;
            if (llList2Float(ls,2) > script_time_warn && script_time_warn >= 0.0) st_trigger = "Warn:"+(string)((integer)(script_time_warn*1000000.0))+"µs";
            if (llList2Float(ls,2) > script_time_teleport && script_time_teleport >= 0.0) st_trigger = "TP:"+(string)((integer)(script_time_teleport*1000000.0))+"µs";
            //llOwnerSay("22 scripttimehighlist:"+llList2CSV(script_time_high_list)+ " st_trigger:" + st_trigger);
            //llOwnerSay(llList2String(ls,2) + ">" + (string)script_time_warn + "&& >= 0.0");
            if (st_trigger != "") {
                if (~x) { //increase count of high script time detection
                    script_time_high_count = llList2Integer(script_time_high_list,x+1) + 1;
                    script_time_high_list = (script_time_high_list=[]) + llListReplaceList(script_time_high_list,[llList2String(ls,3),script_time_high_count],x,++x);
                }
                else script_time_high_list = (script_time_high_list=[]) + script_time_high_list + [llList2String(ls,3),(script_time_high_count = 1)];
                if (script_time_monitor) {
                    if (st_trigger)   
                    llWhisper(0,"(22AvScripts) STM:" + llList2String(ls,3) + " " + (string)((integer)(llList2Float(ls,2)*1000000.0))+"µs>"+st_trigger+" "+(string)script_time_high_count+"times");
                }
                llSleep(0.05); //give SL time to clear unused memory
            }
            else if (~x) {
                script_time_high_list = (script_time_high_list=[]) + llDeleteSubList(script_time_high_list,x,++x);
                if (script_time_monitor) llWhisper(0,"(22AvScripts) STM:" + llList2String(ls,3) + " " + (string)((integer)(llList2Float(ls,2)*1000000.0))+"µs OK");
            }
            
            //ie script maximums are set and they are not in orb friend list
            //llSay(0,"21d entering warning/tp checks for " + intruder_username);
            string lines = "";
            if ((script_memory_teleport >= 0.0) && (llList2Float(ls,0) > script_memory_teleport)) lines += "\nMemory Limit is " + (string)(script_memory_teleport / 1000000.0) + "㎆";
            else if ((script_memory_warn >= 0.0) && (llList2Float(ls,0) > script_memory_warn)) lines += "\nMemory Warning @ " + (string)(script_memory_warn / 1000000.0) + "㎆";
            if (~llSubStringIndex(lines,"Mem")) lines += ", You: " + (string)(llList2Float(ls,0) / 1000000.0)+ "㎆";
            if ((script_count_teleport > -1) && (llList2Integer(ls,1) > script_count_teleport)) lines += "\nCount Limit is " + (string)script_count_teleport + "scripts";
            else if ((script_count_warn > -1) && (llList2Integer(ls,1) > script_count_warn)) lines += "\nCount Warning @ " + (string)script_count_warn + "scripts";
            if (~llSubStringIndex(lines,"Count")) lines += ", You: " + llList2String(ls,1)+ "scripts";
            if ((script_time_teleport >= 0.0) && (script_time_high_count >= script_time_teleport_maxcount)) lines += "\nCPU Time Limit is " + (string)((integer)(script_time_teleport * 1000000.0)) + "µs";
            else if ((script_time_warn >= 0.0) && (script_time_high_count >= script_time_warn_maxcount)) lines += "\nCPU Time Warning @ " + (string)((integer)(script_time_warn * 1000000.0)) + "µs";
            if (~llSubStringIndex(lines,"CPU")) lines += ", You: " + (string)((integer)(llList2Float(ls,2) * 1000000.0)) + "µs"; //+ (string)llList2Float(ls,3)+ "secs";
            if (~llSubStringIndex(lines,"Warn")) //{
                llDialog(k,"This area has attached script limits\nYou might be removed unless you detach some scripts\n" + lines,[],-9999);
                //llSay(0,"21d send dialog to intruder: " + intruder_username + (string)intruder_key); 
            //}
            if (~llSubStringIndex(lines,"Limit")) {
                llDialog(k,"This area has attached script limits\nPlease detach some scripts before returning\n" + lines,[],-9999);
                //3003 Weapon: Teleport Home "Intruder Name|<pos,pos,pos>", [key]
                llMessageLinked(LINK_THIS,3003,llList2String(ls,3)+ " ["+(string)(llList2Float(ls,0) / 1000000.0)+ "㎆/"+llList2String(ls,1)+"/"+(string)((integer)(llList2Float(ls,2) * 1000000.0)) + "µs]|"+llList2String(ls,4),k);
            }
            
        }
        else if (i == 22009) {
            //delete avatars from the high usage script list if they have left the scan range.
            integer x;
            //llWhisper(0,"(21d)check if left");
            for (x = -llGetListLength(script_time_high_list); x; x=x+2) //{
                //llWhisper(0,"(21d)x="+(string)x);
                if (!~llSubStringIndex(s,"\n"+llList2String(script_time_high_list,x)+" ")) { //if name found in float text between new line and a space
                    if (script_time_monitor) llWhisper(0,"(22AvScripts) STM:"+llList2String(script_time_high_list,x)+" leaves;script time count reset");
                    script_time_high_list = (script_time_high_list=[]) + llDeleteSubList(script_time_high_list,x,x+1);
                    //llWhisper(0,"(21d)deleted");
                }
            //}
        }
    }
}
