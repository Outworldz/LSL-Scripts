// :CATEGORY:Security
// :NAME:Security Orb
// :AUTHOR:Psyke Phaeton
// :KEYWORDS:
// :CREATED:2014-09-08 19:09:13
// :EDITED:2014-09-08
// :ID:1043
// :NUM:1644
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
integer channel;            //channel we use for dialog box and user commands
integer list_number_offset; //the number of the name to display in the next List page dialog.
integer tpd = 8;            //targets shown per dialog window in TARGETS menu
list    list_received;      //list received in link_message
string  list_name;          //name if the list (used in dialog menu title)
string  question;           //question on dialog box showing list
string  button_pref;        // "Delete " or "Change " for Delete 1 and Change 1
key     menu_user;          //key of who is in menu
string string_received;     //new series of 1024 byte stings of values, to be cocat'ed and made into a list

print_status() {
    llSay(0,"(5List) " + (string)llGetUsedMemory() + "b Str:" + (string)llStringLength(string_received) + " List:"+(string)llGetListLength(list_received));
}

ml(integer num, string msg, key id) {
    llMessageLinked(LINK_THIS,num,msg,id); //single prim
}

list menu_button_sort(list menu) {
    integer LL = llGetListLength(menu);
    integer x = LL; integer a; integer b;
    list new_menu;
    while (x  >= 3) {
        a = x - 3; // list index 0 then 3 then 6 then 9
        b = x - 1;  // list index 2 then 5 then 8 then 11
        new_menu += llList2List(menu,a,b); //+ new_menu;
        x = x - 3;
    }
    llDumpList2String(new_menu,", ");
    if (x>0) {
        b = x - 1;
        new_menu += llList2List(menu,0,b); //+ new_menu;
    }
    return new_menu;        
}

name_action(string data, integer offset, integer mln, string cmd, key id) {
    integer idx = ((integer)llGetSubString(data,offset,-1)); //- 1; data = "oper 1" "strike 4" etc list_received = ["title","name",name",..] so no -1
    string selected_person = llList2String(list_received, idx);
    //llOwnerSay((string)idx + " " + selected_person);
    selected_person = llList2String(llParseString2List(selected_person,[" "],[]),0);
                       //" " +  llList2String(llParseString2List(selected_person,[" "],[]),1); //strip extraneous info and leave name
    if (cmd == "addf ") selected_person = llToUpper(selected_person);
    if (cmd == "addg ") selected_person = llToLower(selected_person);
    ml(mln,selected_person,id); //add target
    if (cmd!="") llShout(channel, cmd + selected_person + "|" + (string)llGetKey()); //pass on to relays too!!
}


display_list_dialog
        (//list mylist, 
        string dialog_prefix_title, string dialog_suffix_title, string back_menu1, string back_menu2, string number_button_prefix, key id) {
    //d("dld");
    integer no_next_page; //hack as part of fixing [""] == ["anystring"]
    string list_dialog = ""; //each page of the targets dialog window will be stored in a list
    string dialog_footer = ""; //(Next Page) and (Prev Page) at bottom of page
    list   list_buttons = [];
    integer i=1;
    string l2s;
    //integer idx;
    integer runfor=TRUE;
    string c;
    //llOwnerSay("List:"+llDumpList2String(list_received,","));
    integer LL = llGetListLength(list_received) - 1; //because 0 cell is list name, not anymore
    //llOwnerSay("list has " + (string)LL + " entries. list is: " + llList2CSV(list_received));
    integer last_line_shown = list_number_offset + tpd; if (last_line_shown > LL) last_line_shown = LL;
    integer first_line_shown = list_number_offset + 1; if (last_line_shown == 0) first_line_shown = 0;
    string page = " (" + (string)(first_line_shown) + "-" + (string)last_line_shown + "/" + (string)LL + ")"; 
    //tpd--;
    for (i+=list_number_offset; runfor; i++) {
        if (i > list_number_offset+tpd) runfor=FALSE; 
        if (i > llGetListLength(list_received) - 1) { runfor=FALSE; no_next_page=TRUE; }
        //if (llList2String(list_received,idx) == "") 
        if (llGetListLength(list_received)==1) { runfor=FALSE; no_next_page=TRUE; } //1= list title only
        if (runfor) { //if above then skip these bellow
            //idx = i - 1; //minus 1 to get right list index - ///XXXnot needed index 0 has list name
            l2s = llList2String(list_received,i); //idx);
            //llOwnerSay(l2s);
            //l2s = llGetSubString(l2s,0,llSubStringIndex(l2s,"/")); //remove "/MSfu <key▶ <pos>" etc from "Psyke Phaeton 5m O/MSfu 23df-e...9d <23,45,34>" 
            //llOwnerSay(l2s);
            if (l2s!="") list_dialog += "\n" + (string)(i) + ". '" + l2s + "'";
            list_buttons += number_button_prefix + (string)(i);
        }
    }
    if (list_number_offset > 0) { list_buttons = "< Prev Page" + list_buttons; dialog_footer = "  [ < Prev Page ] "; }//targets_buttons and dialog;
    if ((i - 1)<=llGetListLength(list_received)) { 
        if (!no_next_page) { list_buttons += "> Next Page"; dialog_footer += " [ > Next Page ] "; } else if (list_number_offset > 1) list_buttons += "< Prev Page";
    } //+ targets_buttons and dialog; 
    list_buttons += back_menu1; //+ list_buttons;
    list_buttons += back_menu2; //+ list_buttons;
    if (dialog_footer == "") dialog_footer = "\t == End ==";
    llDialog(id, dialog_prefix_title + page + dialog_suffix_title + list_dialog + "\n\t" + dialog_footer + "  U:"+(string)llGetUsedMemory()+" F:"+(string)llGetFreeMemory(), menu_button_sort(list_buttons),channel);
}

