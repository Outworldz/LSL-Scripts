// :CATEGORY:Combat
// :NAME:The_Terra_Combat_System_TCS
// :AUTHOR:Cubey Terra
// :CREATED:2010-07-01 15:11:14.270
// :EDITED:2013-09-18 15:39:07
// :ID:887
// :NUM:1259
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Sensor
// :CODE:
// TERRA COMBAT SYSTEM 2.5.4 by Cubey Terra
// Uses sensor to detect enemy targets and listens for hits on self
// Sends messages to HUD script
// October 26, 2004
// Version 2.1 - May 17 2006
// Version 2.5 - June 7 2007
// * No longer starts/stops physics.
// * Smoke particles moved to another script.
// * TCS no longer attempts to rename prim.

// A note to developers: I'm releasing this script as open-source
// in the hope that scripters can improve on it. Really, there is
// a LOT of room for improvement, since I wrote the core of TCS 
// before I really knew how to do it right. It's kind of a mess.
//
// This script is shared under a Creative Commons license, which means that:
// * You can freely share it.
// * You can make derivative works from it.
//
// Under the following conditions:
// * You must attribute me (Cubey Terra) as original author of the script.
// * If you modify or add to this script in any way, you must apply a compatible license.
//   This means that the script remains with FULL PERMISSIONS ALWAYS
//   (Modify/Copy/Transfer)
//
// For the full Creative Commons license, see:
// http://creativecommons.org/licenses/by-sa/3.0/us/
// 
// Please improve on this, but if you do, share your improvements
// with others. Also, please try to keep it backwards-compatible
// with this version, so that people with older TCS planes can
// take part in dogfights.
//
// Happy scripting!
// -Cubey Terra
// July 15, 2009





float TIMER_INT = 0.25;

integer firing;
//integer reloading;
//integer reloadTime = 1;
//integer currReload;

integer combat_channel = 2224; // Chat channel on which the vehicle sends/receives combat info

//key agent;
integer max_hit_points = 10;
float regenSec = 30; // number of seconds after death before allowing a restart
float currRegenSec;

integer hit_points;
integer avatars_hit;
integer avatars_killed;
integer deaths;
key pilot;
integer combatListen;
integer listentrack2;
key killer; // The one who deals the killing shot
//string hit_name;
integer crashed;

integer sit;

integer combat = FALSE;

vector hovertext_colour = <0,1,0>;

vector deathPush = <0,0,-5>;

pilotListen(integer turnOn)
{
    if (listentrack2) // Check for and add listener for pilot chat commands
    {
        llListenRemove(listentrack2);
        listentrack2 = 0;
    } 
    if (turnOn) listentrack2 = llListen(0, "", pilot, "");
}


combatOn()
{
    combat = TRUE;
    if (combatListen) // Check for and add listener for combat messages
    {
        llListenRemove(combatListen);
        combatListen = 0;
    } 
    combatListen = llListen(combat_channel, "", "", "");
        
    llSetTimerEvent(TIMER_INT);
    llSay(0,"Terra Combat System is ON. You are vulnerable to attack.");
    updateHUD();
}

combatOff()
{
    combat = FALSE;
    llListenRemove(combatListen);
    combatListen = 0;

    llSetTimerEvent(0.0);
    
    llSay(0,"Terra Combat System is OFF.");
}


init()
{
    crashed = FALSE;
    
    // Reset HUD and points ---
    hit_points = max_hit_points;
    avatars_hit = 0;
    deaths = 0; 
    updateHUD();
}

updateHUD()
{
    llMessageLinked(LINK_SET, max_hit_points, "tc init hit points", "");
    llMessageLinked(LINK_SET, hit_points, "tc hit points", "");
    llMessageLinked(LINK_SET, deaths, "tc deaths", "");
    llMessageLinked(LINK_SET, avatars_killed, "tc avatars killed", "");
}

crash()
{
        llMessageLinked(LINK_SET, 0, "tc crash", "");
        string dText = "TERRA COMBAT SYSTEM\n\n"+llKey2Name(killer)+" shot you down! Your vehicle will regenerate in "+(string)((integer)regenSec)+" seconds.";
        llDialog(pilot,dText,[],1);
        llShout(combat_channel,(string)killer+(string)pilot);
        crashed = TRUE;
}




//========================================================================
//========================================================================
//========================================================================

