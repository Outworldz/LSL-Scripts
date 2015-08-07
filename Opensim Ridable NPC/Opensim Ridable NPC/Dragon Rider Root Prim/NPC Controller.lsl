// :SHOW:
// :CATEGORY:Flying NPC's
// :NAME:Opensim Ridable NPC
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2015-03-17 10:27:57
// :EDITED:2015-03-17  09:27:57
// :ID:1073
// :NUM:1731
// :REV:1
// :WORLD:OpenSim
// :DESCRIPTION:
// Rideable NPC dragon, (and other flying creatures) Original script by Shin Ingen
// :CODE:

// Rev 0.1 2014-12-08 Compiles

// Instructions on how to use this is at http://www.outworldz.com/opensim/posts/NPC/
// This is an OpenSim-only script.
// Author: Ferd Frederix

  
////////////////////////////////////////////////////////////////////////////////////////////
//    Original code is Copyright (C) 2013 Wizardry and Steamworks - License: GNU GPLv3    //
///////////////////////////////////////////////////////////////////////////////////////////
//  Please see: http://www.gnu.org/licenses/gpl.html for legal details,                  //
//  rights of fair usage, the disclaimer and warranty conditions.                        //
///////////////////////////////////////////////////////////////////////////////////////////
// The original NPC controller was from http://was.fm/opensim:npc

// Extensive additions and bug fixes by Fred Beckhusem, aka Ferd Frederix, fred@mitsi.com
// llSensor had two params swapped
// @Wander would wander where it had rezzed, not where it was.
// There was no 'no_sensor' event in sit, so if a @sit failed, the NPC got stuck
// The animation and walks always stopped old, then started new.  It should be start new, then stop old so the default stand would be suppressed.
// New code:
// Merged with new Route recorder and notecard writer
// If the NPC failed to reach a destination it never moved on. Added WAIT global to tune this
// Exposed many tunable variables and ported the code to LSLEditor.
// Added floating point to times in notecard.

// Added @sound, @randsound, @whisper, @shout, and @cmd controls.
//
// notecards integers are not floats for better control
// 
// Link Messages may be used to perform external control by injecting @commands into the stream of actions
// Example:
// To chat something, such as with a chat robot
//  llMessageLinked(LINK_SET,0,"@npc_say=Hello","");

// This script assumes that NPCs and OSSl scripting is enabled in the OpenSim configuration.
// In order to enable them, the following changes must be made in the OpenSim.ini configuration file:
//
// ; Turn on OSSL
// AllowOSFunctions = true
// OSFunctionThreatLevel = Severe

//[NPC]
//    ;# {Enabled} {} {Enable Non Player Character (NPC) facilities} {true false}
//    Enabled = true
//
// and then the server has to be restarted.


// Commands: All commands begin with an @ sign.  All other lines are ignored
// @commands may have optional parameters.  The syntax is always:
//    @cmd=parm1|parm2
//  NaN in the table below meand Not a Number.   This means there is no parameter

//Command     First Parameter             Second Parameter        Description
//@spawn         name                      location (vector)        Rezzes an NPC with name at a location.
//@walk         destination (vector)        NaN                     Makes the NPC walk to destination.
//@fly          destination (vector)        NaN                     Makes the NPC fly to destination.
//@land         destination (vector)        NaN                     Makes the NPC land at destination.
//@say         string                     NaN                     Makes the NPC speak a phrase.
//@whisper     string                     NaN                     Makes the NPC whisper a phrase.
//@shout         string                     NaN                     Makes the NPC shout a phrase.
//@pause         seconds (float)            NaN                     Makes the NPC wait for a multiple of seconds.
//@wander     radius (float)            cycles (integer)        Makes the NPC wander in radius, for cycles seconds.
//@stop         NaN                     NaN                     Halts the NPC script indefinitely. Can be started with a @continue. When stopped, you can inject commands via link message
//@continue    NaN                      NaN                     Continue from an @stop
//@delete     NaN                        NaN                     Removes the NPC.
//@animate     animation (string)       time (float)             Makes the NPC trigger the animation animation for time seconds.
//@goto         label (string)           NaN                     Jump to the label label in the script.
//@rotate     degrees                    NaN                     Rotate the NPC degrees around the Z axis.
//@sit         primitive name           NaN                     Sit on a primitive with a given name.
//@stand         NaN                        NaN                     If sitting on a primitive, stand up.
//@sound     sound_name              NaN                    plays a sound from inventory
//@randsound NaN                     NaN                    Plays a random sound from inventory
//@cmd       channel (integer)       string                 Says string on channel, for controlling external gadgets



//////////////////////////////////////////////////////////
//                  DEBUG                               //
//////////////////////////////////////////////////////////

integer debug = FALSE;         // set to TRUE or FALSE for debug chat on various actions
integer Editor = FALSE;        // set to to TRUE to working in  LSLEditor, FALSE for in-world.
integer iTitleText = FALSE;    // set to TRUE to see debug in text above the controller

//////////////////////////////////////////////////////////
//                  TUNABLE CONFIGURATION               //
//////////////////////////////////////////////////////////

float     MAXDIST = 1.0;       // how close a NPC has to get to a dest pos to continue to next state. Do not lower this too much, will also need a faster TIMER
float     TIMER = 0.5;         // how often the system checks the distance traveled
integer   WANDERRAND = TRUE;   // set to TRUE and they will pause during wanders a random number of seconds
float     WANDERTIME = 1.0;    // how long they stand after each @wander,if WANDERRAND is FALSE. If WANDERRAND is  TRUE, this is the max time
integer   WAIT = 5;           // wait for this number of seconds for the NPC to reach a destination (for safety)
float     RANGE = 5.0;        // 1 to 96.0 meters  - anyone this close to the controller will start NPCS if  Sensor button is clicked
float     REZTIME = 5.0;      // wait this lng for NPC to rez in, then start the process
string    STAND = "Stand";     // the name of the default Stand animation
string    WALK = "Walk";       // the name of the default Walk animation
string    FLY = "Fly";        // the name of the default Fly animation
string    RUN = "Run";        // the name of the default Run animation
float    OffsetZ = 0.5;         // appear 0.5 meter above ground, this is added to all destinations to keep them from sinking in.

