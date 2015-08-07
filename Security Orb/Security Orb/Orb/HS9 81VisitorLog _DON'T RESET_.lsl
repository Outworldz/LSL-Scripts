// :CATEGORY:Security
// :NAME:Security Orb
// :AUTHOR:Psyke Phaeton
// :KEYWORDS:
// :CREATED:2014-09-08 19:09:45
// :EDITED:2014-09-08
// :ID:1043
// :NUM:1649
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

// There is 3 lists.
// 1 is the str_log which is in format Muuid??Name, M = message (+In -Out Fail Weapon), ?? = [O|T|F|G|g|-][U|D|L|K|-]
// 2 is the old_list, format uuidName
// 3 is the new_list, format uuidName

list str_log = [];
integer i; //tmp variable
integer announce; //announce channel
integer channel;
list old_list; //old list of strs found, format UUID?Name
list new_list; //new list of strs found, same as above
string twitter_logon_base64; //twitter logon from 
string prim_web_address;
integer foreign_land_safe;  //attack intruders that are ONLY over my land? 1=yes, 2=no, default = true
integer other_land_safe;    //keep all other land safe even my other land
integer visit_im;           //do we IM op when str?
key activater_uuid;   
integer displayname_protection; // true if we check for operator names within display names but the avatar is not the real operator and we will attack them!
list operators_list; //used to look for operator names in Display Names
float script_memory_warn = -1; //memory amount of scripts causing a warning
integer script_count_warn = -1; //count of scripts causing a warning
float script_time_warn = -1; //time usage amount of scripts causing a warning
integer script_time_warn_maxcount = 10; //count of over time usage b4 message
float script_memory_teleport = -1; //memory amount of scripts causing a warning
integer script_count_teleport = -1; //count of scripts causing a warning
float script_time_teleport = -1; //time usage amount of scripts causing a warning
integer script_time_teleport_maxcount = 15; //count of over time usage b4 TP'ed
integer age_ban_end_clock = 0; //holds UnixTime of when ageban ends, 0 = off, int max 2147483647
integer age_days_old_ban = -1; //bellow this number of days old = ban when unixtime < age_ban_end_clock
list age_check_list = []; //up to 16 [UUID,AgeReqID,...] sequences awaiting data() event age reply.
integer sensor_state; //Orbs online/offline mode. Only updates when an avatar is processed.


integer gday(integer yy, integer mm, integer dd)
{
    // convert date to day number 
    integer m = (mm + 9)%12; // mar=0, feb=11 
    integer y = yy - 1600 - m/10;   // if Jan/Feb, year-- 
    return y*365 + y/4 - y/100 + y/400 + (m*306 + 5)/10 + (dd - 1);
}

