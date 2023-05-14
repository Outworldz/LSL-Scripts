//MLPV2 Version 2.3 - Learjeff Innis, from
//MLP MULTI-LOVE-POSE V1.2 - Copyright (c) 20 06, by Miffy Fluffy (BSD License)
//To donate, go to my profile (Search - People - Miffy Fluffy) and use the "Pay..." button, thanks!
//You can also find the link to the latest version here.

integer MAX_AVS             = 6;
integer ResetOnOwnerChange  = FALSE;

// DESCRIPTION OF THE SCRIPTS
//
// ~run:
//  Default: sets other scripts to not running.
//  When the object is touched it will start all scrips.
//
// ~memory:
//  Here the positions are stored permanently. Information is still kept when the script is
//  not running or when everything is placed in inventory. The information will be lost only
//  when the ~memory script is reset.
//  A backup can be made on the .POSITIONS notecard, when the memory is empty, it will start
//  reading the .POSITIONS notecard automatically.
//
// ~menu:
//  1.loading: reads the .MENUITEMS notecard and builds the menu.
//    When it reads a "POSE": - the animations are stored in ~pose
//                            - their matching positions are looked up in ~memory and stored
//                              in ~pos.
//  2.ready:
//    When the object is touched: - shows the main menu
//                                - listens for menu selections.
//
//    When a submenu is selected: - shows the submenu
//                                - when balls are defined for this submenu it will rez
//                                  balls (if not already there) and set their colors.
//
//    When a pose is selected:  - ~pose will send the animations to ~pose1 and ~pose2,
//                                 they will set the animations to the avatars
//                              - ~pos wil send the matching positions to each ball.
//
//    When a position is saved: - ~pose will ask the balls for their position
//                              -  the positions are saved in ~memory ("permanent")
//                              -  the positions are updated in ~pos
//                                  
//    When "STOP" is selected:  - will hide the balls
//                              - will stop the pose
//                              When "STOP" is selected again (or if no pose is started yet):
//                              - will remove the balls (derez/die)
//
// ~pos:
//  - loads the positions from ~memory and stores them (until shutdown/restart)
//  - sends positions for the selected pose to the balls
//
// ~pose:
//  - loads the animations from the .MENUITEMS notecard and stores them (until shutdown/restart)
//  - sends animations for the selected pose to ~pose1 and ~pose2
//  - when saving a position: will ask balls for their position and sends it to ~pos and ~memory
//    (~pos would be a more logical place to handle this, but ~pose has more free memory).
//
// ~poser, ~poser 1, ~poser 2, ~poser 3 (one for each ball):
//  - will ask permission to animate the avatar on ball
//  - will set the animations to avatar
//
// ~ball
//  - when balls are defined for a submenu (in .MENUITEMS), ~menu will rez copies of ~ball
//  - each will receive a unique communication channel from ~menu
//  - the color for each ball is set by ~menu
//  - the position of each ball is set by ~pos
//  - when an avatar selects to sit on a ball, the avatar info is sent to the appropriate; they
//    will ask permission and set the animation directly to the avatar (not via the ball)
//  - balls will commit suicide when they don't hear a "LIVE" message each minute (from ~menu).
//
// have fun!

//Note: if you make a revised version, please mention something like this:
//"MLP - alternative version by ... .... - Revision 1 (based on MLP V1.2 by Miffy Fluffy)

key     Owner;

list Scripts = [
      "~menucfg"
    , "~pos"
    , "~pose"
    , "~poser"
    , "~poser 1"
    , "~poser 2"
    , "~poser 3"
    , "~poser 4"
    , "~poser 5"
    ];

list OptionalScripts = [
      "~props"
    , "~sequencer"
    ];

setRunning(integer st) {
    integer ix;
    list    scripts = Scripts;
    string  script;

    for (ix = 0; ix < 100; ++ix) {
        integer jx;
        
        // try to stop any remaining scripts in the list
        for (jx = llGetListLength(scripts) - 1; jx >= 0; --jx) {
            script = llList2String(scripts, jx);
            if (llGetInventoryType(script) == INVENTORY_SCRIPT) {
                llSetScriptState(script, st);
                scripts = llDeleteSubList(scripts, jx, jx);
                --jx;
            }
        }
        
        // got them all yet?
        if (llGetListLength(scripts) == 0) {
            // Yes -- handle key ones
            llSetScriptState("~memory", st);
            llSetScriptState("~menu", st);
            if (st) {
                llResetOtherScript("~memory");
                llResetOtherScript("~menu");
            }
            
            // start/stop optional scripts if present
            for (jx = llGetListLength(OptionalScripts) - 1; jx >= 0; --jx) {
                script = llList2String(OptionalScripts, jx);
                if (llGetInventoryType(script) == INVENTORY_SCRIPT) {
                    llSetScriptState(script, st);
                }
            }
            return;
        }

        llSleep(0.1);
    }

    llOwnerSay("missing scripts: " + llList2CSV(scripts));
}

setBalls(string cmd) {
    integer ch = channel();
    integer ix;

    for (ix = 0; ix < MAX_AVS; ++ix) {
        llSay(ch + ix, cmd);      //msg to balls
    }
}

integer channel() {
    return (integer)("0x"+llGetSubString((string)llGetKey(),-4,-1));
}

default {
    
    state_entry() {
        setBalls("DIE");
        Owner = llGetOwner();
        setRunning(FALSE);
        llOwnerSay("OFF (touch to switch on)");
    }

    touch_start(integer i) {
        if (llDetectedKey(0) == llGetOwner()) state run;
    }   
    
    // Waits for another script to send a link message.
    link_message(integer sender_num, integer num, string str, key id) {
        if (str == "PRIMTOUCH" && id == llGetOwner()) {
            state run;
        }
    }
    
    changed(integer change) {
        if (change & CHANGED_OWNER && Owner != llGetOwner()) {
            llResetScript();
        }
    }
}

state run {
    state_entry() {
        setRunning(TRUE);
    }
    changed(integer change) {
        if (ResetOnOwnerChange
            && (change & CHANGED_OWNER)
            && Owner != llGetOwner()) {
            llResetScript();
        }
    }
}