// globals section
integer iChannel;        // a listen channel, randomly assigned
integer iHandle;         // the handle to it

// NPC
vector newDest ;                // tmp storage for the walks
integer iWaitCounter ;          // wait for this number of seconds for the NPC to reach a desrtination
string sNPCName;                // the name of the NPC that may be in world. So we can remove it.
integer bNPC_STOP;      // boolean to reuse a listener
integer gExtern;        // set to TRUE by link messages so we do not remember them
float  fTimerVal ;              // how long we wait when wandering (calculated)
            
// OS_NPC_CREATOR_OWNED will create an 'owned' NPC that will only respond to osNpc* commands issued from scripts that have the same owner as the one that created the NPC.
// OS_NPC_NOT_OWNEDwill create an 'unowned' NPC that will respond to any script that has OSSL permissions to call osNpc* commands.
integer  NPCOptions = OS_NPC_NOT_OWNED;


integer NPCWalkOption;
// Just some notes for what happens to NPCWalkOption:
// OS_NPC_FLY - Fly the avatar to the given position. The avatar will not land unless the OS_NPC_LAND_AT_TARGET option is also given.
// OS_NPC_NO_FLY - Do not fly to the target. The NPC will attempt to walk to the location. If it's up in the air then the avatar will keep bouncing hopeless until another move target is given or the move is stopped
//OS_NPC_LAND_AT_TARGET - If given and the avatar is flying, then it will land when it reaches the target. If OS_NPC_NO_FLY is given then this option has no effect.
// OS_NPC_RUNNING - if given, NPC avatar moves at running/fast flying speed, otherwise moves at walking/slow flying speed.


// menus
integer showMenu = FALSE;       // when we switch states, we need to bring up a menu
list lAtButtons = ["Menu","-", "More",         "@run","@walk","@fly",          "@land","@wander","@sit",  "@stand","@animate","@rotate"];
list lMenu2 = ["<<", "@comment", "@stop",      "@say","@whisper","@shout",     "@sound","@randsound", "-", "@cmd", "@pause", "-" ];
string sCommand;  // place to store a command for two-prompted ones
string sParam2;   // place to store a prompt for two-prompted ones
string priPub = "Private";    // Private or Group
key kUserKey;        // the person who is controlling the avatar, not the Owner


// the command lists
list lCommands;  // commands are stored here
list lNPCScript; // Storage for the NPC script.
string npcAction; // Storage for the next action. @cmd=0|hello, this becomes @cmd
string npcParams; // Storage for the param, @cmd=0|hello, this becomes 0|hello
list lBackup;    // holds a backup copy of the main list for processing commands diring @stop

// misc vars
string sNotecard; // commands are stored here temporarily for dumping
vector  vWanderPos; // a place to wander to
string lastANIM ;   // last animation run
// Sensor
integer avatarPresent = TRUE;   // Sensor sets this flag when people are within Range.
integer Sensor;                // set to true if we are running a Sensor for avatars

// Coordinate control
vector vInitialPos ; // Vector that will be filled by the script with the initial starting position in region coordinates.
vector vDestPos = ZERO_VECTOR; // Storage for destination position.
string relAbs = "Absolute";    // absolute vs relative positioning

///////////////////////////////////////////////////////////////////////////
//                              FUNCTIONS                                //
///////////////////////////////////////////////////////////////////////////


// DEBUG(string) will chat a string or display it as hovertext if debug == TRUE
DEBUG(string str)
{
    if (debug)
        llSay(0,llGetScriptName()+":" +  str);                    // Send the owner debug info so you can chase NPCS
    if (iTitleText)
    {
        llSleep(0.1);
        llSetText(str,<1.0,1.0,1.0>,1.0);    // show hovertext
    }
}

integer ProcessLink(string str) {
    if(llGetSubString(str, 0, 0) != "@")
        return FALSE;
        
    DEBUG("Processing exern cmd : " + str);

    if (!gExtern)  // if not already backed up.
        lBackup = lNPCScript;
    
    gExtern = TRUE;    // tell the NPCProcess state to forget this command after processing it.
    lNPCScript = [str];
    return TRUE;
}

// common subroutines

// return TRUE if the avatar is owner when private is set, or TRUE if the avatar is in th same group and GROUP is set.
integer checkPerms() {
    if (priPub == "Private") {
        if (llDetectedKey(0) == llGetOwner()){
            kUserKey = llDetectedKey(0);
            return TRUE;
        }
    } else {
            if (llDetectedGroup(0)) {
                kUserKey = llDetectedKey(0);
                return TRUE;
            }
    }
    kUserKey = NULL_KEY;
    return FALSE;
}



NPCStart(string anim)
{        
    if (lastANIM != anim) {
        DEBUG(" Start Anim: " + anim);
        osNpcPlayAnimation(KeyValueGet("key"), anim);

        if(llStringLength(lastANIM) && llGetInventoryType(lastANIM) == INVENTORY_ANIMATION) {
            osNpcStopAnimation(KeyValueGet("key"), lastANIM)      ;  
        }
        lastANIM = anim;
    }            
}


TimerEvent(float timesent)
{
    //DEBUG("Setting  timer: " + (string) timesent);
    llSetTimerEvent(timesent);
}


