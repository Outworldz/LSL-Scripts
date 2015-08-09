// :CATEGORY:Presenter
// :NAME:Presenter_with_Timer
// :AUTHOR:Paul Preibisch
// :CREATED:2013-03-28 14:17:53.140
// :EDITED:2013-09-18 15:39:00
// :ID:647
// :NUM:877
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Presenter_with_Timer
// :CODE:
/*
*
*  Copyright (c) 2013 contributors (see below)
*  Released under the GNU GPL v3
*  -------------------------------------------
*
*  This program is free software: you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*
*
*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*
*  All scripts must maintain this copyrite information, including the contributer information listed
* 
*  As mentioned, this script has been  licensed under GPL 3.0
*  Basically, that means, you are free to use the script, commercially etc, but if you include
*  it in your objects, you must make the source viewable to the person you are distributuing it to -
*  ie: it can not be closed source - GPL 3.0 means - you must make it open!
*  This is so that others can modify it and contribute back to the community.
*
*  Enjoy!
*
*  This script can be found on git hub: https://github.com/firecentaur/lsl-scripts
*
*  Contributors:
*   Paul Preibisch (fire@b3dmultitech.com)
*
*  DESCRIPTION
*
*  Hi everyone, I hope this script helps you for your Virtual World Presentations!
*  To use, simply place this script into an Opensim Primitive Object, along with your textures.
*  
*  Once clicked, you will get a menu that allows you to:
*  
*  RESET - resets the scripts
*  Set Timer - Set a timer (in seconds) and start the timer to automatically advance the slides
*  Start Timer - Start the timer if it is stopped
*  Stop Timer - Stop the timer if it is currently started
*  Next - advance to next slide
*  Previous - go to previous slide
*  lock/unlock - lock/unlock the presenter so only the owner can use
*  Messages on / Messags off - turn messages on or off to give textual feedback to all users when moving to a new slide etc
*
*/
 