string log_entry_to_text(string logentry, integer twitter_log) {
                string output = logentry; //if Online or Offline we skip any further processing

                if (logentry == "URL") output = "Web page is " + prim_web_address;
                
                else if (logentry != "Online" && logentry != "Offline" && llGetSubString(logentry,0,5) != "  Age>") {
                    //llOwnerSay(logentry); //DEBUG
                    //action
                    //attacks must be a number because we use that to not send attack messages to the operator. Weapon sends attack messages to the operator.
                    if      (llGetSubString(logentry,0,0) == "+") output = "Enters";
                    else if (llGetSubString(logentry,0,0) == "-") output = "Leaves";
                    else if (llGetSubString(logentry,0,0) == "0") output = "Unauthorised: Push";        //weapon sends IM
                    else if (llGetSubString(logentry,0,0) == "2") output = "Unauthorised: TP Home";     //weapon sends IM
                    else if (llGetSubString(logentry,0,0) == "3") output = "Unauthorised: Eject";       //weapon sends IM
                    else if (llGetSubString(logentry,0,0) == "F") output = ">> Attack Failed: Land & Orb not same owner:";
                    else if (llGetSubString(logentry,0,0) == "D") output = ">> Fake Op Display Name";   //weapon sends IM
                    else if (llGetSubString(logentry,0,0) == "d") output = ">> DispName similar to Op:";
                    else if (llGetSubString(logentry,0,0) == "B") output = ">> Land Banned:";
                    else if (llGetSubString(logentry,0,0) == "x") output = ">> Ban/TP Failed: Land & Orb not same owner:";
                    else if (llGetSubString(logentry,0,0) == "S") output = "TP Home: Script limits:";   //weapon sends IM
                    else if (llGetSubString(logentry,0,0) == "T") output = "TP Home by Op: ";
                    else if (llGetSubString(logentry,0,0) == "a") output = "Attack: Avatar age: ";      //weapon sends IM
                                                            
                    ////avatar security status
                    output += " [" + llGetSubString(logentry,37,38) + "]";
                    //if      (message == "-") output += "-"; //was "N" -> "{NA}
                    ////else if (message == "A") output += "(A)";
                    //else if (message == "F") output += "(F)";
                    //else if (message == "g") output += "(gu)"; //g = guest
                    //else if (message == "G") output += "(Gr)"; //G = Group
                    //else if (message == "O") output += "(O)";
                    //else if (message == "T") output += "<T>";
                    //else if (message == "_") ;
                
                    //avatar name
                    output += " " + llGetSubString(logentry,39,-1);
                
                    if (twitter_log) 
                        output += " http://world.secondlife.com/resident/" + llGetSubString(logentry,1,36); //+ " W " + prim_web_address;
                    else output += " secondlife:///app/agent/" + llGetSubString(logentry,1,36) + "/about";
                }
                //llSay(0,"(81D)" + llGetSubString(logentry,0,11));
                return output;
}

add_log(string logentry, integer vlog, integer twitter_visitim) {
    
    while (llGetListLength(str_log) >= 160) str_log = llDeleteSubList(str_log,0,1);

    vector my_pos = llGetPos();
    string slurl_suffix = llEscapeURL(llGetRegionName()) + "/" + (string)((integer)my_pos.x) + "/" + (string)((integer)my_pos.y) + "/" + (string)((integer)my_pos.z) + "/ ";
    string msg = log_entry_to_text(logentry,TRUE) + " @ " + slurl_suffix; 
        
    if (vlog) {
        str_log += [logentry] + [llGetUnixTime()];
        if (visit_im && 
            activater_uuid != NULL_KEY && activater_uuid != "" &&
            activater_uuid != llGetSubString(logentry,1,36) && //don't inform Op he left or arrived in the area, they know obviously
            twitter_visitim && //represent if the person is over foreign or other land, if both are flagged off in orb settings dont send
            ~llSubStringIndex("+-FdBxT",llGetSubString(logentry,0,0)) //don't send attack messages to op, weapon does that
           ) llInstantMessage(activater_uuid,"(81VLogIM) " + (string)((integer)llGetWallclock() / 3600) + llGetSubString(llGetTimestamp(),13,-9)+ "SLT " + 
                                                                    log_entry_to_text(logentry,0) + " @ " + "http://slurl.com/secondlife/" + slurl_suffix);
           //llOwnerSay("81Debug: visit_im:" + (string)visit_im + "activater_uuid:" + (string)activater_uuid + "twitter_visitim:" + (string)twitter_visitim);
    }

    if (twitter_logon_base64 != "" && twitter_visitim) {
                    
        //llOwnerSay("debug msg_length: " + (string)llStringLength(twitter_msg));
        llHTTPRequest("http://www.twitter.com/statuses/update.xml?status=" + llEscapeURL(llGetSubString(msg,0,139))+ " HTTP/1.0\n" +
                    "Authorization: Basic " + twitter_logon_base64 + "\n",
                    [HTTP_METHOD,"POST",HTTP_VERIFY_CERT,FALSE],"\n");
    }//end twitter if
}

string on_off(integer i) {
    return llList2String(["Off","On"],i);
}