// Kill a NPC by Name
Kill(string sNPCName)
{
    list avatars = osGetAvatarList(); // Returns a strided list of the UUID, position, and name of each avatar in the region except the owner.


    //DEBUG(llDumpList2String(avatars,","));
    integer i;
    integer count;
    integer j = llGetListLength(avatars);
    for (; i < j; i++){
        if (llList2String(avatars,i) == sNPCName){
            vector v = llList2Vector(avatars,i-1);
            key target = llList2Key(avatars,i-2);    // get the UUID of the avatar
            osNpcRemove(target);
            llOwnerSay("Removed " + sNPCName + " at  location " + (string) v);
            count++;
        }
    }
    if (count)
        llOwnerSay("Removed " + (string) count + " NPC's");
    else
        llOwnerSay("Could not locate " + sNPCName);
}


// return a vector  position we are at. 
vector  Pos()
{
    vector where = llGetPos(); // find the box position
   
    where.z +=    OffsetZ;  // use the ground position + an offset 
        
    if (Editor)
        where  = <128,128,31 + llFrand(1)>; // center of sim for editing
   
   // if attached the height will be too high by 1/2 the agent size
    if (llGetAttached()) {
        vector size = llGetAgentSize(llGetOwner());   
        float Z = size.z;
        where.z -= Z/2;  
    }
   
    // DEBUG("Pos= " + (string) where);
    return  where;
}

Expire()
{
    llOwnerSay("Menu expired");
    iHandle = 0;
    TimerEvent(0.0);
}

// setup a menu with a timer for timeouts, called by all make*()
menu()
{
    llListenRemove(iHandle);
    iChannel = llCeil(llFrand(100000) + 20000);
    iHandle = llListen(iChannel,"","","");
    TimerEvent(120.0);
}


// make a text box
makeText(string Param)
{
    menu();
    llTextBox(kUserKey, Param, iChannel);
}

// top level menu
makeMainMenu()
{
    menu();
    list buttons = ["Appearance","Recording","Save","Help","Reset","Erase RAM", priPub,relAbs,"-","Stop NPC","Sensor","Start NPC"];
    llDialog(kUserKey,"Choose a command",buttons,iChannel);
}

// programmable menu for @commands
makeMenu(list buttons)
{
    menu();
    llDialog(kUserKey,"Choose a command",buttons,iChannel);
}




// make one or two text boxes with prompts
Text(string cmd, string p1, string p2)
{
    sCommand = cmd;
    sParam2 = "";
    if (llStringLength(p2))
        sParam2 = p2;

    makeText(p1);
}

ProcessSensor(integer n)
{
    if (Sensor && n)
        avatarPresent = TRUE;   // someone is here and we need to tell the system to run
    else if (Sensor && !n)
        avatarPresent = FALSE;  // someone is not here and we need to tell the system to stop
    else
        avatarPresent = TRUE;   // someone is effectivly always here
}

vector CirclePoint(float radius) {
    float x = llFrand(radius *2) - radius;        // +/- radius, randomized
    float y = llFrand(radius *2) - radius;        // +/- radius, randomized
    return <x, y, 0>;        // so this should always happen
}

string KeyValueGet(string var) {
    list dVars = llParseString2List(llGetObjectDesc(), ["&"], []);
    do {
        list data = llParseString2List(llList2String(dVars, 0), ["="], []);
        string k = llList2String(data, 0);
        if(k != var) jump continue;
        //DEBUG("got " + var + " = " +  llList2String(data, 1));
        return llList2String(data, 1);
        @continue;
        dVars = llDeleteSubList(dVars, 0, 0);
    } while(llGetListLength(dVars));
    return "";
}

KeyValueSet(string var, string val) {

    //DEBUG("set " + var + " = " + val);
    list dVars = llParseString2List(llGetObjectDesc(), ["&"], []);
    if(llGetListLength(dVars) == 0)
    {
        llSetObjectDesc(var + "=" + val);
        return;
    }
    list result = [];
    do {
        list data = llParseString2List(llList2String(dVars, 0), ["="], []);
        string k = llList2String(data, 0);
        if(k == "") jump continue;
        if(k == var && val == "") jump continue;
        if(k == var) {
            result += k + "=" + val;
            val = "";
            jump continue;
        }
        string v = llList2String(data, 1);
        if(v == "") jump continue;
        result += k + "=" + v;
        @continue;
        dVars = llDeleteSubList(dVars, 0, 0);
    } while(llGetListLength(dVars));
    if(val != "") result += var + "=" + val;
    llSetObjectDesc(llDumpList2String(result, "&"));
}


KeyValueDelete(string var) {
    list dVars = llParseString2List(llGetObjectDesc(), ["&"], []);
    list result = [];
    list added = [];
    do {
        list data = llParseString2List(llList2String(dVars, 0), ["="], []);
        string k = llList2String(data, 0);
        if(k == var) jump continue;
        string v = llList2String(data, 1);
        if(v == "") jump continue;
        if(llListFindList(added, (list)k) != -1) jump continue;
        result += k + "=" + v;
        added += k;
        @continue;
        dVars = llDeleteSubList(dVars, 0 ,0);
    } while(llGetListLength(dVars));
    //DEBUG("del " + var );
    llSetObjectDesc(llDumpList2String(result, "&"));
}


// clear RAM
Clr() {

    lCommands = [];
    llOwnerSay("RAM Memory cleared. Notecards, if any, are not modified.");
    makeMainMenu();
}

integer checkNoteCards()
{
    // Check that they have saved an Appeaance and Path notecard
    integer num = llGetInventoryNumber(INVENTORY_NOTECARD);    // how many notecards overall

    integer i;
    integer count;
    for (; i < num; i++){
        if (llGetInventoryName(INVENTORY_NOTECARD,i) == "Path")
            count++;
        if (llGetInventoryName(INVENTORY_NOTECARD,i) == "Appearance")
            count++;
    }
    // if we have both, run the NPC
    return count;
}

