// :CATEGORY:Security
// :NAME:Security Orb
// :AUTHOR:Psyke Phaeton
// :KEYWORDS:
// :CREATED:2014-09-08 19:08:33
// :EDITED:2014-09-08
// :ID:1043
// :NUM:1639
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// A high quality Security system
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

integer visible = 1;        //visible or invisible!!
integer announce;       //channel we chatter on usually 0
integer channel;        //channel we listen to commands, menus and pings on (777 is default)
integer listen_id;      //Listen ID so we can kill it if user changes channel in notecard
integer ready;          //FALSE when still loading from notecard
integer max_ops = 40;   //max operators
list    operators_list; //list containing people who can control me
integer group_operated; //true if the HS's group can command the HS
list    relay_list;     //list of object HSIDs that can send commands
string  upgrade_server; // UUID of server ie. 7f3eba0d-3ff2-5e78-90c9-53de7c6184b1;
key     op_update_key = NULL_KEY;  //stores the key of the updater so we can send a dialog box when the update is complete
integer object_interface; //allows encrypted comms from huds and guns
string  password = "sdbdAkK3Kr44kiKuly3r4tpoI0ioIUY7Trtipoia56u7u6y6DpGG"; //password used by weapons/objects that can talk to this script
string  t = "(1Security) "; //chat prefix
string previous_message; //previous message recieved to avoid duplicates from llShout and llRegionSay
integer age_ban_end_clock; //holds UnixTime of when ageban ends, 0 = off, int max 2147483647
integer age_days_old_ban; //bellow this number of days old = ban when unixtime < age_ban_end_clock

//--copy from scanner
input_settings(string s) {
    if (s=="done") {
        //llOwnerSay(t+"settings restored.");
        //listen_id = llListen(channel,"","","");
        //ready = TRUE;
    }
    else {
        integer a = llSubStringIndex(s,"=");
        if(a > -1) //a != -1
        {
            string b = llDeleteSubString(s, a, -1);
            s = llDeleteSubString(s,0,a);
            a = (integer)s;
            if(b == "operator" || b == "o") ml(1801,s,""); //ML1801 adds op as a friend also, b is used to decide to nag or not when adding. b="o" means update so no nag on restore
            else if (b == "network" || b == "n") ml(1901,s,"");
            else if (b == "rn") ml(1901,s,"r"); //restore network relays
            else if (b == "ro") ml(1801,s,"r"); //restore operators
            else if (b == "age_ban_end_clock") age_ban_end_clock = a; //send to log after we get 'age_days_old_ban'
            else if (b == "age_days_old_ban") ml(81501,(string)(age_days_old_ban = a)+"|"+(string)age_ban_end_clock,"");
            else if (b == "group_operated") group_operated = a;
            else if (b == "object_interface") object_interface = a;
            //change old server to new server after accidental delete
            else if (b == "upgrade_server") { upgrade_server = s; if (s == "0ef46b4a-99e4-00ca-99b3-7cd0ae5e47a3") upgrade_server = "cedd82b1-e1ff-b45f-b35f-d232583c0fac"; }
            else if (b == "op_update_key") op_update_key = s;
            else if (b == "visible") visible = a;
            else if (b == "announce") {
                announce = a;
                if (op_update_key == NULL_KEY) llWhisper(0,t+"Announce channel:" +(string)a);
                ml(0002,(string)announce,""); //MENU:Set menu channel
                //print_status();
            }
            else if (b == "channel") {
                ready = ~(channel = a); //set channel and since channel wont be -1 ready will be true
                llListenRemove(listen_id);
                ml(0001,(string)channel,""); //MENU:Set menu channel
                ml(5001,(string)channel,""); //LIST:Set menu channel
                listen_id = llListen(channel,"","",""); //channel may have changed
                if (op_update_key == NULL_KEY) llWhisper(0,t+"Commands channel:" + (string)channel);
                //deactivate(FALSE);
            }
            else if (b == "twitter") ml(81222,llStringToBase64(s),""); //twitter logon in base64
        }
    }
}
//--end copy from scanner

ml(integer i, string s, key k) {
    llMessageLinked(LINK_THIS,i,s,k);
}

Say(integer announce, string message, key id) {
    llSay(announce, message);
    if (llGetAgentSize(id) != ZERO_VECTOR) llDialog(id,message,["TOP MENU","OK"],channel);
    //llSay(0,"**"+t+(string)llGetAgentSize(id)+ " " + (string)id);
}
    

//duplicate() {
//    llSay(announce,t+"Duplicate entry");
//}

string on_off(integer state_number) {
    return llList2String(["Off","ON"],state_number);
}

print_status() {
    llSay(0,
        t+(string)llGetUsedMemory()+"b Group Operated:"+on_off(group_operated)+
        " Networked:"+(string)llGetListLength(relay_list)+
        " Operators:"+(string)llGetListLength(operators_list)+
        " OI:"+on_off(object_interface)+" Channels: Announce="+(string)announce+" Commands="+(string)channel+
        " Age>"+(string)age_days_old_ban+"/UTime:"+(string)age_ban_end_clock
    );
}

