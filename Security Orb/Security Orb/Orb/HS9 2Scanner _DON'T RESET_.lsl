// :CATEGORY:Security
// :NAME:Security Orb
// :AUTHOR:Psyke Phaeton
// :KEYWORDS:
// :CREATED:2014-09-08 19:08:48
// :EDITED:2014-09-08
// :ID:1043
// :NUM:1641
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
//GLOBAL VARIABLES
//integer maximum_names = 100;
integer no_attack_warning; //sim owners can legally have no attack warning
string warning_message; //user defined warning message sent to intruders
string guest_warning_message; // when group/guest member seen but Orb in Friend Mode
integer visible = 1; //visibility toggle
integer foreign_land_safe; //variable from ml(2503,(string)foreign_land_safe,""); from weapon script
integer other_land_safe; //variable from ml(2504,(string)other_land_safe,""); from weapon script
float face = 1; //face stored alpha from when not invis while we are invis
integer announce; //channel we announce normal stuff on
integer channel; //channel to send "ListNear failed. HS offline" dialog
integer ready; //ready = TRUE when note card read ie. we have all user parameters
integer sensor_scan_range; //metres range of sensor when scanning only (70m keeps good un-Alt-viewable distance)
integer sensor_weapon_range; //metres range when armed to shoot (30m is normal hearing range)
integer sensor_range; //will be set to the variabe sensor_scan_range when weapons off and sensor_fire_range when not
integer sensor_state; //intruder sensor setting: 0=off, 1=scan, 2=targets only, 3=Guests, 4=Friends
string intruder_name; //holds the detected targets name
//float   intruder_dist;              //holds the detected targets distance
key intruder_key; //intruder key for llPushObject
//list    access_list;         //list of access people from "access People" NoteCard
//list    targets_list;
//9string warning_string = "|"; //string of people warned on this sensor sweep that we can attack next sweep
//9string attack_string = "|"; //string of people warned on the last sensor sweep that we can attack this sweep (warning_string is copied to attack_string)
float sensor_scan_timer; // time between each sensor sweep
//integer notecard_line_count;        //holds the value of the line number being read from "Settings"
// used by sensor() - put here to speed up sensor()
//9vector llSetText_colour; //text colour green above hs by default
//string detected_people; //list of detected people that will be shown in floating text
//integer relay_count;                //count of relays given from Security using ml(2202)
// recieved from Attack Script and stored here so we can show it on the floating text.
integer group_safe; //set true from notecard so that if HS prim and avatar in same group not attacked.
string group_safe_string; //string of above "/" or "+GS/"
integer attack_type; // 0 = push, 1 = [none], 2 = TPH, 3 = Eject
string attack_type_name; //push, TP, Eject
//string strike_string = "|"; // stringed collection of names seperated by |
string flags; //just FL on the float text when foreign_land_safe on
string t = "(2Scanner) "; //all chat output prefix
//string alc = "0"; //auth list count
//string tlc = "0"; //targe list count - to remove processing from scanner loop
string oitext; //adds "I8" to display when Object_interface is active and Orb uses channel 8
float up = 96;     //down and up ranges
float down = 96;   // "        "
//9string upindicator;     //down and up ranges
//9string downindicator;   // "        "
integer sleep; // if no op or owner detected go to sleep
string url; //holds url for status webpage.
key activater_uuid;
string deactivater_name;
//string activater_name;
float region_start_time; //stores the time when the region started (in secs since 1970)
string region_start_time_comment; //stores info about if it is a region restart time or a script rez time.
integer visit_im; //visit causes IM to op? Temp stored here before we inform the 81visitorlog script.
integer displayname_protection; // true if we check for ops names in others display names
integer announceweb; // turn on off announce web url

float script_memory_teleport = -1;
integer script_count_teleport = -1;
float script_time_teleport = -1;
integer script_time_teleport_maxcount = 15;
float script_memory_warn = -1; //because log does not store values during updates
integer script_count_warn = -1; //because log does not store values during updates
float script_time_warn = -1;
integer script_time_warn_maxcount = 10;
integer script_time_monitor;

string ml(integer i, string s, key k) {
    llMessageLinked(LINK_THIS,i,s,k);
    return s;
}

Say(integer announce, string message, key id) {
    //llSay(announce, t+message);
    if (llGetAgentSize(id) != ZERO_VECTOR) llDialog(id,message,["TOP MENU","OK"],channel);
}

