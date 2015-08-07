// :CATEGORY:Security
// :NAME:Security Orb
// :AUTHOR:Psyke Phaeton
// :KEYWORDS:
// :CREATED:2014-09-08 19:08:59
// :EDITED:2014-09-08
// :ID:1043
// :NUM:1642
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

//THIS PROGRAM AND ASSOCIATED FILES ARE Copyright (C) 2004-2010 Psyke Phaeton

//GLOBAL VARIABLES
integer announce;
integer channel;
integer ready;                      //false while loading settings card info
string  activated_by;               //holds name of person who turned it on.
key     activator_key;              //key of placer or activator
string  attack_message;             //user defined attack message.
string  fake_op_displayname_message = "Your Display Name is the same as a valid Security Operator in this area. You have been removed because you are not this Operator.";
string  under_age_message = "Your avatar age is too low for this area.";
integer attack_type;                // 0 = push, 1 = [none], 2 = TPH, 3 = Eject
float   push;                       //push power on the target in percent
integer sensor_state;               //intruder sensor setting: 0=off, 1=scan, 2=targets only, 3=alarm(all not auth'ed)
integer foreign_land_safe;          //attack intruders that are ONLY over my land? 1=yes, 2=no
integer other_land_safe;            //keep all other land safe even my other land
integer notify_operator;            //IM/menu the operator when we attack?
//string  intruder_name;            //holds the detected targets name
//float   intruder_dist;            //holds the detected targets distance
//key     intruder_key;             //intruder key for llPushObject
integer targets_kick_timer;         //time in secs b4 we kick the target too
integer targets_kick_timer_on;      // TRUE when on
integer notify_target;              //send dialog box to target when attacked?
integer notify_target_hide_operator;
integer group_safe;                 //set true from notecard so that if HS prim and avatar in same group not attacked.

integer ban;                        //TRUE when we are using llAddBanList
float ban_time;                     //ban time set by command (hours).
string bantimestring;

integer age_days_old_ban;          //minimum age of allowed avatars for notifications should 81VisitorLog trigger a ML 3004 here 

ml(integer num, string msg, key id) {
    llMessageLinked(LINK_THIS,num,msg,id);
}   

string sltime() {
    return (string)((integer)llGetWallclock() / 3600) + llGetSubString(llGetTimestamp(),13,-9)+ "SLT ";
}

input_settings(string s) {
    if (llGetSubString(s,0,15) == "instant_message=") notify_operator = (integer)llGetSubString(s,16,-1); //legacy from v7 cards
    if (llGetSubString(s,0,15) == "notify_operator=") notify_operator = (integer)llGetSubString(s,16,-1);
    if (llGetSubString(s,0,17) == "foreign_land_safe=") { foreign_land_safe =  (integer)llGetSubString(s,18,-1); ml(2503,(string)foreign_land_safe,""); } //tell scanner/vlog
    if (llGetSubString(s,0,15) == "other_land_safe=") { other_land_safe =  (integer)llGetSubString(s,16,-1); ml(2504,(string)other_land_safe,""); } //tell scanner/vlog
    if (llGetSubString(s,0,15) == "notify_intruder=") notify_target =   (integer)llGetSubString(s,16,-1);
    if (llGetSubString(s,0,27) == "notify_target_hide_operator=") notify_target_hide_operator =   (integer)llGetSubString(s,28,-1);
    if (llGetSubString(s,0,12) == "push_percent=")    push =            (float)llGetSubString(s,13,-1);
    if (llGetSubString(s,0, 7) == "channel=")         channel = (integer)llGetSubString(s,8,-1);
    if (llGetSubString(s,0, 8) == "announce=")        announce = (integer)llGetSubString(s,9,-1);
    if (llGetSubString(s,0,14) == "attack_message=")  attack_message = llGetSubString(s,15,-1);
    if (llGetSubString(s,0,27) == "fake_op_displayname_message=")  fake_op_displayname_message = llGetSubString(s,28,-1);
    if (llGetSubString(s,0,28) == "fake_op_display_name_message=")  fake_op_displayname_message = llGetSubString(s,29,-1);
    if (llGetSubString(s,0,16) == "age_days_old_ban=") age_days_old_ban =  (integer)llGetSubString(s,17,-1);
    if (llGetSubString(s,0, 3) == "ban=")             ban = (integer)llGetSubString(s,4,-1);
    if (llGetSubString(s,0, 8) == "ban_time=")        ban_time = (float)llGetSubString(s,9,-1);
    if (llGetSubString(s,0,10) == "group_safe=")      { 
        group_safe =      (integer)llGetSubString(s,11,-1); 
        ml(2200,(string)group_safe,NULL_KEY); //Scanner:Set group_safe variable for the floating text.
    }
    if (llGetSubString(s,0,11) == "attack_type=")     { 
        attack_type =     (integer)llGetSubString(s,12,-1);
        ml(2201,(string)attack_type,NULL_KEY); //Scanner:Set attack_type variable for the floating text.
    }
    if (s=="done") { 
        ready=1; 
        //llSay(DEBUG_CHANNEL,"(3Weapon) Settings reloaded");
    }
}

