// :CATEGORY:Pose Balls
// :NAME:Advanced_Poseball_Script
// :AUTHOR:Lymirah Gardner
// :CREATED:2012-08-10 15:13:00.260
// :EDITED:2013-09-18 15:38:47
// :ID:17
// :NUM:23
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This script began when I wanted to write my own poseball script and learn more LSL in the process.  It evolved as I added features to move it beyond a simple, one-prim poseball script.  Since I perform SL burlesque, this has led to further development and the script has turned out to be very useful.// The script now works for a linked prim (e.g., a poseball linked to a burlesque set, v1.5) and for multiple such poseballs linked together (e.g., poseballs for a group burlesque act, all linked to the set, v1.6 and 1.7).// All options are controlled by global variables (located immediately below the title box). They're labeled for easy use. You can enable/disable and modify hover text that automatically hides when you click/sit on the object (very useful for assigning people to specific poseballs in a group act). Use "\n" for multiple lines of hover text (if needed). You can enable/disable hiding of the object on click/sit (normal poseball operation). You can also modify the position of your avatar while performing the animation (via sittarget offset and sittarget rotation - useful for different animations).// I've tested the script for the identified functionality and it appears to work correctly.  If anyone has any recommendations, either for the existing code or additional features, please let me know! // (And fwiw, the forum posting totally destroyed my title box formatting.  Ugh.)// EDIT:  Btw, the reason I have the normal poseball function (object hiding) available as a toggle is for flexibility.  For example, I used a version of this script for an object in a burlesque set of mine to trigger a snow angel animation.  In that case, I didn't want the object/prim to hide - I just wanted click-sitting on it to trigger the animation (with me in the proper orientation). 
// 
// Copyright © 2009 Linden Research, Inc. Licensed under Creative Commons Attribution-Share Alike 3.0 unless otherwise noted.
// :CODE:
////////////////////////////////////////////////////////////////////////////////////////////////////////
// //
// Object Click-Sit-Animation Script by Lymirah Gardner, Version 1.7, 08 May 2012 //
// (First Written 06 March 2012) //
// //
// Clicking will sit on object & animate avatar. //
// Hover text and object hide controlled from global variables. //
// v1.5: Now works for a linked prim. Normal functionality retained for separate, unlinked objects. //
// v1.6: Now works correctly (individually) for multiple poseballs linked together. //
// v1.7: Bug fix for v1.6. //
// //
////////////////////////////////////////////////////////////////////////////////////////////////////////
// //
// Please feel free to share this script. It's meant for anyone and everyone! All I ask is that you //
// don't sell the script on its own or as part of any package, objects or products. It's provided //
// for free - please keep it that way! Please also keep this title box. //
// //
////////////////////////////////////////////////////////////////////////////////////////////////////////

//GLOBAL VARIABLES
string animation = "ANIMATIONNAME";              //change to animation name
vector sittarget = < 0.0, 0.0, 0.1>;              //adjust sittarget offset
vector sitangle = < 0.0, -90.0, -90.0>;               //adjust sittarget rotation in degrees

//WHO CAN USE THIS?  ONLY OWNER?
integer only_owner = 0;                         //toggle access: 1 = only owner, 0 = anyone

//TOGGLE HOVER TEXT AND/OR OBJECT HIDE (SEPARATELY)
integer HOV_ON = 1;                             //toggle hover text: 1 = on, 0 = off
integer OBJHIDE_ON = 1;                         //toggle object hide (poseball action): 1 = on, 0 = off