send_to_21sensor(string p) {
    //llSay(announce, t+ "Sending settings to Sensor: " + p);
    //llSay(0,"2 oitext = " + oitext);

    //we add a space before | because translating it back from string to list makes || be ignored as a null by SL
    
    //" ¢" + (string)sensor_scan_range +
    //" ¢" + (string)sensor_weapon_range +
    //" ¢" + (string)alc +
    //" ¢" + (string)tlc +
    //" ¢" + strike_string;

    string s =
        (string)sensor_state +
        " ¢" + (string)sensor_range +
        " ¢" + (string)sensor_scan_timer +
        " ¢" + (string)no_attack_warning +
        " ¢" + warning_message +
        " ¢" + oitext +
        " ¢" + (string)announce +
        " ¢" + (string)up +
        " ¢" + (string)down +
        " ¢" + (string)channel +
        " ¢" + (string)other_land_safe +
        " ¢" + (string)foreign_land_safe +
        " ¢" + (string)visible +
        " ¢" + (string)group_safe +
        " ¢" + group_safe_string +
        " ¢" + (string)attack_type + 
        " ¢" + attack_type_name+
        " ¢" + (string)sleep+ 
        " ¢" + guest_warning_message+
        " ¢" + (string)script_memory_teleport+
        " ¢" + (string)script_count_teleport+
        " ¢" + (string)script_time_teleport+
        " ¢" + (string)script_time_teleport_maxcount+
        " ¢" + (string)script_time_monitor+
        " ¢" + (string)script_time_warn+
        " ¢" + (string)script_time_warn_maxcount+
        " ¢" + (string)script_memory_warn+
        " ¢" + (string)script_count_warn+
        " ¢" + (string)announce;

    //llOwnerSay(s); //debug what we send
    ml( 21000, s,"");
    //llSay(announce, t+ "Sending Target names to Sensor..");
    //ml(21002,llDumpList2String(targets_list,"|"),""); //tell 21Sensor its new targets and auth
    //llSay(announce, t+ "Sending access names to Sensor..");
    //ml(21001,llDumpList2String(access_list,"|"),""); //tell 21Sensor its new targets and auth
    //llSay(0,"2: " + s);
    //print_status(announce); //naggy on reset
}

input_settings(string s) {
    if (s=="done") {
        //llSay(DEBUG_CHANNEL,t + "settings restored.");
        //send_to_21sensor();
    }
    else
    {
        integer a = llSubStringIndex(s,"=");
        if(a > -1) //a != -1
        {
            string b = llDeleteSubString(s, a, -1);
            s = llDeleteSubString(s,0,a);
            a = (integer)s;
            if (~llSubStringIndex(s,"^")) llShout(0,"^ symbol in " + b + " not allowed");
            if(b == "scan_range") sensor_scan_range = a;
            else if (b == "armed_range") sensor_weapon_range = a;
            else if (b == "scan_rate") sensor_scan_timer = (float)s;
            else if (b == "no_warning") no_attack_warning = a;
            else if (b == "warning_message") warning_message = llStringTrim(s,STRING_TRIM); //llOwnerSay(t+warning_message);}
            else if (b == "guest_warning_message") guest_warning_message = llStringTrim(s,STRING_TRIM);
            else if (b == "oitext") oitext = s; //just internal
            else if (b == "target" || b == "t") ml(2901,s,"");// (targets_list=[]) + targets_list + s;
            else if (b == "rt") ml(21919,s,NULL_KEY); //raw storage of targets in back up script then restored.
            else if (b == "rv") ml(21918,s,NULL_KEY); //raw storage of visitors in back up script then restored. CAPS = Friend, lower = guest. 2801 sorts that out.
            else if (b == "vs") ml(21928,s,""); //visitors stored in multiple 1kb length strings
            else if (b == "ts") ml(21929,s,""); //targets stored in multiple 1kb length strings
            else if (b == "guest" || b == "a" || b == "authorised" || b == "g") ml(2801,llToLower(s),""); //access_list = (access_list=[]) + access_list + s;
            else if (b == "friend" || b == "f") ml(2801,llToUpper(s),""); //access_list = (access_list=[]) + access_list + s;
            else if (b == "announce") announce = a;
            else if (b == "up") up = (float)s;
            else if (b == "sleep") sleep = (integer)s; //sleep
            else if (b == "visible") visible = (integer)s;
            else if (b == "face") face = (float)s;  
            else if (b == "announce_web") announceweb = a;
            else if (b == "fake_op_displayname_protection" || b == "fake_op_display_name_protection") { displayname_protection = a; ml(81500,s,""); } //i released a bad notecard!!
            else if (b == "down") down = (float)s;
            else if (b == "visit_im") { visit_im = a; ml(81310,s,"");} //llOwnerSay("2debug visit_im:" + (string)a); }//visitor makes IM to op via 81Vlog
            
            else if (b == "script_memory_teleport") { script_memory_teleport = (float)s; ml(2301,(string)(script_memory_teleport/1000000.0),"r"); }
            else if (b == "script_count_teleport") { script_count_teleport = a; ml(2301,(string)(script_memory_teleport/1000000.0) + " " + (string)script_count_teleport,"r"); }
            else if (b == "script_time_teleport") { script_time_teleport = (float)s; ml(2301,(string)(script_memory_teleport/1000000.0) + " " + (string)script_count_teleport + " " + (string)(script_time_teleport * 1000000.0),"r"); }
            else if (b == "script_time_teleport_maxcount") { 
                script_time_teleport_maxcount = a; 
                ml(2301,(string)(script_memory_teleport/1000000.0) + " " + (string)script_count_teleport + " " + (string)(script_time_teleport * 1000000.0) + " " + s,"");
            }
            
            else if (b == "script_memory_warn") { script_memory_warn = (float)s; ml(81400,(string)(script_memory_warn/1000000.0),"r"); } 
            else if (b == "script_count_warn") { script_count_warn = a; ml(81400,(string)(script_memory_warn/1000000.0) + " " + (string)script_count_warn,"r"); }
            else if (b == "script_time_warn") { script_time_warn = (float)s; ml(2302,(string)(script_memory_warn/1000000.0) + " " + (string)script_count_warn + " " + (string)(script_time_warn*1000000.0),"r"); } 
            else if (b == "script_time_warn_maxcount") { 
                script_time_warn_maxcount = a; 
                ml(2302,(string)(script_memory_warn/1000000.0) + " " + (string)script_count_warn + " " + (string)(script_time_warn*1000000.0) + " " + s,"");
            }
            
            else if (b == "script_time_monitor") { script_time_monitor = a; send_to_21sensor("r_stm");}
            else if (b == "channel") ready = ~(channel = a); //set channel and since channel wont be -1 ready will be true
        }
    }
}
string sensor_state_to_words(integer state_number) {
    return llList2String(["*OFFLINE*","NoAttack","Public","Guests","Friends"],state_number);
}