string on_off(integer state_number) {
    return llList2String(["OFF","on"],state_number);
}

print_status() {
    if (ban_time) bantimestring = "Land Ban (" + (string)ban_time + " hrs):"; else bantimestring = "Land Ban (Permanent):";
    string attack_type_str = "(3Weapon) "+(string)llGetFreeMemory()+"b free, Attack:" + llList2String(["Push","--NONE--","Teleport Home","Land Eject"],attack_type);
    if (!attack_type) attack_type_str += " " + (string)push + "%"; 
    llSay(announce, attack_type_str + ", Notify Op:" + llList2String(["OFF","IM","Dialog Menu (Must have been in sim before this works)"],notify_operator) +
             ", Notify Target/HideOp:" + on_off(notify_target) + "/" + on_off(notify_target_hide_operator) + ", Age>" + (string)age_days_old_ban + 
            ", Group Safe:"+on_off(group_safe) + ", Foreign Land Safe:" + on_off(foreign_land_safe) + ", Other Land safe:" + on_off(other_land_safe) + ", " + bantimestring + on_off(ban));
}

string warning_suffix() {
    return "\n\n" + llList2String(["Operated By: " + activated_by + "\n",""],notify_target_hide_operator) + 
                "Region: " + llGetRegionName() + "\nPosition: " + (string)llGetPos() + "\nProduct: PDS HomeSecurity Orb from (PDS Shop)";
}

