// MPLV2 2.3 by Learjeff Innis, based on
//MLP MULTI-LOVE-POSE V1.2 - C opyright (c) 2006, by Miffy Fluffy (BSD License)

integer ch;
string animation = "stand";
key avatar;

integer ExprEnabled = TRUE;
string  Expression;
float   ExprTimer;

integer BallNum;

list Expressions = [
      ""
    , "express_open_mouth"          // 1
    , "express_surprise_emote"      // 2
    , "express_tongue_out"          // 3
    , "express_smile"               // 4
    , "express_toothsmile"          // 5
    , "express_wink_emote"          // 6
    , "express_cry_emote"           // 7
    , "express_kiss"                // 8
    , "express_laugh_emote"         // 9
    , "express_disdain"             // 10
    , "express_repulsed_emote"      // 11
    , "express_anger_emote"         // 12
    , "express_bored_emote"         // 13
    , "express_sad_emote"           // 14
    , "express_embarrassed_emote"   // 15
    , "express_frown"               // 16
    , "express_shrug_emote"         // 17
    , "express_afraid_emote"        // 18
    , "express_worry_emote"         // 19
    , "SLEEP"                       // 20
];


stopAnim() {
    key id = llGetPermissionsKey();
    list anims = llGetAnimationList(id); 
    integer ix; 
    for (ix = 0; ix < llGetListLength(anims); ++ix) {
        string anim = llList2String(anims, ix);
        if (anim != "") {
            llStopAnimation(anim);
        }
    }
    llSetTimerEvent(0.0);
}

startAnim(string anim) {
    if (Expression != "") {
        if (Expression == "SLEEP") {
            llStartAnimation("express_disdain");
            llStartAnimation("express_smile");
        } else {
            llStartAnimation(Expression);
        }
        if (ExprEnabled) {
            llSetTimerEvent(ExprTimer);
        }
    } else {
        stopAnim();
    }
    if (anim != "") {
        llStartAnimation(anim);
    }
}    

// Animation names with a "*" suffix get open mouth
// Those with a suffix of "::" followed by a number
//   get the expression associated with that number.
//   This can optionally be followed by another "::" delim,
//   with a timer value following.
// Return the anim name without the suffix.
string getExpression(string anim) {
    if (llGetSubString(anim,-1,-1) == "*") {
        Expression = llList2String(Expressions, 1);
        ExprTimer = 0.5;
        return llGetSubString(anim, 0, -2);
    }
    integer ix = llSubStringIndex(anim, "::");
    if (ix == -1) {
        Expression = "";
        ExprTimer = 0.5;
        return anim;
    }
    
    list parms = llParseString2List(anim, ["::"], []);
    anim = llList2String(parms, 0);
    integer exprIx = (integer) llList2String(parms, 1);
    Expression = llList2String(Expressions, exprIx);
    ExprTimer  = (float) llList2String(parms,2);
    
    if (ExprTimer <= 0.0) {
        ExprTimer = 0.5;
    }
    
    return anim;
}

getChan() {
    BallNum = (integer) llGetSubString(llGetScriptName(),-1,-1);          //offset from script name suffix
    ch = BallNum
        + (integer)("0x"+llGetSubString((string)llGetKey(),-4,-1)); //fixed channel for prim
}

default {
    state_entry() {
        state s_on;
    }
}

state s_on {
    state_entry() {
        getChan();
        llListen(ch+8,"",NULL_KEY,"");
    }
    
    on_rez(integer arg) {
        state default;
    }

    link_message(integer from, integer num, string an, key id) {        //an animation is set
        if (an == "PRIMTOUCH") {
            return;
        }
        
        if (num != ch) return;
        an = getExpression(an);     // get & save expression, and return unadorned anim

        if (avatar == llGetPermissionsKey()
            && avatar != NULL_KEY
            && animation != "") {
            llStopAnimation(animation);
            llMessageLinked(LINK_SET, -11002, (string)BallNum + "|" + an, llGetPermissionsKey());
            startAnim(an);
        }
        animation = an;
    }

    timer() {  // timer to keep mouth open
        if (Expression == "SLEEP") {
            llStartAnimation("express_disdain");
            llStartAnimation("express_smile");
        } else if (Expression != "") {
            llStartAnimation(Expression);
        }
    }

    listen(integer channel, string name, key id, string str) {           
        if (str == "ALIVE" || str == "DIE") {
            llMessageLinked(LINK_THIS,2,str,"");                        //send msg from ball to menu
            if (str == "DIE") {
                avatar = NULL_KEY;
                llSetTimerEvent(0.0);
            }
            return;
        }
            
        avatar = (key) str;     //avatar (sit) or NULL_KEY (stand up)
        if (avatar == NULL_KEY) {
            if (llGetPermissions() & PERMISSION_TRIGGER_ANIMATION) {
                stopAnim();
                llMessageLinked(LINK_SET, -11001, (string)BallNum, llGetPermissionsKey());
            }
            // llReleaseControls();
            return;
        }
        
        if (avatar != llGetPermissionsKey()
            || ! (llGetPermissions() & PERMISSION_TRIGGER_ANIMATION)) {
            ExprEnabled = TRUE;
            llRequestPermissions(avatar, PERMISSION_TRIGGER_ANIMATION);
        } else {
            stopAnim();
            llMessageLinked(LINK_SET, -11000, (string)BallNum + "|" + animation, llGetPermissionsKey());
            startAnim(animation);
        }
    }

    run_time_permissions(integer perm) {
        if (avatar != llGetPermissionsKey()) {
            llWhisper(DEBUG_CHANNEL, "avatar != perm key");
            return;
        }

        if (perm & PERMISSION_TRIGGER_ANIMATION) {
            stopAnim();
            llMessageLinked(LINK_SET, -11000, (string)BallNum + "|" + animation, llGetPermissionsKey());
            startAnim(animation);
        } else {
            llMessageLinked(LINK_SET, -11001, (string)BallNum, llGetPermissionsKey());
            llSetTimerEvent(0.0);
        }
    }
}