// :CATEGORY:Notecard Reader
// :NAME:Advanced_Note_Card_reader
// :AUTHOR:Lear Cale
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:47
// :ID:16
// :NUM:21
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// The script
// :CODE:
// Multi-file configuration, v1a
// Lear Cale, 2007
// Public Domain.  Feel free to delete header comments.
 
// This script reads all configuration notecards that match a given suffix,
// storing the settings in global variables.  It rereads the notecards
// on any inventory change.
 
// It does not require a script reset on any event, but one is done for
// owner change on general principles.  If your object needs not to be
// reset on owner change, you may delete those lines from the code.
 
// ==============================================================
// Places where you change the code are marked with "%%%"
// ==============================================================
 
 
// Example config variables -- replace these with meaningful stuff! %%%
 
// For this example, we allow the user to configure any number of "foos",
// with an integer parameter for each foo.  There's also a float "bar"
// parameter.
 
// Replace these lines with your globals and try to save: you'll get
// errors in the places you need to edit.
 
list    Foos;       // %%% all foos configured
list    FooVals;    // %%% value for each foo configured
float   Bar;        // %%% a configurable parameter
 
 
// %%% Static parameters for reading card config: you may change these, but don't have to.
integer ConfigRequired          = FALSE;        // whether to fail if no config cards
string  ConfigNotecardSuffix    = ".cfg";       // string identifying config notecards
float   ConfigTimeout           = 60.0;         // seconds to wait for slow server
 
 
// Globals for reading card config
integer ConfigLineIndex;    // line number in notecard we're reading
key     ConfigRequestID;    // request we're waiting for
list    ConfigCards;        // list of names of config notecards
string  ConfigCardName;     // name of card being read
integer ConfigCardIndex;    // index of next card to read
 
integer Debug;              // Whether to print debug text
 
 
config_init()
{
    // Initialize all configurable global variables here %%%
    // Don't initialize your configurable globals at their
    // declarations (above).  Doing it here provides default
    // behavior if the user deletes a config line from a notecard
    // rather than retaining the previous value.
    Foos = [];          // %%%
    Bar  = 20.0;        // %%%
}
 
// print the configuration, handy for debugging.
 
config_dump()
{
    // Replace this example code with your config %%%.
    say("Foos: "       + llList2CSV(Foos));      // %%%
    say("FooVals: "    + llList2CSV(FooVals));   // %%%
    say("Bar: "        + (string) Bar);          // %%%     
}
 
 
// Example notecard line parser.
// This function is called for each configuration line.
// It treats all config notecards the same.
//
// For this example (which you can modify to suit your purposes)
//   Comments lines begin with a slash
//   Each line begins with a command followed by optional arguments
//   An Equals-sign ("=") separates command and arguments (and args from each other)
//   Unrecognized commands are ignored -- good for forwards-backwards notecard compatibility
//   cardName and lineNum are in case you want to print error messages.
//   This example doesn't allow spaces around the "=".  If you want to allow
//   and ignore them, use this instead of ["="] in llParsStringKeepNulls().
//     ["  =  ", "  = ", " =  ", " = ", " =", "= ", "="]
//
// Example config file contents:
//   foo=Lowell George=1979
//   foo=Freddy Murcury=1991
//   foo=Robert Johnson=1938
//   bar=1.5
 
config_parse(string str, string cardName, integer lineNum)
{
    str = llStringTrim(str, STRING_TRIM_HEAD);  // delete leading spaces
 
    // lines beginning with slash are comments -- ignore them
    if (llGetSubString(str,0,0) == "/") {
        return;
    }
 
    list ldata  = llParseStringKeepNulls(str, ["="], [""]);
    string cmd  = llList2String(ldata,0);
    string arg1 = llList2String(ldata,1);
    string arg2 = llList2String(ldata,2);
    // %%% Add more lines such as the above as needed for more arguments.
 
    // %%% Process example commands -- replace this code with meaningful stuff! %%%
    if (cmd == "foo") {
        // another Foo configured: remember it
        Foos    += [arg1];
        FooVals += [(integer) arg2];
    } else if (cmd == "bar") {
        Bar = (float) arg1;
    }
 
    // this one is a good one to keep
    else if (cmd == "debug") {
        Debug = (integer) arg1;
    }
}
 
 
// Post-process any config, if necessary
config_done() {
    if (Debug) {
        config_dump();
    }
    say("Config done");
}
 
 
// ==== Utilities ====
 
// Say something, in this case to owner (%%% modify to whisper or whatever)
 
say(string str)
{
    llOwnerSay(str);
}
 
 
// Say something if debug is enabled
debug(string str)
{
    if (Debug) {
        say(llGetScriptName() + ": " + str);
    }
}
 
// Get the next notecard name, and
// return TRUE if there is one
 
integer next_card()
{
    if (ConfigCardIndex >= llGetListLength(ConfigCards)) {
        ConfigCards = [];
        return (FALSE);
    }
 
    ConfigLineIndex = 0;
    ConfigCardName = llList2String(ConfigCards, ConfigCardIndex);
    ConfigCardIndex++;
    ConfigRequestID = llGetNotecardLine(ConfigCardName, ConfigLineIndex);
    say("Reading " + ConfigCardName);
    return (TRUE);
}

// BEGIN STATES

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
