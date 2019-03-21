// :SHOW:1
// :CATEGORY:NPC
// :NAME:All In One NPC Recorder and Player
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2013-09-08 18:27:47
// :EDITED:2015-05-29  11:25:14
// :ID:27
// :NUM:1612
// :REV:2.3
// :WORLD:OpenSim
// :DESCRIPTION:
// All in one NPC recorder player.
// Supports both absolute and relative paths and many new commands
// Add animations named "Fly, Walk, Stand and Run"
// Click Prim to use.
// Should be worn as a HUD to record.
// Put it on the ground and click Sensor or Start NPC when done.
// :CODE:
// This is Rev 2.2 5/17/2015

// Revision History
// Rev 1.1 10-2-2014 @Sit did not work.  Minor tweaks to casting for lslEditor
// Rev 1.2 10-14-2014 @ sit had wrong type.
// Rev 1.3 relative movement fixed for @fly
// Rev 1.4 4-3-2014 allow anyone to use this, non owners and non group members can only start and stop.
// Rev 1.5 5-17-2014 set sensor to auto start on reboot of sim
// Rev 1.6 5-24-2014 move menu so you can get it by touching, removed many of the KeyValues to RAM for efficiency
// Rev 1.7 CHANGED_REGION_RESTART, not CHANGED_REGION_START (Opensim difference)
// Rev 1.8 tuned up Kill NPC, added more flexible upgrader
// Rev 1.9 Better script injection by link message// Rev 2.0 Added osSetSpeed so you can speed up or slow down an NPC.
// Rev 2.1 No laggy sensor used exept to sit on stuff
// Rev 2.2 Various sensor fixes
// Rev 2.3 Sets No Sensorin menu, must be started by hand
//*******************************************************************//

// Instructions on how to use this is at http://www.outworldz.com/opensim/posts/NPC/
// This is an OpenSim-only script.
// Author: Fred Beckhusen (Ferd Frederix) aka Fred Beckhusen - fred@mitsi.com

////////////////////////////////////////////////////////////////////////////////////////////
//    Original code was Copyright (C) 2013 Wizardry and Steamworks - License: GNU GPLv3    //
///////////////////////////////////////////////////////////////////////////////////////////
//  Please see: http://www.gnu.org/licenses/gpl.html for legal details,                  //
//  rights of fair usage, the disclaimer and warranty conditions.                        //
///////////////////////////////////////////////////////////////////////////////////////////
// The original NPC controller was from http://was.fm/opensim:npc
// Extensive additions and bug fixes by Fred Beckhusem, aka Fred Beckhusen (Ferd Frederix), fred@mitsi.com
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
//  @cmd=parm1|parm2
//  NaN in the table below meand Not a Number.   This means there is no parameter

//Command     First Parameter             Second Parameter        Description
//@spawn      name                        location (vector)       Rezzes an NPC with name at a location.
//@walk       destination (vector)        NaN                     Makes the NPC walk to destination.
//@fly        destination (vector)        NaN                     Makes the NPC fly to destination.
//@land       destination (vector)        NaN                     Makes the NPC land at destination.
//@say        string                      NaN                     Makes the NPC speak a phrase.
//@whisper    string                      NaN                     Makes the NPC whisper a phrase.
//@shout      string                      NaN                     Makes the NPC shout a phrase.
//@pause      seconds (float)             NaN                     Makes the NPC wait for a multiple of seconds.
//@wander     radius (float)              cycles (integer)        Makes the NPC wander in radius, for cycles seconds.
//@delete     NaN                         NaN                     Removes the NPC.  Rerquires a link message of @npc_start to continue
//@npc_start  NaN                         NaN                     Starts the NPC at the beginning
//@animate    animation (string)          time (float)            Makes the NPC trigger the animation animation for time seconds.
//@goto       label (string)              NaN                     Jump to the label label in the script.
//@rotate     degrees (float)             NaN                     Rotate the NPC degrees around the Z axis.
//@sit        primitive name              NaN                     Sit on a primitive with a given name.
//@stand      NaN                         NaN                     If sitting on a primitive, stand up.
//@sound      sound_name                  NaN                     plays a sound from inventory
//@randsound  NaN                         NaN                     Plays a random sound from inventory
//@cmd        channel (integer)           string                  Says string on channel, for controlling external gadgets

//@stop       NaN                         NaN                     Halts the NPC script indefinitely. Can be started with a link message
//@go         NaN                         NaN                     Continues on next notecard line, for use in link messages


//////////////////////////////////////////////////////////
//                  DEBUG                               //
//////////////////////////////////////////////////////////
integer debug = FALSE;         // set to TRUE or FALSE for debug chat on various actions
integer Editor = FALSE;        // set to to TRUE to working in  LSLEditor, FALSE for in-world.
                              // you must also include the NPC commands found in the other script since LSLEditor does not support OpenSim
integer iTitleText = TRUE;    // set to TRUE to see debug info in text above the controller