list textures;
integer total_items;
integer random_integer ( integer min , integer max ){
    return min + (integer )( llFrand( max - min + 1 ) );
}
integer MENU_CHANNEL;
integer TEXT_BOX_CHANNEL;
integer LOCK=TRUE;
string timer_status="off";
integer SLIDE_DELAY=10;
integer SILENT=TRUE;
integer current_slide=0;
integer slide_timer_counter=0;
vector RED =<1.00000, 0.00000, 0.00000>;
vector ORANGE=<1.00000, 0.43763, 0.02414>;
vector YELLOW=<1.00000, 1.00000, 0.00000>;
vector GREEN=<0.00000, 1.00000, 0.00000>;
vector BLUE=<0.00000, 0.00000, 1.00000>;
vector BABYBLUE=<0.00000, 1.00000, 1.00000>;
vector PINK=<1.00000, 0.00000, 1.00000>;
vector PURPLE=<0.57338, 0.25486, 1.00000>;
vector BLACK= <0.00000, 0.00000, 0.00000>;
vector WHITE= <1.00000, 1.00000, 1.00000>;
integer UNLOCKED=FALSE;
integer LOCKED=TRUE;
update_inventory(){
    integer index=0;
    total_items = llGetInventoryNumber(INVENTORY_TEXTURE);
    while (index < total_items){
                string item_name= llGetInventoryName(INVENTORY_TEXTURE, index);
 
                 textures+=item_name;
                 llInstantMessage(llGetOwner(), "Adding "+item_name+" to the presentation.");
                ++index;
            }
            if (total_items!=0){
                llSetTexture(llList2String(textures, current_slide), ALL_SIDES);
            }
}
menu(key user_key){
            string lock_message;
            if (user_key==llGetOwner()){
                list timer_option;
                list menu_options;
                list lock_option;
                list silent_option;
                if (timer_status=="on"){
                    timer_option=["Stop Timer"];
                }else{
                    timer_option=["Start Timer"];
                }
                if (LOCK==TRUE){
                    lock_option=["unlock"];    
                    lock_message="Slide show is currently locked";
 
                }else{
                    lock_option=["lock"];
                    llSay(0,"currently unlocked");
                    lock_message="Slide show is currently unlocked";
                }
                if (SILENT==FALSE){
                    silent_option=["Messages on"];    
                }else{
                    silent_option=["Messages off"];
                }
                menu_options = ["Reset","Set Timer"]+ timer_option+ ["Next", "Previous"]+lock_option+silent_option;
                llDialog(user_key, lock_message+"\nSlide "+(string)(current_slide+1)+" of "+(string)llGetListLength(textures)+".\nPlease select an option", menu_options,MENU_CHANNEL);
            }
            else{
                if (LOCK==FALSE){
                    llDialog(user_key, "Please select an option", ["Next","Previous"],MENU_CHANNEL);
                }else{
                    llDialog(user_key, "Sorry, only "+(string)llKey2Name(llGetOwner())+" is allowed to control this presenter", ["Ok"],MENU_CHANNEL);
                }
            }
}
next_slide(key user_key){
        current_slide++;
        if (current_slide>llGetListLength(textures)-1){                
            current_slide=0;
        }
        if (SILENT==FALSE){
            //say to all users
            llSay(0,"Advancing to slide "+(string)(current_slide+1));
        }else{
            //say only to user who pressed
            if (user_key!=NULL_KEY){
                llInstantMessage(user_key, "Going to slide "+(string)(current_slide+1));
            }
        }
        llSetTexture(llList2String(textures, current_slide), ALL_SIDES);
}
prev_slide(key user_key){
        current_slide--;
        if (current_slide<0){                
            current_slide=llGetListLength(textures)-1;
        }
        if (SILENT==FALSE){
                    //say to all users 
                    llInstantMessage(user_key, "Going to slide "+(string)(current_slide+1));
        }else
            //say only to user who pressed
            if (user_key!=NULL_KEY){
                llInstantMessage(user_key, "Going to slide "+(string)(current_slide+1));
            }
 
        llSetTexture(llList2String(textures, current_slide), ALL_SIDES);
}
default {
    state_entry() {
        llSetText("", RED, 1);
        LOCK=TRUE;
        MENU_CHANNEL=random_integer(-900000-30,000);
        TEXT_BOX_CHANNEL=random_integer(-1900000,-900000);
        llListen(MENU_CHANNEL, "", "", ""); 
        llListen(TEXT_BOX_CHANNEL, "", "", "");
        update_inventory();
 
 
    }
    touch_start(integer num_detected) {
        integer n;
 
        for (n=0;n<num_detected;n++){
            menu(llDetectedKey(n));
 
        }
    }
    listen(integer channel, string name, key user_key, string command) {
 
        if (channel==MENU_CHANNEL){
            if (command=="Reset"){
                llShout(0,"Reseting Presenter"); 
                llResetScript();
            }else
            if (command=="lock"){
                if (user_key!=llGetOwner()){
                    llSay(0,"Sorry, only "+llKey2Name(llGetOwner())+" is allowed to lock the presenter.");
                    return;
                }//only allow owner to control if presenter is locked
                LOCK = TRUE;
                llInstantMessage(user_key, "Presenter locked.");
            }else
            if (command=="unlock"){
                if (user_key!=llGetOwner()){
                    llSay(0,"Sorry, only "+llKey2Name(llGetOwner())+" is allowed to lock the presenter.");
                    return;
                }//only allow owner to control if presenter is locked
                LOCK = FALSE;
                llInstantMessage(user_key, "Presenter unlocked.");
            }else
            if (command=="Messages off"){
                if (user_key!=llGetOwner()){
                    llSay(0,"Sorry, only "+llKey2Name(llGetOwner())+" is allowed to turn messages off.");
                    return;
                }//only allow owner to control if presenter is locked
                SILENT = TRUE;
                llInstantMessage(user_key, "Messages off.");
            }else
            if (command=="lock"){
                    if (user_key!=llGetOwner()){
                    llSay(0,"Sorry, only "+llKey2Name(llGetOwner())+" is allowed to turn messages on.");
                    return;
                }//only allow owner to control if presenter is locked
                SILENT = FALSE;
                llInstantMessage(user_key, "Messages on.");
            }else
            if (command=="Set Timer"){
                if (user_key!=llGetOwner()){return;}//only allow owner to control
                //http://wiki.secondlife.com/wiki/LlTextBox
                llTextBox( user_key, "Please enter the time in seconds", TEXT_BOX_CHANNEL);
            }else
            if (command=="Start Timer"){
                if (user_key!=llGetOwner()&&LOCK==TRUE){return;}//only allow owner to control if presenter is locked
                llSetTimerEvent(1);
                timer_status="on";
                llInstantMessage(user_key, "Time started");
            }else
            if (command=="Stop Timer"){
                if (user_key!=llGetOwner()&&LOCK==TRUE){return;}//only allow owner to control if presenter is locked
                llSetTimerEvent(0);
                timer_status="off";
                llSetText("", RED, 1);
                llInstantMessage(user_key, "Timer stopped");
            }else
            if (command=="Previous"){
 
                if (user_key!=llGetOwner()&&LOCK==TRUE){//only allow owner to control if presenter is locked
                    llSay(0,"Sorry, only "+llKey2Name(llGetOwner())+" is allowed to change the slides.");
                    return;
                }
                prev_slide(user_key);
            }else
            if (command=="Next"){
                if (user_key!=llGetOwner()&&LOCK==TRUE){
                    llSay(0,"Sorry, only "+llKey2Name(llGetOwner())+" is allowed to change the slides.");
                return;
                }
                next_slide(user_key);
 
            }
        }else if (channel==TEXT_BOX_CHANNEL){
            if (user_key!=llGetOwner()){
                llInstantMessage(user_key,"Sorry, only "+llKey2Name(llGetOwner())+" change the timer.");
                return;
            }
            SLIDE_DELAY=(integer)command;
            if (SLIDE_DELAY==0){
                llSetTimerEvent(0);
                timer_status="off";
                llInstantMessage(user_key,"Slideshow stopped");
                llSetText("", RED, 1);
            }else{
                llInstantMessage(user_key,"Slide delay set to "+(string)SLIDE_DELAY);
                timer_status="on";
                llSetTimerEvent(1);
            }
        }
            menu(user_key);
    }
    timer() {
 
        slide_timer_counter++;
        if ((SLIDE_DELAY-slide_timer_counter)<0){
            slide_timer_counter=0;
            next_slide(NULL_KEY);
        }
         llSetText("Time before next slide: "+(string)(SLIDE_DELAY-slide_timer_counter), RED, 1);
 
    }
     changed(integer change)
    {
        // Was it an inventory change?
        if ((change & CHANGED_INVENTORY) == CHANGED_INVENTORY) {
            update_inventory();
        }
    }
}
