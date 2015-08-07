// :CATEGORY:Door
// :NAME:Multiuser_Lockable_Door_Script
// :AUTHOR:Meiyo Sojourner
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:547
// :NUM:744
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Multiuser Lockable Door Script.lsl
// :CODE:

// Nifty Neato Multi User Lockable Door, A Red Visions Script
// Copyright (C) 2004  Meiyo Sojourner
// 
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
// (Also available at http://www.gnu.org/copyleft/gpl.html) 
//
// WARNING: Removal of the introduction warning message will corrupt the script.
//
// Additional Credits:
//~~~~~~~~~~~~~~~~~~~~~
// Default door open/close operation from a script by Kyle Chaos




//GLOBALS
//=======
// For the messages, use %nn% in place of the name 
// of the av that clicked on the door.
// Set the variable to "" to disable the message.
string startup_message = 
    "Touch door and say 'show help' in the chat for a list of commands";
string open_message = "%nn% is at the door.";   
string close_message = "";                 
string lock_message = "Sorry %nn%, this door is locked";
float open_time = 30.0;                   
string open_sound = "Door open";     // These can be set to "" 
string close_sound = "Door close";  //  to disable the sounds.
integer debug_messages = FALSE;
//- - - - - - - - - - - - - - - - 
list auth_list = [];
integer door_open = FALSE;
integer locked = FALSE;
integer listen_tag = -1;
float interval = 30.0;
list help_message = [   
        "**Multi User Lockable Door Commands List **",
        " 'show help' - Displays this file",
        " 'lock' - Sets the door to Locked mode",
        " 'unlock' - Sets the door to Unlocked mode",
        " 'add [name]' - Replace [name] with the av you want to add to the list",
        " 'remove [name]' - Replace [name] with an av you want to delete",
        " 'say list' - Shows who is on the All Access list",
        " 'change time [time]' - Replace [time] with the number of seconds",
        "                        you want the door to stay open and listen."
];