//////////////////////////////////////////////////////////
//                  TUNABLE CONFIGURATION               //
//////////////////////////////////////////////////////////
integer   allowUsers = FALSE;   // If true, any user can get a Start NPC and Stop NPC menu.  Only groups and owners can get all commands if TRUE, or FALSE
float     MAXDIST = 2.0;       // how close a NPC has to get to a dest pos to continue to next state. Do not lower this too much, as it may miss the target
float     TIMER = 0.5;         // how often the system checks the distance traveled.  Fastest you can go is 0.5 seconds
integer   WANDERRAND = TRUE;   // set to TRUE and they will pause during wanders a random number of seconds
float     WANDERTIME = 10.0;    // how long they stand after each @wander,if WANDERRAND is FALSE. If WANDERRAND is  TRUE, this is the max time
integer   WAIT = 20;           // wait for this number of seconds for the NPC to reach a destination (for safety). If it fails to reach a target, it will move on after this time.
float     RANGE = 96.0;        // 1 to N meters  - anyone this close to the controller will start NPCS if Sensor button is clicked
float     REZTIME = 10.0;      // wait this long for NPC to rez in, then start the process
string    STAND = "Stand";     // the name of the default Stand animation
string    WALK = "Walk";       // the name of the default Walk animation
string    FLY = "Fly";        // the name of the default Fly animation
string    RUN = "Run";        // the name of the default Run animation
string    LAND = "Land";      // the name of the default land animation ( for birds only)
float     OffsetZ = 0.5;      // appear 0.5 meter above ground, this is added to all destinations to keep them from sinking in.  For fun, make this large and watch them fall out of the sky
float    SPEEDMULT = 0.8;      //  1.0 = regular vatar speed. Smaller numbers slow down walks. Large numbers speed them up.


// DESCRIPTIONS FIELDS HAVE TO SURVIVE A RESET
//  These vars are stored  by saving them with KeyValueSet
// "pr" is a 0 if it is set for Owner Only, 1 for Group control
// "se" is "on" if Started
// "co" = "R" or "A" for relative or absolute addressing mode
// "key" = NPC key

// These Globals used to be stored in description.   Moved to RAM in V1.6
float RAMPause;          // @pause param
float RAMwd ;            // @wander distance
integer RAMwc;           // @wander count
float RAMrot;            //  @rotate
string RAMsit;           // @sit primname
string RAManimationName; // @animate animation (string) time (float)
float RAManimationTime;

// other globals section
integer iChannel;        // a listen channel, randomly assigned
integer iHandle;         // the handle to it

// NPC controls
vector newDest ;                // tmp storage for the walks
integer iWaitCounter ;          // wait for this number of seconds for the NPC to reach a desrtination
string sNPCName;                // the name of the NPC that may be in world. So we can remove it.
integer bNPC_STOP = FALSE;      // boolean to reuse a listener
integer bForget = FALSE;        // set to TRUE by link messages so we do not remember them
float  fTimerVal ;              // how long we wait when wandering (calculated)
            
// OS_NPC_CREATOR_OWNED will create an 'owned' NPC that will only respond to osNpc* commands issued from scripts that have the same owner as the one that created the NPC.
// OS_NPC_NOT_OWNED will create an 'unowned' NPC that will respond to any script that has OSSL permissions to call osNpc* commands.
integer  NPCOptions = OS_NPC_CREATOR_OWNED;    // only yhe owner of this box can control this NPC.

integer walkstate = 0;  // helps us reshare the walk state for run, fly and land - a bit of a hack, but it saves RAM. Has to be done this way because some bits of NPCWalkOption are asserted as 0

integer NPCWalkOption;   // Some notes for what happens to NPCWalkOption:
// OS_NPC_FLY - Fly the avatar to the given position. The avatar will not land unless the OS_NPC_LAND_AT_TARGET option is also given.
// OS_NPC_NO_FLY - Do not fly to the target. The NPC will attempt to walk to the location. If it's up in the air then the avatar will keep bouncing hopeless until another move target is given or the move is stopped
//OS_NPC_LAND_AT_TARGET - If given and the avatar is flying, then it will land when it reaches the target. If OS_NPC_NO_FLY is given then this option has no effect.
// OS_NPC_RUNNING - if given, NPC avatar moves at running/fast flying speed, otherwise moves at walking/slow flying speed.

// menus
string mSensor="Sensor";    // Sensor or "No Sensor"
integer showMenu = FALSE;       // when we switch states, we need to bring up a menu
list lAtButtons = ["Menu","-", "More",         "@run","@walk","@fly",          "@land","@wander","@sit",  "@stand","@animate","@rotate"];
list lMenu2 = ["<<", "@comment", "@stop",      "@say","@whisper","@shout",     "@sound","@randsound", "-", "@cmd", "@pause", "@delete" ];
string sCommand;  // place to store a command for two-prompted ones
string sParam2;   // place to store a prompt for two-prompted ones
string priPub = "Owner Only";    // Private or Group
key kUserKey;        // the person who is controlling the avatar, not the Owner