// Notes:
// No llResetScript() used so we can retain memory between rezzes and sim restarts.  NPC info and stateful info is held in the Description
//


// This state is the first main menu
default
{
    state_entry()
    {
        osNpcRemove(KeyValueGet("key"));
        
        string rA = KeyValueGet("co"); // Get the remembered menu setting for Abs Vs Relative
        if (rA == "A")
            relAbs = "Absolute";
        else  if (rA == "R")
            relAbs = "Relative";
        else
            relAbs = "Absolute";
        
        if (showMenu)
            makeMainMenu();
        llSetText("",<1,1,1>,1.0);  // clr all hovertext in ase we are not using it.
    }
    
     link_message(integer sender, integer num, string str, key id) {
         if (str == "Seated")
            state NPCGo;
    }

    on_rez(integer param)    {
       llResetScript();
    }

    touch_start(integer n) {           // if touched, make a menu
        if (checkPerms())
            makeMainMenu();
    }

    // no changed event needed

    // menu listener
    listen(integer iChannel, string name, key id, string message) {
        TimerEvent(0.0);    /// kill the menu expiration timer

        if (message == "Stop NPC")
        {
            if (llStringLength(sNPCName)){
                Kill(sNPCName);
            } else {
                    bNPC_STOP = TRUE;
                makeText("Enter name of an NPC to stop");
            }
        }
        else if (message == "Erase RAM"){
            Clr();
        }
        else if (message == "Relative"){
            relAbs = "Absolute";
            KeyValueSet("co","A");   // remember coordinates = A
            Clr();
        }
        else if (message == "Absolute"){
            relAbs = "Relative";
            KeyValueSet("co","R");   // remember coordinates = R
            Clr();
        }
        else if (message == "Recording"){
            state Commands;        // show them the recording menu
        }
        else if (message == "Private") {
            priPub = "Group";
            llOwnerSay("Group members have control");
            makeMainMenu();
        }
        else if (message == "Group") {
            priPub = "Private";
            llOwnerSay("Only you have control");
            makeMainMenu();
        }
        else if (message == "Reset"){
            llResetScript();
        }
        else if (message == "Sensor") {
            integer count = checkNoteCards();

            if (count == 2)  {
                ProcessSensor(1);       // fake 1 avatar to get it rezzed
                Sensor = TRUE;        // we need to scan for avatars
                state NPCGo;
            }

            // lslEditor does not handle the above, so I hack it in
            if (Editor) {
                Sensor = TRUE;        // we need to scan for avatars
                state NPCGo;
            }

            llOwnerSay("You have not saved a recording and/or appearance, so we cannot start a NPC");
            makeMainMenu();
        }
        else if (message == "Appearance")  {
            llRemoveInventory("Appearance");            // delete the notecard
            osAgentSaveAppearance(kUserKey, "Appearance");    // make the ntecard
            llOwnerSay("Your Appearance has been recorded in notecard 'Appearance'");
            makeMainMenu();
        }
        else if (message == "Save") {

            if (llGetAttached()) {
                llOwnerSay("Detach the HUD and put it where you want the NPC to appear, then click Start");
                return;
            }
            if (llGetListLength(lCommands) == 0) {
                llOwnerSay("Nothing recorded, you need to make some Recodings first");
                makeMainMenu();
                return;
            }
            state Save;
        }
        else if (message == "Help"){
            llLoadURL(kUserKey,"Click to view help","http://www.outworldz.com/opensim/posts/NPC/");
            makeMainMenu();
        }
        else if (message == "Start NPC")    {
            integer count = checkNoteCards();
            if (Editor) state NPCGo;
            if (count == 2)
                state NPCGo;

            llOwnerSay("You have not saved a either recording or and appearance, so we cannot start a NPC");
            makeMainMenu();
        }
        else if (bNPC_STOP){
            bNPC_STOP = FALSE;
            Kill(message);
            makeMainMenu();
        }
    }
    timer(){
        Expire();
    }
}


// This state is used to save a Path notecard
state Save
{
    state_entry(){
        makeText("Stand where you want the NPC to appear, and enter the NPC Name");
    }
    listen(integer iChannel, string name, key id, string message) {
        TimerEvent(0.0);    /// kill the menu expiration timer

        sNPCName = message; // in case we need to kill it.
        vector  vDest = (vector) Pos();
            
        if (relAbs == "Relative")
        {
            vDest  -= llGetPos();    // just an offset for relative
        }
        sNotecard = "@spawn=" + message + "|" +  (string) vDest  + "\n";
        integer i;
        integer j = llGetListLength(lCommands);
        for (; i < j; i++){
            // get the command to save to the notecard
            string line = llList2String(lCommands,i);
            if (relAbs == "Absolute") {
                sNotecard += line;    // add the un-modified string to the notecard
            } else {
                // since we have to record absolute coords since we do not know whwre the box goes until they press Save,
                // we process the absolute to relative conversion for walks here
                list parts = llParseString2List(line,["="],[]); //get the @command
    
                if (llList2String(parts,0) == "@walk") {
                    vector vec = (vector) llList2String(parts,1) - llGetPos();
                    sNotecard += "@walk=" + (string) vec + "\n";
                }
                else {
                    sNotecard += line;    // add the un-modified string to the notecard
                }
            }
        }
        llRemoveInventory("Path");        // delete the old notecard
        osMakeNotecard("Path",sNotecard); // Makes the notecard.
        llOwnerSay("'Path' notecard has been written");
        state default;
    }
    timer(){
       Expire();
    }

}

