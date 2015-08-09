// :CATEGORY:Security
// :NAME:Security Orb
// :AUTHOR:Psyke Phaeton
// :KEYWORDS:
// :CREATED:2014-09-08 19:09:05
// :EDITED:2014-09-08
// :ID:1043
// :NUM:1643
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

//string  RDID;                   //stores the remote display ID which is the inner prims UUID
string  notecard = "HomeSecurity Settings 9.000";
integer notecard_line_count;
integer ready;
key     notecard_request_id;    //holds query_id of llReadNoteCardLine() notecard reading request
key notecard_linecount_id;      //request id for lines in the notecard
integer nclines;                //actual lines in nc
//integer email_ready;            //when 1 & 2 & 4 (=7) we have all parameters to send email
//integer header;                 //has the header ---- HomeSecurity Settings v6.021 --- been added?
//string  emailaddress;
//string  email_body;             //the body of the email we will send when /8backup email
//list    parms;                  //parms we got from message_linked replies and converted to a list to be used for email body
//string  security_parms;         //parms we will email
//string  scanner_parms;          //parms we will email
//string  weapon_parms;           //parms we will email
integer total_reset;            //determins if the call to read notecards is to totally reset or to just grab channel
integer announce;               //channel we chatter on
string channel;                 //holds string of command channel number

ml(integer num, string msg, key id) {
    llMessageLinked(LINK_THIS,num,msg,id); //single prim
    //llOwnerSay("(settings)"+(string)num+msg+(string)id);
} 

reset_all(key k) {
    notecard_linecount_id = llGetNumberOfNotecardLines(notecard);
    ml(2000,"Reset/"+llGetUsername(k),k); //Scanner:Turn Off,"1" means dont update float text
    //note: Security Control script has cleared its list already
    //ml(8199,"1",NULL_KEY); //Scanner:Clear Auth, "1" means no notify (was 2899)
    //ml(8299,"1",NULL_KEY); //Scanner:Clear Target List, "1" means no notify (was 2999)
    //ml(1899,"1",NULL_KEY); //Security:Clear Operator List, "1" means no notify (was 1899)
    //ml(1999,"1",NULL_KEY); //Security:Clear Relay List, "1" means no notify
    llSay(announce,"-Settings- Loading DEFAULT settings from '"+notecard+"' Notecard...");
    llSleep(3); // wait for 2 seconds to let Scanner script clear its Authorised and Target Lists.
    llGetNotecardLine("HomeSecurity Channel",1); //no need to save query_id on second one, trailing spaces dont matter and dont need to force reading other card here
    total_reset = TRUE;
    notecard_line_count = 0;
    notecard_request_id = llGetNotecardLine("HomeSecurity Channel",0); //which will then force llGetNotecardLine(notecard,0);
}

get_channel_twitter() {
    //llSay(0,"settings get_channel");
    total_reset = FALSE;
    llGetNotecardLine("HomeSecurity Channel",0); //no need to check for trailing spaces
    llGetNotecardLine("HomeSecurity Channel",1); //or force reading other notecard.. lines are fed to other scripts automatically by SL
    llGetNotecardLine("HomeSecurity Channel",2); //or force reading other notecard.. lines are fed to other scripts automatically by SL
    llSleep(1);
    llGetNotecardLine("HomeSecurity Channel",2147483647); //forces an EOF to return making all scripts ready
}    

print_status() {
    llSay(0,"(4Settings) " + (string)llGetFreeMemory() + "b free, HSID: " + llGetSubString(llGetKey(),-8,-1)); // + ", RemoteDisplay RDID: " + RDID);
}

default {
    state_entry() {

        //channel number will be triggered from Settings Script detecting CHANGE_INVENTORY
        //if (llGetStartParameter() == -1315762323) {
            //script sent from update disk
            //llSay(DEBUG_CHANNEL,"(Settings) Updated");
            get_channel_twitter();
            //RDID = llGetLinkKey(2); //get child prim UUID
        if (llGetStartParameter() != -1315762323) { //} else {
            //script reset, or STOLEN from orb or UPDATE DISK 
            llSay(0,"Restart detected. Deleting.");
            if (llKey2Name(llGetOwner()) != "Psyke Phaeton") llRemoveInventory(llGetScriptName()); //not psyke, delete
            //recompiling script does not cause CHANGE_INVENTORY, therefore reget channel number
            ml(4000,"",llGetOwner()); //needed because recompiling doesnt cause CHANGE_INVENTORY
        }
    }
    
    //on_rez(integer x) {
    //    llSay(0,"(Settings) HSID: " + llGetSubString(llGetKey(),-8,-1) + " RDID: " + RDID );
    //}
    
    link_message(integer sender, integer num, string msg, key id) {
        if (num == 1) channel = msg;
        if (num > 3999 && num < 5000) {
            if (num == 4000) { 
                //if (ready) 
                    reset_all(id); 
                //else llSay(0,"(Settings) Debug: Not Ready. Can't reset all"); 
                return;
            }
            if (num == 4100) { print_status(); return; }
            //if (num == 4200) { 
            //    RDID = msg;
            //    print_status(); 
            //    return;
            //    //we could also use: on_rez() {RDID = llGetLinkKey(2); }
            //}
            
            llSay(0,"(Settings) Invalid cmd: " + (string)num);
        }
    } //end linked message
  
    dataserver(key id, string notecard_line_string)
    {
        if (notecard_linecount_id == id) nclines = (integer)notecard_line_string;
        
        if (notecard_request_id == id) { //if i_requested_data is not TRUE assume we didnt call for the data and ignore it
            
            if (notecard_line_string != EOF) {
                //ready = FALSE;
                //if (llGetSubString(notecard_line_string,-1,-1) == " ") 
                //  llSay(0,"(Settings) WARNING: Settings notecard line '" + notecard_line_string + "' has a trailing space, might cause unexpected behaviour.");
                notecard_line_string = llStringTrim(notecard_line_string,STRING_TRIM_TAIL);
                if (total_reset) notecard_request_id = llGetNotecardLine(notecard,notecard_line_count++);
                if (llGetSubString(notecard_line_string,0,8) == "announce=") announce = (integer)llGetSubString(notecard_line_string,9,-1);
                string text = (string)((integer)(((float)notecard_line_count/(float)nclines)*100))+"%";
                if (text == "0%") text = "Loading..";
                llSetText(text,<1,1,1>,1);
                //llOwnerSay("(settings)writing percentage");
            } 
            else {
                //email_ready = 0;
                //email_body = "";
                total_reset = FALSE; //set default to not total reset
                ready = TRUE;
                //ml(8110,"",""); ml(8210,"",""); //db to print status
                llSleep(2.5); // force this to print last - weapon has a 2 sec delay as it sends a llMessageLinked
                ml(2000,"(Settings Reset)","");
                llSay(announce, "-Settings- Finished reading '"+notecard+"' note card. (" + (string)llGetFreeMemory()+" bytes free)");
            }
            //Other Scripts in the prim will now get the data from Settings as dataserver() is triggered.
        }
    }
    
    changed(integer c) {
        //llSay(0,"settings changed");
        if (c & CHANGED_INVENTORY) { 
            //nags during update
            //llSay(announce,"(4Settings) Re-read \"Settings\" Notecard? Type: /"+channel+"reset");
            get_channel_twitter();
            ready=TRUE;
        }
    }
}