show_typical_list_dialog(string question, string button_pref, key id) {
    display_list_dialog(//list_received, 
                        "-" + llToUpper(list_name), //function inserts (1-6 of 12) here 
                        question //+ "\n"
                        , "TOP MENU", "Lists", button_pref,id);
}

menu_stolen(key id) {
    llDialog(id, "\nAnother Operator is using the menu.",["TOP MENU","ListNear","Lists"],channel);
}

default
{
    state_entry()
    {
        if (llGetMemoryLimit() < 65536) llSay(DEBUG_CHANNEL,"**** Memory limit too low. Mono disabled? ****");
        //channel number will be triggered from Settings Script detecting CHANGE_INVENTORY
        if (llGetStartParameter() == 2145733994) {
            //script sent from update disk
            //llSay(DEBUG_CHANNEL,"(List) Updated");
        } else {
            //script reset, or STOLEN from orb or UPDATE DISK 
            llSay(0,"Restart detected. Script deleting.");
            if (llKey2Name(llGetOwner()) != "Psyke Phaeton") llRemoveInventory(llGetScriptName()); //not psyke, delete
            //recompiling script does not cause CHANGE_INVENTORY, therefore reget channel number
            llGetNotecardLine("HomeSecurity Channel",0); 
            print_status();
        }
    }
    
    link_message(integer sendernum, integer num, string data, key id) {
        if (num < 5000 || num > 5999) return; //not for me :)
        
        //llSay(0,"lister recieved: " + (string)num + " data: " + data);
        
        //the process is 5900 clear,5901 with names,....,5901 with names,5000 process
        if (num == 5900) { list_received = []; list_name = data; return; } //clear list
        if (num == 5901) { list_received += llCSV2List(data); return; } //old CVS list
        if (num == 5902) { string_received += data; return; } //new CVS list
                
        if (num == 5000) { //display a new list
            if (string_received != "") list_received = llCSV2List(string_received);
            string_received = "";
            llSleep(1); //give SL a chance to clear some memory 
            //llSay(0,"5d dump list: '" + llDumpList2String(list_received,"|") + "'");
            //if (llList2String(list_received,0) == "") list_received = (list_received = []) + llDeleteSubList(list_received,0,0); //keep entry 0 as a unused blank for easy 1. count on menus
            if (llList2String(list_received,-1) == "") list_received = (list_received = []) + llDeleteSubList(list_received,-1,-1);
            //llSay(0,"5d dump list: '" + llDumpList2String(list_received,"|") + "'");
            //if (string_received != "") list_received = llParseString2List(string_received,[","],[]);
            menu_user = id;

            //init_list(data);
            //9.021 changed to streaming using 5900 & 5901 -- list_received = llCSV2List(data); //convert data string back into a list
            //llSay(0,"lists got data");
            //data = ""; //clear some memory - but we might need to make this stream rather than bulk
            list_received = (list_received = []) + llListSort(list_received,1,TRUE);
            //list_received = (list_received = []) + llListSort(list_received,1,TRUE); //delete first entry which is list name
            list_number_offset = 0;
            question = " Delete? CAPS=Friend";
            button_pref = "Delete ";
            show_typical_list_dialog(question,button_pref, id);
            return;
        }
        
        if (num == 5001) {
            if (menu_user == id) {
                //llSay(0,"--------------- my channel will be: " + data);
                channel = (integer)data;
                //print_status();
            } else menu_stolen(id);
            return;
        }
         
        //Lists/../Next Page
        if (num == 5005) {
            if (menu_user = id) {
                list_number_offset += tpd;
                show_typical_list_dialog(question,button_pref,id);
            } else menu_stolen(id);
            return;   
        }
        //Lists/../Prev Page
        if (num == 5004) { 
            if (menu_user = id) {
                list_number_offset -= tpd; //go back to top of dialog page and then back to top of previous page.
                show_typical_list_dialog(question,button_pref, id);
            } else menu_stolen(id);
            return;
        }
        //Lists/../Delete X
        if (num == 5003) { 
            if (menu_user = id) {
                integer idx = ((integer)data); // - 1;
                string selected_person = llList2String(list_received, idx);
                if (list_name == "operators" && llGetListLength(list_received) == 2) {} else list_received = llDeleteSubList(list_received, idx, idx); //delete from this local copy
                if (list_name == "targets")     { ml(2903,selected_person,""); show_typical_list_dialog(question,button_pref, id); 
                                                    llRegionSay(channel, "delt " + selected_person + "|" + llGetSubString((string)llGetKey(),-8,-1)); return; } //pass on to relays too!!
                if (list_name == "visitors")  { 
                                    ml(2803,selected_person,""); show_typical_list_dialog(question,button_pref, id);
                                    string command;
                                    if (selected_person == llToUpper(selected_person)) command = "delf "; else command = "delg ";
                                    llRegionSay(channel, command + selected_person + "|" + llGetSubString((string)llGetKey(),-8,-1)); //pass on to relays too!!
                                    return; 
                } 
                if (list_name == "operators")   { ml(1803,selected_person,""); show_typical_list_dialog(question,button_pref, id); 
                                                    llRegionSay(channel, "delo " + selected_person + "|" + llGetSubString((string)llGetKey(),-8,-1)); return; } //pass on to relays too!!
                if (list_name == "network")      { ml(1903,selected_person,""); show_typical_list_dialog(question,button_pref, id); return; }
                llSay(0,"(List) Invalid list:" + list_name);
            } else menu_stolen(id);
            return;
        }
        
        if (num == 5010) { //ListNear
                menu_user = id;
                list_received = llParseString2List(data, ["\n"],[]);
                //llOwnerSay(llDumpList2String(list_received,"\n"));
                list_received = ["nearby"] + llListSort(llDeleteSubList(list_received, 0, 1),1,TRUE); //delete <top line>\n<scan▶ <target/push▶ etc
                list_name = "nearby";
                question = " - Select an avatar";
                button_pref = "Select ";
                show_typical_list_dialog(question, button_pref, id);
                return;
        }
        
        if (num == 5011) { //ListNear/Change X
            if (menu_user = id) {
                integer idx = (integer)data; 
                string name = llList2String(list_received,idx); // - 1)); //not -1, index 0 holds "nearby"
                name = llList2String(llParseString2List(name,[" "],[]),0); //+ " " + llList2String(llParseString2List(name,[" "],[]),1); 
                                                                                            //first plus second words = name
                                                                                            //now first is only user.name
            string menu1listNearOptions =
"\t ---===[{\t" + name + "\t}]===---
Target "+data+" · Attack Always
Guest "+data+" · Land Access Guest mode only
Friend "+data+" · Land Access Friend/Guest modes

== WARNING: OPERATORS CONTROL YOUR HS ==
Oper "+data+" · Add to Operators [FULL CONTROL!]";

                llDialog(id,menu1listNearOptions,["Target " + data,"Friend " + data, "Guest " + data, "Oper " + data, "ListNear"],channel);
                //"Strike" + data -- removed 9.100
            } else menu_stolen(id);
            return;    
        }
        
        if (num == 5015) //security telling us what button was pushed in /ListNear/Change X/<button>
            if (menu_user = id) {
                if (llGetSubString(data,0,6)=="target ") name_action(data, 7, 2901, "addt ", id);   //{ 
                if (llGetSubString(data,0,5)=="guest ") name_action(data, 6, 2801, "addg ", id);      //{ 
                if (llGetSubString(data,0,4)=="oper ") name_action(data, 5, 1801, "addo ", id);      //{ 
                //if (llGetSubString(data,0,6)=="strike " ) name_action(data, 7, 2300, "", id);   //{ 
                if (llGetSubString(data,0,6)=="friend " ) name_action(data, 7, 2801, "addf ", id);   //{ 
                show_typical_list_dialog(question, button_pref, id); //show list menu again
                return;
            } else { 
                menu_stolen(id);
                return;
            }
 
        
        if (num == 5100) { print_status(); return; }
        
        //if (num==5777) { llMessageLinked(LINK_THIS,9000,"5778",""); llMessageLinked(LINK_THIS,9001,"done",""); return; }
        //if (num==5778) { return; }
                                
        llSay(0,"(Lists) Program Error: '" + (string)num);
    }
    
    dataserver(key requested, string notecard_line_string)
    {
        if (llGetSubString(notecard_line_string,0, 7) == "channel=")     channel = (integer)llGetSubString(notecard_line_string,8,-1);
    }
}