// This state is used to record the path for the NPC
// Each command can take 0, 1, or 2 params
state Commands
{
    state_entry()    {
        makeMenu(lAtButtons);
    }

    on_rez(integer p)    {
        llResetScript();
    }
    touch_start(integer n){
        if (checkPerms())
            makeMenu(lAtButtons);
    }

    listen(integer iChannel, string name, key id, string message)
    {
        TimerEvent(0.0);    /// kill the menu expiration timer

        if (message == "Menu"){
            showMenu= TRUE;
            state default;
        }
        else if (message == "More"){
            makeMenu(lMenu2);
        }
        else if (message == "<<") {
            makeMenu(lAtButtons);
        }
        else if (message == "@comment"){
            Text("# ","Enter a comment","");
        }
        else if (message == "@stop"){
            lCommands += "@stop"+  "\n";
            makeMenu(lAtButtons);
        }
        else if (message == "@run"){
            lCommands += "@run=" + "\n";
            llOwnerSay("Recorded position: " + (string) Pos());
            makeMenu(lAtButtons);
        }
        else if (message == "@fly"){
            lCommands += "@fly=" +(string) Pos() + "\n";
            llOwnerSay("Recorded position: " + (string) Pos());
            makeMenu(lAtButtons);
        }
        else if (message == "@land"){
            lCommands += "@land=" + (string) Pos() + "\n";
            llOwnerSay("Recorded position: " + (string)Pos());
            makeMenu(lAtButtons);
        }
        else if (message == "@walk") {
            lCommands += "@walk=" + (string)Pos() + "\n";
            llOwnerSay("Recorded position: " + (string)Pos());
            makeMenu(lAtButtons);
        }
        else if (message == "@stop"){
            lCommands += "@stop"+  "\n";
            makeMenu(lAtButtons);
        }
        else if (message == "@sound"){
            Text("@sound=","Enter a sound name or UUID to trigger","");
        }
        else if (message == "@randsound"){
            lCommands += "@randsound"+  "\n";
            makeMenu(lAtButtons);
        }
        else if (message == "@say") { 
            Text("@say=","Enter what the NPC will say","");
        }
        else if (message == "@whisper"){
            Text("@whisper=","Enter what the NPC will whisper","");
        }
        else if (message == "@shout"){
            Text("@shout=","Enter what the NPC will shout","");
        }
        
        else if (message == "@wander") {
            Text("@wander=","Enter radius to wander","Enter number of wanders");
        }
        else if (message == "@pause") {
            Text("@pause=","Enter time to pause","");
        }
        else if (message == "@rotate") {
            Text("@rotate=","Enter degrees to rotate","");
        }
        else if (message == "@sit"){
            Text("@sit=","Enter name of object to sit on","");
        }
        else if (message == "@cmd"){
            Text("@cmd=","Enter cjhannel to speak on","Enter text to speak");
        }
        else if (message == "@stand"){
            lCommands += "@stand\n";
            llOwnerSay("Stand Recorded");
            makeMenu(lAtButtons);
        }
        else if (message == "@animate"){
            Text("@animate=","Enter animation name to play","Enter time to play the animation");
        }
        else  if (! llStringLength(sParam2)) {
            lCommands +=  sCommand + message + "\n";
            llOwnerSay("Recorded");
            makeMenu(lAtButtons);
        }
        else if (llStringLength(sParam2)){
            sCommand = sCommand + message + "|";
            llOwnerSay("Recorded");
            makeText(sParam2);
            sParam2 = "";
        }
    }
    timer() {
       Expire();
    }

}


// This state will create an NPC in world
state NPCGo {
    state_entry() {
        // DEBUG("NPCGo");
        ProcessSensor(1);       // assert that someone is home so we can get rezzed.
        osNpcRemove(KeyValueGet("key"));
        TimerEvent(5);
    }
    timer() {
        lNPCScript = llParseString2List(osGetNotecard("Path"), ["\n"], []);
        if(llGetListLength(lNPCScript) == 0) {
            llSay(DEBUG_CHANNEL, "No Path notecard found.");
            TimerEvent(0.0);
            return;
        }
        state ProcessNPCLine;
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START)
            state ProcessNPCLine;
    }
    on_rez(integer num) {
        llResetScript();
    }
    state_exit() {
        TimerEvent(0.0);
    }
}


