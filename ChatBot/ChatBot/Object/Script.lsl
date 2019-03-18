// :CATEGORY:Chatbot
// :NAME:ChatBot
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2014-08-11 17:29:33
// :EDITED:2014-08-11
// :ID:1038
// :NUM:1622
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// NPC for Opensim Chatbot script
// :CODE:
//integer gToggle = 0;
integer gAnimNumber;
integer gTotalAnims;
integer gTotalAnims2;
integer gInList2;

string gAnimName = "type";


list gAnimations = [ "aim_R_bazooka", "aim_R_handgun", "aim_R_rifle", "angry_fingerwag",
"angry_tantrum", "away", "backflip", "blowkiss", "bow", "brush", "clap",
"courtbow", "cross_arms", "crouch", "crouchwalk", "curtsy",
"dance1", "dance2", "dance3", "dance4", "dance5", "dance6", "dance7", "dance8",
"dead", "drink", "express_afraid", "express_anger", "express_bored",
"express_cry", "express_embarrased", "express_laugh", "express_repulsed",
"express_sad", "express_shrug", "express_surprise", "express_wink",
"express_worry", "falldown", "female_walk", "fist_pump", "fly", "flyslow",
"hello", "hold_R_bazooka", "hold_R_handgun", "hold_R_rifle",
"hold_throw_R", "hover", "hover_down", "hover_up", "impatient",
"jump", "jumpforjoy", "kick_roundhouse_R", "kissmybutt", "kneel_left",
"kneel_right", "land", "musclebeach", "no_head", "no_unhappy",
"nyanya", "peace", "point_me", "point_you", "prejump", "punch_L",
"punch_onetwo", "punch_R", "RPS_countdown" ];

list gAnimations2 = [ "RPS_paper", "RPS_rock",
"RPS_scissors", "run", "salute", "shout", "sit", "sit_ground", "sit_to_stand",
"sleep", "slowwalk", "smoke_idle", "smoke_inhale", "smoke_throw_down",
"snapshot", "soft_land", "stand", "standup", "stand_1", "stand_2",
"stand_3", "stand_4", "stretch", "stride", "surf", "sword_strike_R",
"talk", "throw_R", "tryon_shirt", "turnback_180", "turnleft", "turnright",
"turn_180", "type", "uphillwalk", "walk", "whisper", "whistle", "wink_hollywood", "yell",
"yes_happy", "yes_head", "yoga_float" ];

default {
    state_entry() {
        //llSay(0, "Init...");
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
        gTotalAnims = llGetListLength(gAnimations);
        gTotalAnims2 = llGetListLength(gAnimations2);
        gAnimNumber = -1;
        gInList2 = FALSE;
        llListen(0, "", llGetOwner(), "");
    }
    
    on_rez(integer param) {
        llGiveInventory(llGetOwner(), "Animation Names");
        llResetScript();
    }
    
    listen(integer channel, string name, key id, string mesg) {
        string preamble = llGetSubString(mesg, 0, 3);
        if (preamble != "anim" && preamble != "stop")
            return;
                
        integer perm = llGetPermissions();
        
        if ( !(perm & PERMISSION_TRIGGER_ANIMATION)) {            
            llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
            return;
        }
        
        list parsed = llParseString2List(mesg, [ " " ], []);
        //llSay(0, (string)parsed);
        
        string anim = llList2String(parsed, 1);
        
        if (preamble == "stop") {
            //llSay(0, "Stopping: " + llGetAnimation(llGetOwner()));
            //llStopAnimation(llGetAnimation(llGetOwner()));
            if (anim == "")
                anim = gAnimName;
                        
            if (anim == "all") {
                integer i;
                llSay(0, "Stoping");
                for (i=0; i<gTotalAnims; i++)
                    llStopAnimation(llList2String(gAnimations, i));
                    
                for (i=0; i<gTotalAnims2; i++)
                    llStopAnimation(llList2String(gAnimations2, i));
                    
                llSay(0, "Done.");
                    
                return;
            }
                
            //llSay(0, "Stopping: " + anim);
            llStopAnimation(anim);
            return;
        }
                
        gAnimName = anim;
        //llSay(0, "Animation: " + gAnimName);
        llStartAnimation(gAnimName);            
    }
    
    run_time_permissions(integer perm) {
        //llStopAnimation(gAnimName);
        //gToggle = 0;
    }
    
    attach(key id) {
        integer perm = llGetPermissions();
        
        if (id != NULL_KEY) {        
        
            if (! (perm & PERMISSION_TRIGGER_ANIMATION)) {
                llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
            }                
        }
        else {
            
            if (perm & PERMISSION_TRIGGER_ANIMATION) {
                llStopAnimation(gAnimName);
            }
        }
    }

    touch_start(integer total_number) {
        if (llDetectedKey(0) != llGetOwner())
            return;
        
        integer perm = llGetPermissions();
        
        if (perm & PERMISSION_TRIGGER_ANIMATION) {
            if (gAnimNumber != -1) {
                if (gInList2)                
                    llStopAnimation( llList2String(gAnimations2, gAnimNumber) );
                else
                    llStopAnimation( llList2String(gAnimations, gAnimNumber) );
            }
                
            
            gAnimNumber++;
            
            if (gInList2) {
                if (gAnimNumber == gTotalAnims2) {
                    gAnimNumber = 0;
                    gInList2 = FALSE;
                }
            }
            else {
                if (gAnimNumber == gTotalAnims) {
                    gAnimNumber = 0;
                    gInList2 = TRUE;
                }
            }
                
            if (gInList2)
                gAnimName = llList2String(gAnimations2, gAnimNumber);
            else
                gAnimName = llList2String(gAnimations, gAnimNumber);
            
            llStartAnimation( gAnimName );
            llSay(0, "Animation: " + gAnimName);
        }
        else {
            llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION);
        }
    }
}