//MODIFY HOVER TEXT & COLOR
string HOVERTEXT = "Sit here or else!";         //hover text
vector COLOR = < 0.0, 0.0, 0.0>;                //color of hover text
                                                //black:        < 0.0, 0.0, 0.0>
                                                //gray:         < 0.5, 0.5, 0.5>
                                                //white:        < 1.0, 1.0, 1.0>
                                                //pink:         < 1.0, 0.0, 0.5>
                                                //red:          < 1.0, 0.0, 0.0>
                                                //orange:       < 1.0, 0.5, 0.0>
                                                //yellow:       < 1.0, 1.0, 0.0>
                                                //light green:  < 0.5, 1.0, 0.0>
                                                //green:        < 0.0, 1.0, 0.0>
                                                //blue-green:   < 0.0, 1.0, 0.5>
                                                //cyan:         < 0.0, 1.0, 1.0>
                                                //med-blue:     < 0.0, 0.5, 1.0>
                                                //blue:         < 0.0, 0.0, 1.0>
                                                //purple:       < 0.5, 0.0, 1.0>
                                                //magenta:      < 1.0, 0.0, 1.0>

//SIT MENU TEXT
integer SITTXT_ON = 1;                          //toggle sit menu text override: 1 = on, 0 = off
string SITTEXT = "Sit here!";                   //sit menu text

//OTHER GLOBAL VARIABLE DECLARATIONS
rotation sitrotation;
key owner;
key sitter = NULL_KEY;
integer SITTING;
integer LN;
integer LS;

//USER-DEFINED FUNCTION
integer test_sit() {
    if(LS == 1) {
        if(llAvatarOnLinkSitTarget(LN) != NULL_KEY) return 1;
        else return 0;
    }
    else if(LS == 0) {
        if(llAvatarOnSitTarget() != NULL_KEY) return 1;
        else return 0;
    }
    else return 0;
}

//START HERE
default {
    state_entry() {
        SITTING = 0;
        if(only_owner == 1) owner = llGetOwner();
        if(llGetNumberOfPrims() > 1) {
            LN = llGetLinkNumber();
            LS = 1;
        }
        else {
            LN = LINK_SET;
            LS = 0;
        }
        sitrotation = llEuler2Rot(sitangle * DEG_TO_RAD);          //deg to rad & --> rot
        llSitTarget(sittarget,sitrotation);                        //set sittarget
        llSetClickAction(CLICK_ACTION_SIT);                        //click action to sit
        if(SITTXT_ON) llSetSitText(SITTEXT);                       //set sit menu text
        if(HOV_ON) llSetText(HOVERTEXT,COLOR,1.0);                 //show hover text
        else llSetText("",<0.0,0.0,0.0>,1.0);                      //or make it null
        if(OBJHIDE_ON) llSetLinkAlpha(LN,1.0,ALL_SIDES);           //show object
    }
    
    on_rez(integer num) {
        llResetScript();
    }

    changed(integer change) {
        if(change & CHANGED_LINK) {                                //links changed!
            if(SITTING == 0 && LS == 1) sitter = llAvatarOnLinkSitTarget(LN);
            if(SITTING == 0 && LS == 0) sitter = llAvatarOnSitTarget();
            if(only_owner == 1 && sitter != owner && sitter != NULL_KEY) {
                llUnSit(sitter);
                llInstantMessage(sitter,"You are not permitted to sit here.");
                sitter = NULL_KEY;
            }
            else if(SITTING == 0 && sitter != NULL_KEY) {          //someone sitting?
                SITTING = 1;
                llRequestPermissions(sitter,PERMISSION_TRIGGER_ANIMATION);
            }
            else if(SITTING == 1 && test_sit() == 0) {             //I think someone stood up!
                if(llGetPermissions() & PERMISSION_TRIGGER_ANIMATION) llStopAnimation(animation);
                if(HOV_ON) llSetText(HOVERTEXT,COLOR,1.0);         //show hover text
                if(OBJHIDE_ON) llSetLinkAlpha(LN,1.0,ALL_SIDES);   //show object
                SITTING = 0;
                sitter = NULL_KEY;
            }
        }
    }

    run_time_permissions(integer perm) {
        if(perm & PERMISSION_TRIGGER_ANIMATION) {
            if(HOV_ON) llSetText("",COLOR,1.0);                    //hide hover text
            if(OBJHIDE_ON) llSetLinkAlpha(LN,0.0,ALL_SIDES);       //hide object
            llStopAnimation("sit");                                //stop normal sit
            llStartAnimation(animation);                           //and use this animation
        }
    }
}