// the command lists
list lCommands;  // commands are stored here
list lNPCScript; // Storage for the NPC script.
string npcAction; // Storage for the next action. @cmd=0|hello, this becomes @cmd
string npcParams; // Storage for the param, @cmd=0|hello, this becomes 0|hello

// misc vars
string sNotecard; // commands are stored here temporarily for dumping
vector  vWanderPos; // a place to wander to
string lastANIM ;   // last animation run
// Sensor
integer avatarPresent;   // Sensor sets this flag when people are within Range.

// Coordinate control
vector vInitialPos ; // Vector that will be filled by the script with the initial starting position in region coordinates.
vector vDestPos = ZERO_VECTOR; // Storage for destination position.
string relAbs = "Relative";    // absolute vs relative positioning

///////////////////////////////////////////////////////////////////////////
//                              FUNCTIONS                                //
///////////////////////////////////////////////////////////////////////////


// DEBUG(string) will chat a string or display it as hovertext if debug == TRUE
DEBUG(string str)
{
    if (debug)
        llOwnerSay( str);                    // Send the owner debug info so you can chase NPCS
    if (iTitleText)
    {
        llSleep(0.1);
        llSetText(str,<1.0,1.0,1.0>,1.0);    // show hovertext
    } 
}

integer SenseAvatar()
{
    //Returns a strided list of the UUID, position, and name of each avatar in the region except the owner.
    list avatars = llGetAgentList(AGENT_LIST_REGION ,[]);
    integer numOfAvatars = llGetListLength(avatars);
    if (numOfAvatars == 0)
    {
        DEBUG("No people");
        return 0;
    }
    DEBUG("Located " + (string)numOfAvatars + " avatars"); 
        
    integer nAvatars;
    integer i;
    for( i = 0;i < numOfAvatars; i++) {
        key aviKey = llList2Key(avatars,i);
        if (!osIsNpc(aviKey)) {
            list detail = llGetObjectDetails(aviKey,[OBJECT_POS]);
            vector pos = llList2Vector(detail,0);
            float dist = llVecDist(pos, llGetPos());
            if (dist  < RANGE)
            {
                nAvatars++;
                DEBUG("In range:" + llKey2Name(aviKey));
            }
        }
    }
    DEBUG("Located " + (string) nAvatars + " avatars");
    return nAvatars;
} 
 
// return TRUE if the avatar is owner when private is set, or TRUE if the avatar is in th same group and GROUP is set.
integer checkPerms() {

    integer group = (integer) KeyValueGet("pr");
    if (! group)
        priPub = "Owner Only";
    else
        priPub = "Group";
    
    
    if (llDetectedKey(0) == llGetOwner()){
        kUserKey = llDetectedKey(0);
        return TRUE;
    }
 
    if ( group && llDetectedGroup(0)) {
        kUserKey = llDetectedKey(0);
        return TRUE;
    }
    kUserKey = llDetectedKey(0);
    return FALSE;
}



NPCStart(string anim)
{
    DEBUG(" Start Anim: " + anim);
    if (llGetInventoryType(anim) == INVENTORY_ANIMATION ) {
        
        if (lastANIM != anim) {
            osNpcPlayAnimation(NPCKey(), anim);
    
            if(llStringLength(lastANIM) && llGetInventoryType(lastANIM) == INVENTORY_ANIMATION) {
                osNpcStopAnimation(NPCKey(), lastANIM)      ;  
            }
            
            lastANIM = anim;
        }            
    } else {
        llSay(DEBUG_CHANNEL, "No animation named " + anim);
    }
} 


TimerEvent(float timesent)
{
    //DEBUG("Setting  timer: " + (string) timesent);
    llSetTimerEvent(timesent);
}



ProcessLink(string str)
{
    // DEBUG("Processing exern cmd : " + str);
    bForget = TRUE;    // tell the NPCProcess state to forget this command after processing it.
    lNPCScript = llListInsertList(lNPCScript,[str],0);    // add this command to the beginning of the list of commands
    NPCStart(STAND);
}

// Kill a NPC by Name
Kill(string param)
{

    integer count;
        
    list avatars = osGetAvatarList(); // Returns a strided list of the UUID, position, and name of each avatar in the region except the owner.
    
    integer i;
    integer j = llGetListLength(avatars);
    for (i=0 ; i <= j; i+=3){
        
        string desired = llList2String(avatars,i+2);
        desired = llStringTrim(desired,STRING_TRIM);    // should not be needed but is needed
        
        if (desired == param){
            vector v = llList2Vector(avatars,i+1);
            key target = llList2Key(avatars,i);    // get the UUID of the avatar
            osNpcRemove(target);
            KeyValueSet("key", NULL_KEY );  
            llOwnerSay("Removed " + param+ " at  location " + (string) v);
            count++;
        }
    }
    if (count)
        llOwnerSay("Removed " + (string) count + " NPC's");
    else
        llOwnerSay("Could not locate " + param);
}


