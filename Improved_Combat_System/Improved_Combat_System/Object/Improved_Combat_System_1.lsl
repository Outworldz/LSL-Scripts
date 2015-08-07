// :CATEGORY:Combat
// :NAME:Improved_Combat_System
// :AUTHOR:shesuka
// :CREATED:2013-03-06 12:40:30.970
// :EDITED:2013-09-18 15:38:55
// :ID:398
// :NUM:554
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// An updated combat system.// // I have changed a great deal in this script. Please refer     to the original version to see the changes.//   //  Also i use the name HUD when referring to the cs as I am used to scripting combat systems that have a  full HUD setup. Even though this system has no  HUD so to speak i will be using HUD as a reference to  this system.// 
Based on <a href="http://www.outworldz.com/cgi/freescripts.plx?ID=1430">http://www.outworldz.com/cgi/freescripts.plx?ID=1430</a>
// :CODE:
// This script is free for use, and may be set with any perms  you wish, and even sold; it is only to be sold if it is   modified. Under no circumstances should you sell this free  and opensource code to anyone, beyond the basic 1L for  'gift-item' purposes. This original code should remain  full-perms unless modified.

// THIS SYSTEM CAN SHOULD BE PLACED IN A PRIM FLOATING ABOVE   THE HEAD

string csName = "[Enter CS Name Here]";//Displays the name of your Combat System in floating text. So your system entry for this line may look something like string csName = "[THE FUNKY COMBAT SYSTEM]";
integer chan = 4; //Defining this as 4 means that the player can use the various commands for the HUD on channel 4.
integer health = 100; //Your standard Health Amount.
integer healthMax = 100; //Your maxmimum Health Amount.
integer resist = 10; //Resistance to damage taken.
vector color = <1,1,1>; //Colour of the CS Text above the head.
integer healthInc = 5; //Time between each health regeneration.
string customTitle = "Unamed Player"; //Your own custom title or name that users can set to be displayed in the overhead text via one of the new commands i added.
key user; //Key of person playing (DONT EDIT).
integer deathStatus = 0; //If 1 then dead, else not dead. Used in the timer to let the timer know that if the status is 1 then revive and re set status to 0 (DONT EDIT).
integer hudStatus = 0; //If 1 then HUD is activate else HUD is in offline mode (DONT EDIT).
string statusText = "HUD OFFLINE"; //To be displayed in the overhead text if hud is online this will be changed later in the script (DONT EDIT).

setStatusText(){
    llSetText(csName + "\n" + "Health : " + (string)health + " / " + (string)healthMax + "\n" +  customTitle + "\n" + statusText, color, 1.0);
}
    