// This state loops over the notecard, processing each command
state ProcessNPCLine
{
    state_entry()
    {
        // DEBUG("ProcessNPCLine");
        @ignore;

        string next = llList2String(lNPCScript, 0);        // get the next command
        // DEBUG("Cmd:" + next);
        lNPCScript = llDeleteSubList(lNPCScript, 0, 0);      // delete it
        if (! gExtern) 
            lNPCScript += next;                                // put it on the end unless it came from a Link Message
        
        if(llStringLength(next) && llGetSubString(next, 0, 0) != "@")
            jump ignore;    // ignore non-@ commands
        
        list data  = llParseString2List(next, ["="], []);
        npcAction = llToLower(llStringTrim(llList2String(data, 0), STRING_TRIM));
        npcParams = llStringTrim(llList2String(data, 1), STRING_TRIM);

        @commands;

        // Sensor 
        if (! avatarPresent){
            state  nobodyHome;
        }
        DEBUG("gExtern=" + (string) gExtern);
        DEBUG("npcAction=" + next);

        // If in @stop mode, check for anything to run.
        if (gExtern == TRUE && llStringLength(next) == 0 )
            state stop;

        if(npcAction == "@continue") {

            gExtern = FALSE;    // tell the NPCProcess state to continue reading the notecard
            lNPCScript = lBackup ;
            jump ignore;
        }

        if(npcAction == "@spawn") {
            // DEBUG("Spawning");
            integer lastIdx = llGetListLength(lNPCScript)-1;
            lNPCScript = llDeleteSubList(lNPCScript, lastIdx, lastIdx);        // remove spawn commands, we do them only once
            list spawnData = llParseString2List(npcParams, ["|"], []);
            KeyValueSet("name", llList2String(spawnData, 0));
            list spawnDest = llParseString2List(llList2String(spawnData, 1), ["<", ",", ">"], []);
            vInitialPos.x = llList2Float(spawnDest, 0);
            vInitialPos.y = llList2Float(spawnDest, 1);
            vInitialPos.z = llList2Float(spawnDest, 2);
            state spawn;
        }
        if(npcAction == "@stop") {
            state stop;
        }
        if(npcAction == "@goto") {
            // DEBUG("goto");
            integer lastIdx = llGetListLength(lNPCScript)-1;
            lNPCScript = llDeleteSubList(lNPCScript, lastIdx, lastIdx);
            // Wind commands till goto label.
            @wind;
            string next1 = llList2String(lNPCScript, 0);
            lNPCScript = llDeleteSubList(lNPCScript, 0, 0);
            lNPCScript += next1;
            if(next1 != npcParams) jump wind;
            // Wind the label too.
            next1 = llList2String(lNPCScript, 0);
            lNPCScript = llDeleteSubList(lNPCScript, 0, 0);
            lNPCScript += next1;
            // Get next command.
            list data1  = llParseString2List(next1, ["="], []);
            npcAction = llToLower(llStringTrim(llList2String(data1, 0), STRING_TRIM));
            npcParams = llStringTrim(llList2String(data1, 1), STRING_TRIM);
            // Reschedule.
            jump commands;
        }
        
        if(npcAction == "@sound") {
            // DEBUG("sound");
            llTriggerSound(npcParams,1.0);
            jump ignore;      // process next line
        }
        if(npcAction == "@randsound") {
            // DEBUG("random sound");
            integer N = llGetInventoryNumber(INVENTORY_SOUND);
            integer rand = llCeil(llFrand(N)) -1;    // pick a random sound
            string toPlay = llGetInventoryName(INVENTORY_SOUND,rand);
            llTriggerSound(toPlay,1.0);
            jump ignore;      // process next line
        }

        if(npcAction == "@walk") {
            // DEBUG(WALK);
            list dest = llParseString2List(npcParams, ["<", ",", ">"], []);
            vDestPos.x = llList2Float(dest, 0);
            vDestPos.y = llList2Float(dest, 1);
            vDestPos.z = llList2Float(dest, 2);

            if (vDestPos == ZERO_VECTOR) {
                llSay(DEBUG_CHANNEL,"Bad (zeros) position for @walk");
                state ProcessNPCLine;
            }
            
            NPCWalkOption = OS_NPC_NO_FLY ;      
            state walk;
        }
        
        if(npcAction == "@fly") {
            list dest = llParseString2List(npcParams, ["<", ",", ">"], []);
            vDestPos.x = llList2Float(dest, 0);
            vDestPos.y = llList2Float(dest, 1);
            vDestPos.z = llList2Float(dest, 2);

            if (vDestPos == ZERO_VECTOR) {
                llSay(DEBUG_CHANNEL,"Bad (zeros) position for @walk");
                state ProcessNPCLine;
            }
            
            NPCWalkOption = OS_NPC_FLY ;  
            state walk;
        }
        
        if(npcAction == "@run") {
           list dest = llParseString2List(npcParams, ["<", ",", ">"], []);
            vDestPos.x = llList2Float(dest, 0);
            vDestPos.y = llList2Float(dest, 1);
            vDestPos.z = llList2Float(dest, 2);

            if (vDestPos == ZERO_VECTOR) {
                llSay(DEBUG_CHANNEL,"Bad (zeros) position for @walk");
                state ProcessNPCLine;
            }
            
            NPCWalkOption = OS_NPC_NO_FLY | OS_NPC_RUNNING;
            state walk;
        }
        
        if(npcAction == "@land") {
            list dest = llParseString2List(npcParams, ["<", ",", ">"], []);
            vDestPos.x = llList2Float(dest, 0);
            vDestPos.y = llList2Float(dest, 1);
            vDestPos.z = llList2Float(dest, 2);

            if (vDestPos == ZERO_VECTOR) {
                llSay(DEBUG_CHANNEL,"Bad (zeros) position for @walk");
                state ProcessNPCLine;
            }

            NPCWalkOption= OS_NPC_FLY | OS_NPC_LAND_AT_TARGET ;  
            state walk;
        }
        
          
        
        // chat commands    
        // speak in white text

        if(npcAction == "@say") {
            // DEBUG("say");
            osNpcSay(KeyValueGet("key"),0, npcParams);
            jump ignore;    // process next line
        }
        if(npcAction == "@shout") {
            // DEBUG("shout");
            osNpcShout(KeyValueGet("key"),0, npcParams);
            jump ignore;    // process next line
        }
        if(npcAction == "@whisper") {
            // DEBUG("whisper");
            osNpcWhisper(KeyValueGet("key"),0, npcParams);
            jump ignore;    // process next line
        }
        // speak a command on a channel, so you can open doors and control stuff.
        if(npcAction == "@cmd") {
            // DEBUG("cmd");
            list dataToSpeak = llParseString2List(npcParams, ["|"], []);
            integer iChannel = (integer) llList2String(dataToSpeak,0);
            string stringToSpeak = llList2String(dataToSpeak,1);
            osNpcSay(KeyValueGet("key"), iChannel, stringToSpeak);
            jump ignore;    // process next line
        }
        // stop everything
        if(npcAction == "@pause") {
            // DEBUG("pause");
            KeyValueSet("pause", npcParams);
            state pause;
        }
        if(npcAction == "@wander") {
            // DEBUG("wander");
            list wanderData = llParseString2List(npcParams, ["|"], []);
            KeyValueSet("wd", llList2String(wanderData, 0));
            KeyValueSet("wc", llList2String(wanderData, 1));
            vDestPos = osNpcGetPos(KeyValueGet("key"));        // set the wander start
            DEBUG("Starting at " + (string) vDestPos);
            state wander;
        }
        if(npcAction == "@rotate") {
            // DEBUG("rotate");
            KeyValueSet("rot", npcParams);
            state rotate;
        }
        if(npcAction == "@sit") {
            // DEBUG("sit");
            KeyValueSet("sit", npcParams);
            state sit;
        }
        if(npcAction == "@stand") {
            // DEBUG("stand");
            state stand;
        }
        if(npcAction == "@delete") {
            state delete;
        }
        if(npcAction == "@animate") {
            // DEBUG("animate");
            list animateData = llParseString2List(npcParams, ["|"], []);
            KeyValueSet("an", llList2String(animateData, 0));
            KeyValueSet("at", llList2String(animateData, 1));
            state animate;
        }
        llSay(DEBUG_CHANNEL, "ERROR: Unrecognized script line: " + npcAction + "=" + npcParams);
        jump ignore;

    }
    changed(integer change) {
        if(change & CHANGED_REGION_START)
            state NPCGo;
    }
    on_rez(integer num) {
        llResetScript();
    }
    link_message(integer sender, integer num, string str, key id) {
        if (ProcessLink(str))
            state ProcessNPCLine;
    }


}