default
{ 
    state_entry() {
        if (llGetMemoryLimit() < 65536) llSay(DEBUG_CHANNEL,"**** Memory limit too low. Mono disabled? ****");
        if (llGetStartParameter() != -3333333333) {
            if (llKey2Name(llGetOwner()) != "Psyke Phaeton") {
                llSay(0,"(81VisitorLog) Unauthorised copy, deleting.");
                llRemoveInventory(llGetScriptName()); //not psyke, delete
            } else llMessageLinked(LINK_THIS,4000,"Reset","");
        }
        activater_uuid = llGetOwner();
        if (llGetFreeMemory() < 16384) llSay(0, "(81VLog) *** WARNING: Not Mono, report to Psyke Phaeton ***");
    } 
    
    //http_request(key ID, string Method, string Body) {
    //   if (Method == URL_REQUEST_GRANTED) {
    //       llOwnerSay("debug vlog got web addy: " + Body);
    //       prim_web_address = Body;
    //   }
    //}

    
    link_message(integer sender_num, integer num, string str, key id) {
        //if (num == 81310) { //  of new str list
        //llOwnerSay("81debug: " + str);
        
        if (num == 21120) {
            //llOwnerSay("recieved op string:" + str);
            operators_list = llParseString2List(str,["|"],[]);  //used by SLEEP to see if op is seen and by us to look for display name fraud
            //llOwnerSay("Op List length = " + (string)llGetListLength(operators_list));
        }
            
            
        if (num == 81300) { 
            //LM format: "??Name|<pos>|script memory|script count|sensor_state",UUID
            //LM format: end
            // ?? = [ufkd-][OTFGg-]
            //llSay(0,"(Log)8300:" + str);
            
            if (str != "end") {
                
                /////////////////////////////////////
                // GETTING LIST OF CURRENT VISITORS
                // add to new_list
                /////////////////////////////////////
                

                list tmp = llParseString2List(str,["|"],[]);
                str = llList2String(tmp,0); //ie "TUuser.name"
                vector pos = (vector)llList2String(tmp,1);
                //float avatar_script_memory = llList2Float(tmp,2);
                //integer avatar_script_count = llList2Integer(tmp,3);
                sensor_state = llList2Integer(tmp,4);
                //float avatar_script_time = llList2Float(tmp,5);
                tmp = []; //clear tmp

                
                //if person not on old list then add log entry
                if (llListFindList(old_list,[(string)id + str]) == -1) {
                    //check foreign and other_land_safe
                    integer twitter_visitim = 1; //twitterlog on by default
                    
                    //if FLSafe on and land owners different then ignore the intruder
                    if( foreign_land_safe && (llGetLandOwnerAt(llGetPos()) != llGetLandOwnerAt(pos)) ) {
                        //twitter_visitim = FALSE;
                        //llOwnerSay("FLS is true and LO != LO");
                        return;
                    }
                    
                    //if OLSafe on AND land owners the same AND parcel names differ ignore the intruder
                    if( other_land_safe && (llGetLandOwnerAt(llGetPos()) == llGetLandOwnerAt(pos)) &&
                        (llList2String(llGetParcelDetails(pos,[PARCEL_DETAILS_NAME]),0) != llList2String(llGetParcelDetails(llGetPos(),[PARCEL_DETAILS_NAME]),0))) {
                        //twitter_visitim = FALSE;
                        //llOwnerSay("OLS is true and PName != PName");
                        return;
                    }
                    //llOwnerSay("Orb:FLS/twitterim" + (string)foreign_land_safe + (string)twitter_visitim);
                    //llOwnerSay("Orb:OLS/twitterim" + (string)other_land_safe + (string)twitter_visitim);
                    //["-UUID?Name",UNIXTIME]
                    add_log("+" + (string)id + str + " " + (string)llFloor(llVecDist(pos,llGetPos())) + "m",TRUE,twitter_visitim);
                    
                    string str_username = llGetUsername(id);
                    string str_fullname = llKey2Name(id);
                    string str_displayname = llGetDisplayName(id);

                    /// START SCRIPT MEMORY LIMITS ///
                    //string lines = "";
                    //if (script_count_warn > -1 && avatar_script_count > script_count_warn) 
                    //    lines += "\nPreferred count < " + (string)script_count_warn + ", You: " + (string)avatar_script_count;
                    //if (script_memory_warn >= 0 && avatar_script_memory > script_memory_warn)
                    //    lines += "\nPreferred memory < " + (string)(script_memory_warn/1000000.0) + "㎆, You: " + (string)(avatar_script_memory / 1000000.0) + "㎆";
                    //if (script_time_warn >= 0 && avatar_script_time > script_time_warn) 
                    //    lines += "\nPreferred CPU time usage < " + (string)((integer)(script_time_warn * 1000000.0)) + "µs, You: " + (string)((integer)(avatar_script_time * 1000000.0)) + "µs";
                    //if (lines != "" && llGetOwner() != id && llGetLandOwnerAt(llGetPos()) == llGetLandOwnerAt(pos)) 
                    //    llDialog(id,"Please detach some scripts to avoid causing lag\n" + lines,[],-9999);
                    /// END SCRIPT MEMORY LIMITS ///

                    ////////////////////////////////////
                    // START: DISPLAY NAME PROTECTION //
                    ////////////////////////////////////
                    
                    //check not a real operator
                    if (!~llListFindList(operators_list,[llToUpper(str_username)]) && !~llListFindList(operators_list,[llToUpper(str_fullname)]) ){
                        //llOwnerSay("not op");
                        integer spacepos; // holds the position of the space char in an op name
                        integer dotpos; // holds the position of the dot char in an op name
                        string opfullname;
                        string opusername;
                        string opfirstname;
                        integer x;
                        //check if any valid op_list name is in the display name of a non-op detected avatar
                        for (x = llGetListLength(operators_list) - 1; ~x; --x) { 
                            //check if op_list contains full or user name, then derive the other
                            if ( (spacepos = llSubStringIndex(llList2String(operators_list,x)," ")) != -1 ) { //space = full name
                                //llOwnerSay("for loop x = " + (string)x + ", op_name_test:'" + llList2String(operators_list,x) + "' found spacepos at:" + (string)spacepos);
                                opfullname = llList2String(operators_list,x);
                                opfirstname = llGetSubString(opfullname,0,spacepos - 1);
                                opusername = opfirstname + "." + llGetSubString(opfullname,spacepos + 1,-1);
                            } else if ( (dotpos = llSubStringIndex(llList2String(operators_list,x),".")) != -1 ) { //. = user name
                                //llOwnerSay("for loop x = " + (string)x + ", op_name_test:'" + llList2String(operators_list,x) + "' found dotpos at:" + (string)dotpos);
                                opusername = llList2String(operators_list,x);
                                opfirstname = llGetSubString(opusername,0,dotpos - 1);
                                opfullname = opfirstname + " " + llGetSubString(opusername,dotpos + 1,-1);
                            } else { //new format name joe123
                                //llOwnerSay("for loop x = " + (string)x + ", op_name_test:" + llList2String(operators_list,x) + " shows op is new format");
                                opfirstname = ""; // same as username so make it blank to compare faster
                                opusername = llList2String(operators_list,x);
                                opfullname = llList2String(operators_list,x) + " Resident";
                            }
                            //llOwnerSay("opfirstname:" + opfirstname);
                            //llOwnerSay("opusername:" + opusername);
                            //llOwnerSay("opfullname:" + opfullname);
                            //llOwnerSay("displayname:" + str_displayname);
                            
                            //check if an op full or user name is in the display name
                            if (~llSubStringIndex(llToUpper(str_displayname),opusername) || ~llSubStringIndex(llToUpper(str_displayname),opfullname))
                            {
                                if  (displayname_protection && sensor_state > 1) {
                                                                    
                                    if (llOverMyLand(id)) {
                                        //llTeleportAgentHome(id); //we want them gone long enough for the scanner sweep to see them gone. Because this only attacks once per visit!
                                        llMessageLinked(LINK_THIS,3002,str_displayname + " (" + str_username + ")|" + (string)pos,id);
                                        //llSay(announce,"(81VisitorLog) Fake Display Name: Ban/Teleporting/Adding Target " + str_displayname + " (" + str_username + ")");
                                    }
                                    else {
                                        llMessageLinked(LINK_THIS,81303,"F"+str_username,id); //version 12 "F" becomes "F " for log entry
                                        llSay(announce,"(81VisitorLog) Fake Display Name: Cant TP-Not over my land: " + str_displayname + " (" + str_username + ")");
                                    }
                                    llMessageLinked(LINK_THIS,2901,str_username,"");
                                    llAddToLandBanList(id,0);
                                }//end dispprot on and sensor > 1
                                
                                add_log("D" + (string)id + str + " " + (string)llFloor(llVecDist(pos,llGetPos())) + "m",TRUE,twitter_visitim);
                            }
                            //check if an op first name is in a display name
                            else if (~llSubStringIndex(llToUpper(str_displayname),opfirstname)) 
                            {
                                //warning message
                                add_log("d" + (string)id + str + " " + (string)llFloor(llVecDist(pos,llGetPos())) + "m",TRUE,twitter_visitim);
                            }
                            //else llOwnerSay("op name not in avatar display name:"+ llGetDisplayName(id));
                            
                            
                        }//end for loop: iterate through op_list
                                                
                    }//end if scanned avatar not an op

                    //////////////////////////////////
                    // END: DISPLAY NAME PROTECTION //
                    //////////////////////////////////
                    
                    ///Age ban for X hours
                    if (age_ban_end_clock && llGetUnixTime() > age_ban_end_clock) { //not 0 and passed.
                        age_ban_end_clock = 0;
                        age_days_old_ban = -1;
                        llSay(announce,"(81VisitorLog) Age banning ends");
                    }
                    //llSay(0,"(81D) age_check_list length before 16 record check:" + (string)llGetListLength(age_check_list)); 
                    while (llGetListLength(age_check_list) > 32) age_check_list = (age_check_list = []) + llDeleteSubList(age_check_list,0,1);
                    //llSay(0,"(81D) age_check_list length after 16 record check:" + (string)llGetListLength(age_check_list)); 

                    if (llGetUnixTime() < age_ban_end_clock && llGetSubString(str,1,1) != "F" && sensor_state > 1) //within age ban clock time AND avatar is not Friend AND orb is attacking
                        age_check_list = (age_check_list = []) + age_check_list + [id,llRequestAgentData(id, DATA_BORN )];
                    //llSay(0,"(81D) age_check_list length after adding a new check:" + (string)llGetListLength(age_check_list)); 

                        
                }
                //add str UUID to the new list so we can store them in old list for the next scan cycle
                new_list += [(string)id + str];
                
                
                
                //llSay(0,"81 add " + (string)id + str);
                
            } else { // "end"
                //llSay(0,"81 end");
                
                ////////////////////////////////////////////////
                // COMPLETED GETTING NEW_LIST
                ////////////////////////////////////////////////

                // compare old_list to new_list and see who left
                
                
                integer oll = llGetListLength(old_list) - 1;
                i = 0;
                //llSay(0,"v2");
                //llSay(0,"81 old_list length - 1 = oll = " + (string)oll);
                //llSay(0,"81 Contents of old_list: " + llDumpList2String(old_list,"|"));
                while (i <= oll) {
                    //llOwnerSay("81 looking For old_list record '" + llList2String(old_list,i) + "' in new list: '" + llDumpList2String(new_list,"|"));
                    //if (i > 10) { llSay(0,"FAIL"); return;}
                    if (llListFindList(new_list,[llList2String(old_list,i)]) == -1) {
                        // old_list str not found in the new list
                        //format: [-UUID?Name, TTTTTTTT]
                        add_log("-" + llList2String(old_list,i),1,1);
                        //llOwnerSay("81 adding LOG: [-" + llList2String(old_list,i) + "|" + (string)llGetUnixTime() + "]");
                        //llSleep(2);
                    }
                    //else llSay(0, "81 name in old_list - has not left yet");
                    i++; //next
                }
                                
                //make new_list old, and clear new_list
                old_list = [];
                old_list = new_list;
                new_list = [];
                //llSay(0, "81 List lengths: " + (string)llGetListLength(old_list) + " " + (string)llGetListLength(old_list));
            }
            //llOwnerSay("ll="+(string)llGetListLength(log)+" b="+(string)llGetFreeMemory());
        }
        else if (num == 81301) {
            i = 0;
            integer time_diff;
            integer hours;
            integer days;
            integer mins;
            string output;
            llSay(announce,"--- Visitor Log - " + (string)(llGetListLength(str_log) / 2) + " entries ---");
            while(i < llGetListLength(str_log)) {
                time_diff = llGetUnixTime() - (integer)llList2String(str_log,i + 1);
                days = time_diff / 86400;
                hours = time_diff % 86400 / 3600;
                mins = time_diff % 8640 % 3600 / 60;
                output = (string)days + "d" + (string)hours + "h" + (string)mins + "mins ago: ";
                
                //llSay(0,"'"+llList2String(str_log,i)+"'");
                
                //input str log entry
                output += log_entry_to_text(llList2String(str_log,i),0);
                //output is a text message
                
                llSay(announce,output);
                i = i + 2;
            }
                        
            //llSay(0,llDumpList2String(log,"|"));
            llSay(announce,"--- End --- " + (string)llGetFreeMemory() + "b free");
        }

       // else if (num == 81222 && str != twitter_logon_base64) {
       //     //if default or blank then make blank
       //     if (str == llStringToBase64("name:password") || str =="") str = "";
       //     else {
       //         twitter_logon_base64 = str; //this will be already in base64
       //         llWhisper(announce, "(81VisitorLog) Loaded Twitter login.");
       //     }
       // }
        
        else if (num == 81303) //attack from weapon // log format Muuid?Name
            add_log(llGetSubString(str,0,0) + (string)id + "➤➤" + llGetSubString(str,1,-1),1,1);
        
        
        else if (num == 81304) {
            add_log(str,1,1); //turn off/on orb
            new_list = [];
            old_list = [];
        }
        else if (num==81310) {
            visit_im = (integer)str;
            activater_uuid = id;
            //llOwnerSay("81debug visit_im:" + (string)visit_im);
        }
        else if (num==2302) {
            if (str == "slw") jump x2302;
            list sw = llParseString2List(str,[" "],[]);
            //script_memory_warn = -1;
            //script_count_warn = -1;
            //script_time_warn = -1;
            //script_time_warn_maxcount = 10;
            if (llGetListLength(sw) > 0 && llList2String(sw,0) != "*") script_memory_warn = llList2Float(sw,0) * 1000000.0;
            if (llGetListLength(sw) > 1 && llList2String(sw,1) != "*") script_count_warn = llList2Integer(sw,1);
            if (llGetListLength(sw) > 2 && llList2String(sw,2) != "*") script_time_warn = llList2Float(sw,2) / 1000000.0; //entered as µs (microseconds) so we convert to seconds
            if (llGetListLength(sw) > 3 && llList2String(sw,3) != "*") script_time_warn_maxcount = llList2Integer(sw,3);

            @x2302;
            string smw = (string)(script_memory_warn / 1000000.0) + "㎆, ";
            if (script_memory_warn < 0) smw = "Ignore Memory, ";
            string scw = (string)script_count_warn + "scripts, ";
            if (script_count_warn < 0) scw = "Ignore Count, ";
            string stw = (string)((integer)(script_time_warn * 1000000.0)) + "µs/frame (" + (string)script_time_warn_maxcount + " times)"; //(string)script_time_warn + "s";
            if (script_time_warn < 0) stw = "Ignore Time";
            if (id != "r")  llSay(announce,"(81VisitorLog) Script Limits, Warn: " + smw + scw + stw);
   
        }        
        else if (num==2301) { //(num==81401) { //steal from Sensor command so we can update the AvLimits menu here
            if (str == "slt") return; //no parameters
            list sl = llParseString2List(str,[" "],[]);
            //script_memory_teleport = -1;
            //script_count_teleport = -1;
            //script_time_teleport = -1;
            //script_time_teleport_maxcount = 15;
            if (llGetListLength(sl) > 0 && llList2String(sl,0) != "*") script_memory_teleport = llList2Float(sl,0) * 1000000.0;
            if (llGetListLength(sl) > 1 && llList2String(sl,1) != "*") script_count_teleport = llList2Integer(sl,1);
            if (llGetListLength(sl) > 2 && llList2String(sl,2) != "*") script_time_teleport = llList2Float(sl,2) / 1000000.0; //entered as µs (microseconds) so we convert to seconds
            if (llGetListLength(sl) > 3 && llList2String(sl,3) != "*") script_time_teleport_maxcount = llList2Integer(sl,3);
        }        
        else if (num == 81666) {
            str_log = [];
            llSay(announce,"Visitors Log cleared");
        }
        
        else if (num == 81777) {
            prim_web_address = str;
            add_log("URL",0,1); //twitter log only
        }
        
        else if (num == 81500) { displayname_protection = (integer)str; num = 100; }
        else if (num == 81501) { //string str = integer days old|integer age ban end time in Unix Time
            age_days_old_ban = llList2Integer(llParseString2List(str,["|"],[]),0);
            age_ban_end_clock = llList2Integer(llParseString2List(str,["|"],[]),1);
            if (age_days_old_ban > 0) 
                llSay(announce,"(81Vlog) ▶▶ YOUR ORB IS SET TO BAN PEOPLE " + (string)age_days_old_ban + " DAYS OLD OR LESS. To disable this type: /"+(string)channel+"age off ◀◀");
            //num = 100;
            if (llList2String(llParseString2List(str,["|"],[]),2) != "nomenu") num = 81502;
        }
        //else: 81501 wants to call this too
        if (num == 81502) {
            float agetlhours = (float)(age_ban_end_clock - llGetUnixTime()) / 3600.0;
            if (agetlhours <= 0.0) agetlhours = 0;
            string str_age_days_old_ban = "Age > " + (string)age_days_old_ban + "days inclusive";
            if (age_days_old_ban < 0) str_age_days_old_ban = "Off";
            
            string print_scripts_warn = "";
            string print_scripts_teleport = "";
            
            if ( script_memory_warn > -1) print_scripts_warn = (string)(script_memory_warn / 1000000.0) + "㎆, ";
            else print_scripts_warn = "Ignore memory, ";
                
            if ( script_count_warn > -1) print_scripts_warn += (string)script_count_warn + "scripts, ";
            else print_scripts_warn += "Ignore count, ";

            if ( script_time_warn >= 0.0) print_scripts_warn += (string)((integer)(script_time_warn * 1000000.0)) + "µs/f (" + (string)script_time_warn_maxcount + " times)";
            else print_scripts_warn += "Ignore time";

            if ( script_memory_teleport > -1) print_scripts_teleport = (string)(script_memory_teleport / 1000000.0) + "㎆, ";
            else print_scripts_teleport = "Ignore memory, ";
                
            if ( script_count_teleport > -1) print_scripts_teleport += (string)script_count_teleport + "scripts, ";
            else print_scripts_teleport += "Ignore count, ";                
                                   
            if ( script_time_teleport >= 0.0) print_scripts_teleport += (string)((integer)(script_time_teleport * 1000000.0)) + "µs/f (" + (string)script_time_teleport_maxcount + " times)";
            else print_scripts_teleport += "Ignore time";                
                                   
            llDialog(id,"Avatar Limits: (Applies to Orb's non-Friends)" +
                            "\nDispProt ·· Display Name Protection: " + llList2String(["Off","On"],displayname_protection)+
                            //"\nSLHelp ·· Attached Scripts Limit help" +
                            "\nSLHelp ·· Avatar Script Limits:" +
                            "\n\tWarn: " + print_scripts_warn + 
                            "\n\tTP: " + print_scripts_teleport +
                            "\nAgeHelp ·· Avatar Age Limits:" +
                            "\n\t" + str_age_days_old_ban + " / " + (string)agetlhours + "hrs left"
            ,["DispProt","SLHelp","AgeHelp","< SETTINGS"],channel);
        }


        
        else if (num == 2503) foreign_land_safe = (integer)str; //used to stop twittering foreign land strs if TRUE
        else if (num == 2504) other_land_safe = (integer)str;   //used to stop twittering other land strs if TRUE
        
        //print_status //removed else so others cann call num=100
        if (num == 100) llSay(0,"(81VisitorLog) "+(string)llGetUsedMemory()+"b FLS:" + on_off(foreign_land_safe) + " OLS:" + on_off(other_land_safe)  + " Ops:" + (string)llGetListLength(operators_list) + 
                      " Log: " + (string)llGetListLength(str_log) + " VisitIM:" + on_off(visit_im) + " DispProt:" + on_off(displayname_protection) + " " +  
                      "b Announce/Channel:" + (string)announce+ "/" + (string)channel + " SLW:" + (string)script_memory_warn + "b," + 
                      (string)script_count_warn + "," + (string)script_time_warn + "s/frame," + (string)script_time_warn_maxcount + "times" +
                      " Age:>"+(string)age_days_old_ban+"days/EndUnixTime="+(string)age_ban_end_clock);
        
        else if (num == 2) announce = (integer)str;
        else if (num == 1) channel = (integer)str;        
    }
    //http_response(key reqid, integer status, list metadata, string body) {
    //    llOwnerSay("http_response status number: " + (string)status);
    //}
    
    dataserver(key reqid,string data) {
        //age_check_list is up to 16 [UUID,AgeReqID,...] sequences awaiting dataserver() event age reply.
        //triggering this means we ARE banning if age is less days than we want.
        if ((i = llListFindList(age_check_list,[reqid])) > -1) {
            key avi_key = llList2String(age_check_list,i - 1);
            string date = llGetDate();
            integer age = gday((integer)llGetSubString(date,0,3),(integer)llGetSubString(date,5,6),(integer)llGetSubString(date,8,9)) - 
                  gday((integer)llGetSubString(data,0,3),(integer)llGetSubString(data,5,6),(integer)llGetSubString(data,8,9));
            //  compare age to days old limit
            if (age <= age_days_old_ban) {
                llSay(announce,"(81VLog) Attack: Avatar age : "+llGetUsername(avi_key) + " secondlife:///app/agent/" + (string)avi_key + "/about Born:" + data + " Age: ~" + (string)age + " <= " +(string)age_days_old_ban+" days");
                //log
                add_log("a" + (string)avi_key + "--" + llGetUsername(avi_key) + " Age:~" + (string)age + "<=" +(string)age_days_old_ban+"days" + " " + data ,TRUE,1);
                //user prefered attack
                llMessageLinked(LINK_THIS,3004,llGetDisplayName(avi_key) + " (" + llGetUsername(avi_key) + ")|" + (string)llGetPos() +"|"+(string)age,avi_key); //+"|"+(string)age_days_old_ban
            }
            age_check_list = (age_check_list = []) + llDeleteSubList(age_check_list,i - 1, i);
            //llSay(0,"(81D) age_check_list length after dataserver processing and delete entry:" + (string)llGetListLength(age_check_list)); 

        }
    }
}
