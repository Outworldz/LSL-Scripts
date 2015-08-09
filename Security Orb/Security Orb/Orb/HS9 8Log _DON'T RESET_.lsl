// :CATEGORY:Security
// :NAME:Security Orb
// :AUTHOR:Psyke Phaeton
// :KEYWORDS:
// :CREATED:2014-09-08 19:09:51
// :EDITED:2014-09-08
// :ID:1043
// :NUM:1650
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

list log = [];
integer i; //tmp variable
integer announce; //announce channel

default
{ 
    state_entry() {
        if (llGetMemoryLimit() < 65536) llSay(DEBUG_CHANNEL,"**** Memory limit too low. Mono disabled? ****");
    }
    link_message(integer sender_num, integer num, string msg, key id) {
        if (num == 8300) { 
            //llSay(0,"(Log)8300:" + msg);
            //3 entries in list for each log record 3*40 = 120
            if (llGetListLength(log) >= 120) log = llDeleteSubList(log,0,2);
            
            //if (llGetSubString(msg,0,0) == "⇋") llSay(0,"8D msg="+msg); //msg = "⇋" 
            
            log += [llGetUnixTime()] + [id] + [llGetSubString(msg,0,40)];
            //llOwnerSay("ll="+(string)llGetListLength(log)+" b="+(string)llGetFreeMemory());
        }
        else if (num == 8301) {
            i = 0;
            integer time_diff;
            integer hours;
            integer days;
            integer mins;
            string output;
            llSay(announce,"--- Command Log - " + (string)(llGetListLength(log) / 3) + " entries ---");
            do {
                time_diff = llGetUnixTime() - (integer)llList2String(log,i);
                days = time_diff / 86400;
                hours = time_diff % 86400 / 3600;
                mins = time_diff % 8640 % 3600 / 60;
                output = (string)days + "d" + (string)hours + "h" + (string)mins + "mins ago: ";
                //output += "http://world.secondlife.com/resident/" + llList2String(log,++i);
                output += "secondlife:///app/agent/" + llList2String(log,++i) + "/about";
                output += " "+llList2String(log,++i);
                llSay(announce,output);
            } while((++i)< llGetListLength(log));
            llSay(announce,"--- End ---");
        }
        
        else if (num == 8666) {
            log = [];
            llSay(announce,"Commands Log cleared");
        }

        //print_status
        else if (num == 100) llSay(0,"(8Log) " + (string)llGetUsedMemory() + "b, Announce:" + (string)announce);
        
        else if (num == 2) announce = (integer)msg;
    }
}