state nobodyHome
{
    state_entry()    {
        // DEBUG("Removing NPC");
        osNpcRemove(KeyValueGet("key"));
        llSensorRepeat("","",AGENT,RANGE,TWO_PI, 5);
    }
    sensor(integer n)    {
        llSensorRemove();
        state NPCGo;
    }
}


state spawn
{
    state_entry() {
        // DEBUG("state spawn");
        list name = llParseString2List(KeyValueGet("name"), [" "], []);
       // notecard is stored as offsets from this box with relative addressing.  Convert to absolute
        if (relAbs == "Relative"){
            vInitialPos += llGetPos();
        }

        // DEBUG("rez:" + (string) vInitialPos);
        
        key NPCKey = osNpcCreate(llList2String(name, 0), llList2String(name, 1), vInitialPos, "Appearance", NPCOptions);    // no OS_NPC_SENSE_AS_AGENT allowed due to llSensor Use
        KeyValueSet("key",NPCKey);
        llMessageLinked(LINK_SET,0,"NPCkey",NPCKey);
            
       //osNpcLoadAppearance(KeyValueGet("key"), "Appearance");
        TimerEvent(REZTIME);
        NPCStart(STAND);
    }
    link_message(integer sender, integer num, string str, key id) {
        if (ProcessLink(str))
            state ProcessNPCLine;
    }
    timer() {
        KeyValueDelete("name");
        state ProcessNPCLine;
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START)
            state NPCGo;
    }
    on_rez(integer num) {
        llResetScript();
    }
    state_exit(){
        TimerEvent(0.0);
    }


}


state rotate {
    state_entry() {
        // DEBUG("state rotate");
        osNpcSetRot(KeyValueGet("key"), llEuler2Rot(<0,0,(float)KeyValueGet("rot")> * DEG_TO_RAD));
        TimerEvent(TIMER);
    }
    link_message(integer sender, integer num, string str, key id) {
        if (ProcessLink(str))
            state ProcessNPCLine;
    }
    timer() {
        KeyValueDelete("rot");
        state ProcessNPCLine;
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START)
            state NPCGo;
    }
    on_rez(integer num) {
        llResetScript();
    }
    state_exit() {
        TimerEvent(0.0);
    }


}

state sit {
    state_entry() {
        DEBUG ("state sit on " + KeyValueGet("sit"));

        osNpcSit(KeyValueGet("key"), llGetKey(), OS_NPC_SIT_NOW);
        osNpcStopAnimation(KeyValueGet("key"),"sit");
         
        KeyValueDelete("sit");
        state ProcessNPCLine;
    }
    link_message(integer sender, integer num, string str, key id) {
        if (ProcessLink(str))
            state ProcessNPCLine;
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START)
            state NPCGo;
    }
    on_rez(integer num) {
        llResetScript();
    }
    state_exit(){
        TimerEvent(0.0);
    }

}

state stand {
    state_entry() {
        // DEBUG("state stand");
        osNpcStand(KeyValueGet("key"));
        state ProcessNPCLine;
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START)
            state NPCGo;
    }
    on_rez(integer num) {
        llResetScript();
    }

}

state animate {
    state_entry() {
        // DEBUG("state animate");
        if(llGetInventoryType(KeyValueGet("an")) == INVENTORY_ANIMATION) osNpcPlayAnimation(KeyValueGet("key"), KeyValueGet("an"));
        TimerEvent((float) KeyValueGet("at"));
    }
    link_message(integer sender, integer num, string str, key id) {
        if (ProcessLink(str))
            state ProcessNPCLine;
    }
    timer() {
        if(llGetInventoryType(KeyValueGet("an")) == INVENTORY_ANIMATION) osNpcStopAnimation(KeyValueGet("key"), KeyValueGet("an"));
        KeyValueDelete("an");
        KeyValueDelete("at");
        state ProcessNPCLine;
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START)
            state NPCGo;
    }
    on_rez(integer num) {
        llResetScript();
    }
    state_exit() {
        TimerEvent(0.0);
    }

}
state delete {
    state_entry() {
        // DEBUG("state delete");
        osNpcRemove(KeyValueGet("key"));
    }
    link_message(integer sender, integer num, string str, key id) {
        if(str == "@npc_start")
        {
            state NPCGo;
        }
    }

    // No on_rez or changed event needed, the only way out is a link message
}


