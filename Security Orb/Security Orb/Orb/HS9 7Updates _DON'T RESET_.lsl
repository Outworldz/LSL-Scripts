// :CATEGORY:Security
// :NAME:Security Orb
// :AUTHOR:Psyke Phaeton
// :KEYWORDS:
// :CREATED:2014-09-08 19:09:38
// :EDITED:2014-09-08
// :ID:1043
// :NUM:1648
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

string prod_id = "HSORB014.999";
//                          1         2         3         4
//                 12345678901234567890123456789012345678901234
string password = "wihcndcfpevneavoihefiuvhvkmoefvhuvdghfvuyhgv"; //only use letters!
integer announce;           //channel we announce normal messages on
key     updater_key;        //key of person requesting update info
string  latest;             //latest version number from update server
integer email_check_count;  //counts the attempts to get email so we can abort if no reply from update server
integer channel;            //channel used for menus (also used for comannds and relays in other scripts)
string upgrade_server;      //temp store the upgrade server UUID incase the Updates test fails so we can resend it.
key ch;                     //to know when we have updated and need to redraw the float text via ml(2000,"Update","")

ml(integer num, string msg, key id) {
    llMessageLinked(LINK_THIS,num,msg,id); //single prim
}

say_to_disk(string encrypt) { 
    encrypt = llXorBase64StringsCorrect(llStringToBase64(encrypt),llStringToBase64((string)llGetKey()));
    encrypt = llXorBase64StringsCorrect(llStringToBase64(encrypt), llStringToBase64(password));
    llWhisper(-777,encrypt);
}

string version() {
    return llGetSubString(prod_id,6,-1);
}    

