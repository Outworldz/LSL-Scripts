// :CATEGORY:Notecard Reader
// :NAME:Advanced_Note_Card_reader
// :AUTHOR:Lear Cale
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:16
// :NUM:22
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// States:
// :CODE:
// Default state can do any init you need that doesn't require configuration.
 
default
{
    state_entry() {
        llSetText("", <1.0,1.0,1.0>, 1.0);
        state s_config;
    }
}
 
// This state is only used to get into s_config, because going from
// s_config to s_config won't redo it's state_entry.  But we might
// not want to redo anything we might have put in default state entry.
 
state s_reconfig
{
    state_entry() {
        state s_config;
    }
}
 
// Read card config
// Multiple notecard version - read all cards with the given extension
 
state s_config
{
    state_entry() {
        config_init();
 
        string item;
        ConfigCards = [];
        integer n = llGetInventoryNumber(INVENTORY_NOTECARD);
        while (n-- > 0) {
            item = llGetInventoryName(INVENTORY_NOTECARD, n);
            // Note: for simplicity, read cards with the "suffix" anywhere in the name
            if (llSubStringIndex(item, ConfigNotecardSuffix) != -1) {
                ConfigCards += [item];
            }
        }
 
        ConfigCardIndex = 0;
        if (next_card()) {
            llSetTimerEvent(ConfigTimeout);
        } else if (ConfigRequired) {
            say("Configuration notecard missing.");              
            state s_configRetry;
        } else {
            state s_active;
        }
    }
 
    dataserver(key query_id, string data) {
        if (query_id == ConfigRequestID) {
            if (data == EOF) {
                if (! next_card()) {
                    config_done();
                    state s_active;
                }
            } else {
                config_parse(data, ConfigCardName, ConfigLineIndex);
                ConfigRequestID = llGetNotecardLine(ConfigCardName, ++ConfigLineIndex);
                llSetTimerEvent(ConfigTimeout);
            }
        }
    }
 
    timer() {
        say("Dataserver time out: touch to retry");
        state s_configRetry;
    }
 
    on_rez(integer num) { state s_reconfig; }
 
    changed(integer change) {
        if (change & CHANGED_OWNER) { llResetScript(); }
        if (change & CHANGED_INVENTORY) { state s_reconfig; }
    }
 
    state_exit() {
        llSetTimerEvent(0);
    }
}
 
state s_configRetry
{
    touch_start(integer tot) {
        if (llDetectedKey(0) == llGetOwner()) {
            state s_config;
        }
    }
 
    changed(integer change) {
        if (change & CHANGED_OWNER) { llResetScript(); }
        if (change & CHANGED_INVENTORY) { state s_config; }
    }
}
 
// State to go into if notecard is required but missing.
// You can delete this and the code above that refers to it,
// or just set ConfigurationRequired to FALSE.
state s_unconfigured
{
    state_entry() {
        llSetText("Configuration missing", <1.0,1.0,1.0>, 1.0);
    }
 
    changed(integer change) {
        if (change & CHANGED_OWNER) { llResetScript(); }
        if (change & CHANGED_INVENTORY) { state s_reconfig; }
    }
 
    state_exit() {
        llSetText("", <1.0,1.0,1.0>, 1.0);
    }
}
 
 
// The fun starts here!
 
state s_active
{
 
    // %%% Your code goes here!
 
    // Every state should usually have this, or something like it.
    changed(integer change) {
        if (change & CHANGED_OWNER) { llResetScript(); }
        if (change & CHANGED_INVENTORY) { state s_reconfig; }
    }
}