//TOOL FUNCTIONS
//==============
float debug(string m)                // Allows for debug messages
{                                   //  to be easily turned on/off
    if (debug_messages)
        llSay(0,m);
    return TRUE;
}
integer k = FALSE;
//- - - - - - - - - - - - - - - - 
float debugList(list l)              // List version of the 
{                                   //  debug() function
    string s = "";
    if (debug_messages){
        integer i;
        for (i = 0; i < llGetListLength(l); i++){        
            s += llList2String(l,i);
            if (i < llGetListLength(l) - 1)
                s += ",  ";
        }
        if (s == "") {
            llSay(0,"LIST IS EMPTY");
        }else{
            llSay(0,s);
        }    
    }
    return TRUE;
}
//- - - - - - - - - - - - - - - - 
integer q(){
    llSay(0,"This script is provided free of charge. 
        Please contact Meiyo Sojourner if you paid for it.");
    return TRUE;
}
//- - - - - - - - - - - - - - - - 
integer d(){
    llSay(0,"This script has been unacceptably modified!  
        It is now deleting itself.");
    llRemoveInventory(llGetScriptName());
    return TRUE;
}
//- - - - - - - - - - - - - - - - 
float sayList(list l)               // Dumps the contents of 
{                                   // the list into the chat 
    string s = "";
    integer i;
    for (i = 0; i < llGetListLength(l); i++){        
        s += llList2String(l,i);
        if (i < llGetListLength(l) - 1)
            s += ",  ";
    }
    if (s == "") {
        llSay(0,"LIST IS EMPTY");
    }else{
        llSay(0,s);
    }    
    return TRUE;
}
//- - - - - - - - - - - - - - - - 
float sayList2(list l)               // Dumps the contents of the list 
{                                   //  into the chat one line at a time
    integer i;
    for (i = 0; i < llGetListLength(l); i++){        
        llSay(0,llList2String(l,i));
    }
    return TRUE;
}
//- - - - - - - - - - - - - - - - 
integer isIn(list test_list, list test_item)  // Looks for test_item
{                                            //  in test_list
    integer i;
    for (i = 0; i < llGetListLength(test_list); i++){
        if (llList2String(test_item, 0) == llList2String(test_list, i))
            return TRUE;
    }
    return FALSE;
}
//- - - - - - - - - - - - - - - - 
string replace(string main, string old, string new)  // Search and replace 
{                                                   //  function for strings
    string temp = "";
    list m = llParseString2List(main,["%"],[]);
    integer i;   
    for(i = 0; i < llGetListLength(m); i ++){
        string c = llList2String(m,i);
        if (c == old){
            temp += new;
        }else{
            temp += c;
        }
    }
    return temp;
}
//- - - - - - - - - - - - - - - - 

float stopListening()                // Kills the listen function
{                                   //  in order to save resources
    if(listen_tag != -1)
        llListenRemove(listen_tag);
    listen_tag = -1;
    return TRUE;
}
//- - - - - - - - - - - - - - - -     
float removeName(string target_name) // Searches for and deletes 
{                                   //  target_name from auth_list
    integer i;
    for (i = 0; i < llGetListLength(auth_list); i++){
        if (target_name == llList2String(auth_list, i)){
            auth_list = llDeleteSubList(auth_list, i, i);         
            return TRUE;
        }
    }
    return FALSE;
}
//- - - - - - - - - - - - - - - -     
integer open(string av_name) // Opens the door.
{
    if (open_sound != "")
        llTriggerSound(open_sound, 0.5);
    if (open_message != "")
        llSay(0, replace(open_message,"nn",av_name));
    // vv  Replace this snippet with custom code to close the door vv 
    rotation rot = llGetRot();
    rotation delta = llEuler2Rot(<0,0,PI/4>);
    rot = delta * rot;
    llSetRot(rot);
    llSleep(0.25);
    rot = delta * rot;
    llSetRot(rot);
    // ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^
    return TRUE;
}
//- - - - - - - - - - - - - - - -     
integer close(string av_name) // Closes the door.
{
    if (close_sound != "")
        llTriggerSound(close_sound, 0.5);
    if (close_message != "")
        llSay(0, replace(close_message,"nn",av_name));
    // vv  Replace this snippet with custom code to close the door vv
    rotation rot = llGetRot();
    rotation delta = llEuler2Rot(<0,0,-PI/4>);
    rot = delta * rot;
    llSetRot(rot);
    llSleep(0.25);
    rot = delta * rot;
    llSetRot(rot);
    // ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^
    return FALSE;
}
//- - - - - - - - - - - - - - - -     




//CODE ENTRY
//==========
default
{
    state_entry()
    {
        k = q();
        llRequestAgentData(llGetOwner(), DATA_NAME); 
    }


    dataserver(key queryid, string data) {
        auth_list += data;
        llSay(0,"Owner added to Authorized List.");
        if (startup_message != "")
            llSay(0,startup_message);
    }


    on_rez(integer rez)
    {
        llResetScript();
    }


    touch_start(integer total_number)
    {
        if (!k) d();
        list temp = [];
        if (!door_open){
            if (!locked){
                door_open = open(llDetectedName(0));
                listen_tag = llListen(0,"","","");
                llSetTimerEvent(open_time);
            } else if (isIn(auth_list, temp += llDetectedName(0))){
                debug("authorized");
                door_open = open(llDetectedName(0));
                listen_tag = llListen(0,"","","");
                llSetTimerEvent(open_time);
            } else {
                llSay(0, replace(lock_message,"nn",llDetectedName(0)));
            }
        } else {
            door_open = close(llDetectedName(0));
        }
        debug("TEMP =");
        debugList(temp);
        debug("AUTH_LIST = ");
        debugList(auth_list);        
    }
    
    
    timer()
    {
        stopListening();
        if (door_open){
            door_open = close("the script");
        }
    }
    
        
    listen(integer chan, string name, key id, string msg) 
    {
        list temp = [];
        if (isIn(auth_list, temp += name)){
            list n = llParseString2List(msg, [" "], []);
            string cmd_a = llList2String(n, 0);
            string cmd_b = llList2String(n, 1);
            string cmd_c = llList2String(n, 2);
            if (cmd_a == "lock"){
                locked = TRUE;
                llSay(0,"Door Locked");
            }
            if (cmd_a == "unlock"){
                locked = FALSE;
                llSay(0,"Door Unlocked");
            }
            if (cmd_a == "add"){
                if ((cmd_b == "")||(cmd_c == "")){
                    llSay(0, "Incorrect Name Format!");
                }else{
                    temp = [];
                    string new_name = cmd_b + " " + cmd_c;
                    if(!isIn(auth_list, temp += new_name)){
                        auth_list += new_name;
                        llSay(0, new_name + " added to list.");
                    }else{
                        llSay(0, new_name + " was already on the list.");
                    }
                }
            }
            if ((cmd_a == "remove")||(cmd_a == "delete")){
                if ((cmd_b == "")||(cmd_c == "")){
                    llSay(0, "Incorrect Name Format!");
                }else{
                    string kill_name = cmd_b + " " + cmd_c;
                    if (removeName(kill_name)){
                        llSay(0,"Name Successfully Removed");
                    }else{
                        llSay(0,"Name Not Found!");
                    }
                }
            }
            if ((cmd_a == "say")&&(cmd_b == "list")){
                sayList(auth_list);
            }
            if ((cmd_a == "show")&&(cmd_b == "help")){
                sayList2(help_message);
            }
            if ((cmd_a == "change")&&(cmd_b == "time")){
                float foo = llList2Float(n, 2);
                if (foo < 10){
                    llSay(0, "Invalid Time Specified!");
                }else{
                    open_time = foo;
                    llSay(0, "Open time changed to " + cmd_c + " seconds.");
                }                
            }
        }
    }
}// END //