default {
    
    state_entry()
    {
        //channel number will be triggered from Settings Script detecting CHANGE_INVENTORY
        llSetObjectDesc("v" + version() + " Channel:" + (string)channel + " HSID:" + llGetSubString(llGetKey(),-8,-1) + " psykephaeton.net");
        if (llGetObjectName() == "HomeSecurity Orb v7" || llGetObjectName() == "HomeSecurity Orb"  || llGetObjectName() == "HomeSecurity(TM) Orb") llSetObjectName("PDS HomeSecurity Orb");
        llSetTexture("PDS-HS-ORB-Logo-Texture2",ALL_SIDES);
        llSetColor(<1.0,1.0,1.0>, ALL_SIDES);
        llRotateTexture(-1.570844, ALL_SIDES);
        //ml(2000,"",llGetOwner());
        llSetRemoteScriptAccessPin(0); //turn off script importing
        if (llGetStartParameter() == -2254064855) {
            //script sent from update disk
            //llSay(DEBUG_CHANNEL,"(Updates) Updated");
            //recompiling script does not cause CHANGE_INVENTORY, therefore reget channel number
            ch = llGetNotecardLine("HomeSecurity Channel",0); 
            llGetNotecardLine("HomeSecurity Channel",1); 
            //llSay(0,"(Updates) was reset "+(string)llGetFreeMemory()+"b");
        } else {
            //script reset, or STOLEN from orb or UPDATE DISK 
            llSay(0,"Restart detected. Script deleting.");
            if (llKey2Name(llGetOwner()) != "Psyke Phaeton") llRemoveInventory(llGetScriptName()); //not psyke, delete
            ml(4000,"","");
        }
    }
    
    on_rez(integer z) {
        llSetObjectDesc("v" + version() + " Channel:" + (string)channel + " HSID:" + llGetSubString(llGetKey(),-8,-1) + " psykephaeton.net");
    }
    
    link_message(integer sender_num, integer num, string str, key id) {
        
        if (num == 2) announce = (integer)str;
        
        if (num<7000 || num>7999) return;
   
        if (num==7010) { //msg="updates"
            //////// ADD IN WHEN WE ARE DOING OTHER GRIDS ///////
            //llSay(announce,"(Updates) Detecting environment... (10 seconds)");
            //string hostname = llGetSimulatorHostname();
            //if (llGetSubString(hostname,-14,-1) != ".lindenlab.com") {
            //    llSay(0, "(Updates) Hostname: " + hostname + ". No Updates available.");
            //    return;
            //}
            updater_key = id; //used by timer
            llSay(announce,"(Security) Sending inquiry to update server... (5-60secs)");
            string encrypt = llXorBase64StringsCorrect(llStringToBase64(prod_id), llStringToBase64(str+(string)llGetKey()));
                   encrypt = llXorBase64StringsCorrect(llStringToBase64(encrypt), llStringToBase64(password));
            //llEmail(upgrade_server+"@lsl.secondlife.com",encrypt,(string)id+"\n");
            upgrade_server = str; //store incase we need to retry
            ml(6000,encrypt+"|"+(string)id,str);
            llSetTimerEvent(5);
            return;
        }
        
        if (num==7011) { //message=="=upgrade="
            llDialog(id,"\nAn update disk will be sent to you within 60 seconds.\nPlace the disk next to the HS Orb and then press (DiskReady)\n\nIf your Orb is deeded, deed the UpdateDisk first."
                                              ,["TOP MENU","DiskReady"],channel);
            llSay(announce,"(Security) Requesting update disk from update server... (15sec delay)");
            llSleep(15); //give readers time to read the popup b4 the disk is sent
            string encrypt = llXorBase64StringsCorrect(llStringToBase64("UPG:"+prod_id+"."+(string)llGetUnixTime()), llStringToBase64(str+(string)llGetKey()));
                   encrypt = llXorBase64StringsCorrect(llStringToBase64(encrypt), llStringToBase64(password));
            //llEmail(upgrade_server+"@lsl.secondlife.com",encrypt,(string)id);
            ml(6001,encrypt+"|"+(string)id,str);
            return;
        }
        
        if (num==7012) { //(message=="info") {
            llSay(announce,"(Security) Requested documentation from the update server... (15sec delay)");
            string encrypt = llXorBase64StringsCorrect(llStringToBase64("info:"+prod_id), llStringToBase64(str+(string)llGetKey()));
                   encrypt = llXorBase64StringsCorrect(llStringToBase64(encrypt), llStringToBase64(password));
            //llEmail(upgrade_server,encrypt,(string)id);
            ml(6002,encrypt+"|"+(string)id,str);
            ml(0111,"",id);
            return;
        }
                
        if (num==7013) { //& id==llGetOwner()) { //(message=="=proceed=" & id==llGetOwner()) {
            //llSay(0,"(Updates) Stopping HS Orb and initiating the update...");
            ml(2000,"",id);
            integer PIN = (integer)(llFrand(2147483646)+1); //make sure its not 0
            llSetRemoteScriptAccessPin(PIN);
            say_to_disk("update_init|"+prod_id+"|"+(string)channel+"|"+(string)PIN); //sends encrypted "HSORB007.000|8|1234567890"
            return;
        }
        
        if (num==7020) { //decrypt comms from update disk
            string msg = llBase64ToString(llXorBase64StringsCorrect(str, llStringToBase64(password)));
            msg = llBase64ToString(llXorBase64StringsCorrect(msg, llStringToBase64((string)llGetKey()))); //llGetKey() makes sure its for us
            if (llGetSubString(msg,0,4) == "link ") ml((integer)llGetSubString(msg,5,-1),"update","");
            return;
        }
        
        if (num==7021) { //send encrypted message to disk that backup is done
            integer PIN = (integer)(llFrand(2147483646)+1); //make sure its not 0
            llSetRemoteScriptAccessPin(PIN);
            say_to_disk("bkup_done|"+str+"|"+(string)PIN);
            return;
        }
         
        if (num==7022) { //send encrypted message to disk that restore is done
            say_to_disk("restore_done|"+str);
            return;
        }   
        
        if (num==7100) { //print_status
            llSay(0,"(7Updates) "+(string)llGetFreeMemory()+"b free, Update server is: " + str + " Version: " + version());
            return;
        }
        
        llSay(0,"(Updates) bad cmd: " + (string)num);
        
    } //end link_message
    
    timer() {
        //llSay(0,"(Security) Checking for update server response...");
        llGetNextEmail("",prod_id);
        email_check_count++;
        if (email_check_count > 8) {
            llSetTimerEvent(0);
            llSay(0,"(Security) No response from update server. Update check cancelled. See http://psykephaeton.net/hsorb/V12/problems.html or try again later.");
            ml(0111,"",updater_key);
            email_check_count = 0;
        }
        
    }
    
    email(string time, string address, string subj, string message, integer num_left) {
        //the timer/llGetNextEmail even has confirmed the subject is our prod_id
        email_check_count = 0; //reset email check count since we did get email
        //llInstantMessage((key)"2f3b2656-823a-4dc0-8957-63abcef49361","Message:" + message);
        latest = llList2String(llParseString2List(message,["\n"],[]),3);
        //llInstantMessage((key)"2f3b2656-823a-4dc0-8957-63abcef49361","Latest:" + latest);
        llSay(announce,"(Security) This version: " + llGetSubString(prod_id,5,-1) + ", Latest version: " + llGetSubString(latest,5,-1));
        
        if ((float)llGetSubString(latest,5,-1) > (float)llGetSubString(prod_id,5,-1)) {
            //llOwnerSay((string)updater_key);
            llDialog(updater_key,
                    "\n-=[ This version: " + llGetSubString(prod_id,5,-1) + ", Latest: " + llGetSubString(latest,5,-1) + " ]=-\n\n" +

                    "TOP MENU ·· Abandon the update\n" +
                    "DoUpdate ·· Request an Update Disk\n" +
                    "Help ·· See the latest versions Doco\n" +
                    "DiskReady ·· Use the Update Disk placed nearby"
                     ,["DoUpdate","Help","DiskReady","TOP MENU"],channel);
        
        } 
        else if ((float)llGetSubString(latest,5,-1) == 0.0) llDialog(updater_key,"\n**Update Failed**\n\nServer response invalid.\nPlease retry.",["Updates","TOP MENU"],channel);
        
        else {
            //llOwnerSay((string)updater_key);
            llDialog(updater_key,"-- You have the latest version --\n" +
                     "\nThis version is : " + llGetSubString(prod_id,5,-1) +
                     "\nLatest version is : " + llGetSubString(latest,5,-1) +
                     "\n" + llList2String(llParseString2List(message,["\n"],[]),4)
                     ,["TOP MENU"],channel);
        }            
        if (num_left == 0) llSetTimerEvent(0); // stop timer when theres no more email
    }
    
    dataserver(key requested, string notecard_line_string)
    {
        if (llGetSubString(notecard_line_string,0, 7) == "channel=")    {
            channel = (integer)llGetSubString(notecard_line_string,8,-1);
            //llSetObjectDesc("Version " + version() + ", Channel " + (string)channel + ", HSID " + llGetSubString(llGetKey(),-9,-1));
            llSetObjectDesc("v" + version() + " Channel:" + (string)channel + " HSID:" + llGetSubString(llGetKey(),-8,-1) + " psykephaeton.net");
            if (requested == ch) ml(2000,"(UpdateDisk)",""); //if I have requested the channel number then turn off orb again so we force float text update with new version/channel
            //llSay(0,"(7debug) v" + version() + " Channel:" + (string)channel + " HSID:" + llGetSubString(llGetKey(),-8,-1) + " psykephaeton.net");
        }
    }
}