relay(string command) {
    command += "|" + llGetSubString((string)llGetKey(),-8,-1);
    if (llStringLength(command) < 256) {
        llShout(channel,command); //add my HSID to the command so i know to drop this command if i see it again. cut to 255 chars
        llRegionSay(channel,command);
        //llOwnerSay("**(1D) relayed command:" + command);
    }
    else llShout(0,t+"Network path is too long, can't forward this command.");
}

advertising_menu(key id) {
    llDialog(id,"Unauthorised User\nThe HomeSecurity system is used to secure your home, shop, club or sim(s). It can Push, Teleport Home and Land Eject trouble makers. It can also be used by Groups and on Group Land. Click (PDS Shop) to visit our shop.
        \n\t\t-=[{ PSYKE'S DEFENSE SYSTEMS }]=-\n\t\t\t\t\t\tShipley (35, 231)",["PDS Shop"],channel);
}

ops_to_21sensor() {
    //integer i;
    //for(i = -llGetListLength(operators_list);i;++i) {
    //    llMessageLinked(LINK_THIS,21120,llList2String(operators_list,i),"");
    //}
    llMessageLinked(LINK_THIS,21120,llDumpList2String(operators_list,"|"),""); //estimate 30x40x2 memory = 2400bytes in 1Sec, 1200bytes in LM
}

integer valid_operator(key id, string cmd_fullname) { //UUID, "Psyke Phaeton"
    integer ok = FALSE;
    //if (llGetAgentSize(id) == <0,0,0>) return FALSE;
    //llSay(0,(string)llList2Key(llGetObjectDetails(id,[OBJECT_OWNER]),0));
    //llSay(0,(string)id);
    if (llList2Key(llGetObjectDetails(id,[OBJECT_OWNER]),0) != id) return FALSE; //if object key = object owner key it is an avatar. this works over sim borders
    if (llSameGroup(id) &&  group_operated) ok=TRUE;                 //same group(1) & group commanded(1)
    if (id == llGetOwner()) ok=TRUE;                                 //owner(1)
    //if (  (  llListFindList(  operators_list, llParseString2List(llToLower(cmd_name),[],[])  )  ) != -1 ) ok=TRUE; //controller(1)
    if (~llListFindList(operators_list,[llToUpper(cmd_fullname)])) ok=TRUE; // "Psyke Phaeton"
    if (~llListFindList(operators_list,[llToUpper(llGetUsername(id))])) ok=TRUE; // "psyke.phaeton" or "joe123"
    //llOwnerSay("1Debug: valid_op: " + (string)ok);
    return ok;
}

integer valid_relay(string id) {
    return ( llListFindList(relay_list, [llGetSubString(id,-8,-1)]) > -1 ); //message from valid HSID(1)
}

default
{
    state_entry()
    {
        ready = FALSE;
        if (llGetMemoryLimit() < 65536) llSay(DEBUG_CHANNEL,"**** Memory limit too low. Mono disabled? ****");
        
        //channel number will be triggered from Settings Script detecting CHANGE_INVENTORY -- used to be!!
        llGetNotecardLine("HomeSecurity Channel",0);
    
        if (llGetStartParameter() == -2318674858) {
            //script sent from update disk
            //llOwnerSay(t+"Updated..restoring settings");
            ml(9004,"1778","");
        } else {
                //script reset, or STOLEN from orb or UPDATE DISK
                llSay(0,"Restart detected. Script deleting.");
            if (llKey2Name(llGetOwner()) != "Psyke Phaeton") llRemoveInventory(llGetScriptName()); //not psyke, delete
            //recompiled so reset to notecard defaults
            else ml(4000,"",llGetOwner());
            //llSay(0,"1 reset");
        }
    }

    on_rez(integer x) { 
        ml(1801,llGetUsername(llGetOwner()),""); //add owner as op which will add them as auth too
        ml(8666,"",""); ml(81666,"",""); //clear logs
    }

    listen(integer channel, string cmd_fullname, key id, string message)
    {
        
        if (~llSubStringIndex(message,"¢")) {
            llInstantMessage(id,"Symbol ¢ not allowed");
            return;
        }
        
        string cmd_username = llGetUsername(id);
        string cmd_displayname = llGetDisplayName(id);
    
        if (llToLower(message)=="pds shop")      {
            llGiveInventory(id,llGetInventoryName(INVENTORY_LANDMARK, 0));
            //llSay(0,t+"Gave LandMark");
            return;
        }

        if (~llSubStringIndex(message, "|"+llGetSubString((string)llGetKey(),-8,-1))) return;  //if my key is in this command then i have seen it already

        if (llGetSubString(message,0,7) == "encrypt|") {
            //llOwnerSay(t+"got encrypted message");
            ml(7020,llGetSubString(message,8,-1),id); //send encrypted message from disk to Update Script and disks id
            return;
        }

        //HUD asked for Orb menu
        if (message == "HSMenuMe"+(string)llGetKey()) {
            message = "menu"; 
            id = llGetOwnerKey(id);
            cmd_fullname = llKey2Name(id);
            cmd_username = llGetUsername(id);
            cmd_displayname = llGetDisplayName(id);
        }

        //if allowing guns/objects to send commands then look at the avie or objects owner (an avatar is owned by the avatar conveniently)
        //check that the command is valid from a gun/object. So far we only allow Object Interface to send add target commands: oi|<encrypted:"targetTarget Name">
        if (llGetSubString(message,0,2) == "oi|") {
            if (object_interface) {
                message = llBase64ToString(llXorBase64StringsCorrect(llGetSubString(message,3,-1), llStringToBase64(password))); //decrypt encrypted target name
                message = llBase64ToString(llXorBase64StringsCorrect(message, llStringToBase64(llGetOwnerKey(id)))); //id is the gun/objects key id
                message = llBase64ToString(llXorBase64StringsCorrect(message, llStringToBase64(id)));
                //llSay(0,"idoi="+(string)id);
                id = llGetOwnerKey(id);       //change var id from the gun/object's to its owner's uuid which we then check they are operator below
                //llOwnerSay(message);
                if (llGetSubString(message,-6,-1) == "target" && (integer)message + 60 > llGetUnixTime()) {//check decrypted message is in format "<Utime><target name>target"
                    message = llGetSubString(message,10,-7);                    //remove the 'target'
                    if (llKey2Name(id) != message && llGetUsername(id) != message) //check the person being targeted doesn't own the script requesting it-stop trojans
                        if (!~llListFindList(operators_list,[message])) { //check the target isn't an operator!
                            message = "addt " + message;                       //change message to the expected format for processing below
                            cmd_fullname = llKey2Name(id);
                            cmd_username = llGetUsername(id);
                        }
                } else llSay(announce,"(Security) Invalid object_interface msg; Object: " + cmd_fullname + " Owner: " + llGetDisplayName(id) + " (" + llGetUsername(id) + ")");
            } else llShout(0,"(Security) Object_interface is disabled. To enable shout: /"+(string)channel+"oi on");
        }

        if (!valid_operator(id, cmd_fullname) && !valid_relay(id)) {
            if (!llSubStringIndex(message,"|")) {
                //if a relays message dont complain in open chat to avoid spam
                llSay(announce, t+"Unauthorised: " + cmd_displayname + " (" + cmd_fullname + "), " + (string)id);
            }
            return;
        }
        //=============================================================================
        //============ OPERATION COMMANDS MUST BE AFTER THIS!! ========================
        //=============================================================================
        
        //strip icon and space from front if present.
        string message_original = message; //we send this to 0Menu below (ML112) so it keeps the symbol,space,command format
        if (llGetSubString(message,1,1) == " ") message = llGetSubString(message,2,-1);

        string logmessage = message; //default log_message as message then trim if it is a networked command
        //llOwnerSay("**(1D) message='"+message+"'");
        if (llGetAgentSize(id) == ZERO_VECTOR) {
            integer pipe = llSubStringIndex(message,"|");
        
            if (llSubStringIndex(message,"=") > -1) { 
                //from a prim ie networked Orb and includes "command=avatar name|hsid"- disaalow from avatars forging the command

                //cmd_name = name of avatar operator
                //message = command they sent
                //id & remoteop_key = uuid of the operator avatar

                //OLD VERSION "command=Avatar name0000000-0000-0000-0000-000000000000|HSIDHSID|HSIDHSID..."
                integer equals = llSubStringIndex(message,"=");

                logmessage = llGetSubString(message,0,equals - 1);
                //key remoteop_key = (key)llGetSubString(message,-45,-10);
                id = (key)llGetSubString(message,pipe - 36, pipe - 1);
                //cmd_name = "Avatar Name@HSIDHSID"
                cmd_username = llGetSubString(message,equals + 1,pipe - 37) + "@" + llGetSubString(message,pipe + 1, pipe + 8);
                //llOwnerSay("**(1D) remoteop_key:"+(string)id); //remoteop_key);
                //8300 link message log format: ⇋Avatar Name: message, id of avatar
            }
            else if (llSubStringIndex(message,"|") > -1) {
                logmessage = llGetSubString(message,0,pipe - 1); ///8add/8del avatar name relayed messages, chop off |HDID...
                //cmd_name = "#"+llGetSubString(message,pipe + 1, pipe + 8); //make name the HSID of the original Orb
                cmd_username = "HSID #"+llGetSubString(message,-8, -1); //make name the HSID of the Orb who send this to us (not origin but last)
            } else { logmessage = message; cmd_username = cmd_fullname; }
        }

        //llOwnerSay("**(1D) id=" + (string)id);
        //llOwnerSay("**(1D) cmd_name:" + cmd_name);

        // ignore duplicate messages
        if (message == previous_message && llSubStringIndex(message,"|") > -1) return; //same as previous and networked message
        previous_message = message;

        //log the command
        ml(8300,cmd_username + ": "+logmessage,id);
        //llOwnerSay("**(1D) log entry:" + cmd_name + ": "+logmessage);
        logmessage=""; //save space
            

        //--------------------------------------------------
        // Commands that can run while in Not Ready state
        //--------------------------------------------------

        if (message == "reset") { //might be needed when recompiled (and therefore ready=FALSE) to load default settings
            ml(4000,"",id); //Settings:Clear All Lists in All Scripts then Load Settings Card
            ml(81501,"-1|0|nomenu",id); age_days_old_ban = -1; age_ban_end_clock = 0; //reset age ban
            return;
        }

        //upgrade menus -- might be in not ready state due to failed update
        if (llToLower(message)=="updates")   { ml(7010,upgrade_server,id); return; }
        if (llToLower(message)=="doupdate" || llToLower(message)=="=upgrade=") { ml(7011,upgrade_server,id); return; }
        if (llToLower(message)=="help" || llToLower(message)=="doco")      {
            string url = "http://psykephaeton.net/hsorb/V14/";
            llInstantMessage(id,"Online Help: " + url);
            llLoadURL(id, "Show web based PDS HomeSecurity™ Orb Documentation?", url);
            url = "";
            return;
        }
        // pre HTML { ml(7012,upgrade_server,id); return; }
        if (llToLower(message)=="diskready") { //& id==llGetOwner()) {
            //llOwnerSay(t+"--- UPDATE STARTING ---");
            //ready=FALSE;
            op_update_key = id; //save the update requestors key so we can lldialog him when its done.
            ml(7013,upgrade_server,id);
            return;
        }

        //---------------------------------------------------
        //    Settings loaded, ready for the command?
        //---------------------------------------------------
        //if (!ready) { llSay(0,t+"Not initialised yet..."); return; }        //still loading

        string relay_message = message; //save the relay message with UUIDs so we can pass it on to other HS devices
        integer j;
        if (~(j = llSubStringIndex(relay_message,"|"))) message = llGetSubString(relay_message,0,--j); //strip |HSIDs off the end if found

        //case sensitive
        if (llGetSubString(message,0,4)=="amsg ") ml(3506,llGetSubString(relay_message,5,-1),id); //set attack message
        if (llGetSubString(message,0,4)=="dmsg ") ml(3509,llGetSubString(relay_message,5,-1),id); //set attack message
        if (llGetSubString(message,0,4)=="wmsg ") ml(2012,llGetSubString(relay_message,5,-1),id); //set warning message
        if (llGetSubString(message,0,5)=="gwmsg ") ml(2014,llGetSubString(relay_message,6,-1),id); //set warning message
        
        //////////////////////////////// DATABASE COMMANDS ///////////////////////////////////////////
        //RELAY, NO MENU
        
        string msg4 = llGetSubString(message,0,4);
        string msg3 = llGetSubString(message,0,3);
        integer name_start = 5;
        if (msg3 == "del ") name_start = 4;
                
        //guests are stored as lower case in the access_list, friends stored as UPPERCASE

        if (llSubStringIndex(message,"  ") == -1 && !(llGetSubString(message,-1,-1) == " ")) { //dont accept extra spaces on /8add*
            if (msg4 == "addf ") { ml(2801,llToUpper(llGetSubString(message,5,-1)),id); relay(relay_message); return; }
            if (msg4 == "addg " || msg4 == "adda ") { ml(2801,llToLower(llGetSubString(message,5,-1)),id); relay(relay_message); return; }
            if (msg4 == "addn ") { ml(1901,llGetSubString(message,5,-1),id); return; }
            if (msg4 == "addt ") { ml(2901,llGetSubString(message,5,-1),id); relay(relay_message); return; }
            if (msg4 == "addo ") { ml(1801,llGetSubString(message,5,-1),id); relay(relay_message); return; }
        }
        if (msg4 == "delf " || msg3 == "del ") { ml(2803,llToUpper(llGetSubString(message,name_start,-1)),id); relay(relay_message); }
        if (msg4 == "delg " || msg4 == "dela " || msg3 == "del ") { ml(2803,llToLower(llGetSubString(message,name_start,-1)),id); relay(relay_message); }
        if (msg4 == "delo " || msg3 == "del ") { ml(1803,llGetSubString(message,name_start,-1),id); relay(relay_message); return; }
        if (msg4 == "deln ") { ml(1903,llGetSubString(message,5,-1),id); return; }
        if (msg4 == "delt ") { ml(2903,llGetSubString(message,5,-1),id); relay(relay_message); return; }
        
        if (llGetSubString(message,0,2) == "lb " || llGetSubString(message,0,2) == "tp ") {
            if (llOverMyLand(llGetKey())) {
                string details = llGetSubString(message,3,-1);
                integer space = llSubStringIndex(details," ");
                float hours = (float)llGetSubString(details,0,(space - 1));
                if (llGetSubString(message,0,2) == "tp ") hours = -1.0;
                details = llGetSubString(details,++space,-1);
            
                if (llSubStringIndex(details,"-") == 8 && llStringLength(details) == 36) {
                    string dname = llGetDisplayName(details);
                    if (dname == "") dname = llKey2Name(details);
                    string name = dname + " (" + llGetUsername(details) + ")";
                    
                    string status = "x"; //ban failed for log
                    if (hours == -1.0) { 
                        llInstantMessage(id,t+"TP Home: " + name);
                        llTeleportAgentHome((key)details); 
                        ml(81303,"T"+ name,details); // "T " means tp'ed by op
                    } // tp success for log
                    else { 
                        llInstantMessage(id,t+(string)hours+"hrs ban: " + name);
                        llAddToLandBanList((key)details,hours); 
                        ml(81303,"B"+ name + " " + llGetSubString((string)hours,0,5) + "hrs",details); // "B " means banned
                    }// ban success for log
                
                } else {
                    ml(21915,(string)hours + "|" + details,id);
                    llInstantMessage(id,t+"Scanning for: "+ details);
                }
            } else llInstantMessage(id,t+"Ban/TP failed. Land/Orb different owners");
            relay(relay_message); return;
        }

        //////////////////////////////////////////////////////////////////////////////////////////////////

        message = llToLower(message);
        //below not case sensitive

        if (llGetSubString(message,0,2)=="slt") ml(2301,llGetSubString(message,4,-1),""); //networked - region level effect
        if (llGetSubString(message,0,2)=="slw") ml(2302,llGetSubString(message,4,-1),""); //llList2String(l,3) + " " + llList2String(l,4),""); //SL will make 3 or 4 blank if they dont exist :)
        
        if (message=="slhelp") { 
            llSay(announce,"Warn or Teleport Home avatars that exceed certain script attachment limits. See http://psykephaeton.net/hsorb/V14/commands.html#Script_Limits");
            return; 
        }
        if (message=="rdid") { ml(4100,"",""); return;} //cause rdid to be sent by settings

        if (llGetSubString(message,0,6) == "server ") { upgrade_server = llGetSubString(message,7,-1); return; }

        if (message=="amsg") { ml(3507,"",id); return;}//show attack message
        if (message=="dmsg") { ml(3509,"",id); return;} //show warning message
        if (message=="wmsg") { ml(2013,"",id); return;} //show warning message
        if (message=="gwmsg") { ml(2015,"",id); return;} //show warning message

        if (message=="warn off") { ml(2010,"",""); return; }
        if (message=="warn on") { ml(2011,"",""); return; }

        if (message=="delta" || message=="deltv") { ml(2899,"",""); ml(2999,"",""); return;}
        if (message=="delop") {ml(1899,"",""); llSay(announce,t+"Deleting ALL Operators"); ml(1801,llGetUsername(id),id); return;}
        if (message=="delnr") {ml(1999,"",""); llSay(announce,t+"Deleting ALL Networks"); return;}
        
        if (llGetSubString(message,0,7) == "bantime=") { ml(3801,llGetSubString(message,8,-1),""); relay(relay_message); return; }

        //integer x = llSubStringIndex(message,"|");
        //if (x > -1) { //ie. a pipe(|) symbol was found
        //    x--;      //then strip off from the pipe onwards to remove UUIDs
        //    message = llGetSubString(message,0,x); //strip ",UUID,UUID,..." from message if comma found in message.
        //}

        ///////////////////////////////// MISC COMMANDS ///////////////////////////////////
        //NO RELAY, NO MENU
        //if (message == "help") {
        //    llSay(0, t+"Click me for menus. Commands: /<channel> [add|del][t|a|o|n] <entry>, reset, status, uuid, v[isible], warn [on|off]");
        //    return;
        //}
        //if (message=="doco")          { llGiveInventory(id,llGetInventoryName(7, 0)); return; }

        if (message == "visible" || message == "v") {
            visible = !visible;
            ml(2310,(string)visible,id); //Scanner:Toggle Visible
            return;
        }
        if (llGetSubString(message,0,2)=="up=") //{
            ml(2650,llGetSubString(message,3,-1),"");
        //llSay(0,"(Security) Upward attack range is: " + llGetSubString(message,3,-1) + "m");
        //}
        if (llGetSubString(message,0,4)=="down=") //{
            ml(2651,llGetSubString(message,5,-1),"");
        //llSay(0,"(Security) Downward attack range is: " + llGetSubString(message,5,-1) + "m");
        //}
        if (message == "oi on") {
            object_interface = TRUE;
            //llSay(0,"(Security) ** WARNING ** object_interface enabled.");
            ml(2350,"1","");
            print_status();
        }
        if (message == "oi off") {
            object_interface = FALSE;
            ml(2350,"0","");
            print_status();
        }
        if (message == "web on") ml(2360,"1","");
        if (message == "web off") ml(2360,"0","");

        if (llGetSubString(message,0,3) == "age ") { // /8age days_old [hours]
            list tl = llParseString2List(message,[" "],[]);
            if (llToLower(llList2String(tl,1)) == "off") { ml(81501,"-1|0",id); age_days_old_ban = -1; age_ban_end_clock = 0; }
            else if (llList2Float(tl,2) == 0) ml(81501,(string)(age_days_old_ban = llList2Integer(tl,1)) +"|"+ (string)(age_ban_end_clock = 0x7FFFFFFF),id); //no [hours], ie 2038
            else ml(81501,(string)(age_days_old_ban = llList2Integer(tl,1)) +"|"+ (string)(age_ban_end_clock = (integer)(llGetUnixTime() + (llList2Float(tl,2) * 3600.0))) ,id); //days old|UnixTime ban setting expires
            ml(81304,"  Age>" + (string)age_days_old_ban + " Rescaning everyone. Orb Friends safe.",id);
            //llSay(0,"Current Unix Time: " + (string)llGetUnixTime());
            //llSay(0,"(1D) " + llList2String(tl,1) +"|"+ (string)(llGetUnixTime() + (llList2Float(tl,2) * 3600.0)));
        }

        if (message == "status") {
            ml(0100,"","");   //menus
            print_status();   //security
            ml(2100,"","");   //scanner
            ml(3100,"","");   //weapon
            ml(4100,"","");   //settings
            ml(5100,"","");   //lists
            ml(6100,"","");   //email
            ml(7100,upgrade_server,"");   //updates
            //ml(8110,"","");   //auth db
            //ml(8210,"","");   //target db
            ml(9100,"","");   //backup
            return;
        }

        if (message == "hsid") { llInstantMessage(id,
                                    t+"Position: " + (string)llGetPos() + 
                                    ", HSID: " + llGetSubString((string)llGetKey(),-8,-1) + 
                                    ", Distance: " + (string)( 
                                        llVecDist(
                                            llGetPos(),llList2Vector(
                                                llGetObjectDetails(id,[OBJECT_POS]),0
                                            )
                                        )
                                    ) + "m"
                                ) ; return; }
        if (message == "listnear") { ml(2700,"",id); return; }


        /////////////////// MENUS/COMMANDS THAT WE REDIRECT TO SCRIPTS OTHER THAN MENU ///////////////////
        if (message=="operators")  {
            operators_list = llListSort(operators_list,1,TRUE);
            ml(5900,"operators",""); //clear 50List
            //ml(5901,"operators," + llList2CSV( llList2List(operators_list,0,(max_ops/2) - 1) ),""); //add first 10 ops
            //if (llGetListLength(operators_list) > (max_ops/2)) ml(5901,llList2CSV( llList2List(operators_list,(max_ops/2),max_ops) ),""); //add ops 10-20
            llMessageLinked(LINK_THIS,5901,"","");
            integer i;
            for (i=0;i < llGetListLength(operators_list); i += 5) llMessageLinked(LINK_THIS,5901,llList2CSV( llList2List(operators_list,i,i+4) ),"");
            ml(5000,"",id); //signal completed
            return;
        }
        if (message=="network")    { ml(5900,"network",""); ml(5901,"," + llList2CSV(relay_list),""); ml(5000,"",id); return; }
        if (message=="visitors") { ml(2800,"",id); return; }
        if (message=="targets")    { ml(2900,"",id); return; }

        if (message == "prev page") { ml(5004,"",id); return; } //(List) menu:Prev Page
        if (message == "next page") { ml(5005,"",id); return; } //(List) menu:Next Page
        if (llGetSubString(message,0,6) == "delete ") { ml(5003,llGetSubString(message,7,-1),id); return; } //tell List which Delete button was pushed

        if (llGetSubString(message,0,6)=="select ")    { ml(5011,llGetSubString(message,7,-1),id); return; } //tell Nearby List which Change button was pushed

        if (llGetSubString(message,0,6)=="target ")    { ml(5015,message,id); return; } //
        //if (llGetSubString(message,0,4)=="auth ")      { ml(5015,message,id); return; } // return back to lists
        if (llGetSubString(message,0,5)=="guest ")      { ml(5015,message,id); return; } // return back to lists
        if (llGetSubString(message,0,6)=="friend ")      { ml(5015,message,id); return; } // return back to lists
        if (llGetSubString(message,0,4)=="oper ")      { ml(5015,message,id); return; } // the button pressed in
        //if (llGetSubString(message,0,6)=="strike " )   { ml(5015,message,id); return; } // ListNear/Change X/<button>

 //send change status messages - 
        //if (llGetSubString(message,0,6)=="turnoff" | message=="off") 
        //    relay("turnoff="+llKey2Name(id))+(string)id);
        //if (llGetSubString(message,0,7)=="noattack" | llGetSubString(message,0,5)=="public" | llGetSubString(message,0,5)=="guests" | llGetSubString(message,0,6)=="friends")
        //    relay(relay_message+"="+llKey2Name(id))+(string)id); //relay the Op UUID!
        
        //normal local op status change causes network message with operator data
        if (message=="turnoff" | message=="off") relay("turnoff="+llKey2Name(id)+(string)id);
        if (message=="noattack" | message=="public" | message=="guests" | message=="friends") relay(relay_message+"="+llKey2Name(id)+(string)id); //relay the Op UUID!
        //remote op messages with command=avatar nameUUID|HSID are relayed without change
        if (llSubStringIndex(message_original,"|") > -1) relay(relay_message); 
        //llOwnerSay("(1D) message:" + message);
        //llOwnerSay("(1D) relay_message:" + relay_message);
        //llOwnerSay("(1D) message_original:" + message_original);
        //llOwnerSay("(1D) message_original:" + message_original);

        //if (message=="log") { ml(8301,"",""); return; }
        //if (message=="vlog") { ml(81301,"",""); return; }

        if (message=="sendta" || message=="sendtv") { ml(21998,"",""); return; }
        if (message=="sendo") {
            integer j;
            for  (j = llGetListLength(operators_list) + 1; j > 0; --j) llRegionSay(channel,"addo " + llList2String(operators_list,(j - 1)));
            llSay(announce,t + "Send complete");
        }

        //if none of the above is triggered then we assume its text from a menu button
        ///llSay(0,"Button pressed was: '" + message + "'");
        ml(0112,message_original,id);
        /////////////////////////////////////////////////////////////////////////////////////////////////////

    } // end Listen

    touch_start(integer total_number)
    {
        //if (!ready) { llSay(0,t+"Not initialised yet..."); return; }
        //llSay(0,t + "If you do not see a menu read and vote here: http://jira.secondlife.com/browse/SVC-1815");
        //if (llGetOwner() != llGetLandOwnerAt(llGetPos())) llDialog(llDetectedKey(0),"USER ERROR: HomeSecurity Orb owner must be the same as the lands owner",[],-99999);

//        if (   llDetectedKey(0)==llGetOwner()
//            ||
//            (llSameGroup(llDetectedKey(0)) && group_operated)
//                ||
//            (  (  llListFindList(  operators_list, llParseString2List(llToLower(llDetectedName(0)),[],[])  )  ) != -1 )
//                )
//
//
//                {
//                    ml(0111,"",llDetectedKey(0)); //Menu:Load Main Menu
//                } else advertising_menu(llDetectedKey(0));

        if (valid_operator(llDetectedKey(0), llKey2Name(llDetectedKey(0)))) ml(0111,"",llDetectedKey(0)); //Menu:Load Main Menu
        else advertising_menu(llDetectedKey(0));

    }

    link_message(integer sender, integer num, string str, key id) {
        
        //llSay(0,t+"got msg link number: " + (string)num + " with key id: " + (string)id);

        if (num == 4000) ready = FALSE; // if call to Settings to reset the script is heard set ready off.
        // This will allow other data requests to be ignored, after we are ready

        if (num < 1000 || num > 1999) return; //not for me :)

        //integer opos;
        //integer rpos;
        //if (num == 1801 || num == 1803 || num == 1901 || num == 1903) { //add/del in operator/relay Lists (no need to check!)
        integer opos = llListFindList(  operators_list, [llToUpper(str)]); //llParseString2List(str,[],[]  )  );
        integer rpos = llListFindList(  relay_list, [llToLower(str)]); //llParseString2List(str,[],[]  )  );
        //}

        if (num == 1801) {
            if (~opos) Say(announce,t+"Already Operator",id);
            else {
                if (llGetListLength(operators_list) > max_ops) { llSay(announce, t+"Full, remove some Operators"); return; }
                //if (llGetUsedMemory() > 55000) { Say(announce, t+"Full. Remove some Operators (or Networks)",id); return; }
                operators_list += llCSV2List(llToUpper(str)); // + operators_list;
                //if (op_update_key == NULL_KEY)
                //id carries "r" or "operator". "r" means restore, and we dont nag during restore.
                if (llStringLength((string)id) - 1) {
                    Say(announce,t+"Added Operator:'" + llToUpper(str) + "' Free:" + (string)(65536 - llGetUsedMemory()),id); //only say if not updating
                    ml(2801,llToUpper(str),"o"); //add to friend, "o" means do not nag in ML2801
                }
            }
            ops_to_21sensor();
        }

        else if (num == 1901) { // add name to Relay List
            if (~rpos)  Say(announce,t+"Already Networked",id);
            else {
                //if (llGetListLength(relay_list) > 9) { llSay(announce, t+"Full, remove some NetworkRelays"); return; }
                if (llGetUsedMemory() > 55000) { Say(announce, t+"Full, remove some Operators (or Networks)",id); return; }
                relay_list += llCSV2List(llToLower(str));
                //if (op_update_key == NULL_KEY)
                if (llStringLength(id) - 1) Say(announce,t+"Added Network:'" + str + "' Free:" + (string)(65536 - llGetUsedMemory()),id); //only say if not updating
            }
        }

        else if (num == 1803) { //DELETE "str" from op list
            if (~opos) {
                //--- is op -- no nag if 
                if (llGetListLength(operators_list) > 1) {
                    Say(announce,t+"Deleted Operator:'" + llToUpper(str) + "'",id);
                    operators_list = llDeleteSubList(operators_list, opos, opos);
                }
                else Say(announce,t+"One Operator left. Delete disallowed.",id);
            } else  if ((string)id != "t") Say(announce,t+"Not an Operator:'" + llToUpper(str) + "'",id); //"t" means update is happening so dont spam
            ops_to_21sensor();

        }

        else if (num == 1903) { //DELETE "str" from relay list
            if (~rpos) {
                //--- is relay
                Say(announce,t+"Deleted Network:'" + str + "'",id);
                relay_list = llDeleteSubList(relay_list, rpos, rpos);
            } else Say(announce,t+"Not a Relay:'" + str + "'",id);
        }

        else if (num == 1899)   //clear Operator Lists
            operators_list = [];
        //if (!(integer)str) llSay(0,t+"Operator's"); //str = "1" means no printed message

        else if (num == 1999) //clear Relay Lists
            relay_list = [];
        //if (!(integer)str) llSay(0,t+"Relay List has been cleared."); //str = "1" means no printed message

        else if (num==1777) {
            //llOwnerSay(t+"starting my backup");
            //llListenRemove(listen_id);
            //ready=0;
            //llSay(announce,t+"Backing up...(1min)");
            ml(9000,"1778",""); //init Backup
            ml(9001,"visible="+(string)visible,"");
            ml(9001,"group_operated="+(string)group_operated,"");
            ml(9001,"object_interface="+(string)object_interface,"");
            ml(9001,"upgrade_server="+upgrade_server,"");
            ml(9001,"op_update_key="+(string)op_update_key,""); //save also who requested update so we can lldialog back after
            ml(9001,"age_ban_end_clock="+(string)age_ban_end_clock,""); //holds UnixTime of when ageban ends, 0 = off, int max 2147483647. B4 'age_days_old_ban'
            ml(9001,"age_days_old_ban="+(string)age_days_old_ban,""); //bellow this number of days old = ban when unixtime < age_ban_end_clock. after above 

            //
            //integer c=0;
            //for (c=0; c<llGetListLength(operators_list); c++) ml(9001,"o="+llList2String(operators_list,c),"");
            //
            integer i;
            integer l;
            for (i=0;i < llGetListLength(operators_list); i += 7) {
                llMessageLinked(LINK_THIS,9001,"ro="+llList2CSV( llList2List(operators_list,i,i+6) ),""); //rv = restore visitors silently
                l = llGetListLength(operators_list) - i;
                if (i % 30 == 29) llSay(announce,t + "Backup Operators:" + (string)l + " to go (" + (string)(l/7) + "s)"); //420 = 7 items * 60 seconds
                llSleep(1);
            }
            
            //        
            //c=0;
            //for (c=0; c<llGetListLength(relay_list); c++) ml(9001,"n="+llList2String(relay_list,c),"");
            //
            for (i=0;i < llGetListLength(relay_list); i += 7) {
                llMessageLinked(LINK_THIS,9001,"rn="+llList2CSV( llList2List(relay_list,i,i+6) ),""); //rv = restore visitors silently
                l = llGetListLength(relay_list) - i;
                if (i % 30 == 29) llSay(announce,t + "Backup Relays:" + (string)l + " to go (" + (string)(l/7) + "s)"); //420 = 7 items * 60 seconds
                llSleep(1);
            }
            
            ops_to_21sensor(); //why is this here? leave it anyway
            ml(9001,"channel="+(string)channel,"");//added 11/5/2013 to fix freeze when 1security updates, enables lllisten
            ml(9001,"done","");
            //llOwnerSay(t+"completed my backup");
        }
        else if (num==1778) input_settings(str);

        else if (num==1779) {
            //llDialog(op_update_key,"\nUpdate ended.",["TOP MENU"],channel);
            //llOwnerSay(t+"--- UPDATE ENDED ---");
            op_update_key = NULL_KEY; //..and also use to allow channel change and op/net to announce again
            ready=TRUE;
        }

        ////////////////////////////////////////////////////////////
        //BELLOW COMMANDS CAN'T RUN WHEN WE ARE FLAGGED NOT READY //
        ////////////////////////////////////////////////////////////
        else if (!ready) llSay(0,t+"Not ready. To force ready type: /" + (string)channel + "reset");

        else if (num == 1100) print_status();

        else if (num == 1205) ops_to_21sensor(); //21sensor asks for the operators list after upgrading

        else if (num == 1111) {
            llDialog(id,"SETTINGS / Security" +
                "\nOperators ·· "+(string)llGetListLength(operators_list)+ " operators" +
                "\nGroup Op ·· Group Operation is "+on_off(group_operated)+
                "\nNetwork ·· "+(string)llGetListLength(relay_list)+ " networked to me" +
                "\nComms channel: " + (string)channel + ", OI: " + on_off(object_interface)
                    ,["Operators","GroupOp","Network","SETTINGS","TOP MENU"],channel);
        }

        else if (num == 1500) { //set group status
            group_operated = (integer)str;
            print_status();
        }

        //llSay(0,t+"Invalid cmd: " + (string)num);
    }

    dataserver(key requested, string notecard_line_string)
    {
        if (notecard_line_string != EOF) input_settings(notecard_line_string);
        //else print_status();
        ready=TRUE;
    }

} //end default()