// return a String for the position we are at. Strings used as the caller wants strings
string Pos()
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
    return (string) where;
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
    list buttons = ["Appearance","Recording","Save","Help","-","Erase RAM", priPub,relAbs,"-","Stop NPC",mSensor,"Start NPC"];
    llDialog(kUserKey,(string) llGetListLength(lCommands) + " Recordings",buttons,iChannel);
}


// Rev 1.4
// top level menu for non group/ non owners
makeUserMenu()
{
    if (!allowUsers)
            return;
    menu();
    list buttons = ["Start NPC","Stop NPC"];
    llDialog(kUserKey,"Choose",buttons,iChannel);
}



// programmable menu for @commands
makeMenu(list buttons)
{
    menu();
    llDialog(kUserKey,(string) llGetListLength(lCommands) + "Recordings",buttons,iChannel);
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

// Set the Avatar Present flag - if sensors are off and we are forece run, there will be one present.
ProcessSensor()
{
    integer SensorOn;
    if ("on" == KeyValueGet("se"))
    {
        SensorOn = TRUE;        // we need to scan for avatars
    } else {
        SensorOn = FALSE;        // we need to scan for avatars
    }
    DEBUG("Sensor:" + (string) SensorOn);
    
    integer n = SenseAvatar();
    
    if (SensorOn && n)
        avatarPresent = TRUE;   // someone is here and we need to tell the system to run
    else if (SensorOn && !n)
        avatarPresent = FALSE;  // someone is not here and we need to tell the system to stop
    else
        avatarPresent = TRUE;   // someone is effectivley always here when sensor is off and we are running
        
    DEBUG("Avatar Present: " + (string) avatarPresent);
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
        if (llGetInventoryName(INVENTORY_NOTECARD,i) == "!Path")
            count++;
        if (llGetInventoryName(INVENTORY_NOTECARD,i) == "!Appearance")
            count++;
    }
    // if we have both, run the NPC
    return count;
}
// saves a few bytes per call
key NPCKey()
{
    return KeyValueGet("key");
}

// Notes:
// No llResetScript() used so we can retain memory between rezzes and sim restarts.  NPC info and stateful info is held in the Description
//