string sensor_range_text(integer range) {
    string sensorrangetext = (string)range+"m";
    if (range == -1) sensorrangetext = "ThisLand";
    else if (range == -2) sensorrangetext = "LandOwner's Lands";
    else if (range == -4) sensorrangetext = "Region";
    return sensorrangetext;
}

string print_status(integer c) {
    llSay(c,t + (string)llGetUsedMemory()+"b Mode:" + sensor_state_to_words(sensor_state) + " Range:"+sensor_range_text(sensor_range)+
        llList2String([" Scans/Warnings:"," Warnings off, Scans:"], no_attack_warning) + (string)sensor_scan_timer+"s " +
        "Announce:" + (string)announce + " Sleep:" + llList2String(["Never","NoOp","SeeOp"],sleep) +
        " FLS:" + llList2String(["Off","on"],foreign_land_safe) + " VisitIM:" + llList2String(["Off","on"],visit_im) + " OLS:"+llList2String(["Off","on"],other_land_safe) +
        " DispProt:" + llList2String(["Off","on"],displayname_protection) + " Web:" + (string)announceweb +
        " Up:"+(string)up+ "m Down:"+(string)down+ "m V:" + (string)visible);
    return ""; //allows us to embed this function in other commands!
}
deactivate(integer dont_print) //display_welcome_text)
{
    //llOwnerSay(t+deactivater_name);
    //llReleaseURL(url);
    //integer notext = 0;
    //if (!sensor_state) notext = 1; //if already off ignore the request
    //9disable sensor
    //9llSensorRemove();
    //llOwnerSay("dont_print=" + (string)dont_print + ", sensor_state=" + (string)sensor_state);
    if (!dont_print) print_status(announce); //&& sensor_state
    llSetTextureAnim((sensor_state = 0), ALL_SIDES,1,1,1.0, 1.0, 0.0); //stop texture animation
    send_to_21sensor("off");
    llSetText("PDS HomeSecurity™ Orb\n" + llGetSubString(llGetObjectDesc(),0,-18) + "\n>> OFFLINE " + deactivater_name + " <<\nClick for Menu.\nNew? Click then [SET UP].\nGroup Land? You might need to deed me!\n**RESETTING MY SCRIPTS WILL BREAK ME**"
            ,<0.5,0.5,1.0>, visible);
    llRegionSay(2222,"PDS HSOrb OFFLINE");
    //ml(2,20000,"OFFLINE",""); //2=child prim, then used for remote display v9
    //llOwnerSay("(ScannerDebug) deactivater=" + deactivater_name);
}
activate(key id) {
    if (ready)
    {
        deactivater_name = "";
        //llOwnerSay("2Debug: llIM @ activate()");
        if (url != "" && announceweb) llInstantMessage(activater_uuid,t+"IM: Web address changed due to changes by " + llGetUsername(id));
        activater_uuid = id;
        ml(81310,(string)visit_im,activater_uuid); //inform the 81visitorlog who Op is and if they want IMs when visitor visits
        llRequestURL();
        //activater_name = llKey2Name(id);
        //if (activater_name == "") activater_name = activater_uuid;
        //llSay(0,"scanner in activate()");
        if (sensor_scan_timer == 0.0) sensor_scan_timer = 10.0; //if 0 default to 10
        if (up == 0 && down == 0) { up = 500.0; down = 500.0; } //if up and down wrong set to defaults
        if (sensor_state == 1) sensor_range = sensor_scan_range;
        else sensor_range = sensor_weapon_range;
        llSetTextureAnim(ANIM_ON|SMOOTH|LOOP, ALL_SIDES, 1,1, 2.0,2.0, 0.25); //texture animation
        //llSensorRepeat("", "", AGENT, sensor_range, PI, sensor_scan_timer);
        llSetText("\nActivated.\n.",<0.0,1.0,0.0>, visible);
        llRegionSay(2222,"Activated");
        send_to_21sensor("activate");

        if (attack_type && llGetOwner() != llGetLandOwnerAt(llGetPos())) {
            //llShout(DEBUG_CHANNEL,
        llInstantMessage(id,t+"Setup Error: SL requires "+ llGetObjectName()+" to have the same owner as the land when using Eject/Teleport. If the land is deeded then deed it to same group. If another avatar owns the land, give me it them to place. More info: http://psykephaeton.net/hsorb/V13/groups.html#Groups");
        }
        print_status(announce);
    }
}


