// :CATEGORY:Security
// :NAME:Security Orb
// :AUTHOR:Psyke Phaeton
// :KEYWORDS:
// :CREATED:2014-09-08 19:08:41
// :EDITED:2014-09-08
// :ID:1043
// :NUM:1640
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
integer sensor_state; //intruder sensor setting: 0=off, 1=scan, 2=targets only, 3=Guests, 4=Friends
integer sensor_range;
float sensor_scan_timer; 
integer no_attack_warning;
string warning_message;
string guest_warning_message;
string oitext;
integer announce;
float up;
float down;
integer channel;
integer other_land_safe;
integer foreign_land_safe;
float visible = 1.0; //we make this a float because we will use it in llSetText
integer group_safe;
string group_safe_string;
integer attack_type;
string attack_type_name;
string detected_people;
string intruder_fullname;
string intruder_username;
string intruder_displayname;
vector intruder_pos;
key intruder_key;
string flags = "*";
string upindicator;
string downindicator;
string warning_string = ",";
string attack_string = ",";
string t = "(21Sensor) ";
string access_list = ",";
string targets_list = ",";
integer i; //internal multipurpose integer
list    l; //internal multipurpose list
integer sleep_setting; // 0 = never sleep, 1 = means sleep when no operator seen, 2 = sleep when operator seen.
string operators_string; // a string list of operators from security so we can implement SLEEP.
string ban_tp_visitor;         //all 3 used in the "/8bv [hours] [name/key]" command
float ban_tp_visitor_hours;    //
key ban_tp_visitor_op;         //stores op who requested ban
integer ban_tp_visitor_active; //switch on/off ban_tp_visitor (tp or land ban)
float script_memory_teleport;
integer script_count_teleport;
float script_time_teleport;
integer script_time_teleport_maxcount;
float script_memory_warn;
integer script_count_warn;
float script_time_warn;
integer script_time_warn_maxcount;
//list script_time_high_list;
//integer script_time_monitor;


warn_dialog(key intruder,string visitor_status) {
    //llSay(0,"21wd1 " + (string)llGetFreeMemory());
    if (llGetSubString(llToLower(visitor_status),1,1) == "g" && llStringTrim(guest_warning_message,STRING_TRIM) != "") 
        llDialog(intruder,guest_warning_message+"\nYou have " + (string)sensor_scan_timer + " seconds to leave this area.\n\nProduct: PDS HomeSecurity Orb",["PDS Shop"],channel);
    else llDialog(intruder,warning_message+"\nYou have " + (string)sensor_scan_timer + " seconds to leave this area.\n\nProduct: PDS HomeSecurity Orb",["PDS Shop"],channel);
    //llSay(0,"21wd2 " + (string)llGetFreeMemory());
    //llSay(0,"21sensor debug sending: warning_message = " + warning_message);
}
    

warn_then_attack(string intruder_username, string intruder_key, vector pos, string visitor_status) {
    //llSay(0,"21wta " + (string)llGetFreeMemory());
    if (llGetLandOwnerAt(pos) != llGetLandOwnerAt(llGetPos()) || //if banned over foreign land..
        llGetAgentSize(intruder_key) == <0.0,0.0,0.0> )          //or if in different sim
       if (attack_type & 2 || foreign_land_safe) return;         //and attack type is teleport(2), land eject(3) or foreign land is safe then return
                                                                 
    if (llList2Key(llGetParcelDetails(pos,[PARCEL_DETAILS_ID]),0) != llList2Key(llGetParcelDetails(llGetPos(),[PARCEL_DETAILS_ID]),0) 
               && other_land_safe) return; //if land has a diff uuid key and other_land_safe is on then return
    vector my_pos = llGetPos();
        // maxup < poz = return      maxdown > poz = return - for appartments
    if (my_pos.z + up < pos.z || my_pos.z - down > pos.z ) return; 

    if ((llSubStringIndex(attack_string,"," + intruder_username + ",") > -1) || no_attack_warning) {
            
            string dname = llGetDisplayName(intruder_key);
            if (dname == "") dname = llKey2Name(intruder_key);
            llMessageLinked(LINK_THIS,3000,dname + " (" +  intruder_username +")|"+(string)pos, intruder_key); //Attack:Fire!
    }
    else {
        warning_string += intruder_username + ",";
        llSay(announce,t + "*** " + llGetDisplayName(intruder_key) + " (" + intruder_username + ") you have " + (string)sensor_scan_timer + " seconds to leave this protected area. ***");
        warn_dialog(intruder_key, visitor_status);
    }
}