default{
    attach(key attached){
        if(attached == NULL_KEY){
            llSay(0, (string)llKey2Name(user) + " has detached their " + (string)csName); //Says this on channel 0 if they detatch "Shesuka Resident has detached their FUNKY COMBAT SYSTEM
        }else{
            hudStatus = 0; //On attach the HUD is off by default.
            statusText = "HUD OFFLINE"; //On attach HUD displays it is off by default.
            user = llGetOwner(); //Defines the user variable from above as the owners key. Reason i did this is it means you do not have to reset each time a new owner is given the HUD.
            llRequestPermissions(user, PERMISSION_TRIGGER_ANIMATION); //Requests the users permissions to play animations.
            llListen(chan, "", user, ""); //Listen on the channel chan and only to the user.
            setStatusText(); //Our global status variable. The handy thing about global variables is i only need to write llSetText once at the top of the script and then i can just user setStatusText(); instead of writing out the full set text line each time.
            llOwnerSay("Welcome to the " + (string)csName + ". " + "Please type /4help for a list of commands to help you activate and use this system"); //Tells the user on attach what to do and gives them a welcome message.
        }
    }
    listen(integer channel, string name, key id, string message){
        if(channel == chan){
            if(id == user){
                if(message == "help"){
                    //Displays the list of commands you can do with this system.
                    llOwnerSay("Command for this System are typed onto channel " + (string)chan + " and are as follows : " + "\n" +  "1. To activate the system type : /4on" + "\n" + "2. To deactivate the system type : /4off" + "\n" + "3. To change your title/name type : /4title (name) so for example you might type..../4title THE GREAT BASINGA...." + "\n" + "4. To change your Overhead Text color type : /4color (vector colour) so for example you might type..../4color <1,0,0>....which would set the overhead text to red.");
                }else if(message == "on"){
                    hudStatus = 1; //Set to 1 as HUD is on. Setting as 1 and 0 is the same as using TRUE and FALSE.
                    statusText = "HUD ONLINE"; //Sets the HUD text status to "HUD ONLINE".
                    setStatusText(); //Again calling this global function to update the overhead text to show the HUD is online.
                llOwnerSay((string)csName + " is now online"); //Telling player the HUD is online
                }else if(message == "off"){
                    hudStatus = 0; //Set to 0 as HUD is now off.
                    statusText = "HUD OFFLINE"; //Sets the HUD text status back to "HUD OFFLINE".
                    setStatusText(); //Now calling to update the overhead text to display the offline status of the HUD.
                    llOwnerSay((string)csName + " is now offline"); //Telling player the HUD is offline.
                }else if(llGetSubString(message, 0,4) == "title"){ //checking if the first five letters of the message say title.
                    if(llGetSubString(message, 5,-1) != ""){ //Checking if letters 5 to the last letter do not equal nothing.
                        customTitle = llGetSubString(message, 5,-1); //Assign letters 5 to end (name etc) as the new title.
                        llOwnerSay("You have changed your title to " + customTitle + "."); //Telling the user that their name is successfully changed.
                        setStatusText(); //Update overhead text to display new name.
                    }
                }else if(llGetSubString(message, 0,6) == "color"){ //If the first 7 letters say color.
                        if(llGetSubString(message, 7,-1) != ""){ //if letters/symbols etc etc 7 to end do not equal nothing.
                            color = (vector)llGetSubString(message, 7,-1); //Set the new color of the overhead text as whatever colour is set from 7 to end in the message.
                            setStatusText(); //Update new color to overhead text.
                        }
                }else{
                    llOwnerSay("Unknown command please try again"); //If a help command is entered wrongly then it will display this message.
                }
            }
        }
    }
    collision_start(integer num){
        if(hudStatus == 0)return;
        if(llDetectedType(0) == AGENT_BY_LEGACY_NAME)return;//if the detected object is an agent then do not go any further.
            integer damage = llRound(llVecMag(llDetectedVel(0))/resist);
            health -= damage;//Health is minus the bullet velocity divided by the resist and then the damage is taken off the health. 
            setStatusText(); //Update over head text to display new health.
            llSetTimerEvent(10); //Instead of having individual times and multiple timers as this is a script for beginners we are going to use a default value of 10 for all timers. This one will increase health.
            if(health <= 0){
                deathStatus = 1; //As status now equals 1
                llShout(0, (string)llKey2Name(user) + " has died in combat."); //Announce players death.
                llStartAnimation("death");
                health = 0; //so if health is reduced to below 0 this will automatically make health equal 0 so you don't go into negative numbers.
                setStatusText(); //update new health to overhead text.
                llSetTimerEvent(10); //This will start the timer again at 10 seconds but with the deathStatus added this will also deal with how long you stay dead for.
            }
        }
    timer(){
        if(health < healthMax){//If health is less than the max health available.
            health += 20; //So every 10 seconds add 20 health.
            if(health > healthMax){ //Checking if health is greater than healthMax.
                health = healthMax; //If so health is equal healthMax.
            }
            setStatusText(); //update health regain to overhead text.
        }else if(deathStatus == 1){ //if death status is true (1).
            llStopAnimation("death"); //stop the death animation.
            llOwnerSay("You have been revived"); //alert the player.
        }
    }
}
            
            
