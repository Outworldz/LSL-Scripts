// :CATEGORY:Combat
// :NAME:OpenSource_Combat_System
// :AUTHOR:Tyro Dreamscape
// :CREATED:2010-03-03 12:56:36.693
// :EDITED:2013-09-18 15:38:59
// :ID:597
// :NUM:819
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Here it is:// (best used when compiled in mono)// // Also note, armor ratings are based on AC; velocity of bullet divided by AC equals damage. Set AC higher to take less damage.
// :CODE:
// Basic Physics-Based Combat System (Open-Source)
// Created by Tyro Dreamscape
// Source Version: v1.1

// This script is free for use, and may be set with any perms you wish, and even sold; it is only to be sold if it is modified. Under no circumstances should you sell this free and opensource code to anyone, beyond the basic 1L for 'gift-item' purposes. This original code should remain full-perms unless modified.

// This system does NOT accept melee damage. Only physical damage from bullets. It is able to have custom titles and colors of text.

// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- CODE BELOW -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
// -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- CODE BELOW -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-


string CSname = "[UnnamedCS v1.1]"; // The title displayed over the CS
integer userCHAN = 4;  // The channel users use for commands
string adminKEY = "fe0f105a-3a2a-4d70-ad1e-6cac0da5388d"; //The key of the Admin, who uses /5heal and /5kill plus a name to do stuff

integer HEALTH = 100;  //Basic health to start with
integer AC = 35; // Resistance to damage. Bullet vel/AC = damage taken.
vector COLOR = <1,1,1>; // The color of the meter text
integer REGENRATE = 5; // Time between each regeneration of 1 HP
integer DOWNTIME = 15; // How long you remain unconcious after being downed
string CUSTOMtitle = ""; // The starting title between CS name and stats
// ^^^^^^^ SETTINGS  ^^^^^^^

key OWNER; // Not to be changed...
integer DAMAGE; // Not to be changed...
integer DEAD = FALSE; // Not to be changed...

default  // ~~~~~~~~~~~~~~OFFLINE STATE~~~~~~~~~~~~~
{
    state_entry()
    {
        llReleaseControls();
        OWNER = llGetOwner();
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
        
        llStopAnimation("DOWNED");
        
        llListen(userCHAN,"",llGetOwner(),"");
        llListen(5,"",adminKEY,"");
        HEALTH = 100;
        integer DEAD = FALSE;
        llSetText(CSname + CUSTOMtitle + "\nOFFLINE", COLOR, 1.0);
        llOwnerSay("-\nOFFLINE\nSay /4on to enable system. '/4color (vector)' will change hovertext. '/4title (text)' will add a custom title.\n'/4reset' will perform a hard reset of the scripts, and can be performed at any time... but will lose you ANY and ALL saved information.");
    }
    
    attach(key id)  // This resets the whole system if a new owner is detected
    {
        if(OWNER != llGetOwner())
        {
            llOwnerSay("New owner detected. Performing total wipe of memory...");
            llSleep(2);
            llOwnerSay("Welcome to " + CSname + ". This system ONLY accepts physical damage, modified by a set ArmorClass or AC."); // The new owner Welcome Message.
            llResetScript();
        }
    }
    
    listen(integer channel, string name, key id, string message) // Here be all commands.
    {
        string MSG = llToLower(message); // Changes all commands to lowercase so it ain't case-sensitive
        if(channel == 4)
        {
            if(message == "reset")
            {
                llOwnerSay("Performing total reset...");
                llResetScript();
            }
            
            if(message == "on")
            {
                state ARMED;
            }
         
            if(llGetSubString(MSG,0,4) == "title") //Setting Titles
            {
                if(llGetSubString(message,5,-1) != "")
                {
                    CUSTOMtitle = "\n" + llGetSubString(message,5,-1) + "\n";
                    llSetText(CSname + CUSTOMtitle + "\nOFFLINE", COLOR, 1.0);
                }
                else
                {
                    CUSTOMtitle = "";
                    llSetText(CSname + CUSTOMtitle + "\nOFFLINE", COLOR, 1.0);
                }
            }
            
            if(llGetSubString(MSG,0,4) == "color") //Setting colors.
            {
                if(llGetSubString(message,5,-1) != "")
                {
                    COLOR = (vector)llGetSubString(message,6,-1);
                    llSetText(CSname + CUSTOMtitle + "\nOFFLINE", COLOR, 1.0);
                }
                else
                {
                    COLOR = <1,1,1>;
                    llSetText(CSname + CUSTOMtitle + "\nOFFLINE", COLOR, 1.0);
                }
            }
        }
        else // Everything here is ADMIN ONLY command!
        {
            if(message == "kill " + llKey2Name(llGetOwner()))
            {
                llOwnerSay("You were AdminKilled by: " + name);
                state down;
            }
        }    // Everything here is ADMIN ONLY command!
    }
}