default
{
    state_entry()
    {
        init();
        
    }
    
    on_rez(integer num)
    {
        llResetScript();
        
    }
    
    
    // SENSORS ====================================================================
    sensor(integer total_number)
    {
        integer i;
        for ( i = 0; i < total_number; i++ ) // allow for possibility of more than one av in shot
        {
            if (llDetectedKey(i) != pilot)
            {
                llSay(0,llKey2Name(pilot)+" hit " + llDetectedName(i) + ".");
                llShout(2224,"hit " + llDetectedName(i));
                avatars_hit += 1;
                llMessageLinked(LINK_SET, avatars_hit, "tc avatars hit", "");
            }
        }
    }
    
    
    // LINK MESSAGES ====================================================================
    link_message(integer sender_number, integer number, string message, key id)
    {
        
        if ((message == "tc ctrl") && combat)
        {
            
            // The the vehicle script should pass the held (or "level") integer to this script
            integer ctrl = number;
            if ((ctrl & CONTROL_ML_LBUTTON) || (ctrl & CONTROL_LBUTTON))
            {
                firing = TRUE;
                llSensor("", NULL_KEY, AGENT, 90, PI/20);
            }
            else firing = FALSE;
            
        } 
        else if (message == "tc on")
        {
            if (!combat) combatOn();
        }
        else if (message == "tc off")
        {
            if (combat) combatOff();
        }
        else if (message == "tc unseated")
        {
            if (combat && !crashed) combatOff();
            sit = FALSE;
        }
        
        else if (message == "tc uncrash")
        {
            crashed = FALSE;
        }
        else if (message == "tc seated")
        {
            pilot = id; // The TCS operator is now the ID passed to it from the TCS sit target script
            sit = TRUE;
            pilotListen(TRUE);
        }
        else if (message == "tc hud startup")
        {
            updateHUD();
        }
    } 
    
    // LISTEN ============================================================================
    listen(integer channel, string name, key id, string message)
    {
        if ((channel == combat_channel) && combat && sit)
        {
            // My object key is shouted, means I killed someone, apparently. This is so lame.
            if (llSubStringIndex(message, (string)llGetKey()) == 0) 
            {
                string victimKey = llGetSubString(message, 36, llStringLength(message));
                llSay(0,llKey2Name(pilot)+" shot down "+llKey2Name(victimKey)+"!"); // only works if victim is still in the sim
                avatars_killed += 1;
                updateHUD();
            }
            
            // If a TCS message begins with "hit" then an agent has been hit. Who?
            else if (llSubStringIndex( llToLower(message), "hit") == 0)
            {
                // a hit message is in this format:
                // hit <detected avatar name>
                string hitName = llGetSubString(message, 4, -1); 
                
                if ((hitName == llKey2Name(pilot)) && (!crashed)) // not a valid hit if already crashed
                {
                    // The name and id of shooter would be the name/id of the object doing the shooting,
                    // and not the name of the object's owner.
                    string shooterName = name;
                    string shooterId = id;
                    
                    if (hit_points > 1) // Still have hp remaining...
                    {
                        hit_points -= 1;
                        llSay(0,shooterName + " shot you. You have " + (string)hit_points + " hit points.");
                        updateHUD();
                    }
                    else // No more hp remaining! Vehicle is toast!
                    {
                        hit_points = 0;
                        killer = shooterId; 
                        updateHUD();
                        crash();
                    }
                }
            }
        }
        if (channel == 0)
        {
            string msg = llToLower(message);
            if (msg == "combat on" && sit)
            {
                // only link message sent here to avoid repeated link messages
                llMessageLinked(LINK_SET, 0, "tc on", "");
                updateHUD(); 
            }
            if (msg == "combat off")
            {
                // only link message sent here to avoid repeated link messages
                llMessageLinked(LINK_SET, 0, "tc off", "");
                updateHUD();
            }
            
            if (msg == "beacon on")
            {
                llMessageLinked(LINK_SET, 0, "tc beacon on", ""); 
            }
            else if (msg == "beacon off")
            {
                llMessageLinked(LINK_SET, 0, "tc beacon off", ""); 
            }
            
            
            if (msg == "tc help")
            {
                string txt = "Terra Combat System:\n
                To turn on/off TCS, say COMBAT/ ON or COMBAT/ OFF.\n
                To fire the gun:\n\tIn Mouselook view, hold your mouse button.\n\tIn 3rd-person view, click anywhere except on the vehicle.";
                llDialog(pilot,txt,[],1);
            }
        }
        

    }
    
    timer()
    {
        
        if (crashed)
        {
            currRegenSec += TIMER_INT;
            integer timeLeft = (integer)(llRound(regenSec - currRegenSec));
            llMessageLinked(LINK_SET, timeLeft, "tc regen", "");
            //llSetStatus(STATUS_PHYSICS, TRUE);
            //llApplyImpulse(deathPush,0);
            if (timeLeft <= 0)
            {
                //llSetStatus(STATUS_PHYSICS, FALSE);
                currRegenSec = 0;
                llMessageLinked(LINK_SET, 0, "tc uncrash", "");
                crashed = FALSE;
                // Reset HUD and points ---
                hit_points = max_hit_points;
                avatars_hit = 0;
                deaths += 1;
                updateHUD(); 
                //---
                vector pos = llGetPos();
                string dText = "TERRA COMBAT SYSTEM\n\nYour aircraft has regenerated and is ready for combat. You can find it at "+llGetRegionName()+"("+(string)((integer)pos.x)+","+(string)((integer)pos.y)+"), at an altitude of "+(string)((integer)pos.z)+" meters.";
                llDialog(pilot,dText,[],1);
                //combatOff();
            }
        }
        
        else if (firing)
        {
            llSensor("", NULL_KEY, AGENT, 90, PI/20);
        }
    }
}