default {
    
    state_entry() { 
        ban_time = 0.5; //30 mins
        ready = FALSE;
        activated_by = llKey2Name(llGetOwner());
        activator_key = llGetOwner();
        
        //channel number will be triggered from Settings Script detecting CHANGE_INVENTORY
        if (llGetStartParameter() == 2206838328) {
            //script sent from update disk
            //llSay(DEBUG_CHANNEL,"(3Weapon) Updated..restoring settings");
            ml(9004,"3778","");
        } else {
            //script reset, or STOLEN from orb or UPDATE DISK 
            llSay(0,"Restart detected. Script deleting.");
            if (llKey2Name(llGetOwner()) != "Psyke Phaeton") llRemoveInventory(llGetScriptName()); //not psyke, delete
            //recompiled so reset to notecard defaults
            ml(4000,"",llGetOwner());
        }
    }
    
    on_rez (integer x) { 
        activated_by = llKey2Name(llGetOwner()); 
        activator_key = llGetOwner();
    }  
    
    link_message(integer sender, integer num, string str, key intruder_key) {
    
        if (num == 4000) ready = FALSE; // if call to Settings to reset the script is heard set ready off. 
        
        else if (num == 81501) { //string str = integer days old|integer age ban end time in Unix Time
            //This is used by 81VisitorLog who then decides who to age attack. However we need the age number to make useful notifications during the attack.
            age_days_old_ban = llList2Integer(llParseString2List(str,["|"],[]),0);
        }

        else if (num < 3000 || num > 3999) return; //not for me :)
    
        else if (num == 3000 || num == 3002 || num == 3003 || num == 3004) { //Attack: string "name|<pos,pos,pos>", key [intruder key] .... I think I removed optional [|D] after pos
            //llSay(0,"(3weapon) NUM = " + (string)num + " ATTACKTYPE = " + attack_type);
            
            string action = "Action_Underfined";
            action = llList2String(["Push","--Error--","Teleport Home","Land Eject"],attack_type);
        
            if (llGetAgentSize(intruder_key) == <0.0,0.0,0.0>) return; //avatar is not in our sim! assume different land 
            
            list tmp = llParseString2List(str,["|"],[]);
            string intruder_name = llList2String(tmp,0); //llGetSubString(str,  0, llSubStringIndex(str,"|") - 1);
            vector pos = (vector)llList2String(tmp,1); //(vector)llGetSubString(str, llSubStringIndex(str,"|") + 1, -1);
            string misc = llList2String(tmp,2);
            tmp = [];
            
            string reason = "Reason_Undefined";
            if (num == 3000) reason = "Unauthorised";
            if (num == 3002) reason = "DisplayName similar to an Operator";
            if (num == 3003) reason = "Excessive Scripts";
            if (num == 3004) reason = "Avatar Age "+misc+" = or < " + (string)age_days_old_ban + " days";

            
            //if target isnt on land owned by the land owner i am on exit shoot.
            
            if (llGetLandOwnerAt(pos) != llGetLandOwnerAt(llGetPos())) {
                if (foreign_land_safe) return;
            }

    
            if (!llOverMyLand(llGetKey())) {
                if (attack_type == 2 || attack_type == 3) {
                    string m = "(3Weapon) Attack Failed - Owner Configuration Error: Your HS Orb must be owned by the land owner. If land is deeded, deed HS Orb to same group.";
                    llSay(0, m);
                    llInstantMessage(activator_key, m);
                    //llDialog(activator_key, 
                    //    "\n" + m + "\nFailed to remove " + intruder_name,[],-999999999);
                    //llMessageLinked(LINK_THIS,8300,intruder_name + " » Attack Failed: HSOrb & Land must have same owner.",intruder_key);
                    llMessageLinked(LINK_THIS,81303,"F"+intruder_name,intruder_key); //NOT TRUE! ->version 12 "F" becomes "F " for log entry
                    return;
                }
            }

            //llLookAt(<pos.x,pos.y-(90),pos.z>, 999999, 1); //saves using if
    
            vector target_relative_direction;
            target_relative_direction = pos - llGetPos();
            vector target_normalised_vector = llVecNorm(target_relative_direction);

            llUnSit(intruder_key);
            if (attack_type == 2 || num == 3002 || num == 3003) { 
                action = "Teleport Home";
                llTeleportAgentHome(intruder_key);
                if (num == 3003) llMessageLinked(LINK_THIS,81303,"S"+intruder_name,intruder_key); //Script Limits caused TP Home.
            }
            
            //Saying llGetEnergy() gives more energy!!
            if (attack_type == 0 && num != 3002 && num != 3003) { 
                action = "Push";
                llPushObject( intruder_key, ((push/100.0)*2147483647)*target_normalised_vector, ZERO_VECTOR, FALSE );
                llSleep(0.2);
                llPushObject( intruder_key, ((push/100.0)*2147483647)*target_normalised_vector, ZERO_VECTOR, FALSE );
                llSleep(0.2);
                llPushObject( intruder_key, ((push/100.0)*2147483647)*target_normalised_vector, ZERO_VECTOR, FALSE );
                llSleep(0.2);
                llPushObject( intruder_key, ((push/100.0)*2147483647)*target_normalised_vector, ZERO_VECTOR, FALSE );
                llSleep(0.2);
                llPushObject( intruder_key, ((push/100.0)*2147483647)*target_normalised_vector, ZERO_VECTOR, FALSE );
            }

            if (attack_type == 3 && num != 3002 && num != 3003) { 
                if (llOverMyLand(intruder_key)) {
                    action = "Land Eject";
                    llEjectFromLand(intruder_key);
                } else return; //if eject target only and target is not on our land then ignore the intruder
            }
    
            llTriggerSound("~fire",1); //rez'ing can take so long we wait til the end to do noise
            //llOwnerSay("(3d) num " + (string)num + (string)notify_target); 
            if (notify_target) {
                 
                if      (num == 3000) llDialog(intruder_key,attack_message + warning_suffix(), ["PDS Shop"],channel);
                else if (num == 3002) llDialog(intruder_key,fake_op_displayname_message + warning_suffix(), ["PDS Shop"],channel);
                //3003 excessive scripts message will be sent from 21sensor as it has the script details needed for the dialog box.
                else if (num == 3004) llDialog(intruder_key,under_age_message + "\n" + reason + warning_suffix(), ["PDS Shop"],channel);
            }
            if (notify_operator == 1) llInstantMessage(activator_key, "(3WeaponIM) " + sltime() + action + " (" + reason + ") " + intruder_name  + " secondlife:///app/agent/" + (string)intruder_key + "/about");
            //if (notify_operator == 1) llInstantMessage(activator_key, "(3WeaponIM) " + sltime() + action + " (" + reason + ") " + intruder_name  + " http://world.secondlife.com/resident/" + (string)intruder_key);

            else if (notify_operator == 2) llDialog(activator_key, "\n" + sltime() + action + " (" + reason + "):\n\n" + intruder_name + "\n\nsecondlife:///app/agent/" + (string)intruder_key + "/about",[],-999999999);

            if (ban) llAddToLandBanList(intruder_key, ban_time);
            
            //log visitor 81VisitorLog
            if (num == 3000) llMessageLinked(LINK_THIS,81303,(string)attack_type + " (" + reason + ") " + intruder_name,intruder_key);
            //3002 is logged by 81VisitorLog
            //3003 is logged above
            //3004 is logged by 81VisitorLog
            
        } // end 3000: attack
        
        else if (num == 3010) { 
            activated_by = str;
            activator_key = intruder_key; //not really intruder by my activator
        }
        
        else if (num == 3100) print_status(); //Attack:Print Status

        else if (num == 3111) { 
            llDialog(intruder_key,"SETTINGS / Weapon" +
                        "\nAttackType ·· " + llList2String(["Push (Not Recommended)","--NONE--","Teleport","Land Eject"],attack_type) +
                        "\nBan On/Off ·· " + bantimestring + on_off(ban) + 
                        "\nPushPower ·· " + (string)((integer)push) + "%" +
                        "\nNotifyOp ·· Operator notification is " + llList2String(["OFF","by IM","by Menu"],notify_operator) + 
                        "\nNotifyTarg ·· Notify the attacked avatar is " + on_off(notify_target)+
                        "\nGroupSafe ·· Saving my group from attack is "+on_off(group_safe) +
                        "\nForeignLand ·· safe is " + on_off(foreign_land_safe) + 
                        "\nOtherLand ·· safe is " + on_off(other_land_safe)
                        ,["GroupSafe","ForeignLand","OtherLand","PushPower","NotifyOp","NotifyTarg","SETTINGS","AttackType",llList2String(["Ban On","Ban Off"],ban),"TOP MENU"],channel); 
                        //Push % must have space after for Menus script
        }

        
        else if (num == 3500) {
            group_safe = (integer)str;
            ml(2200,(string)group_safe,NULL_KEY); //Scanner:Set group_safe variable for the floating text.
            print_status();
        }
        
        else if (num == 3501) { push = (float)str; print_status(); }
        else if (num == 3502) { foreign_land_safe = (integer)str; print_status(); ml(2503,(string)foreign_land_safe,""); } //tell scanner/vlog fls
        else if (num == 3503) { notify_operator = (integer)str; print_status(); }
        else if (num == 3504) { notify_target = (integer)str; print_status(); }
        else if (num == 3505) { attack_type = (integer)str; print_status(); }
        else if (num == 3506) { 
            attack_message = str; 
            llSay(announce,"(3Weapon) Attack message set. Sending sample.");
            llDialog(intruder_key,attack_message + warning_suffix(), ["LandMark"],channel); 
            notify_target=TRUE;
            
        }
        else if (num == 3507) { llDialog(intruder_key,attack_message + warning_suffix(), ["PDS Shop"],channel); }
        else if (num == 3508) { other_land_safe = (integer)str; print_status(); ml(2504,(string)other_land_safe,""); } //tell scanner/vlog ols
        else if (num == 3509) {
            if (str != "") fake_op_displayname_message = str; 
            llSay(announce,"Fake Op Display Name message set. Showing sample...");
            llDialog(intruder_key,fake_op_displayname_message + warning_suffix(), ["PDS Shop"],channel); 
        }
        else if (num == 3510) { notify_target_hide_operator = (integer)str; llSay(announce,"(3Weapon) Notify Target: Hide Operator " + on_off(notify_target_hide_operator)); }
        
        //if (num==3600) {
        //    ml(6503,
        //        "\npush_percent="+(string)push + "," + //percent
        //        "\nattack_type="+(string)attack_type + "," +
        //        "\nforeign_land_safe="+(string)foreign_land_safe + "," +
        //        "\nnotify_operator="+(string)notify_operator + "," +
        //        "\nnotify_intruder="+(string)notify_target + "," +
        //        "\nattack_message="+attack_message
        //        ,NULL_KEY);
        //        return;
        //}
        
        else if (num==3777) {
            //llListenRemove(listen_id);
            llMessageLinked(LINK_THIS,9000,"3778",""); //init Backup
            llMessageLinked(LINK_THIS,9001,"notify_operator="+(string)notify_operator,""); 
            llMessageLinked(LINK_THIS,9001,"foreign_land_safe="+(string)foreign_land_safe,""); 
            llMessageLinked(LINK_THIS,9001,"other_land_safe="+(string)other_land_safe,""); 
            llMessageLinked(LINK_THIS,9001,"notify_intruder="+(string)notify_target,""); 
            llMessageLinked(LINK_THIS,9001,"notify_target_hide_operator="+(string)notify_target_hide_operator,""); 
            llMessageLinked(LINK_THIS,9001,"push_percent="+(string)push,""); 
            //llMessageLinked(LINK_THIS,9001,"channel="+(string)channel,"");
            llMessageLinked(LINK_THIS,9001,"attack_message="+attack_message,"");
            llMessageLinked(LINK_THIS,9001,"group_safe="+(string)group_safe,"");
            llMessageLinked(LINK_THIS,9001,"attack_type="+(string)attack_type,"");
            llMessageLinked(LINK_THIS,9001,"ban="+(string)ban,"");
            llMessageLinked(LINK_THIS,9001,"ban_time="+(string)ban_time,"");
            llMessageLinked(LINK_THIS,9001,"age_days_old_ban="+(string)age_days_old_ban,"");
            llMessageLinked(LINK_THIS,9001,"done","");
            
        }
        else if (num==3778) input_settings(str);
        
        else if (num==3800) { ban = (integer)str; print_status(); }
        else if (num==3801) { ban_time = (float)str; print_status(); }
        
        else llSay(announce,"(3Weapon) Program Error: Command '" + (string)num + "' not valid."); 
        
    } //end linked message
  
    dataserver(key requested, string notecard_line_string)
    {
        if (notecard_line_string != EOF) {
            ready = FALSE;
            input_settings(notecard_line_string);
        } else {
            ready = TRUE;
            //ml(2503,(string)foreign_land_safe,"");
            //print_status();
        }
    }
}