print_status() {
   llSay(0,t +(string)llGetUsedMemory()+ "b F:"+(string)llGetFreeMemory()+" State:" + (string)sensor_state + " Range:"+(string)sensor_range+"m Scan:"+(string)sensor_scan_timer+"s NoWarn:" + (string)no_attack_warning+
         //"Access:" + (string)llStringLength(visitor_string) + "b Targets:" + (string)llStringLength(banned_string) + "b" +
         " Sleep:" + (string)sleep_setting + " FLS:" + llList2String(["Off","on"],foreign_land_safe) +
         " Friends+Guests:" + (string)llStringLength(access_list) + "c Targets:" + (string)llStringLength(targets_list) +
         "c Up:"+(string)up+ "m Down:"+(string)down+ "m Visible:" + (string)visible + " SLT:" + (string)script_memory_teleport + "b," + (string)script_count_teleport+","+(string)script_time_teleport+"s/frame,"+
         (string)script_time_teleport_maxcount+"times"
             );
         llSay(0,t+"Warning msg:'" + warning_message + "'");
         llSay(0,t+"Guest Warning msg:'" + guest_warning_message + "'");
             
}

default
{
    state_entry() {
        if (llGetMemoryLimit() < 65536) llSay(DEBUG_CHANNEL,"**** Memory limit too low. Mono disabled? ****");
        //channel number will be triggered from Settings Script detecting CHANGE_INVENTORY
        if (llGetStartParameter() == -1186873345) {
            //script sent from update disk
            //llSay(DEBUG_CHANNEL,t + "Updated..restoring");
            llMessageLinked(LINK_THIS,9004,"2778","");
        } else {
            //script reset, or STOLEN from orb or UPDATE DISK 
            llSay(0,"Restart detected. Script deleting.");
            if (llKey2Name(llGetOwner()) != "Psyke Phaeton") llRemoveInventory(llGetScriptName()); //not psyke, delete
            llMessageLinked(LINK_THIS,4000,"",llGetOwner());//recompiled so reset to notecard defaults
        }
        llMessageLinked(LINK_THIS,1205,"",""); //request operator names from 1Security
    }

    link_message(integer snum, integer num, string str, key id) {
        if (num == 2100) print_status();
        
        if (num < 21000 || num > 21999) return;
        
        else if (num == 21000) { //settings from 2Scanner
            //llSay(0, "21000:debug: " + str);
            l = llParseString2List(str,["¢"],[]);
            //llOwnerSay(llDumpList2String(l,","));
            sensor_state        = llList2Integer(l,0);  //llSay(0,t + "state = " + (string)sensor_state );
            sensor_range        = llList2Integer(l,1);    //llSay(0,t + "range = " + (string)range );
            sensor_scan_timer   = llList2Float(l,2);  //llSay(0,t + "state = " + (string) );
            no_attack_warning   = llList2Integer(l,3);  //llSay(0,t + "state = " + (string) );
            warning_message     = llStringTrim(llList2String(l,4),STRING_TRIM);   //llSay(0,t + "state = " + (string) );
            oitext              = llList2String(l,5);   //llSay(0,t + "state = " + (string) );
            announce            = llList2Integer(l,6);  //llSay(0,t + "state = " + (string) );
            up                  = llList2Float(l,7);    //llSay(0,t + "state = " + (string) );
            down                = llList2Float(l,8);    //llSay(0,t + "state = " + (string) );
            channel             = llList2Integer(l,9);  //llSay(0,t + "state = " + (string) );
            other_land_safe     = llList2Integer(l,10); //llSay(0,t + "state = " + (string) );
            foreign_land_safe   = llList2Integer(l,11); //llSay(0,t + "state = " + (string) );
            visible             = llList2Integer(l,12); //llSay(0,t + "state = " + (string) );
            group_safe          = llList2Integer(l,13); //llSay(0,t + "state = " + (string) );
            group_safe_string   = llList2String(l,14);  //llSay(0,t + "state = " + (string) );
            attack_type         = llList2Integer(l,15); //llSay(0,t + "state = " + (string) );
            attack_type_name    = llList2String(l,16);  //llSay(0,t + "state = " + (string) );
            sleep_setting         = llList2Integer(l,17);
            guest_warning_message = llStringTrim(llList2String(l,18),STRING_TRIM);
            script_memory_teleport = llList2Float(l,19);
            script_count_teleport = llList2Integer(l,20);
            script_time_teleport = llList2Float(l,21);
            script_time_teleport_maxcount = llList2Integer(l,22);
            //script_time_monitor = llList2Integer(l,23); //field 23 used by (22ScriptTime)
            script_time_warn = llList2Float(l,24);
            script_time_warn_maxcount = llList2Integer(l,25);
            script_memory_warn = llList2Float(l,26);
            script_count_warn = llList2Integer(l,27);
            
            //strike_string       = llList2String(l,19);  //llSay(0,t + "state = " + (string) );
            
            l = [];
            if (oitext == " ") oitext = ""; // remove the space
            flags = "";
            if (!foreign_land_safe) flags += "F";
            if (sleep_setting) flags += "S";
            if (flags == "") flags = "."; // flags must be something needed so GHUD parses correctly
            
            //llSensorRepeat("", "", AGENT, sensor_range, PI, sensor_scan_timer); //VERSION 12 OLD Sensor
            llSetTimerEvent(sensor_scan_timer); //VERSION 13 timer and llGetAgentList
            detected_people = "Offline";
            //if (sensor_scan_timer==0.0) script_time_high_list = []; //when orb turned off forget who was high script time
            
            //print_status();
            //llSay(0,"21sensor debug: warning_message = " + warning_message);
        }
        
        else if (num == 21120) {
            //designed to conserve memory usage
            operators_string = "";
            llSleep(0.1);
            operators_string = (str = "") + "," + str + ","; //used by SLEEP to see if op is seen
        }
        
        else if (num == 21668) access_list = ","; //clear access list
        else if (num == 21667) targets_list  = ","; //clear target list
        
        else if (num == 21700) llMessageLinked(LINK_THIS,5010,detected_people,id); //Menu: ListNear

        else if (num == 21008) { //Menu: Access List
            //access_list = llListSort(access_list,1,TRUE);
            llMessageLinked(LINK_THIS,5900,"visitors","");
            //llMessageLinked(LINK_THIS,5902,"-visitors","");
            //for (i=0;i < llGetListLength(access_list); i += 5) llMessageLinked(LINK_THIS,5901,llList2CSV( llList2List(access_list,i,i+4) ),"");
            for (i=0; i < llStringLength(access_list); i += 1000) llMessageLinked(LINK_THIS,5902,llGetSubString(access_list,i,i+999),""); //starts at 1 to skip first comma
            //llSay(0,"21d " + llGetSubString(access_list,i,i+999));}
            llMessageLinked(LINK_THIS,5000,"",id);
        }
        else if (num == 21007) { //Menu: Target List
            //targets_list = llListSort(targets_list,1,TRUE);
            llMessageLinked(LINK_THIS,5900,"targets","");
            //llMessageLinked(LINK_THIS,5902,"-targets","");
            for (i=0; i < llStringLength(targets_list); i += 1000) llMessageLinked(LINK_THIS,5902,llGetSubString(targets_list,i,i+999),""); //starts at 1 to skip first comma
            llMessageLinked(LINK_THIS,5000,"",id);
            
        } 
        else if (num == 21100) { //backup
            for (i=1; i < llStringLength(access_list); i += 1000) { //starts at 1 because we wont store initial comma as it is already in the string by default when the script initialises
                llMessageLinked(LINK_THIS,9001,"vs="+llGetSubString(access_list,i,i+999),"");
                //llSay(announce,"Visitors:" + (string)i + "b of " + (string)llStringLength(access_list));
                llSleep(1.0);
            }
            
            for (i=1; i < llStringLength(targets_list); i += 1000) { //starts at 1 because we wont store initial comma as it is already in the string by default when the script initialises
                llMessageLinked(LINK_THIS,9001,"ts="+llGetSubString(targets_list,i,i+999),"");
                //llSay(announce,"Targets:" + (string)i + "b of " + (string)llStringLength(targets_list));
                llSleep(1.0);
            }
            llMessageLinked(LINK_THIS,9001,"done","");
        }
        
        else if (num == 21450) llMessageLinked(LINK_THIS,2450,detected_people,id); //for webserver in 2Scanner
        
        else if (num == 21998) { //send visitors and targets to network 
            llSay(announce,"Send started..");
            string name;
            for  (i=1; i < llStringLength(access_list); ++i) {
                 if (llGetSubString(access_list,i,i) != ",") name += llGetSubString(access_list,i,i);
                 else {
                    if (name == llToUpper(name)) llRegionSay(channel,"addf " + name); else llRegionSay(channel,"addg " + name);
                    name = "";
                 }
            }
            for  (i=1; i < llStringLength(targets_list); ++i) {
                 if (llGetSubString(targets_list,i,i) != ",") name += llGetSubString(targets_list,i,i);
                 else {
                    llRegionSay(channel,"addt " + name);
                    name = "";
                }
            }
            llSay(announce,"Send ended");
        }
            
        else if (num == 21915) {
            integer pipe = llSubStringIndex(str,"|");
            ban_tp_visitor_hours = (float)llGetSubString(str,0,pipe - 1);
            ban_tp_visitor = llGetSubString(str,++pipe,-1);
            ban_tp_visitor_op = id;
            ban_tp_visitor_active = TRUE;
            if (!sensor_state) llInstantMessage(id,t+"Must be on to ban by name");
        }
        
        //
        // EVERYTHING PAST THIS LINE REFERS TO 21916 to 21919 ONLY!!
        //
        //else if (num < 21916 || num > 21919) return; //equals 21916 to 21919 then continue
        if (num < 21916) return; //equals 21916 to 21919 then continue
        
        integer name_usage = (llStringLength(access_list) + llStringLength(targets_list)) / 70;
        if ((num == 21918 || num == 21919) && //(llGetUsedMemory() > 56535)) { //keep 9k free
                                            (name_usage > 99)) { //10Kb reserved for names
            llSay(announce,"Full. Delete some Friends/Guests/Targets");
            if (llGetAgentSize(id) != ZERO_VECTOR) llDialog(id,"Full. Delete some Friends/Guests/Targets",["TOP MENU","OK"],channel);
            return;
        }
                
        if (~(i = llSubStringIndex(access_list,","+str+","))) {
            if (num == 21916) access_list = (access_list = "") + llDeleteSubString(access_list,i,i+llStringLength(str));
        }
        else if (num == 21918) {
            access_list = (access_list = "") + access_list + llDumpList2String(llCSV2List(str),",") + ","; //need to strip ", " seperator from the CSV and change it to "," sperator
        }
        
        if (~(i = llSubStringIndex(targets_list,","+str+","))) {
            if (num == 21917) targets_list = (targets_list = "") + llDeleteSubString(targets_list,i,i+llStringLength(str));
        }
        else if (num == 21919) targets_list = (targets_list = "") + targets_list + llDumpList2String(llCSV2List(str),",") + ","; //need to strip ", " seperator from the CSV and change it to "," sperator
        
        if (num == 21928) { access_list = (access_list = "") + access_list + str; llSleep(0.5);} //from vs= backup
        if (num == 21929) { targets_list = (targets_list = "") + targets_list + str; llSleep(0.5);}//from ts= backup
        
        llSleep(0.05); //allow SL to clear up freed memory
        //if ((string)id != NULL_KEY) llSay(announce,t + str + "' (" + (string)name_usage + "%, U:"+(string)llGetUsedMemory()+")");
        //llWhisper(0,"(21d) " + access_list);

    } //end link_message


    timer() {
        if (!sensor_state) return; //was turned off so ignore this
        integer altype = AGENT_LIST_REGION; //aka -4
        if (sensor_range < 0) altype = llAbs(sensor_range); // -1 this parcel only = AGENT_LIST_PARCEL, -2 = all land owners parcels = AGENT_LIST_PARCEL, -4 = AGENT_LIST_REGION
        list detectedkeys = llGetAgentList(altype,[]);
        integer detected = llGetListLength(detectedkeys);

        if (!detected) { //no one detected same as no_sensor
            detected_people = "-\nNo one detected\nwithin range.\n";
            llSetText(detected_people, <0.0,1.0,0.0>, 1.0);
            llRegionSay(2222,detected_people);
            llMessageLinked(LINK_THIS,81300,"end",""); //tell 81visitor log that all visitors have been sent for this cycle.
            return; //exit timer()
        }

        llResetTime();
        
        //==== SLEEP ==== check if sleep_setting if so then check for op here
        integer sleep_now = FALSE;
        if (sleep_setting) { //if sleep is 1 or 2
            sleep_now = TRUE;
            for (i=0;i<detected;++i) {
                //NEW AGENT_LIST VERSION 13
                intruder_key = llList2Key(detectedkeys,i);
                intruder_fullname = llKey2Name(intruder_key);
                intruder_username = llGetUsername(intruder_key);
                intruder_pos = llList2Vector(llGetObjectDetails(intruder_key,[OBJECT_POS]),0);
                //
                llSleep(0.05);
                if (llGetMemoryLimit() - llGetUsedMemory() < 2 * llStringLength(operators_string)) return llSetText("Memory:"+(string)(llGetMemoryLimit() - llGetUsedMemory())+"b",<0,1,0>,1);  
                if (~llSubStringIndex(operators_string,","+llToUpper(intruder_fullname)+",")) sleep_now = FALSE;
                llSleep(0.05); 
                if (llGetMemoryLimit() - llGetUsedMemory() <  2 * llStringLength(operators_string)) return llSetText("Memory:"+(string)(llGetMemoryLimit() - llGetUsedMemory())+"b",<0,1,0>,1);  
                if (~llSubStringIndex(operators_string,","+llToUpper(intruder_username)+",")) sleep_now = FALSE; //an op was detected
                                                            
                if (intruder_key == llGetOwner()) sleep_now = FALSE; //an owner was detected
                
                //VERSION 13 if op is past range make sleep actions not see the op
                if (llVecDist(llGetPos(),intruder_pos) > sensor_range && sensor_range > 0) sleep_now = TRUE;
                
            }
            if (sleep_setting == 2) sleep_now = !sleep_now; //if reverse wanted, reverse it

            if (sleep_now) {
                llSetText("\nSLEEPING\nFor more info type: /" +(string)channel+ "sleep",<0,1,0>,visible);
                llRegionSay(2222,"PDS HSOrb SLEEPING " + oitext); //need oitext for the GHUD to detect when Orb sleeps
                detected_people = "SLEEPING";
                return;  //exit timer()
            }
        }
        //===== SLEEP ===== code ends
        
        vector colour = <0.0,1.0,0.0>; //text yellow above hs by default
        i=0;
        detected_people = ""; //reset
        integer outofrangecount;
        for (i=0;i<detected;++i) {
            
            string visitor_status = "--"; 
            
            //
            //NEW AGENT_LIST VERSION 13            
            intruder_key = llList2Key(detectedkeys,i);
            intruder_fullname = llKey2Name(intruder_key);
            intruder_username = llGetUsername(intruder_key);
            intruder_pos = llList2Vector(llGetObjectDetails(intruder_key,[OBJECT_POS]),0);
            //
            
            if (( intruder_username = llGetUsername(intruder_key) ) == "") intruder_username = intruder_fullname;
            
            vector my_pos = llGetPos();
            
            //VERSION 13 ignore avatars out of range when range is used rather than ThisLand,Landowners,Region or when past up/down range
            if ((sensor_range > 0 && llVecDist(my_pos,intruder_pos) > sensor_range) || (my_pos.z + up < intruder_pos.z || my_pos.z - down > intruder_pos.z)) {
                //detected_people += "\n" + intruder_username + " " + (string)llFloor(llVecDist(pos,my_pos)) + "m>range";
                ++outofrangecount;
                jump outofrange;
            }

            llMessageLinked(LINK_THIS,10000,intruder_username,intruder_key);

            //if (( intruder_fullname = llDetectedName(i) ) == "") intruder_fullname = (string)intruder_key;
            if (( intruder_fullname = llKey2Name(intruder_key) ) == "") intruder_fullname = (string)intruder_key;
            if (( intruder_displayname = llGetDisplayName(intruder_key) ) == "") intruder_displayname = intruder_username;
            
                                    
            //// float text above with username///
            detected_people += "\n" + intruder_username + " " + (string)llFloor(llVecDist(intruder_pos,my_pos)) + "m ";
            
            
            if (llSameGroup(intruder_key) && group_safe)                            { visitor_status = "kG"; if (colour.x == 0.0) colour = <0.0,1.0,1.0>; }
            //llScriptProfiler(PROFILE_SCRIPT_MEMORY);
            llSleep(0.1);
            //llOwnerSay("bytes:"+(string)(2 * llStringLength(access_list)) + " nowfree:"+(string)(llGetMemoryLimit() - llGetUsedMemory()) + " minfree:" +(string)llGetFreeMemory());
            //llOwnerSay(access_list);
            if (llGetMemoryLimit() - llGetUsedMemory() < 2 * llStringLength(access_list)) return llSetText("Memory:"+(string)(llGetMemoryLimit() - llGetUsedMemory())+"b",<0,1,0>,1);
            integer l = ~llSubStringIndex(access_list, ","+llToLower(intruder_fullname)+",");
            //llOwnerSay("SPMAxa" + (string)llGetSPMaxMemory());
            if (~llSubStringIndex(access_list, ","+llToLower(intruder_fullname)+",")) { visitor_status = "fg"; if (colour.x != 1.0) colour = <0.0,1.0,1.0>; } //blue(011) if not yellow(110) or red(100)
            else if (~llSubStringIndex(access_list, ","+llToLower(intruder_username)+",")) { visitor_status = "ug"; if (colour.x != 1.0) colour = <0.0,1.0,1.0>; }
            else if (~llSubStringIndex(access_list, ","+llToUpper(intruder_fullname)+",")) visitor_status = "fF"; //colour = <0.0,1.0,0.0>; } //green(010) if not blue(011),yellow(110),red(110)
            else if (~llSubStringIndex(access_list, ","+llToUpper(intruder_username)+",")) visitor_status = "uF"; //colour = <0.0,1.0,0.0>; }
            llSleep(0.1);
            if (llGetMemoryLimit() - llGetUsedMemory() < 2 * llStringLength(targets_list)) return llSetText("Memory:"+(string)(llGetMemoryLimit() - llGetUsedMemory())+"b",<0,1,0>,1);
            l = ~llSubStringIndex(targets_list, ","+llToLower(intruder_fullname)+",");
            //llOwnerSay("SPMAx" + (string)llGetSPMaxMemory());
            if (~llSubStringIndex(targets_list, ","+llToLower(intruder_fullname)+",")) { visitor_status = "fT"; colour = <1.0,0.0,0.0>; } //red(100)
            else if (~llSubStringIndex(targets_list, ","+llToLower(intruder_username)+",")) { visitor_status = "uT"; colour = <1.0,0.0,0.0>; }
            else if ( intruder_key == llGetOwner()) visitor_status = "kO"; //green(010) if not blue(011), yellow(110), red(100)
            
            if (visitor_status == "--") { if (colour.x != 1.0) colour = <1.0,1.0,0.0>; }
            //--            
            //else { if (colour.x != 1.0) colour = <1.0,1.0,0.0>; } //Triggers when avie not in any lists. If no Targets in this batch of avies change colour to yellow from green
            
            //llScriptProfiler(PROFILE_NONE);
            //llOwnerSay("SPMAx" + (string)llGetSPMaxMemory());
            
            //llSay(0,"vs1 "+(string)llGetFreeMemory());

            if (
                (sensor_state > 3 && llGetSubString(visitor_status,1,1) == "g") ||   //friends mode, no guests
                (sensor_state > 3 && visitor_status == "kG") ||   //friends mode, no group
                (sensor_state > 2 && visitor_status == "--") ||   //guests and friends mode, no others
                (sensor_state > 1 && llGetSubString(visitor_status,1,1) == "T")      //attack targets except in NoAttack mode
               ) warn_then_attack(intruder_username, intruder_key, intruder_pos, visitor_status); //,visitor_status
            
            //llSay(0,"vs2 "+(string)llGetFreeMemory());

            detected_people += visitor_status + "/";

            integer ai = llGetAgentInfo(intruder_key);
            if (ai & AGENT_MOUSELOOK) detected_people += "M";
            if (ai & AGENT_AWAY) detected_people += "a";
            if (ai & AGENT_BUSY) detected_people += "b";
            detected_people += " ";

            //* Get stats: show in detected people
            list ls = llGetObjectDetails(intruder_key,[OBJECT_SCRIPT_MEMORY, OBJECT_RUNNING_SCRIPT_COUNT, OBJECT_SCRIPT_TIME]);
            string script_stats = (string)(llRound(llList2Float(ls,0)/1000000.0)) + "㎆/" + (string)((integer)(llList2Float(ls,2)*1000000.0))+"µs";
            detected_people += script_stats;
            
            //SCRIPT_
            
            if ((llGetSubString(visitor_status,1,1) != "F" && llGetSubString(visitor_status,1,1) != "O") && sensor_state > 1) 
                llMessageLinked(LINK_THIS,22000,(string)llList2Integer(ls,0)+","+(string)llList2Integer(ls,1)+","+(string)llList2Float(ls,2)+","+intruder_username+","+(string)intruder_pos,intruder_key);
            
            //END SCRIPT_
            
            llMessageLinked(LINK_THIS,81300,visitor_status + intruder_username + "|" + (string)intruder_pos + "|" +llList2String(ls,0)+ "|" +llList2String(ls,1)+"|"+(string)sensor_state+"|"+llList2String(ls,2),intruder_key);             
            
            //manual boot avatar, ALWAYS allowed in any mode
            if (ban_tp_visitor_active && (intruder_fullname == ban_tp_visitor || intruder_username == ban_tp_visitor || intruder_displayname == ban_tp_visitor)) {
                string status = "T";
                if (ban_tp_visitor_hours == -1) {
                    llTeleportAgentHome(intruder_key);
                    llInstantMessage(ban_tp_visitor_op,t+"TPing Home: " + intruder_displayname + " (" + intruder_username + ")");
                } else { 
                    llAddToLandBanList(intruder_key,ban_tp_visitor_hours);
                    status = "B";
                    llInstantMessage(ban_tp_visitor_op,t+(string)ban_tp_visitor_hours + "hrs banned: " + intruder_displayname + " (" + intruder_username + ")");
                }
                ban_tp_visitor_active = FALSE; //we choose . because "" can match empty intruder_displayname;
                llMessageLinked(LINK_THIS,81303,status+ intruder_displayname + " (" + intruder_username + ")",intruder_key); // "B " means banned
            }
            
            //VERSION 13 jump to here if avatar found is out of wanted range
            @outofrange;
            //llOwnerSay("21d"+(string)llGetUsedMemory());
        } // end for loop for all agents found
        llMessageLinked(LINK_THIS,22009,detected_people,"");
        
        if (ban_tp_visitor_active) llInstantMessage(ban_tp_visitor_op,t+"Can't find: " + ban_tp_visitor);
        ban_tp_visitor_active = FALSE; //clear any ban_tp_visitor requests

        if (sensor_state == 1)  detected_people = "NoAttack" + detected_people; 
        if (sensor_state == 3)  detected_people = "Guests" + group_safe_string  
                                                             + attack_type_name + detected_people; 
        if (sensor_state == 2)  detected_people = "Public" + "/" 
                                                             + attack_type_name + detected_people;
        if (sensor_state == 4)  detected_people = "Friends" + "/" 
                                                             + attack_type_name + detected_people;
        if (up != 500) upindicator = "}"; else upindicator = "";
        if (down != 500) downindicator = "{"; else downindicator = "";
        
        string sensorrangetext = (string)sensor_range + "m";
        string oor;
        if (sensor_range == -1) sensorrangetext = "TL";
        if (sensor_range == -2) sensorrangetext = "LO";
        if (sensor_range == -4) sensorrangetext = "R";
        if (sensor_range > 0) oor = ")" + (string)outofrangecount;
        
        detected_people = "(" + (string)((llGetMemoryLimit() - llGetUsedMemory())/1000) +"㎅) "+
                flags + oitext + " " +
                downindicator + sensorrangetext + upindicator + " " +
                llGetSubString((string)llGetAndResetTime(),0,3)+"s "+
                "["+ (string)detected+oor+"]\n"+
                detected_people;

        llSetText(detected_people,colour,visible);

        if (llStringLength(detected_people) > 255) llRegionSay(2222,"~HSOp2~"+llGetSubString(detected_people,255,-1));
        llRegionSay(2222,detected_people);
        //llMessageLinked(2,20000,detected_people,""); //2=child prim, then used for remote display v9
        attack_string = warning_string; //move the warned list to the attack list for next sweep
        warning_string = ","; //reset warned list; //reset strike list to none
        
        llMessageLinked(LINK_THIS,81300,"end",""); //tell visitor log that all visitors have been sent for this cycle.      
    } // end sensor()
}
