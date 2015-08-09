// :CATEGORY:HUD
// :NAME:AntiAFK_HUD
// :AUTHOR:Noland Brokken
// :CREATED:2010-11-08 12:18:03.007
// :EDITED:2013-09-18 15:38:47
// :ID:42
// :NUM:55
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The Main Script - you need this script plus the HUDF positioner, and then add any sounds you want to play when AFK
// :CODE:
// Super simple stay awake HUD. Looks like an "8" when off
// and a lemniscate (infinity) when on
// Public Domain by Noland Brokken. 
// 
vector C0 = <0,0.4,0>;      // Off Color
vector C1 = <1,0.4,0>;      // On Color
vector C2 = <1,1,1>;        // Triggered Color
float timespan = 0.5;       // time between checks
float Volume = 1.0;         // Volume for sound fx (0.0 - 1.0)


key OwnerKey;
integer active;
integer numsounds;
string soundfile;

upd()
{
    llSetLinkColor(ALL_SIDES,llList2Vector([C0,C1],active),ALL_SIDES);
    llSetTimerEvent(active * timespan);
    llSetRot(llEuler2Rot(<active * PI_BY_TWO,0,0>));
}

default
{
    state_entry()
    {
        OwnerKey = llGetOwner();
        active = FALSE;
        numsounds = llGetInventoryNumber(INVENTORY_SOUND);
        if (!(llGetPermissions() & PERMISSION_TRIGGER_ANIMATION))
        {
            llRequestPermissions(OwnerKey, PERMISSION_TRIGGER_ANIMATION);
        }       
        upd();
    }
    on_rez(integer r)
    {
        llOwnerSay("Click me to enable/disable.");
    }    
            
    changed(integer change)
    {
        if(change & (128 | CHANGED_INVENTORY))    
                        // You'd better put this in the 
                        // changed() event when you use llGetOwner
        {               // by way of precaution.
            llResetScript();
        }
    }    

    timer()
    {
        if (llGetAgentInfo(OwnerKey) & AGENT_AWAY) {
            llSetLinkColor(ALL_SIDES,C2,ALL_SIDES);
            do { llStopAnimation("away");}
            while (llGetAgentInfo(OwnerKey) & AGENT_AWAY);
            integer n = llFloor(llFrand((float)numsounds- .00001));
            soundfile = llGetInventoryName(INVENTORY_SOUND, n);
            if (Volume > 0.0)
                if (llGetInventoryType(soundfile) != -1)
                    llTriggerSound(soundfile, Volume);
            llSetLinkColor(ALL_SIDES,C1,ALL_SIDES);
        }
    }
    touch_start(integer n)
    {
        if (llDetectedKey(0) != OwnerKey) return;
        active = !active;
        upd();
    }
}