state walk {
    state_entry() {

       if (NPCWalkOption & OS_NPC_LAND_AT_TARGET ) {
            NPCStart(FLY);

        } else if (NPCWalkOption & OS_NPC_RUNNING ) {
            NPCStart(RUN);

        } else  {  
            NPCStart(WALK);
        }
                      
        if (Sensor)  {
            // DEBUG("Sensor on");
            llSensor("","",AGENT,RANGE,TWO_PI);        // sensor survive state switches.
        }

        newDest = vDestPos ;
        // notecard is stored as offsets from this box with relative addressing.  Convert to absolute
        if (relAbs == "Relative"){
            newDest += llGetPos();
        }

        DEBUG("Moveto:" + (string) newDest);
        iWaitCounter = WAIT;            // wait 60 seconds to get to a destination.
        osNpcMoveToTarget(KeyValueGet("key"), newDest, NPCWalkOption);
        TimerEvent(TIMER);
    }
    link_message(integer sender, integer num, string str, key id) {
        if (ProcessLink(str))
            state ProcessNPCLine;
    }
    timer() {
        if (--iWaitCounter) {            

            if (llVecDist(osNpcGetPos(KeyValueGet("key")), newDest) > MAXDIST)  {
                return;
            }      
        }
            

        if (NPCWalkOption & OS_NPC_LAND_AT_TARGET ) {
            NPCStart(STAND);
        } else if (NPCWalkOption & OS_NPC_RUNNING ) {
            NPCStart(STAND);
        } else  {  
            NPCStart(STAND);
        }
            
        state ProcessNPCLine;
    }
    sensor(integer n) {
        ProcessSensor(n);
    }
    no_sensor(){
        ProcessSensor(0);
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START)
            state NPCGo;
    }
    on_rez(integer num) {
        llResetScript();
    }
    state_exit() {
        TimerEvent(0.0);
    }

}

state wander
{
    state_entry() {
        DEBUG("state wander");
        if (Sensor)
        {
            // DEBUG("Sensor on");
            llSensor("","",AGENT,RANGE,TWO_PI);        // sensor survive state switches.
        }

        vector point = CirclePoint((float)KeyValueGet("wd"));
        DEBUG("CirclePoint:" + (string) point);
        vWanderPos = vDestPos + point;
        DEBUG("vWanderPos:" + (string) vWanderPos);
        // notecard is stored as offsets from this box with relative addressing.  Convert to absolute
       // if (relAbs == "Relative"){
            
          //  vWanderPos += llGetPos();
          //  DEBUG("Relative:" + (string) vWanderPos);
       // }

        fTimerVal = WANDERTIME;    // default time to pause after each wander
        if (WANDERRAND)
            fTimerVal = llFrand(WANDERTIME);    // override, they want random times

        NPCStart(WALK);

        DEBUG("Wander to:" + (string) vWanderPos);

        osNpcMoveToTarget(KeyValueGet("key"), vWanderPos, NPCWalkOption);
        iWaitCounter = WAIT;            // wait 60 seconds to get to a destination.

        TimerEvent(TIMER);      // first time we wait for the short timer.
    }
    link_message(integer sender, integer num, string str, key id) {
        if (ProcessLink(str))
            state ProcessNPCLine;
    }
    timer() {

        if (--iWaitCounter)           // wait 60 seconds to get to a destination.
            if (llVecDist(osNpcGetPos(KeyValueGet("key")), vWanderPos) > MAXDIST) return;


        // see if wander counter == 0, if so, stop walking, go to stand and process next line
        if(KeyValueGet("wc") == "0") {
            KeyValueDelete("wc");
            KeyValueDelete("wd");
            NPCStart(STAND);
            state ProcessNPCLine;
        }

        // subtract 1 from the wander counter
        KeyValueSet("wc", (string)((integer)KeyValueGet("wc")-1));

        NPCStart(STAND);
        state wanderhold;
    }
    sensor(integer n) {
        ProcessSensor(n);
    }
    no_sensor() {
        ProcessSensor(0);
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START)
            state NPCGo;
    }
    on_rez(integer num) {
        llResetScript();
    }
    state_exit() {
        TimerEvent(0.0);
    }
}


state wanderhold
{
    state_entry(){
        // now that we have reached a wander spot, slow the timer down to the desired value
        TimerEvent(fTimerVal);
        if (Sensor)
        {
            // DEBUG("Sensor on");
            llSensor("","",AGENT,RANGE,TWO_PI);        // sensor survive state switches.
        }
    }
    timer()  {
        state wander;
    }
    sensor(integer n){
        ProcessSensor(n);
    }
    no_sensor(){
        ProcessSensor(0);
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START)
            state NPCGo;
    }
    on_rez(integer num) {
        llResetScript();
    }
    state_exit() {
        TimerEvent(0.0);
    }


}



// @pause=10 will stand for 10 seconds
state pause {
    state_entry() {
        DEBUG("state pause");
        NPCStart(STAND);
        if (Sensor)
        {
            // DEBUG("Sensor on");
            llSensor("","",AGENT,RANGE,TWO_PI);        // sensor survive state switches.
        }
        TimerEvent((float)KeyValueGet("pause"));
    }
    link_message(integer sender, integer num, string str, key id){
        if (ProcessLink(str))
            state ProcessNPCLine;
    }
    timer() {
        NPCStart(STAND);
        KeyValueDelete("pause");
        state ProcessNPCLine;
    }
    sensor(integer n)
    {
        ProcessSensor(n);
    }
    no_sensor()
    {
        ProcessSensor(0);
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START)
            state NPCGo;
    }
    on_rez(integer num) {
        llResetScript();
    }
    state_exit()
    { 
        TimerEvent(0.0); 
    }
} 

// @stop makes the NPC stand there.  You have to linkmessage @continue to get moving again
state stop {
    state_entry() {
        DEBUG("Stopped");
    }
    link_message(integer sender, integer num, string str, key id){
        if (ProcessLink(str))
            state ProcessNPCLine;        
        
         if (str == "Unseated")
         {
             llResetScript();
         }
                        
    }
    changed(integer change) {
        if(change & CHANGED_REGION_START)
            state NPCGo;
    } 
    on_rez(integer num) {
        llResetScript();
    }
}