default
{
    state_entry()
    {
        if (llGetMemoryLimit() < 65536) llSay(DEBUG_CHANNEL,"**** Memory limit too low. Mono disabled? ****");
        deactivater_name = "(script reset)";
        visible = !(ready = (integer)"");
        region_start_time = llGetUnixTime(); region_start_time_comment = "Script";
        //channel number will be triggered from Settings Script detecting CHANGE_INVENTORY
        if (llGetStartParameter() == -1186873829) {
            //script sent from update disk
            //llSay(announce,t + "Updated..restoring");
            //ml(9004,"2778",""); -- now triggered by 21Sensor as both are a set
        } else {
                //script reset, or STOLEN from orb or UPDATE DISK
                llSay(0,"Restart detected. Script deleting.");
            if (llKey2Name(llGetOwner()) != "Psyke Phaeton") llRemoveInventory(llGetScriptName()); //not psyke, delete
            else ml(4000,"",llGetOwner());//recompiled so reset to notecard defaults
        }
    }
    on_rez(integer x) {//rezzing isn't somethign that happens often enough, so we optimize the FALSE for a tighter value.
        deactivater_name = llGetUsername(llGetOwner());
        deactivate((integer)""); //deactivate on rez and cause UUID of floating text to update.
        region_start_time = llGetUnixTime(); region_start_time_comment = "Script";
    }
    link_message(integer snum, integer num, string str, key id)
    {
        integer silent = FALSE;
        //llSay(0,"(Scanner) got LM number " + num);
        //if (num == 2801) llOwnerSay("2Debug1 2801 str = " + str);
        
        //if (num==81400) {
        //    //format: /8slw <scriptmb> <scriptcount> <scripttime>
        //
        //    //script_memory_warn = (float)llGetSubString(str,0,llSubStringIndex(str," ") - 1) * 1000000;
        //    //script_count_warn = (integer)llGetSubString(str,llSubStringIndex(str," ") + 1,-1);
        //    list sl = llParseString2List(str,[" "],[]);
        //    script_memory_warn = -1;
        //    script_count_warn = -1;
        //    script_time_warn = -1;
        //    if (llGetListLength(sl) > 0) script_memory_warn = llList2Float(sl,0) * 1000000.0;
        //    if (llGetListLength(sl) > 1) script_count_warn = llList2Integer(sl,1);
        //    if (llGetListLength(sl) > 2) script_time_warn = llList2Float(sl,2) / 1000000.0; //entered as µs (microseconds) so we convert to seconds
        //}  

        if (num >= 2000 && num < 3000)
        {
            if (num == 2350) {
                oitext = "";
                if ((integer)str) oitext = "/i" + (string)channel;
                send_to_21sensor("oitext");
            }
            else if (num == 2360) { announceweb = (integer)str; print_status(announce);} 
            
            //os fix else if((snum = (num & 0xFFFFFFFE)) == 2010){
            else if (num == 2010 || num == 2011) {
                //these values satisfy the above condition.
                //2010 = no_attack_warning = TRUE
                //2011 = no_attack_warning = FALSE
                no_attack_warning = !(num & 1);
                print_status(announce);
            }
            else if (num == 2012 || num == 2013) {
                if(num == 2012)
                {
                    warning_message = llStringTrim(str,STRING_TRIM);
                    llSay(announce, t + "Warning message set. Showing...");
                    send_to_21sensor("wmsg");
                }
                llDialog(id,warning_message+"\nYou have " + (string)sensor_scan_timer + " seconds to leave this area.\n\nProduct: PDS 'HomeSecurity™ Orb'",["PDS Shop"],channel);
            }
            else if (num == 2014 || num == 2015) {
                if(num == 2014)
                {
                    guest_warning_message = llStringTrim(str,STRING_TRIM);
                    llSay(announce, t + "Guest/Group warning message set. Showing...");
                    send_to_21sensor("Gwmsg");
                }
                llDialog(id,guest_warning_message+"\nYou have " + (string)sensor_scan_timer + " seconds to leave this area.\n\nProduct: PDS 'HomeSecurity™ Orb'",["PDS Shop"],channel);
            }
            else if (num == 2016) {
                    script_time_monitor = !script_time_monitor;
                    send_to_21sensor("stm");
                    llWhisper(announce,t+"STMon:"+llList2String(["Off","On"],script_time_monitor));
            }
                
            else if (num == 2020) ml(81500,(string)(displayname_protection = (integer)str),"");
            
            else if (num == 2301) {
                if (str == "slt") jump x2301print;
                list sl = llParseString2List(str,[" "],[]);
                if (llGetListLength(sl) > 0 && llList2String(sl,0) != "*") script_memory_teleport = llList2Float(sl,0) * 1000000.0;
                if (llGetListLength(sl) > 1 && llList2String(sl,1) != "*") script_count_teleport = llList2Integer(sl,1);
                if (llGetListLength(sl) > 2 && llList2String(sl,2) != "*") script_time_teleport = llList2Float(sl,2) / 1000000.0; //entered as µs (microseconds) so we convert to seconds
                if (llGetListLength(sl) > 3 && llList2String(sl,3) != "*") script_time_teleport_maxcount = llList2Integer(sl,3);
                send_to_21sensor("slt");
                @x2301print;
                string smt = (string)(script_memory_teleport / 1000000.0) + "㎆, ";
                if (script_memory_teleport < 0) smt = "Ignore Memory, ";
                string sct = (string)script_count_teleport + "scripts, ";
                if (script_count_teleport < 0) sct = "Ignore Count, ";
                string stt = (string)((integer)(script_time_teleport * 1000000.0)) + "µs/frame (" +  (string)script_time_teleport_maxcount + " times)";
                if (script_time_teleport < 0) stt = "Ignore Time";
                if (id != "r") llSay(announce,t+"Script Limits, Teleport: " + smt + sct + stt); //r if from restore

            }
            else if (num == 2302) {
                //81VLog will now read ML2302 as well
                if (str == "slw") return; //jump x2302print;
                list sl = llParseString2List(str,[" "],[]);
                //script_memory_warn = -1;
                //script_count_warn = -1;
                //script_time_warn = -1;
                //script_time_warn_maxcount = 10;
                if (llGetListLength(sl) > 0 && llList2String(sl,0) != "*") script_memory_warn = llList2Float(sl,0) * 1000000.0;
                if (llGetListLength(sl) > 1 && llList2String(sl,1) != "*") script_count_warn = llList2Integer(sl,1);
                if (llGetListLength(sl) > 2 && llList2String(sl,2) != "*") script_time_warn = llList2Float(sl,2) / 1000000.0; //entered as µs (microseconds) so we convert to seconds
                if (llGetListLength(sl) > 3 && llList2String(sl,3) != "*") script_time_warn_maxcount = llList2Integer(sl,3);
                send_to_21sensor("slw");
                //@x2302print;
                //ml(81400,(string)(script_memory_warn/1000000.0) + " " + (string)script_count_warn + " " + (string)(script_time_warn * 1000000.0) + " " + (string)script_time_warn_maxcount,id);
            }
                    

            else if (num == 2450) {
                vector pos = llGetPos();
                list landlist = llGetParcelDetails(pos,[0,4]);
                if (str == "Offline") str += " " + deactivater_name;
                
                string region_uptime;
                
                if (region_start_time) {
                    float region_uptime_hours = ((float)llGetUnixTime() - region_start_time) / 3600;
                    region_uptime = (string)(region_uptime_hours / 24.0) + " days (" + (string)region_uptime_hours + " hours)";
                }
                else region_uptime = "Unknown (Greater than " + (string)(llGetTimeOfDay() / 3600) + " hours)";
                
                //string sltp = (string)(script_memory_teleport / 1000000.0) + "㎆," + (string)script_count_teleport + "scripts, " + (string)((integer)(script_time_teleport * 1000000.0)) + "µs/f";
                //if (script_count_teleport < 0) sltp = "Off";
                string smt = (string)(script_memory_teleport / 1000000.0) + "㎆, ";
                if (script_memory_teleport < 0) smt = "Ignore Memory, ";
                string sct = (string)script_count_teleport + "scripts, ";
                if (script_count_teleport < 0) sct = "Ignore Count, ";
                string stt = (string)((integer)(script_time_teleport * 1000000.0)) + "µs/frame";
                if (script_time_teleport < 0) stt = "Ignore Time";
                
                string webpage =
                    "= HOMESECURITY ORB =\nName: " + llGetObjectName() +
                    "\nDesc: " + llGetObjectDesc() +
                    "\nMode: " + sensor_state_to_words(sensor_state) +
                    ", Range: "+ sensor_range_text(sensor_range) + "\n"+
                    llList2String(["Scans/Warnings: ","Warnings off, Scans: "], no_attack_warning) + (string)sensor_scan_timer+"s " +
                    //"Auth'ed:" + (string)llGetListLength(access_list) + " Targets:" +
                    // (string)llGetListLength(targets_list) +
                    //"\nAnnounce: " + (string)announce +
                    "\nSleep: " + llList2String(["Never","When no Op","When Op seen"],sleep) +
                    ", FLS: " + llList2String(["Off","on"],foreign_land_safe) +
                    "\nUp: "+(string)up+ "m, Down: "+(string)down+ "m"+
                    "\nScript Limits TP: " + smt + sct + stt +
                    "\n\n= DISPLAY =\n" +
                    str + //contains the collection of seen avatars from 21sensor
                    "\n\n= LAND DETAILS =" +
                    "\nhttp://slurl.com/secondlife/" + llGetRegionName() + "/"
                        + (string)((integer)pos.x) + "/" + (string)((integer)pos.y) + "/" + (string)((integer)pos.z) + "/ " +
                    "\nLand Name: " + llList2String(landlist,0) +
                    //"\nLand Desc: " + llList2String(landlist,1) +
                    "\nLand Size: " + llList2String(landlist,1) +
                    "\nLand Prims: " + (string)llGetParcelPrimCount(llGetPos(),0,0) + " of " + (string)llGetParcelMaxPrims(llGetPos(),0) +
                    "\nLand URLs Free: " + (string)llGetFreeURLs() +
                    "\nRegion Name: " + llGetRegionName() +
                    "\nRegion Avatar Count: " + (string)llGetRegionAgentCount() +
                    "\nRegion Time Dilation: " + (string)llGetRegionTimeDilation() +
                    "\nRegion FPS: " + (string)llGetRegionFPS() + llList2String([""," (Idle)"],(integer)llGetEnv("region_idle")) +
                    "\nRegion Prims: " + (string)llGetParcelPrimCount(llGetPos(),0,1) + " of " + (string)llGetParcelMaxPrims(llGetPos(),1) +
                    "\n"+ region_start_time_comment +" Uptime: " + region_uptime +
                    "\nRegion Software: " + llGetEnv("sim_channel") + " " + llGetEnv("sim_version") +
                    "\n\nTimestamp: " + llGetTimestamp();
                llHTTPResponse(id, 200, webpage + "\nPage Size: " + (string)llStringLength(webpage));
                //webpage = sltp = "";
            }

            else if (num == 2801 || num == 2901 || num == 2803 || num == 2903) { //add/del in Auth/Target Lists
                //llOwnerSay("2Debug2 2 8/9 0 1/3 str = " + str);
                string tag = "Guests/Friends:"; //typically when a CSV of names are supplied which has both UPPER and lower case names together
                if (llToLower(str) == str) tag = "Guest:'";
                if (llToUpper(str) == str) tag = "Friend:'";
                //llOwnerSay("2Debug3 2 8/9 0 1/3 str = " + str);
                if (num == 2801) {
                    //if id is "f" or "g" these names are being added again do to update, do not spam the owner during update.
                    if (llStringLength((string)id) - 1) Say(announce,"Adding "+ tag + str + "'",id); //else llOwnerSay("b was:"+(string)id);
                    silent = TRUE;
                    ml(21918,str,"Added " + tag);   //add to access_list in 21sensor names
                    if (tag == "Guest:'") ml(21916,llToUpper(str),"");   //delete guest if becomes friend and vice versa
                    if (tag == "Friend:'") ml(21916,llToLower(str),""); // " "
                    num = 2903;         //delete from targets
                }
                else if (num == 2901) {
                    //if id is "t" these names are being added again due to update, do not spam the owner during update.
                    if (llStringLength((string)id) - 1) Say(announce,"Adding Target:'" + str + "'",id);
                    ml(21919,llToLower(str),"Added Target:'"); //add to target_list in 21sensor names
                    ml(21916,llToUpper(str),""); //delete if FRIEND
                    ml(21916,llToLower(str),""); //delete if guest
                    ml(1803,llToUpper(str),"t"); //remove name from Operators too, id might be "t" from loading targets from 9Backup causes silent op check
                }

                if (num == 2803) { //DELETE "str" from access list
                    if (!silent) {
                        Say(announce, "Deleting " + tag + str + "'",id); //use silent to make the text not show
                        ml(21916,str,"Deleted " + tag); //update 21sensor names
                    } else ml(21916,str,"");
                }
                else if (num == 2903) { //DELETE "str" from target list
                    if (!silent) {
                        Say(announce, "Deleting Target:'" + str + "'",id);
                        ml(21917,llToLower(str),"Deleted Target:'"); //update 21sensor names
                    } else ml(21917,llToLower(str),"");
                }
            }

            //llSay(DEBUG_CHANNEL,"scanner got command: " + (string)num + " string: " + str);
            else if (num == 2200)  {
                group_safe_string = llList2String(["/","+GS/"],(group_safe = (integer)str));
                send_to_21sensor("group_safe_string");
            }
            else if (num == 2201) {
                attack_type_name = llList2String(["Push","","TP","Eject"],(attack_type = (integer)str));
                send_to_21sensor("attack_type_name");
            }
            else if (num == 2899) {
                llSay(announce,t + "Deleting ALL visitors");
                send_to_21sensor("DelVis");
                ml(21668,"","");
            }
            else if (num == 2999) {
                llSay(announce,t + "Deleting ALL Targets");
                send_to_21sensor("DelBan");
                ml(21667,"","");
            }
            //else if (num == 2503) flags = llList2String(["FL","*"],foreign_land_safe = (integer)str) + send_to_21sensor("foreign_land_safe");
            else if (num == 2503) { foreign_land_safe = (integer)str; send_to_21sensor("foreign_land_safe"); }
            else if (num == 2504) { other_land_safe = (integer)str; send_to_21sensor("other_land_safe"); }
            //else if (num == 2400) send_to_21sensor(); //send settings and names to 21Sensor
            //needed here for when we reset scripts and scanner isnt ready but needs this
            ////////////////////////////////////// SENSOR STATE /////////////////////////////////////////
            //os fix else if ((num & 0xFFFFFFFC) == 2000){
            else if (num >= 2000 && num <= 2004) {
                //llSay(0,"scanner num 2000-2003");
                //these values satisfy the above condition.
                //2000 = off
                //2001 = scan
                //2002 = target
                //2003 = Guests
                //2004 = Friends
                sensor_state = num - 2000;
                if(sensor_state) {//is it 2000?
                    //llSay(0,"scanner sensor state = " + (string)sensor_state);
                    activate(id);
                }
                else//it is 2000, so lets
                {
                    sensor_range = 0;
                    //llOwnerSay("ScannerDebug id=" + (string)id + " name=" + llKey2Name(id));
                    //if (llKey2Name(id) != "") deactivater_name = "by " + llKey2Name(id);
                    //else if (id != NULL_KEY) deactivater_name = "by " + (string)id;
                    if (!(id == NULL_KEY || id == "")) deactivater_name = "by " + llGetUsername(id);
                    else if (llStringTrim(str,STRING_TRIM) != "") deactivater_name = str;
                    else deactivater_name = " (settings reload)";
                    //llOwnerSay(t+str+(string)id);
                    //if (deactivater_name == "") deactivater_name = " for update";
                    deactivate(FALSE);
                }
            }
                    
            else if (num==2778) input_settings(str); //"r" = restore, single letter causes silent name adding, "" = noisy
            
            //LOWER CASE IT
            str = llToLower(str);

            //else if (!ready) { /////////////////// Stop commands running that we aren't ready for ////////////////
            //    llSay(announce,t + "Not Ready yet.. ");
            //}
            ///////////////////////////////// MISC COMMANDS ///////////////////////////////////
            if (num == 2100) {
                print_status(0);
            }

            //sleep
            else if (num == 2104) {
                sleep = (integer)str;
                send_to_21sensor("no op sleep");
                print_status(announce);
                num = 2111; //show menu
            }
            
            else if (num==2106) {
                visit_im = (integer)str; //set visitor causes IM, we store here for it to be kept when upgrading
                ml(81310,str,activater_uuid); //we send this incase the Orb was already on. We also resend when it is turned on.
            }

            if (num == 2111) {
                string error = "";
                string error_button = "";
                if (attack_type && llGetOwner() != llGetLandOwnerAt(llGetPos()) && (string)id != "") { 
                    error = "\n⚠𝔼ℝℝ𝕆ℝ: HSOrb & Land: different owners!\n";
                    //llInstantMessage(id,"⚠ 𝔼ℝℝ𝕆ℝ: HSOrb & Land: different owners.\nSee this webpage which explains the error: http://psykephaeton.net/hsorb/V11/groups.html#Groups");
                }
                //string avatar_scripts_teleport = "Off";
                //string avatar_scripts_warn = avatar_scripts_teleport; //ie. off
                //if (script_count_teleport > -1) avatar_scripts_teleport = 
                //                       (string)llRound(script_memory_teleport / 1000000) + "㎆ / " + (string)script_count_teleport + " scripts";
                //if (script_count_warn > -1) avatar_scripts_warn = 
                //                       (string)llRound(script_memory_warn / 1000000) + "㎆ / " + (string)script_count_warn + " scripts";
                                
                llDialog(id,"Scanner Mode: " + sensor_state_to_words(sensor_state) + ", Range: "+sensor_range_text(sensor_range)+", " + (string)(llGetFreeMemory()/1000)+"kb" +
                    error +
                    "\nScanTimer ·· "+(string)sensor_scan_timer+"s scans" + llList2String(["/warnings",". Warnings OFF"],no_attack_warning) +
                    "\nScanRange ·· " + sensor_range_text(sensor_scan_range) + " in NoAttack mode" +
                    "\nArmedRng ·· " + sensor_range_text(sensor_weapon_range) + " in attacking modes" +
                    "\nTargets ·· to attack" +
                    "\nVisitors ·· who are safe" +
                    "\nSleep ·· is set to: " + llList2String(["Never","No Op","Op seen"],sleep) +
                    "\nVisitIM ·· Visitor causes IM to Op: " + llList2String(["Off","On"],visit_im) +
                    "\nVRange ·· Up: "+(string)up+"m Down: "+(string)down+ "m" //+
                    //"\nDispProt ·· Display Name Protection: " + llList2String(["Off","On"],displayname_protection)+
                    //"\n\nAvatar Script Limits: /"+(string)channel+"slhelp\n Warn: " + avatar_scripts_warn + 
                    //"\n TP: " + avatar_scripts_teleport
                    ,["Sleep","VisitIM","VRange","ScanRange","Targets","Visitors","SETTINGS","ScanTimer","ArmedRng","TOP MENU","Help"],channel); //"DispProt"
                // } else if (num == 2300) {
                //    if (sensor_state) {
                //        strike_string += (str + "|");
                //        llSay(announce,t + "WARNING:Striking '" + str + "'");
                //        send_to_21sensor("strike_string");
                //    } else {
                //        llSay(0,t + "Can't strike when Off");
                //    }

            } else if (num == 2310) {
                if (visible) {
                    face = llGetAlpha(0);
                    if (face == 0.0) face = 1.0; //if while visible face is 0 (transparent) then force it to be 1 (solid)
                }
                if ((visible = (integer)str)) {
                    llSetAlpha(face, ALL_SIDES);
                    if (!sensor_state) deactivate(0); else llSetText("Scanning\n.",<0.0,1.0,0.0>,1.0);
                } 
                else {
                    llSetAlpha(0.0, ALL_SIDES);
                    llSetText("",<0.0,0.0,0.0>,0.0);
                }
                send_to_21sensor("visible");
            }

            //} else if (num == 2350) {
            //    if ((integer)str) oitext = "/I" + (string)channel;
            //    else oitext = "";

            ///////////////////////////////// CONFIG COMMANDS /////////////////////////////////
            //os fix else if ((num & 0xFFFFFFFC) == 2500) { //2500-2504, Binary 00,01,10,11
            else if (num >= 2500 && num <= 2502) { //was 2500-2504 but seems not needed!!
            
                deactivater_name = "by " + llGetUsername(id);
                deactivate(1);
                if(num == 2502) {//2502
                    sensor_scan_timer = (integer)str;
                    //llOwnerSay((string)num + "|" +str);
                } else {
                    //llSay(0,"2Debug - str = " + str);
                    //Version 13 new llGetAgentList options
                    if (llGetSubString(str,0,2) == "Thi") str = "-1"; //ThisLand
                    if (llGetSubString(str,0,2) == "Lan") str = "-2"; //LandOwner's
                    if (llGetSubString(str,0,2) == "Reg") str = "-4"; //Region
                    if(num == 2501) str = "Armed Range: " + (string)((sensor_weapon_range = (integer)str)) + "m";
                    else if(num == 2500) str = "NoAttack Range: " + (string)((sensor_scan_range = (integer)str)) + "m";
                }
                send_to_21sensor("ML2500-2");
                print_status(announce);
            } else if (num==2700) { //ListNear
                    if (sensor_state) {
                        //now in (sensor) ml(5010,detected_people,id);
                        ml(21700,"",id);
                    } else { //serurity requested we (Scanner) send
                            llDialog(id,"\nHS Orb is Off\nClick [TurnOn], choose a mode,\nthen try again.",["TurnOn","TOP MENU"],channel);
                        //llSay(0,t + "ListNear failed because Offline.");
                    }
            } else if (num==2777) {
                //llListenRemove(listen_id);
                ml(9000,"2778",""); //init Backup
                ml(9001,"visible="+(string)visible,"");
                ml(9001,"face="+(string)face,"");
                ml(9001,"scan_range="+(string)sensor_scan_range,"");
                ml(9001,"armed_range="+(string)sensor_weapon_range,"");
                ml(9001,"scan_rate="+(string)sensor_scan_timer,"");
                //ml(9001,"channel="+(string)channel,"");
                ml(9001,"no_warning="+(string)no_attack_warning,"");
                ml(9001,"warning_message="+warning_message,"");
                ml(9001,"guest_warning_message="+guest_warning_message,"");
                ml(9001,"sleep="+(string)sleep,"");
                ml(9001,"announce_web="+(string)announceweb,"");
                ml(9001,"fake_op_displayname_protection="+(string)displayname_protection,"");
                ml(9001,"up="+(string)up,"");
                ml(9001,"down="+(string)down,"");
                ml(9001,"oitext="+(string)oitext,""); //only for internal not notecard
                //10for(num = -llGetListLength(targets_list);num;++num) ml(9001,"t=" + llList2String(targets_list,num),"");
                //10for(num = -llGetListLength(access_list);num;++num) ml(9001,"a=" + llList2String(access_list,num),"");
                //10ml(9001,"done","");
                ml(9001,"visit_im="+(string)visit_im,"");
                ml(9001,"script_memory_teleport="+(string)script_memory_teleport,"");
                ml(9001,"script_count_teleport="+(string)script_count_teleport,"");
                ml(9001,"script_time_teleport="+(string)script_time_teleport,"");
                ml(9001,"script_time_teleport_maxcount="+(string)script_time_teleport_maxcount,"");
                ml(9001,"script_memory_warn="+(string)script_memory_warn,"");
                ml(9001,"script_count_warn="+(string)script_count_warn,"");
                ml(9001,"script_time_warn="+(string)script_time_warn,"");
                ml(9001,"script_time_warn_maxcount="+(string)script_time_warn_maxcount,"");
                ml(9001,"script_time_monitor="+(string)script_time_monitor,"");
                ml(21100,"","");
            }

            else if (num == 2800) {
                //llSay(announce, "Listing of allowed access:");
                ml(21008,"",id);
            }
            //10access_list = llListSort(((access_list = []) + access_list),1,TRUE);
            //10ml(5000,"access," + llList2CSV(access_list),id); //(Lists) script


            else if (num == 2900) {
                //llSay(announce, "Listing of Banned People:");
                ml(21007,"",id);
            }
            //10targets_list = llListSort(((targets_list = []) + targets_list),1,TRUE);
            //10ml(5000,"targets,"+ llList2CSV(targets_list),id); //(Lists) script

            else if (num == 2650) { up = (float)str; send_to_21sensor("up"); print_status(announce); }
            else if (num == 2651) { down = (float)str; send_to_21sensor("down"); print_status(announce); }

            //=== UPDATE SENSOR IF NEEDED WITH NEW INFO ===
            //if (num < 2800) send_to_21sensor(); //tell 21Sensor its new variables -- no need we will send at turn on only!!
            //else
            //if (num >= 2900) ml(21002,llDumpList2String(targets_list,"|"),""); //tell 21Sensor its new targets
            //else if (num >= 2800) llMessageLinked(LINK_THIS,21001,llDumpList2String(access_list,"|"),""); //tell 21Sensor its new auths

        } //end ML(2***) check
    } // end Listen

    dataserver(key requested, string notecard_line_string)
    {
        if (notecard_line_string == EOF) { //loaded notecard
            ready = TRUE;
            //if (deactivater_name == "(script reset)" ) deactivater_name = "(settings reload)"; //V12
            //deactivate(1);                                                                     //V12
            //send_to_21sensor();
        } else {
                input_settings(notecard_line_string);
        }
    }
    changed(integer What) {
        //if ((What & CHANGED_REGION_START) && sensor_state) llRequestURL();
        if (What & CHANGED_REGION_START) {
            region_start_time = llGetUnixTime(); region_start_time_comment = "Region";
            if (sensor_state) llRequestURL();
        }
        if (What & CHANGED_OWNER) { activater_uuid = ""; url = ""; } //clear the old activater so the web page code doesnt spam them (or me when a sale).
    }

    http_request(key ID, string Method, string new_url) {
        if (Method == URL_REQUEST_GRANTED) {
            llReleaseURL(url); //release old URL
            url = new_url;
            //llOwnerSay("2Debug: llIM @ http_request()");
            if (activater_uuid != "" && announceweb) llInstantMessage(activater_uuid,"New web address: " + ml(81777,url,"")); //includes telling visitor script new url for twitter
        } else if (Method == URL_REQUEST_DENIED) {
                llInstantMessage(activater_uuid,"Web address denied by SL. Available URLs on this land = " + (string)llGetFreeURLs());
            ml(81777,"",""); //tell visitor script that we have no webpage (for twitter)
        } else if (Method == "GET") {
                //request list of seen avatars from 21sensors
                ml(21450,"",ID); //response will be 2XXX
            //log("From "    + llGetHTTPHeader( ID, "x-remote-ip" ) +
            //": Path: " + llGetHTTPHeader( ID, "x-path-info" ) +
            //" Query: " + llGetHTTPHeader( ID, "x-query-string")
            //);
        }
    }
} //end default()
