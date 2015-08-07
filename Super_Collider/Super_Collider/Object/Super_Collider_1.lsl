// :CATEGORY:Collider
// :NAME:Super_Collider
// :AUTHOR:Rickard Roentgen
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:05
// :ID:845
// :NUM:1173
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Super collider script
// :CODE:
string fall_anim_fwd = "fall hard forward";
string fall_anim_back = "fall hard backward";

float speed;
integer forward;
integer listen1;
integer blood;
integer online = FALSE;
string animation;
vector size;
vector detvel;
vector vel;

default
{
    state_entry()
    {
        llMessageLinked(LINK_SET, 0, "revive", NULL_KEY);
        llListenRemove(listen1);
        listen1 = llListen(0, "", llGetOwner(), "");
        llRequestPermissions(llGetOwner(), PERMISSION_TRIGGER_ANIMATION | PERMISSION_TAKE_CONTROLS);
        llStopMoveToTarget();
        online = FALSE;
        llMessageLinked(llGetLinkNumber(), 0, "status", NULL_KEY);
        size = llGetAgentSize(llGetOwner());
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if (str == "online") {
            online = TRUE;
        } else if (str == "offline") {
            online = FALSE;
        }
    }
    
    attach(key id)
    {
        if (id != NULL_KEY) {
            llResetScript();
        } else if (llKey2Name(llGetPermissionsKey()) != "") {
            llStopAnimation(fall_anim_fwd);
            llStopAnimation(fall_anim_back);
        }
    }
    
    listen(integer channel, string name, key id, string message)
    {
        message = llToLower(message);
        if (message == "collide on" || message == "collider on" || message == "super collider on") {
            llMessageLinked(llGetLinkNumber(), TRUE, "set status", NULL_KEY);
            llWhisper(0, "/me Online.");
            online = TRUE;
        } else if (message == "collide off" || message == "collider off" || message == "super collider off") {
            llMessageLinked(llGetLinkNumber(), FALSE, "set status", NULL_KEY);
            llWhisper(0, "/me Offline.");
            online = FALSE;
        }
    }
    
    collision_start(integer n)
    {
        detvel = llDetectedVel(0);
        vel = llGetVel();
        speed = llVecMag(detvel - (vel / 2.0));
        animation = llGetAnimation(llGetOwner());
        if (speed > 3.5 && llVecMag(detvel) > 3.5 && (animation == "Standing" || animation == "Walking" || animation == "Running") && online) {
            llSetScale(<0.1, 0.1, 0.1>);
            llMoveToTarget(llGetPos() + <0.0, 0.0, (2.0 - size.z) / 3.5>, 0.05);
            if (llRot2Fwd(llGetRot()) * llVecNorm(detvel) <= 0.0) {
                llStartAnimation(fall_anim_back);
                forward = FALSE;
            } else {
                llStartAnimation(fall_anim_fwd);
                forward = TRUE;
            }
            state dead;
        }
    }
}

state dead
{
    state_entry()
    {
        llTakeControls(CONTROL_LEFT | CONTROL_RIGHT | CONTROL_ROT_LEFT | CONTROL_ROT_RIGHT | CONTROL_FWD | CONTROL_BACK | CONTROL_UP | CONTROL_DOWN, TRUE, FALSE);
        llSetTimerEvent(0.1);
        blood = 0;
        llListenRemove(listen1);
        listen1 = llListen(0, "", llGetOwner(), "");
        llResetTime();
    }
    
    on_rez(integer sparam)
    {
        llResetScript();
    }
    
    listen(integer channel, string name, key id, string message)
    {
        message = llToLower(message);
        if (message == "collide on" || message == "collider on" || message == "super collider on") {
            online = TRUE;
            llMessageLinked(llGetLinkNumber(), TRUE, "set status", NULL_KEY);
            llWhisper(0, "/me Online.");
        } else if (message == "collide off" || message == "collider off" || message == "super collider off") {
            online = FALSE;
            llMessageLinked(llGetLinkNumber(), FALSE, "set status", NULL_KEY);
            llWhisper(0, "/me Offline.");
        }
    }
    
    control(key id, integer level, integer edge)
    {
        if (llGetTime() > 2.0) {
            llMessageLinked(LINK_ALL_OTHERS, 0, "revive", NULL_KEY);
            llSleep(0.1);
            llStopAnimation(fall_anim_back);
            llStopAnimation(fall_anim_fwd);
            llSetTimerEvent(0.0);
            llSleep(0.1);
            llStopMoveToTarget();
            llResetScript();
        }
    }
    
    timer()
    {
        if (blood < 10) {
            blood += 1;
        } else if (blood == 10) {
            blood += 1;
            if (speed > 10.0) {
                if (forward) {
                    llMessageLinked(LINK_ALL_OTHERS, 0, "blood forward", NULL_KEY);
                } else {
                    llMessageLinked(LINK_ALL_OTHERS, 0, "blood backward", NULL_KEY);
                }
            }
        }
        llSetScale(<0.1, 0.1, 0.1>);
        llSetScale(<0.05, 0.05, 0.05>);
    }
}