state ARMED    // ~~~~~~~~~~~~~~ONLINE STATE~~~~~~~~~~~~~
{
    state_entry()
    {
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
        llReleaseControls();
        llStopAnimation("dead");
        
        llListen(userCHAN,"",llGetOwner(),"");
        llListen(5,"",adminKEY,"");
        llSetTimerEvent(REGENRATE);
        llSetText(CSname + CUSTOMtitle + "\nHP: "+(string)HEALTH, COLOR, 1.0); // Set text for meter!
        llOwnerSay("-\nONLINE\nSay /4off to disable system.");
    }
    
    attach(key id) // This resets the whole system if a new owner is detected
    {
        if(OWNER != llGetOwner())
        {
            llOwnerSay("New owner detected. Performing total wipe of memory...");
            llResetScript();
        }
    }
    
    collision_start(integer total_number)  // THIS IS WHERE DAMAGE IS CALCULATED
    {
        //key BLEG = llDetectedKey(0);
        if(llDetectedType(0) != AGENT)
        {
            
            DAMAGE = llRound(llVecMag(llDetectedVel(0))) / AC;  
            // The damage you take is 'bullet velocity' divided by 'AC'. So, 100m per second bullets would normally do 10 damage each to a 10 AC individual.
            HEALTH = HEALTH - DAMAGE; // Subtract health...
            llSetText(CSname + CUSTOMtitle + "\nHP: "+(string)HEALTH, COLOR, 1.0); // Refresh text to show new status
            if(HEALTH <= 0) // If you're out of health...
            {
                llShout(0, "/me -- "+llKey2Name(llGetOwner())+ " has been DEFEATED");
                state down; // ...drop dead.
            }
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        string MSG = llToLower(message);
        if(channel == 4)
        {
            if(message == "reset")
            {
                llOwnerSay("Performing total reset...");
                llResetScript();
                llShout(0, llKey2Name(llGetOwner()) + " is resetting while combative..."); // Alert others to possible cheating attempt >.>
            }
            
            if(message == "off")
            {
                state default;
            }
         
            if(llGetSubString(message,0,4) == "title")
            {
                if(llGetSubString(message,5,-1) != "")
                {
                    CUSTOMtitle = "\n" + llGetSubString(message,5,-1) + "\n";
                    llSetText(CSname + CUSTOMtitle + "\nHP: "+(string)HEALTH, COLOR, 1.0);
                }
                else
                {
                    CUSTOMtitle = "";
                    llSetText(CSname + CUSTOMtitle + "\nHP: "+(string)HEALTH, COLOR, 1.0);
                }
            }
            
            if(llGetSubString(MSG,0,4) == "color")
            {
                if(llGetSubString(message,5,-1) != "")
                {
                    COLOR = (vector)llGetSubString(message,6,-1);
                    llSetText(CSname + CUSTOMtitle + "\nHP: "+(string)HEALTH, COLOR, 1.0);
                }
                else
                {
                    COLOR = <1,1,1>;
                    llSetText(CSname + CUSTOMtitle + "\nHP: "+(string)HEALTH, COLOR, 1.0);
                }
            }
        }
        else // Everything here is ADMIN ONLY command!
        {
            if(message == "kill " + llKey2Name(llGetOwner()))
            {   
                llOwnerSay("You were AdminKilled by: " + name);
                state down;
            }
            
            if(message == "heal " + llKey2Name(llGetOwner()))
            {   
                llOwnerSay("You were AdminHealed by: " + name);
                HEALTH = HEALTH + 10;
            }
        } // Everything here is ADMIN ONLY command!
    }
    
    timer() // The timer for regeneration
    {
        if(DEAD == FALSE)
        {
            if(HEALTH >= 100)
            {
                // Do Nothing...
            }
            else
            {
                HEALTH++; // Regenerate 1 HP
                llSetText(CSname + CUSTOMtitle + "\nHP: "+(string)HEALTH, COLOR, 1.0); // Refresh title
            }
        }
        else
        {
            state down;
        }
    }
}

state down   // ~~~~~~~~~~~~~~DEAD STATE~~~~~~~~~~~~~
{
    state_entry()
    {
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
        
        llStartAnimation("dead");
        
        llListen(userCHAN,"",llGetOwner(),"");
        llListen(5,"",adminKEY,"");
        integer DEAD = TRUE;
        llRequestPermissions(llGetOwner(),PERMISSION_TAKE_CONTROLS);
        llSetText(CSname + CUSTOMtitle + "\nUNCONSCIOUS", <1,0,0>, 0.7);
        
        llSetTimerEvent(DOWNTIME);
    }
    
    run_time_permissions(integer perm)
    {
        if(PERMISSION_TAKE_CONTROLS & perm)
        {
            llTakeControls(CONTROL_FWD |
                           CONTROL_BACK |
                           CONTROL_LEFT |
                           CONTROL_RIGHT |
                           CONTROL_ROT_LEFT |
                           CONTROL_ROT_RIGHT |
                           CONTROL_UP |
                           CONTROL_DOWN,TRUE,FALSE );
        }
    }
    
    attach(key id) // This resets the whole system if a new owner is detected
    {
        if(OWNER != llGetOwner())
        {
            llOwnerSay("New owner detected. Performing total wipe of memory...");
            llResetScript();
        }
    }
    
    timer() // Downtime expired...
    {
        state default; //...reset to offline status
    }
    
    listen(integer channel, string name, key id, string message)
    {
        string MSG = llToLower(message);
        if(channel == 4)
        {
            if(message == "reset")
            {
                llOwnerSay("Performing total reset...");
                llShout(0, llKey2Name(llGetOwner()) + " is resetting while down..."); // Alert others to possible cheating attempt >.>
                llResetScript();
            }
         
            if(llGetSubString(MSG,0,4) == "title")
            {
                if(llGetSubString(message,5,-1) != "")
                {
                    CUSTOMtitle = "\n" + llGetSubString(message,5,-1) + "\n";
                    llSetText(CSname + CUSTOMtitle + "\nUNCONSCIOUS", <1,0,0>, 0.7);
                }
                else
                {
                    CUSTOMtitle = "";
                    llSetText(CSname + CUSTOMtitle + "\nUNCONSCIOUS", <1,0,0>, 0.7);
                }
            }
            
            if(llGetSubString(MSG,0,4) == "color")
            {
                if(llGetSubString(message,5,-1) != "")
                {
                    COLOR = (vector)llGetSubString(message,6,-1);
                    llSetText(CSname + CUSTOMtitle + "\nUNCONSCIOUS", <1,0,0>, 0.7);
                }
                else
                {
                    COLOR = <1,1,1>;
                    llSetText(CSname + CUSTOMtitle + "\nUNCONSCIOUS", <1,0,0>, 0.7);
                }
            }
        }
        else // Everything here is ADMIN ONLY command!
        {
            if(message == "heal " + llKey2Name(llGetOwner()))
            {
                llOwnerSay("You were AdminHealed by: " + name);
                state ARMED;
            }
        } // Everything here is ADMIN ONLY command!
    }
}
