// :CATEGORY:Updater
// :NAME:Script Updater
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:Update, updater
// :CREATED:2014-01-30 12:16:43
// :EDITED:2014-02-14 12:33:24
// :ID:1017
// :NUM:1578
// :REV:1.0
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// Remote prim updater for scripts.  This registers the prim to accept scripts from a server in the same region.
// :CODE:

// when anything changes in the prims inventory, this sends the name and UUID to a central server.
// It enabled remote script loading from that central prim, estate-wide
// As a result, if you add any new scripts, they auto-get inserted into the database
// tunable

integer debug = FALSE;        // chat a message
integer UNIQ = 1246;       // the private channel unique to the owner of this prim

// Not tuneable
integer CHECKIN = 86400;       // 86400 seconds = 1 day
integer comChannel ;           // placeholder for llRegionSay
DEBUG (string msg) { if (debug) llOwnerSay(llGetScriptName() + ":" + msg);}
integer pin;             // a random pin for security

update() {
    
    integer j = llGetInventoryNumber(INVENTORY_SCRIPT);
    integer i;
    for (i = 0; i < j; i++)
    {
        string name = llGetInventoryName(INVENTORY_SCRIPT,i);
        DEBUG("Sending " + name);
        llRegionSay(comChannel,name + "^" + (string) pin);        
    }
    llOwnerSay("Script Updater ready");
    llSetTimerEvent(CHECKIN); // Hourly check ins
}

   
default
{
    state_entry()
    {
        pin = llCeil(llFrand(123456) + 654321);
        comChannel = (((integer)("0x"+llGetSubString((string)llGetOwner(),-8,-1)) & 0x3FFFFFFF) ^ 0xBFFFFFFF ) + UNIQ;    // 1234 is the private channel for this owner
        llSetRemoteScriptAccessPin(pin);
        update();
        
    }
    // in case we rez, our UUID changed, so we check in
    on_rez(integer p) {
        llResetScript();    }

    // a new script may have been added
    changed ( integer what)
    {
        if (what & CHANGED_INVENTORY ) {
            update();
        }
        if (what & CHANGED_REGION_START ) {
            llResetScript();
        }
    }

    timer()
    {
        update();
    }
    
}
