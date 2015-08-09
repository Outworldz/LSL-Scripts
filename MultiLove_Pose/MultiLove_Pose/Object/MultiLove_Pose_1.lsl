// :CATEGORY:Pose Balls
// :NAME:MultiLove_Pose
// :AUTHOR:Miffy Fluffy
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:541
// :NUM:727
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Multi-Love Pose.lsl
// :CODE:

//MLP MULTI-LOVE-POSE 1.0 - Copyright (c) 2006, by Miffy Fluffy (BSD License)
//To donate, go to my profile (Find - People - Miffy Fluffy) and use the "Pay..." button, thanks!
//You can also find the link to the latest version here.

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
// ~pose1 & pose2:
//  - will ask permission to animate the avatar on ball 1&2
//  - will set the animations to avatar 1&2
//
// ~ball
//  - when balls are defined for a submenu (in .MENUITEMS), ~menu will rez two copies of ~ball
//  - ball 1&2 will receive a unique communication channel from ~menu
//  - the color for ball 1&2 is set by ~menu
//  - the position of ball 1&2 is set by ~pos
//  - when an avatar selects to sit on a ball, the avatar info is sent to ~pose1 or ~pose2, they
//    will ask permission and set the animation directly to the avatar (not via the ball)
//  - balls will commit suicide when they don't hear a "LIVE" message each minute (from ~menu).
//
// have fun!

//Note: if you make a revised version, please mention something like this:
//"MLP - alternative version by ... .... - Revision 1 (based on MLP 1.0 by Miffy Fluffy)

setRunning(integer st) {
    llSetScriptState("~menu", st);
    llSetScriptState("~pos", st);
    llSetScriptState("~pose", st);
    llSetScriptState("~pose1", st);
    llSetScriptState("~pose2", st);
    llResetOtherScript("~menu");
    llSetScriptState("~memory", TRUE);
}
default {
    state_entry() {
        llOwnerSay("OFF (touch to switch on)");
        setRunning(FALSE);
    }
    touch_start(integer i) {
        if (llDetectedKey(0) == llGetOwner()) state run;
    }    
}
state run {
    state_entry() {
        llOwnerSay("Starting...");
        setRunning(TRUE);
    }
}
// END //