// This state is the first main menu
default
{
    state_entry()
    {
        llSetText("",<1,1,1>,1.0);  // clr all hovertext- we may not be using it.
        
        // delete all NPC*scripts except myself
        integer i;
        integer j = llGetInventoryNumber(INVENTORY_SCRIPT);
        for (i = 0; i < j; i++) {
            string name = llGetInventoryName(INVENTORY_SCRIPT,i);
            string match = llGetSubString(name,0,2);
            if (match == "NPC" && llGetScriptName() != name)
            {
                llRemoveInventory(name);
                llOwnerSay("Upgraded");
            }
        }
        
        
        string rA = KeyValueGet("co"); // Get the remembered menu setting for Abs Vs Relative
        if (rA == "A")
            relAbs = "Absolute";
        else  if (rA == "R")
            relAbs = "Relative";
        else
            relAbs = "Absolute";

        // menu reentrance
        if (showMenu) {
            makeMainMenu();
            return;
        }
            
        // reenable NPC is sensor is on.
        if ("on" == KeyValueGet("se"))
        {
            mSensor  = "Sensor";
            ProcessSensor();       // fake 1 avatar to get it rezzed
            state NPCGo;
        } else {
            mSensor  = "No Sensor";
        }
    } 


    touch_start(integer n) {           // if touched, make a menu
        if (checkPerms())
            makeMainMenu();
        else
            makeUserMenu();
    }

    // no changed event needed

    // menu listener
    listen(integer iChannel, string name, key id, string message) {
        TimerEvent(0.0);    /// kill the menu expiration timer

        if (message == "Stop NPC")
        {
            if (llStringLength(sNPCName)){
                Kill(sNPCName);
                sNPCName = "";
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
        else if (message == "Owner Only") {
            priPub = "Group";
            KeyValueSet("pr","1");

            llOwnerSay("Group members have control");
            makeMainMenu();
        }
        else if (message == "Group") {
            priPub = "Owner Only";
            KeyValueSet("pr","0");
            llOwnerSay("Only you have control");
            makeMainMenu();
        }
        else if (message == "Sensor") {
            mSensor ="No Sensor";
            KeyValueSet("se", "off");
            llOwnerSay("Sensors now Off");
            makeMainMenu();
        }
        else if (message == "No Sensor") {
            mSensor ="Sensor";
            llOwnerSay("Sensors now On");
            KeyValueSet("se", "on");
            
            integer count = checkNoteCards();
            if (count >= 2)  {    
                state NPCGo;
            }

            // lslEditor does not handle the above, so I hack it in
            if (Editor) {
                state NPCGo;
            }

            llOwnerSay("You have not saved a recording and/or appearance, so you cannot start a NPC");
            makeMainMenu();
        }
        else if (message == "Appearance")  {
            llRemoveInventory("!Appearance");            // delete the notecard
            osAgentSaveAppearance(kUserKey, "!Appearance");    // make the ntecard
            llOwnerSay("Your Appearance has been recorded in notecard '!Appearance'");
            makeMainMenu();
        }
        else if (message == "Save") {
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
      
        }
        else if (bNPC_STOP){
            bNPC_STOP = FALSE;
            Kill(message);
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
        vector  vDest = (vector)  Pos();
            
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
                // since we have to record absolute coords since we do not know where the box goes until they press Save,
                // we process the absolute to relative conversion for walks here
                list parts = llParseString2List(line,["="],[]); //get the @command
    
                if (llList2String(parts,0) == "@walk") {
                    vector vec = (vector) llList2String(parts,1) - llGetPos();
                    sNotecard += "@walk=" + (string) vec + "\n";
                }
                else if (llList2String(parts,0) == "@fly") {
                    vector vec = (vector) llList2String(parts,1) - llGetPos();
                    sNotecard += "@fly=" + (string) vec + "\n";
                }
                else if (llList2String(parts,0) == "@run") {
                    vector vec = (vector) llList2String(parts,1) - llGetPos();
                    sNotecard += "@run=" + (string) vec + "\n";
                }
                else if (llList2String(parts,0) == "@land") {
                    vector vec = (vector) llList2String(parts,1) - llGetPos();
                    sNotecard += "@land=" + (string) vec + "\n";
                }
                else {
                    sNotecard += line;    // add the un-modified string to the notecard
                }
            }
        }
        llRemoveInventory("!Path");        // delete the old notecard
        osMakeNotecard("!Path",sNotecard); // Makes the notecard.
        llOwnerSay("'!Path' notecard has been written");
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
       showMenu= TRUE;
        state default;
    }
    touch_start(integer n){
        if (checkPerms())
            makeMenu(lAtButtons);
        else
            makeUserMenu();

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
            lCommands += "@run=" + Pos() + "\n";
            llOwnerSay("Recorded position: " + Pos());
            makeMenu(lAtButtons);
        }
        else if (message == "@fly"){
            lCommands += "@fly=" + Pos() + "\n";
            llOwnerSay("Recorded position: " + Pos());
            makeMenu(lAtButtons);
        }
        else if (message == "@land"){
            lCommands += "@land=" + Pos() + "\n";
            llOwnerSay("Recorded position: " + Pos());
            makeMenu(lAtButtons);
        }
        else if (message == "@walk") {
            lCommands += "@walk=" + Pos() + "\n";
            llOwnerSay("Recorded position: " + Pos());
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
        }        else if (message == "@shout"){
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
        DEBUG("NPCGo");
        
        ProcessSensor();       // Set the flags
            
        lNPCScript = llParseString2List(osGetNotecard("!Path"), ["\n"], []);
        if(llGetListLength(lNPCScript) == 0) {
            llSay(DEBUG_CHANNEL, "No !Path notecard found.");
            return;
        }
        state ProcessNPCLine;
    }
    changed(integer change) {
        if(change & CHANGED_REGION_RESTART)
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
        if (! bForget) {
            lNPCScript += next;                                // put it on the end unless we are told to forget it from a Link Message
            bForget = FALSE;
        }
        if(llGetSubString(next, 0, 0) != "@") jump ignore;    // ignore non-@ commands
        list data  = llParseString2List(next, ["="], []);
        npcAction = llToLower(llStringTrim(llList2String(data, 0), STRING_TRIM));
        npcParams = llStringTrim(llList2String(data, 1), STRING_TRIM);

        @commands;

        if (! avatarPresent){
            state  nobodyHome;
        }
        if(npcAction == "@spawn") {
            // DEBUG("Spawning");
            integer lastIdx = llGetListLength(lNPCScript)-1;
            lNPCScript = llDeleteSubList(lNPCScript, lastIdx, lastIdx);        // remove spawn commands, we do them only once
            list spawnData = llParseString2List(npcParams, ["|"], []);
            sNPCName =llList2String(spawnData, 0);    // V 1.6 name in RAM

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
            list dest = llParseString2List(npcParams, ["<", ",", ">"], []);
            vDestPos.x = llList2Float(dest, 0);
            vDestPos.y = llList2Float(dest, 1);
            vDestPos.z = llList2Float(dest, 2);

            if (vDestPos == ZERO_VECTOR) {
                llSay(DEBUG_CHANNEL,"Bad (zeros) position for @walk");
                state ProcessNPCLine;
            }
            walkstate = 1;//  walking
            NPCWalkOption = OS_NPC_NO_FLY ;      
            state walk;
        }
        
        if(npcAction == "@fly") {
            list dest = llParseString2List(npcParams, ["<", ",", ">"], []);
            vDestPos.x = llList2Float(dest, 0);
            vDestPos.y = llList2Float(dest, 1);
            vDestPos.z = llList2Float(dest, 2);

            if (vDestPos == ZERO_VECTOR) {
                llSay(DEBUG_CHANNEL,"Bad (zeros) position for @fly");
                state ProcessNPCLine;
            }
            
            walkstate = 2;//  flying
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
            walkstate = 3;//  running
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

            walkstate = 4;//  landing

            
            NPCWalkOption= OS_NPC_FLY | OS_NPC_LAND_AT_TARGET ;  
            state walk;
        }
        
          
        
        // chat commands    
        // speak in white text

        if(npcAction == "@say") {
            // DEBUG("say");
            osNpcSay(NPCKey(),0, npcParams);
            jump ignore;    // process next line
        }
        if(npcAction == "@shout") {
            // DEBUG("shout");
            osNpcShout(NPCKey(),0, npcParams);
            jump ignore;    // process next line
        }
        if(npcAction == "@whisper") {
            // DEBUG("whisper");
            osNpcWhisper(NPCKey(),0, npcParams);
            jump ignore;    // process next line
        }
        // speak a command on a channel, so you can open doors and control stuff.
        if(npcAction == "@cmd") {
            // DEBUG("cmd");
            list dataToSpeak = llParseString2List(npcParams, ["|"], []);
            integer iChannel = (integer) llList2String(dataToSpeak,0);
            string stringToSpeak = llList2String(dataToSpeak,1);
            llRegionSay(iChannel, stringToSpeak);     // V 1.2
            
            jump ignore;    // process next line
        }
        // stop everything
        if(npcAction == "@pause") {
            // DEBUG("pause");
            RAMPause = (float) npcParams;
            state pause;
        }
        if(npcAction == "@wander") {
            // DEBUG("wander");
            list wanderData = llParseString2List(npcParams, ["|"], []);
            RAMwd = (float) llList2String(wanderData, 0);
            RAMwc = (integer) llList2String(wanderData, 1);
            
            vDestPos = osNpcGetPos(NPCKey());        // set the wander start
            DEBUG("Starting at " + (string) vDestPos);
            state wander;
        }
        if(npcAction == "@rotate") {
            // DEBUG("rotate");
            RAMrot = (float) npcParams;
            state rotate;
        }
        if(npcAction == "@sit") {
            // DEBUG("sit");
            RAMsit= npcParams;
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
            RAManimationName = llList2String(animateData, 0);
            RAManimationTime = (float) llList2String(animateData, 1);
            state animate;
        }
        llSay(DEBUG_CHANNEL, "ERROR: Unrecognized script line: " + npcAction + "=" + npcParams);
        jump ignore;

    }
    changed(integer change) {
        if(change & CHANGED_REGION_RESTART)
            state NPCGo;
    }
    on_rez(integer num) {
        llResetScript();
    }
    link_message(integer sender, integer num, string str, key id) {
        ProcessLink(str);
        state ProcessNPCLine;
    }
    // if touched by owner while running code, make a menu
    touch_start(integer n) {
    
        if (checkPerms()) {
            TimerEvent(0); // stop the NPC from ticking
            showMenu = TRUE;
            state default;
        }  else {
            makeUserMenu();
        }

    }
}


state nobodyHome
{
    state_entry()    {
        DEBUG("Nobody Home");
        if (NPCKey() != NULL_KEY) {
            DEBUG("NPC Remove");
            osNpcRemove(NPCKey());
            KeyValueSet("key", NULL_KEY );  
        }

        llSetTimerEvent(10);   
    }
    timer()
    {
        if (llGetRegionAgentCount()) {
            llSetTimerEvent(0);
            state NPCGo;
        }
    }
    // if touched by owner while running code, make a menu
    touch_start(integer n) {
        if (checkPerms()) {
            TimerEvent(0); // stop the NPC from ticking
            showMenu = TRUE;
            state default;
        } else {
            makeUserMenu();
        }
    }
}

state spawn
{
    state_entry() {
        // DEBUG("state spawn");
        list name = llParseString2List(sNPCName, [" "], []);
       // notecard is stored as offsets from this box with relative addressing.  Convert to absolute
        if (relAbs == "Relative"){
            vInitialPos += llGetPos();
        }

        // DEBUG("rez:" + (string) vInitialPos);
        key aKey = osNpcCreate(llList2String(name, 0), llList2String(name, 1), vInitialPos, "!Appearance", NPCOptions);
        KeyValueSet("key", aKey );    
        osSetSpeed(aKey,SPEEDMULT);   // 1.9 speed multiplier
        TimerEvent(REZTIME);
        NPCStart(STAND);
    }
    link_message(integer sender, integer num, string str, key id) {
        ProcessLink(str);
        state ProcessNPCLine;
    }
    timer() {
        state ProcessNPCLine;
    }
    changed(integer change) {
        if(change & CHANGED_REGION_RESTART)
            state NPCGo;
    }
    on_rez(integer num) {
        llResetScript();
    }
    state_exit(){
        TimerEvent(0.0);
    }
    // if touched by owner while running code, make a menu
    touch_start(integer n) {
        if (checkPerms()) {
            TimerEvent(0); // stop the NPC from ticking
            showMenu = TRUE;
            state default;
        }else {
            makeUserMenu();
        }
    }
}


state rotate {
    state_entry() {
        // DEBUG("state rotate");
        osNpcSetRot(NPCKey(), llEuler2Rot(<0,0,RAMrot> * DEG_TO_RAD));
        TimerEvent(TIMER);
    }
    link_message(integer sender, integer num, string str, key id) {
        ProcessLink(str);
        state ProcessNPCLine;
    }
    timer() {
        state ProcessNPCLine;
    }
    changed(integer change) {
        if(change & CHANGED_REGION_RESTART)
            state NPCGo;
    }
    on_rez(integer num) {
        llResetScript();
    }
    state_exit() {
        TimerEvent(0.0);
    }
    // if touched by owner while running code, make a menu
    touch_start(integer n) {
        if (checkPerms()) {
            TimerEvent(0); // stop the NPC from ticking
            showMenu = TRUE;
            state default;
        }else {
            makeUserMenu();
        }
    }
}

state sit {
    state_entry() {
        // DEBUG ("state sit");
        llSensorRepeat(RAMsit, "", PASSIVE|ACTIVE,  96, TWO_PI, 1);
    }
    sensor(integer num) {
        llSensorRemove();
        osNpcSit(NPCKey(), llDetectedKey(0), OS_NPC_SIT_NOW); //V1.2
        TimerEvent(TIMER);
    }
    no_sensor(){
        state ProcessNPCLine;
    }
    timer() {
        state ProcessNPCLine;
    }
    link_message(integer sender, integer num, string str, key id) {
        ProcessLink(str);
        state ProcessNPCLine;
    }
    changed(integer change) {
        if(change & CHANGED_REGION_RESTART)
            state NPCGo;
    }
    on_rez(integer num) {
        llResetScript();
    }
    // if touched by owner while running code, make a menu
    touch_start(integer n) {
        if (checkPerms()) {
            TimerEvent(0); // stop the NPC from ticking
            showMenu = TRUE;
            state default;
        } else {
            makeUserMenu();
        }

    }

    
    state_exit(){
        TimerEvent(0.0);
    }
    

}

state stand {
    state_entry() {
        // DEBUG("state stand");
        osNpcStand(NPCKey());
        state ProcessNPCLine;
    }
    changed(integer change) {
        if(change & CHANGED_REGION_RESTART)
            state NPCGo;
    }
    // if touched by owner while running code, make a menu
    touch_start(integer n) {
        if (checkPerms()) {
            TimerEvent(0); // stop the NPC from ticking
            showMenu = TRUE;
            state default;
        } else {
            makeUserMenu();
        }

    }

    
    on_rez(integer num) {
        llResetScript();
    }

}

state animate {
    state_entry() {
        // DEBUG("state animate");
        NPCStart(RAManimationName);
        TimerEvent(RAManimationTime);
    }
    link_message(integer sender, integer num, string str, key id) {
        ProcessLink(str);
        state ProcessNPCLine;
    }
    timer() {
        NPCStart(STAND);
        state ProcessNPCLine;
    }
    changed(integer change) {
        if(change & CHANGED_REGION_RESTART)
            state NPCGo;
    }
    // if touched by owner while running code, make a menu
    touch_start(integer n) {
        if (checkPerms()) {
            TimerEvent(0); // stop the NPC from ticking
            showMenu = TRUE;
            state default;
        } else {
            makeUserMenu();
        }

    }

    
    on_rez(integer num) {
        llResetScript();
    }
    state_exit() {
        TimerEvent(0.0);
    }

}
state walk {
    state_entry() {

        DEBUG("NPCWalkOption = " + (string) NPCWalkOption);
        
        // walk, fly, run, land
       if (walkstate == 1) {
            NPCStart(WALK);
        } else if (walkstate == 2)  {
            llShout(299,"on");
            NPCStart(FLY);
        } else if (walkstate == 3) {
            NPCStart(RUN);
        } else if (walkstate == 4) {
            NPCStart(LAND);
        } else  {          
            state ProcessNPCLine;
        }
        

        ProcessSensor();

        newDest = vDestPos ;
        // notecard is stored as offsets from this box with relative addressing.  Convert to absolute
        if (relAbs == "Relative"){
            newDest += llGetPos();
        }

        DEBUG("Moveto:" + (string) newDest);
        iWaitCounter = WAIT;            // wait 60 seconds to get to a destination.
        osNpcMoveToTarget(NPCKey(), newDest, NPCWalkOption);
        TimerEvent(TIMER);
    }
    link_message(integer sender, integer num, string str, key id) {
        ProcessLink(str);
        state ProcessNPCLine;
    }
    timer() {
        if (--iWaitCounter) {            

            if (llVecDist(osNpcGetPos(NPCKey()), newDest) > MAXDIST)  {
                return;
            }      
        }
            
         // walk, fly, run, land
        if (walkstate == 1) {
            NPCStart(STAND);
        } else if (walkstate == 2)  {
            // nothing
        } else if (walkstate == 3) {
            NPCStart(STAND);
        } else if (walkstate == 4) {
            llShout(299,"off");
            NPCStart(STAND);
        } else  {          
            state ProcessNPCLine;
        }
            
        state ProcessNPCLine;
    }
   
   
    // if touched by owner while running code, make a menu
    touch_start(integer n) {
        if (checkPerms()) {
            TimerEvent(0); // stop the NPC from ticking
            showMenu = TRUE;
            state default;
        } else {
            makeUserMenu();
        }

    }

    
    changed(integer change) {
        if(change & CHANGED_REGION_RESTART)
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

        ProcessSensor();
        
        vector point = CirclePoint(RAMwd);
        DEBUG("CirclePoint:" + (string) point);
        vWanderPos = vDestPos + point;
        DEBUG("vWanderPos:" + (string) vWanderPos);

        fTimerVal = WANDERTIME;    // default time to pause after each wander
        if (WANDERRAND)
            fTimerVal = llFrand(WANDERTIME);    // override, they want random times

        NPCStart(WALK);

        DEBUG("Wander to:" + (string) vWanderPos);

        osNpcMoveToTarget(NPCKey(), vWanderPos, NPCWalkOption);
        iWaitCounter = WAIT;            // wait 60 seconds to get to a destination.

        TimerEvent(TIMER);      // first time we wait for the short timer.
    }
    link_message(integer sender, integer num, string str, key id) {
        ProcessLink(str);
        NPCStart(STAND);
        state ProcessNPCLine;
    }
    timer() {

        if (--iWaitCounter)           // wait 60 seconds to get to a destination.
            if (llVecDist(osNpcGetPos(NPCKey()), vWanderPos) > MAXDIST) return;


        // see if wander counter == 0, if so, stop walking, go to stand and process next line
        if(RAMwc == 0) {
            NPCStart(STAND);
            state ProcessNPCLine;
        }

        // one less time to wander around
        RAMwc--;

        NPCStart(STAND);
        state wanderhold;
    }
   
    // if touched by owner while running code, make a menu
    touch_start(integer n) {
        if (checkPerms()) {
            TimerEvent(0); // stop the NPC from ticking
            showMenu = TRUE;
            state default;
        } else {
            makeUserMenu();
        }
    }

    
    changed(integer change) {
        if(change & CHANGED_REGION_RESTART)
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

        ProcessSensor();
        
    }
    timer()  {
        state wander;
    }
   
    // if touched by owner while running code, make a menu
    touch_start(integer n) {
        if (checkPerms()) {
            TimerEvent(0); // stop the NPC from ticking
            showMenu = TRUE;
            state default;
        } else {
            makeUserMenu();
        }

    }

    
    changed(integer change) {
        if(change & CHANGED_REGION_RESTART)
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

        ProcessSensor();

        llSetTimerEvent(RAMPause);
    }
    link_message(integer sender, integer num, string str, key id){
        ProcessLink(str);
        state ProcessNPCLine;
    }
    timer() {
        NPCStart(STAND);
        state ProcessNPCLine;
    }
   
    // if touched by owner while running code, make a menu
    touch_start(integer n) {
        if (checkPerms()) {
            TimerEvent(0); // stop the NPC from ticking
            showMenu = TRUE;
            state default;
        } else
            makeUserMenu();

    }    
    changed(integer change) {
        if(change & CHANGED_REGION_RESTART)
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

// @stop makes the NPC stand there.  You have to linkmessage to get moving again
state stop {
    state_entry() {
        NPCStart(STAND);
    }
    link_message(integer sender, integer num, string str, key id){
        if (str=="@go")
            state ProcessNPCLine;
        ProcessLink(str);
    }
    // if touched by owner while running code, make a menu
    touch_start(integer n) {
        if (checkPerms()) {
            TimerEvent(0); // stop the NPC from ticking
            showMenu = TRUE;
            state default;
        } else
            makeUserMenu();

    }

    changed(integer change) {
        if(change & CHANGED_REGION_RESTART)
            state NPCGo;
    }
    on_rez(integer num) {
        llResetScript();
    } 
}


 
state delete {
    state_entry() {
        // DEBUG("state delete");
        if (NPCKey() != NULL_KEY) {
            DEBUG("NPC Remove");
            osNpcRemove(NPCKey());
            KeyValueSet("key", NULL_KEY );  
        }
    }
    link_message(integer sender, integer num, string str, key id) {
        if(str == "@npc_start")
        {
            state NPCGo;
        }
        
    }

    // No on_rez or changed event needed, the only way out is a link message
}

