// :SHOW:1
// :CATEGORY:NPC
// :NAME:All In One NPC Recorder and Player
// :AUTHOR:Ferd Frederix
// :KEYWORDS:NPC, Puppeteer
// :CREATED:2015-10-12 18:07:40
// :EDITED:2016-06-27  20:52:25
// :ID:27
// :NUM:1903
// :REV:5.0
// :WORLD:OpenSim
// :DESCRIPTION:
// All in one NPC recorder player.
// Supports both absolute and relative paths and many new commands
// Add animations named "Fly, Walk, Stand and Run"
// Click Prim to use.
// Should be worn as a HUD to record.
// Put it on the ground and click Sensor or Start NPC when done.
// :CODE:


// This is Rev 5.0 2016-06-26  Revert to llGetAgentlist

// Revision History
// Rev 1.1 10-2-2014 @Sit did not work.  Minor tweaks to casting for lslEditor
// Rev 1.2 10-14-2014 @ sit had wrong type.
// Rev 1.3 relative movement fixed for @fly
// Rev 1.4 4-3-2014 allow anyone to use this, non owners and non group members can only start and stop.
// Rev 1.5 5-17-2014 set sensor to auto start on reboot of sim
// Rev 1.6 5-24-2014 move menu so you can get it by touching, removed many of the KeyValues to RAM for efficiency
// Rev 1.7 CHANGED_REGION_START, not CHANGED_REGION_START (Opensim difference)
// Rev 1.8 tuned up Kill NPC, added more flexible upgrader
// Rev 1.9 Better script injection by link message// Rev 2.0 Added osSetSpeed so you can speed up or slow down an NPC.
// Rev 2.1 No laggy sensor used exept to sit on stuff
// Rev 2.2 Various sensor fixes
// Rev 2.3 Sets No Sensor in menu, must be started by hand
// Rev 2.4 - reserved for patches to 2.3 if needed
// Rev 3.0 Refactor out into subs, not states to make command injection easier
//            New command: @appearance=Notecardname so you can switch to a new notecard on the fly
//            New command: @speed=1.0  which slows up  ( < 1 )  or speeds up ( > 1)
// Rev 3.1 Commands are not interruptible by Link Message
// Rev 3.2 Sensor patches for consistency in removing the NPC
// Rev 3.3 Added Touch command by Neo.Cortex@hbase42/hopto/org:8002
//         Added Menu 3 for notecard and appearance commands
// Rev 3.4 animation timer cannot be zero or it shuts off timer tweaked
//         solves the NPC starting up when no sensor is set.
// Rev 3.5 fixes saving to !Path  notecard
// Rev 3.6 08-11-2015 @delete acts like @stop. TYjhe NPC now rezzes after an @go back in where it was deleted
// Rev 3.7 08-11-2015 @attach command added to load an attachment from the inventory to the NPC
// Rev 3.8 08-17-2015 process queued commands one at a time without calling ProcessNPCLine on link message
// Rev 3.9 08-23-2011 Queued command fixes including @delete which were not always working
// Rev 4.0 09-15-2015 Fixes for Sensor functions which continually rezzed a NPC when no one was around.
// Rev 4.1 09-20-2015 Added a Listener so link messages are not needed
// Rev 4.2 09-23-2015 Added @teleport=<vector>
// Rev 4.3 09-24-2015 Added @reset to restart the NPC at the very start of the !Path notecard
//                    @teleport works for relative and absolute modes
// Rev 4.4 09-26-2015 if it could not find the (deleted) NPC, it could not restart
// Rev 4.5 09-29-2015 remove wait for STATE == 0
// Rev 4.6 12-4-2015 fixed wanderhold  did not wander correctly.
// Rev 4.7 2016-06-10 Sensor mode was continually rezzing NPC's
// Rev 4.8 2016-06-14 Detect Owner, too.  osGetAgentList is broken :-(
// Rev 4.9 2016-06-14 Speed up respawn after removal.
//*******************************************************************//

// Instructions on how to use this are at http://www.outworldz.com/opensim/posts/NPC/
// This is an OpenSim-only script.
// Author: Ferd Frederix aka Fred Beckhusen - fred@mitsi.com

////////////////////////////////////////////////////////////////////////////////////////////
//    Original code was Copyright (C) 2013 Wizardry and Steamworks - License: GNU GPLv3    //
///////////////////////////////////////////////////////////////////////////////////////////
//  Please see: http://www.gnu.org/licenses/gpl.html for legal details,                  //
//  rights of fair usage, the disclaimer and warranty conditions.                        //
///////////////////////////////////////////////////////////////////////////////////////////
// The original NPC controller was from http://was.fm/opensim:npc
// Extensive additions and bug fixes by Fred Beckhusen, aka Ferd Frederix
// llSensor had two params swapped
// @Wander would wander where it had rezzed, not where it was.
// There was no 'no_sensor' event in sit, so if a @sit failed, the NPC got stuck
// The animation and walks always stopped old, then started new.  It should be start new, then stop old so the default stand would be suppressed.
// New code:
// Merged with new Route recorder and notecard writer
// If the NPC failed to reach a destination it never moved on.
// Added WAIT global to tune this
// Exposed many tunable variables and ported the code
// Added floating point to times in notecard.
// Added @sound, @randsound, @whisper, @shout, and @cmd controls.
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
// please note that there are better ways to enable NPC in the latest Opensim.

// Commands: All commands begin with an @ sign.  All other lines are ignored
// @commands may have optional parameters.  The syntax is always:
//  @cmd=parm1|parm2
//  NaN in the table below meand Not a Number.   This means there is no parameter

//Command     First Parameter             Second Parameter        Description
//@spawn      name                        location (vector)       Rezzes an NPC with name at a location.
//@appearance NoteCardName                NaN                     switch the NPC appearance to a new notecard
//@walk       destination (vector)        NaN                     Makes the NPC walk to destination.
//@fly        destination (vector)        NaN                     Makes the NPC fly to destination.
//@land       destination (vector)        NaN                     Makes the NPC land at destination.
//@say        string                      NaN                     Makes the NPC speak a phrase.
//@whisper    string                      NaN                     Makes the NPC whisper a phrase.
//@shout      string                      NaN                     Makes the NPC shout a phrase.
//@pause      seconds (float)             NaN                     Makes the NPC wait for a multiple of seconds.
//@wander     radius (float)              cycles (integer)        Makes the NPC wander in radius, for cycles seconds.
//@delete     NaN                         NaN                     Removes the NPC.  Requires a link message to continue
//@goto       label (string)              NaN                     Jump to the label label in the script.
//@animate    animation (string)          time (float)            Makes the NPC trigger the animation animation for time seconds.
//@sound      sound_name                  NaN                     plays a sound from inventory
//@randsound  NaN                         NaN                     Plays a random sound from inventory
//@rotate     degrees (float)             NaN                     Rotate the NPC degrees around the Z axis.
//@sit        primitive name              NaN                     Sit on a primitive with a given name.
//@touch      primitive name              NaN                     Touch on a primitive with a given name.
//@stand      NaN                         NaN                     If sitting on a primitive, stand up.
//@cmd        channel (integer)           string                  Says string on channel, for controlling external gadgets
//@stop       NaN                         NaN                     Halts the NPC script indefinitely. Can be started with a link message
//@go         NaN                         NaN                     Continues on next notecard line, for use in link messages
//@speed      speed (float)               NaN                     from 0 to N, where 1.0 ius a normal speed of an avatar.  0.2 is a turtle.
//@notecard   notename (string)           NaN                     load a new Path notecard
//@attach     InventoryName               attachmentPoint         load an attachment from the inventory to the NPC onto point
//@teleport   destination (vector)        NaN                     Makes the NPC teleport to destination in the same sim.  They cannot tp to another sim or across the HG
//@reset      NaN                         NaN                     Deletes the NPC, starts the !Path notecard over.

// Constant            attachmentPoint Comment
// ATTACH_CHEST            1    chest/sternum
// ATTACH_HEAD             2    head
// ATTACH_LSHOULDER        3    left shoulder
// ATTACH_RSHOULDER        4    right shoulder
// ATTACH_LHAND            5    left hand
// ATTACH_RHAND            6    right hand
// ATTACH_LFOOT            7    left foot
// ATTACH_RFOOT            8    right foot
// ATTACH_BACK             9    back
// ATTACH_PELVIS          10    pelvis
// ATTACH_MOUTH           11    mouth
// ATTACH_CHIN            12    chin
// ATTACH_LEAR            13    left ear
// ATTACH_REAR            14    right ear
// ATTACH_LEYE            15    left eye
// ATTACH_REYE            16    right eye
// ATTACH_NOSE            17    nose
// ATTACH_RUARM           18    right upper arm
// ATTACH_RLARM           19    right lower arm
// ATTACH_LUARM           20    left upper arm
// ATTACH_LLARM           21    left lower arm
// ATTACH_RHIP            22    right hip
// ATTACH_RULEG           23    right upper leg
// ATTACH_RLLEG           24    right lower leg
// ATTACH_LHIP            25    left hip
// ATTACH_LULEG           26    left upper leg
// ATTACH_LLLEG           27    left lower leg
// ATTACH_BELLY           28    belly/stomach/tummy
// ATTACH_LEFT_PEC        29    left pectoral
// ATTACH_RIGHT_PEC       30    right pectoral
// ATTACH_HUD_CENTER_2    31    HUD Center 2
// ATTACH_HUD_TOP_RIGHT   32    HUD Top Right
// ATTACH_HUD_TOP_CENTER  33    HUD Top
// ATTACH_HUD_TOP_LEFT    34    HUD Top Left
// ATTACH_HUD_CENTER_1    35    HUD Center
// ATTACH_HUD_BOTTOM_LEFT 36    HUD Bottom Left
// ATTACH_HUD_BOTTOM      37    HUD Bottom
// ATTACH_HUD_BOTTOM_RIGHT 38   HUD Bottom Right
// ATTACH_NECK            39   neck
// ATTACH_AVATAR_CENTER  40    avatar center/root



//////////////////////////////////////////////////////////
//                  DEBUG                               //
//////////////////////////////////////////////////////////
integer debug = FALSE;
// set to TRUE or FALSE for debug chat on various actions
integer LSLEditor = FALSE;        // set to to TRUE to working in  LSLEditor, FALSE for in-world.
// you must also include the NPC commands found in the other script since LSLEditor does not support OpenSim
integer iTitleText = FALSE;    // set to TRUE to see debug info in text above the controller

//////////////////////////////////////////////////////////
//                  TUNABLE CONFIGURATION               //
//////////////////////////////////////////////////////////
integer keyNum = -1;    // (namaka) special number for link message to broadcast the NPC key
integer   allowListener = TRUE; // set to TRUE to anable a command listener. Usually, this is setto FALSE
integer   link_Channel =   4223; // some random number you want to talk to this gadget on. Best if large and negative
float     TIMER = 1;         // faster = less jerky stopping.  How often the system checks the distance traveled.  Fastest you can go is 0.5 seconds
float     QUICK = 1;        // when we need to move to the next state, we use a QUICK timer
string    Appearance = "!Appearance";  // The name of the recorded Appearance notecard
string    Notecard = "!Path"; // The name of the recorded routes
integer   allowUsers = FALSE;  // If true, any user can get a Start NPC and Stop NPC menu.  Only groups and owners can get all commands if TRUE, or FALSE
float     MAXDIST = 2.0;       // how close a NPC has to get to a dest pos to continue to next state. Do not lower this too much, as it may miss the target
integer   WANDERRAND = TRUE;   // set to TRUE and they will pause during wanders a random number of seconds
float     WANDERTIME = 3.0;    // how long they stand after each @wander,if WANDERRAND is FALSE. If WANDERRAND is  TRUE, this is the max time
integer   WAIT = 30;           // wait for this number of seconds for the NPC to reach a destination (for safety). If it fails to reach a target, it will move on after this time.
float     RANGE = 150;        // 1 to N meters  - anyone this close to the controller will start NPCS if Sensor button is clicked
float     REZTIME = 2.0;      // wait this long for NPC to rez in, then start the process
string    STAND = "Stand";     // the name of the default Stand animation
string    WALK = "Walk";       // the name of the default Walk animation
string    FLY = "Fly";        // the name of the default Fly animation
string    RUN = "Run";        // the name of the default Run animation
string    LAND = "Land";      // the name of the default land animation ( for birds only)
float     OffsetZ = 0.5;      // appear 0.5 meter above ground, this is added to all destinations to keep them from sinking in.
float    SPEEDMULT =0.8;     // 1.0 = regular avatar speed. Smaller numbers slow down walks. Large numbers speed them up.
integer  FLIGHT = 299;        // For controlling wings.  A channel that is shouted at when flight starts and ends. "flying" or "landing"

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
string RAMtouch;         // @touch primname
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
integer Stopped = FALSE;        // set to TRUE by link messages so we do not remember them
float  fTimerVal ;              // how long we wait when wandering (calculated)
float NPCEnabled;               // true if the NPC is suppodes to be running

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
string mSensor="Sense is Off";    // Sensor or "No Sensor"

list lAtButtons = ["Menu","-",   ">>",         "@run",    "@walk",   "@fly",  "@land", "@wander",    "@sit",   "@stand","@animate","@rotate"];
list lMenu2 = ["<<", "@comment", ">>>",        "@stop",      "@say",    "@whisper","@shout","@sound","@randsound","@cmd",  "@pause",  "@delete"];
list lMenu3 = ["<<<","@notecard","@appearance", "@touch", "@speed",       "@attach",     "@teleport","-", "-", "-", "-", "-" ];

string sCommand;  // place to store a command for two-prompted ones
string sParam2;   // place to store a prompt for two-prompted ones
string priPub = "Owner Only";    // Private or Group
key kUserKey;        // the person who is controlling the avatar, not the Owner
// the command lists
list lCommands;  // commands are stored here
list lNpcCommandList; // Storage for the NPC script.
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


// STATES
integer MENU ;             // processing a dialog box state, may be concurrent with STATE
integer STATE;             // state storage
integer NULL = 0;          // the null state
integer MakeNotecard = 1;  // displaying a text box for NPC name
integer RecordPath = 2;    // displaying a path notecard menu
integer NobodyHome = 3;    // looking for an avatar
integer Spawning = 4;      // spawning an avatar
integer Animate = 5;       // animation timer needed
integer Walking = 6;       // Hey! I am walking here!
integer Wander = 7;        // Wandering around neeeds a timer, too
integer WanderHold = 8;    // We reached a wander point
integer DoProcess = 9;     // Set this to make it process a new command
integer Touch = 10;        // Timer is busy sensing something to touch
integer Sit = 11;          // Timer is busy sensing something to sit on
integer Paused = 12;       // Timer is busy pausing

key gNpcKey = NULL_KEY;   // global key storage for the one NPC, to save CPU cycles
list Stack ;              // a command stack from link message input

///////////////////////////////////////////////////////////////////////////
//                              FUNCTIONS                                //
///////////////////////////////////////////////////////////////////////////


TimerEvent(float timesent)
{
	if (LSLEditor)
		timesent *= 5;   // slow thinggs doen when the LSLEDITOR is in use

	DEBUG("Setting  timer: " + (string) timesent);
	llSetTimerEvent(timesent);
}

// for 4.1 parse a message from a Listen or a Link message
ParseMsg(string str) {
	DEBUG("Command In:" + str);
	if (str=="@go") {
		SetStop(FALSE); // Let's run the notecard
		DEBUG("@go running");
		DoProcessNPCLine();
	} else {
			Stack += [str];    // take anything, the controller will filter away non @ stuff
		if (STATE == NULL)
			DoProcessNPCLine(); // v 4.5 remove wait for STATE == 0
	}
}

SetStop(integer what)
{
	DEBUG("Stopped set to " + (string ) what);
	Stopped = what;
}
// Do* functions are much like states from the old V2 scripts.

// Save a Path notecard
DoSave()
{
	STATE = MakeNotecard;
	makeText("Stand where you want the NPC to appear, and enter the NPC Name");
}

// This function is used to record the path for the NPC
// Each command can take 0, 1, or 2 params
DoMenuForCommands() {
	makeMenu(lAtButtons);
}


// No one is here when sensors were on, so we kill off the NPC
DoNobodyHome()
{
	DEBUG("Nobody Home");
	STATE = NobodyHome;
	if (NPCKey() != NULL_KEY) {
		osNpcRemove(NPCKey());
		SaveKey(NULL_KEY);
	}
	TimerEvent(5);  // keep ticking to sense avatars
}


///////////////////////  STATELIKE BEHAVIOUR  /////////////
// these StateXX functions need to wait on a timer to fire.

// Create a NPC
StateSpawn() {
	DEBUG("state spawn " + sNPCName);

	NPCEnabled = TRUE; //  in world
	// see if there is already one out there.
	if (NPCKey() != NULL_KEY) {
		DEBUG("Already living");
		return;
	}

	STATE = Spawning;
	list name = llParseString2List(sNPCName, [" "], []);

	vector vRezPos = vInitialPos;
	if (relAbs == "Relative"){
		vRezPos += llGetPos();
	}

	// llSay(0,llDumpList2String(name,","));

	DEBUG("Rezzing NPC name " +llList2String(name, 0)+ llList2String(name, 1) + " at "+ (string) vRezPos);
	key aKey = osNpcCreate(llList2String(name, 0), llList2String(name, 1), vRezPos, Appearance, NPCOptions);

	llMessageLinked(LINK_SET,keyNum,"",aKey);    // bboradcast the key on num = -1
	SaveKey(aKey); // save in description and global, too

	osSetSpeed(aKey,SPEEDMULT);   // 1.9 speed multiplier
	TimerEvent(REZTIME);
	NPCAnimate(STAND);
}

StateSit() {
	DEBUG ("state sit - looking for " + RAMsit);
	STATE=Sit;
	llSensor(RAMsit, "", PASSIVE|ACTIVE|SCRIPTED,  96, PI);
}

StateTouch() {
	DEBUG ("state touch - looking for " + RAMtouch);
	STATE = Touch;
	llSensor(RAMtouch, "", PASSIVE|ACTIVE|SCRIPTED,  96, PI);
}

DoStand() {
	DEBUG("state stand");
	osNpcStand(NPCKey());
}


StateAnimate() {

	DEBUG("state animate");
	STATE = Animate;
	NPCAnimate(RAManimationName);
	if (RAManimationTime <=0 )    // V 3.4 tweak
		RAManimationTime = 1;
	TimerEvent(RAManimationTime);
}

StateWalk() {

	DEBUG("Start Walk");
	//DEBUG("NPCWalkOption = " + (string) NPCWalkOption);
	STATE = Walking;

	// walk, fly, run, land
	if (walkstate == 1) {
		NPCAnimate(WALK);
	} else if (walkstate == 2)  {
			llShout(FLIGHT,"flying");
		NPCAnimate(FLY);
	} else if (walkstate == 3) {
			NPCAnimate(RUN);
	} else if (walkstate == 4) {
			NPCAnimate(LAND);
	}
	newDest = vDestPos ;
	newDest.z += OffsetZ;

	// notecard is stored as offsets from this box with relative addressing.  Convert to absolute
	if (relAbs == "Relative"){
		newDest += llGetPos();
	}

	DEBUG("Moveto:" + (string) newDest);
	osNpcMoveToTarget(NPCKey(), newDest, NPCWalkOption);
	iWaitCounter = WAIT;            // wait 60 seconds to get to a destination.
	TimerEvent(TIMER);
}


StateWander(){
	DEBUG("state wander");
	STATE = Wander;

	vector point = CirclePoint(RAMwd);
	DEBUG("CirclePoint:" + (string) point);
	vWanderPos = vDestPos + point;
	DEBUG("vWanderPos:" + (string) vWanderPos);

	fTimerVal = WANDERTIME;    // default time to pause after each wander
	if (WANDERRAND)
		fTimerVal = llFrand(WANDERTIME) + 1;    // override, they want random times

	NPCAnimate(WALK);

	DEBUG("Wander to:" + (string) vWanderPos);

	osNpcMoveToTarget(NPCKey(), vWanderPos, NPCWalkOption);
	iWaitCounter = WAIT;            // wait 60 seconds to get to a destination.
	TimerEvent(TIMER);
}

StateWanderhold() {

	DEBUG("Wander Hold");
	STATE = WanderHold;

	// now that we have reached a wander spot, slow the timer down to the desired value
	TimerEvent(fTimerVal);
}



DoRotate() {
	DEBUG("@rotate=" + (string) RAMrot);
	osNpcSetRot(NPCKey(), llEuler2Rot(<0,0,RAMrot> * DEG_TO_RAD));
}



// @pause=10 will do nothing for 10 seconds
DoPause() {
	STATE = Paused;
	if (RAMPause < 0.1)
		RAMPause = 0.1;
	DEBUG("@pause=" + (string)RAMPause);
	TimerEvent(RAMPause);
}


// @stop makes the NPC stop moving in whatever state it is in.  You have to linkmessage to get moving again
DoStop() {
	DEBUG("NPC is Stopped");
	STATE   = 0;    // accept commands
	SetStop(TRUE); // Link controlled - we mnust have a @go to continue with notecards
	TimerEvent(0);
	Stack = []; // v3.8
}

// @delete removes the NPC forever. Next command starts it up again at the beginning
DoDelete() {
	DEBUG("state delete");
	osNpcRemove(NPCKey());
	SaveKey(NULL_KEY);
	TimerEvent(0);
	Stack = []; // v3.8
	STATE = NULL;    // accept commands
}

// change the appearance of the NPC
DoAppearance(string notecard) {
	DEBUG("state appearance");
	if (llGetInventoryType(notecard) == INVENTORY_NOTECARD){
		DEBUG("Load appearance " + notecard);
		osNpcLoadAppearance(NPCKey(),notecard);
	}
	STATE = NULL;    // accept commands
}

// Change the avatar speed
DoSpeed(string speed) {
	float newspeed = (float) speed;
	if (newspeed > 0.1 && newspeed < 5.0) {// sanity check
		osSetSpeed(NPCKey(),newspeed);
	}
	STATE = NULL;    // accept commands
}

DoTeleport(string params) {
	list Data = llParseString2List(params, ["|"], []);
	string itemName = llList2String(Data, 0);
	vector Dest = (vector) itemName;
	if (Dest != ZERO_VECTOR) {
		if (relAbs == "Relative"){
			Dest += llGetPos();
		}
		osTeleportAgent( NPCKey(), llGetRegionName(), Dest, ZERO_VECTOR );

	} else {
			llSay(DEBUG_CHANNEL,"Attempt to teleport to <0,0,0> probably not what you intended: @teleport=<vector>");
	}
	STATE = NULL;    // accept commands
}



DoNewNote (string card) {
	DEBUG("Load Notecard " + card);
	NPCReadNoteCard(card);
	SetStop(FALSE);
	STATE = NULL;    // accept commands
}
DoAttach(string params) {

	list Data = llParseString2List(params, ["|"], []);
	string itemName = llList2String(Data, 0);
	integer attachmentPoint  = (integer) llList2String(Data, 1);
	if (attachmentPoint > 0
		&& attachmentPoint < 40
			&& llGetInventoryType(itemName) == INVENTORY_OBJECT
				)
				{
					osForceAttachToOtherAvatarFromInventory(NPCKey(),itemName,attachmentPoint);
				}
	STATE = NULL;    // accept commands
}

// This loops over the notecard, processing each command
DoProcessNPCLine() {
	DEBUG("ProcessNPCLine, stopped = " + (string) Stopped);

	STATE = DoProcess;

	// auto load a notecard
	if (! llGetListLength(lNpcCommandList)) {
		DEBUG("Read Notecard");
		NPCReadNoteCard(Notecard);
	}

	// look for link messages on the stack
	string next = llList2String(Stack,0);    // lets see if there is anything from a link message
	if (llStringLength(next))
	{
		Stack = llDeleteSubList(Stack,0,0);
		ProcessCmd(next);        //lets do this command instead.
		return;
	}

	// @stop issued?
	if (Stopped) {
		TimerEvent(0);
		DEBUG("Stopped, waiting for input");
		STATE = NULL;
		return;
	}

	// No, we have an @go for liftoff
	next = llList2String(lNpcCommandList, 0);        // get the next command
	DEBUG("Execute:" + next);
	lNpcCommandList = llDeleteSubList(lNpcCommandList, 0, 0);      // delete it

	if (llGetListLength(lNpcCommandList) == 0) {
		DEBUG("EOF");
	}
	ProcessCmd(next);
}



ProcessCmd(string cmd) {

	DEBUG("ProcessCmd:" + cmd);

	llMessageLinked(LINK_SET,keyNum,"",NPCKey());    // bboradcast the key on num = -1
	if (llGetSubString(cmd, 0, 0) != "@") {
		DEBUG("ignoring");
		TimerEvent(QUICK);  // this is so we do not recurse the stack
		STATE = NULL;
		return;
	}

	list data  = llParseString2List(cmd, ["="], []);
	npcAction = llToLower(llStringTrim(llList2String(data, 0), STRING_TRIM));

	DEBUG("Action:" + npcAction);
	npcParams = llStringTrim(llList2String(data, 1), STRING_TRIM);
	DEBUG("Params:" + npcParams);

	@commands;

	ProcessSensor();
	if (! avatarPresent){
		DoNobodyHome();
		DEBUG("No avatar nearby");
		STATE = NULL;
		return;
	}

	if(npcAction == "@spawn") {
		DEBUG("@spawn npcParams ");
		list spawnData = llParseString2List(npcParams, ["|"], []);
		sNPCName =llList2String(spawnData, 0);    // V 1.6 name in RAM

		vInitialPos = (vector) llList2String(spawnData, 1);
		DEBUG("Coords for NPC at " + (string) vInitialPos);
		StateSpawn();
		return;
	}

	StateSpawn();

	if(npcAction == "@stop") {
		DoStop();
		STATE = NULL;
		return;
	}
	else if(npcAction == "@goto") {
		DEBUG("goto");
		integer lastIdx = llGetListLength(lNpcCommandList)-1;
		lNpcCommandList = llDeleteSubList(lNpcCommandList, lastIdx, lastIdx);
		// Wind commands till goto label.
		@wind;
		string next1 = llList2String(lNpcCommandList, 0);
		lNpcCommandList = llDeleteSubList(lNpcCommandList, 0, 0);
		lNpcCommandList += next1;
		if(next1 != npcParams) jump wind;
		// Wind the label too.
		next1 = llList2String(lNpcCommandList, 0);
		lNpcCommandList = llDeleteSubList(lNpcCommandList, 0, 0);
		lNpcCommandList += next1;
		// Get next command.
		list data1  = llParseString2List(next1, ["="], []);
		npcAction = llToLower(llStringTrim(llList2String(data1, 0), STRING_TRIM));
		npcParams = llStringTrim(llList2String(data1, 1), STRING_TRIM);
		// Reschedule.
		jump commands;
	}
	else if(npcAction == "@sound") {
		DEBUG("sound");
		llTriggerSound(npcParams,1.0);
	}
	else if(npcAction == "@randsound") {
		DEBUG("@randsound");
		integer N = llGetInventoryNumber(INVENTORY_SOUND);
		integer rand = llCeil(llFrand(N)) -1;    // pick a random sound
		string toPlay = llGetInventoryName(INVENTORY_SOUND,rand);
		llTriggerSound(toPlay,1.0);
	}
	else if(npcAction == "@walk") {
		DEBUG("@walk");
		GetDest(npcParams);
		walkstate = 1;//  walking
		NPCWalkOption = OS_NPC_NO_FLY ;
		StateWalk();
		return;
	}
	else if(npcAction == "@fly") {
		GetDest(npcParams);
		walkstate = 2;//  flying
		NPCWalkOption = OS_NPC_FLY ;
		StateWalk();
		return;
	}
	else if(npcAction == "@run") {
		DEBUG("@run");
		GetDest(npcParams);
		walkstate = 3;//  running
		NPCWalkOption = OS_NPC_NO_FLY | OS_NPC_RUNNING;
		StateWalk();
		return;
	}
	else if(npcAction == "@land") {
		DEBUG("@land");
		GetDest(npcParams);
		walkstate = 4;//  landing
		NPCWalkOption= OS_NPC_FLY | OS_NPC_LAND_AT_TARGET ;
		StateWalk();
		return;
	}
	else if(npcAction == "@say") {
		DEBUG("@say " + npcParams);
		osNpcSay(NPCKey(), 0, npcParams);
	}
	else if(npcAction == "@shout") {
		DEBUG("@shout");
		osNpcShout(NPCKey(),0, npcParams);
	}
	else if(npcAction == "@whisper") {
		DEBUG("@whisper " + npcParams);
		osNpcWhisper(NPCKey(),0, npcParams);
	}
	// speak a command on a channel, so you can open doors and control stuff.
	else if(npcAction == "@cmd") {
		DEBUG("@cmd");
		list dataToSpeak = llParseString2List(npcParams, ["|"], []);
		string channel = llList2String(dataToSpeak,0);
		DEBUG("Channel:"+(string) channel);
		integer iChannel = (integer) channel;
		string stringToSpeak = llList2String(dataToSpeak,1);
		llSay(iChannel, stringToSpeak);
	}
	// stop everything
	else if(npcAction == "@pause") {
		RAMPause = (float) npcParams;
		DoPause();
		return;
	}
	else if(npcAction == "@wander") {
		list wanderData = llParseString2List(npcParams, ["|"], []);
		RAMwd = (float) llList2String(wanderData, 0);
		RAMwc = (integer) llList2String(wanderData, 1);
		vDestPos = osNpcGetPos(NPCKey());        // set the wander start
		DEBUG("Starting at " + (string) vDestPos);
		StateWander();
		return;
	}
	else if(npcAction == "@rotate") {
		RAMrot = (float) npcParams;
		DoRotate();
	}
	else if(npcAction == "@sit") {
		RAMsit= npcParams;
		StateSit();
		return;
	}
	else if(npcAction == "@touch") {
		RAMtouch= npcParams;
		StateTouch();
		return;
	}
	else  if(npcAction == "@stand") {
		DoStand();
	}
	else if(npcAction == "@delete") {
		DoDelete();
		SetStop(TRUE); // Link controlled - we mnust have a @go to continue with notecards
		return;
	}
	else if(npcAction == "@animate") {
		list animateData = llParseString2List(npcParams, ["|"], []);
		RAManimationName = llList2String(animateData, 0);
		RAManimationTime = (float) llList2String(animateData, 1);
		StateAnimate();
		return;
	}
	else if(npcAction == "@appearance" ){
		DoAppearance(npcParams);
	}
	else if (npcAction =="@speed") {
		DoSpeed(npcParams);
	}
	else if (npcAction =="@notecard") {
		DoNewNote(npcParams);
		Notecard = npcParams;
	}
	else if (npcAction == "@attach")
	{
		DoAttach(npcParams);
	}
	else if (npcAction == "@teleport")
	{
		DoTeleport(npcParams);
	}
	else if (npcAction == "@reset")
	{
		DoDelete();
		SetStop(FALSE); // a @resst will restart the original !Path after deleting the notecard.
	}

	STATE = NULL;
	TimerEvent(QUICK);  // yeah I know, not possible this fast, we just go as fast as we can go - this is so we do not recurse the stack
}



/////////////////// UTILITY Functions, not state-like //////////////////

// DEBUG(string) will chat a string or display it as hovertext if debug == TRUE
DEBUG(string str) {
	if (debug && ! LSLEditor)
		llOwnerSay( str);                    // Send the owner debug info
	if (debug &&  LSLEditor)
		llSay(0, str);                    // Send to the Console in LSLEDitor
	if (iTitleText) {
		llSetText(str,<1.0,1.0,1.0>,1.0);    // show hovertext

	}
}

GetDest(string npcParams) {
	list dest = llParseString2List(npcParams, ["<", ",", ">"], []);
	vDestPos.x = llList2Float(dest, 0);
	vDestPos.y = llList2Float(dest, 1);
	vDestPos.z = llList2Float(dest, 2);
}

NPCReadNoteCard(string Note) {
	DEBUG("NPCReadNoteCard");
	lNpcCommandList = llParseString2List(osGetNotecard(Note), ["\n"], []);
}

integer SenseAvatar()
{
	//Returns a strided list of the UUID, position, and name of each avatar in the region
	list avatars = llGetAgentList(AGENT_LIST_REGION ,[]);
	integer numOfAvatars = llGetListLength(avatars);
	if (numOfAvatars == 0)
	{
		DEBUG("No people, no NPC's");
		return 0;
	}
	DEBUG("Located " + (string)numOfAvatars + " avatars and NPC's");

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
			} else {
					// DEBUG("*Not in range:" + llKey2Name(aviKey));
				}
		} else {
				//  DEBUG("NPC: " + llKey2Name(aviKey));
			}
	}
	//DEBUG("Located " + (string) nAvatars + " avatars");
	return nAvatars;
}

// return TRUE if the avatar is owner when private is set, or TRUE if the avatar is in the same group and GROUP is set.
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



NPCAnimate(string anim)
{
	DEBUG("Start Anim: " + anim);
	if (llGetInventoryType(anim) == INVENTORY_ANIMATION ) {

		if (lastANIM != anim) {
			if(llStringLength(lastANIM)) {
				osNpcStopAnimation(NPCKey(), lastANIM);
			}
			osNpcPlayAnimation(NPCKey(), anim);
			lastANIM = anim;
		}
	} else {
			llSay(DEBUG_CHANNEL, "No animation named " + anim);
	}
}

// Kill a NPC by Name
Kill(string param)
{
	integer count;
	list avatars = osGetAvatarList(); // Returns a strided list of the UUID, position, and name of each avatar in the region except the owner.\
	integer i;
	integer j = llGetListLength(avatars);
	for (i=0 ; i <= j; i+=3){

		string desired = llList2String(avatars,i+2);
		desired = llStringTrim(desired,STRING_TRIM);    // should not be needed but is needed

		if (desired == param){
			vector v = llList2Vector(avatars,i+1);
			key target = llList2Key(avatars,i);    // get the UUID of the avatar
			osNpcRemove(target);

			llOwnerSay("Removed " + param+ " at  location " + (string) v);
			count++;
		}
	}

	NPCEnabled = FALSE; // not in world
	SaveKey(NULL_KEY );    // Rev 4.4

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

	if (LSLEditor)
		where  = <128,128,31 + llFrand(1)>; // force center of sim when editing

	// if attached the height will be too high by 1/2 the agent size
	if (llGetAttached()) {
		vector size = llGetAgentSize(llGetOwner());
		float Z = size.z;
		where.z -= Z/2;
	}

	// DEBUG("Pos= " + (string) where);
	return (string) where;
}

// setup a menu with a timer for timeouts, called by all make*()
menu()
{
	llListenRemove(iHandle);
	iChannel = llCeil(llFrand(100000) + 20000);
	iHandle = llListen(iChannel,"","","");
	TimerEvent(30.0);
	MENU = TRUE;
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
	llDialog(kUserKey,(string) llGetListLength(lCommands) + " Records",buttons,iChannel);
}


// Rev 1.4
// top level menu for non group/ non owners
makeUserMenu()
{
	if (!allowUsers) return;

	menu();
	list buttons = ["Start NPC","Stop NPC"];
	llDialog(kUserKey,"Choose",buttons,iChannel);
}



// programmable menu for @commands
makeMenu(list buttons)
{
	menu();
	llDialog(kUserKey,(string) llGetListLength(lCommands) + " Record",buttons,iChannel);
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

// Set the Avatar Present flag - if sensors are off and we are force run, there will be one present.
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

	DEBUG("Avatars:" + (string) n);
	if (SensorOn && n)
		avatarPresent = TRUE;   // someone is here and we need to tell the system to run
	else if (SensorOn && !n)
		avatarPresent = FALSE;  // someone is not here and we need to tell the system to stop
	else {       // sensor is off, lete see if there is a NPC. If so, we are ON
		// DEBUG("NPCEnabled:" + (string) NPCEnabled);

		if (NPCEnabled)
			avatarPresent = TRUE;
		else
			avatarPresent = FALSE;
	}

	//  start up from when when no one is near
	if (avatarPresent && STATE == NobodyHome)
		STATE = NULL;

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
		if (llGetInventoryName(INVENTORY_NOTECARD,i) == Notecard)
			count++;
		if (llGetInventoryName(INVENTORY_NOTECARD,i) == Appearance)
			count++;
	}
	DEBUG("Checked " + (string) count + " Notecards");
	// if we have both, run the NPC
	return count;
}

Update(string SName) {

	// delete all NPC* scripts except myself
	integer i;
	integer j = llGetInventoryNumber(INVENTORY_SCRIPT);
	for (i = 0; i < j; i++) {
		string targetName = llGetInventoryName(INVENTORY_SCRIPT,i);
		string match = llGetSubString(targetName,0,2);

		if (match == SName && llGetScriptName() != targetName){
			llOwnerSay("Upgrading " + targetName);
			if (! LSLEditor){        // lets not kill the editor
				llRemoveInventory(targetName);
			}
		}
	}
}

// Get all default saved params from the Description
GetSwitches()
{
	string rA = KeyValueGet("co"); // Get the remembered menu setting for Abs Vs Relative
	if (rA == "A")
		relAbs = "Absolute";
	else  if (rA == "R")
		relAbs = "Relative";
	else
		relAbs = "Absolute";


	// reenable NPC if sensor is on.
	if ("on" == KeyValueGet("se"))
	{
		NPCEnabled = TRUE;
		mSensor  = "Sense is On";
		ProcessSensor();       // fake 1 avatar to get it rezzed
	} else {
			mSensor  = "Sense is Off";
	}
}


SaveKey(key akey)
{
	DEBUG("Saving Key of " + (string) akey);
	KeyValueSet("key", akey);
	if (akey !=  (key) KeyValueGet("key") )
	{
		DEBUG("Fatal error, cannot save key");
	}
	gNpcKey = akey;
}


key NPCKey()
{
	key akey = gNpcKey;   // from cached copy
	// gNpcKey saves a lot of CPU processing by caching the key, if blank we get it from the description
	if (gNpcKey == NULL_KEY)
	{
		//DEBUG("Get DKey");
		akey = KeyValueGet("key");    // from Description of the prim
	}
	// DEBUG("NPC KEY:" + (string) akey);
	return  akey;
}


/////////////////// CODE BEGINS //////////////////


default
{
	changed(integer change) {
		if(change & CHANGED_REGION_START) {
			llResetScript();
		}
	}

	on_rez(integer start_param)
	{
		llResetScript();
	}

	state_entry() {

		llSetText("",<1,1,1>,1.0);  // clr all hovertext- we may not be using it.
		DoDelete(); // kill any NPC that is out running
		Update("NPC"); // If dragged and ropped into a prim with any script named "NPC...", this will replace it.
		GetSwitches(); // Get all default saved params from the Description

		// 4.1 allow listeners to send us commands
		if (allowListener)
			llListen(link_Channel,"","","");
		TimerEvent(TIMER);
	}


	touch_start(integer n)
	{           // if touched, make a menu

		if (checkPerms()) {
			if (RecordPath == STATE) {
				makeMenu(lAtButtons);
			}   else {
					makeMainMenu();
			}
		} else {
				makeUserMenu();
		}
	}

	// menu listener
	listen(integer iChannel, string name, key id, string message) {

		// process @commands that come in via the listener
		if (iChannel == link_Channel)
		{
			ParseMsg(message);
			return;
		}

		if (MENU) {
			llListenRemove(iHandle);
			MENU = 0;       // menu is off
			iHandle = 0;
		}

		if (message == "Stop NPC")
		{
			lNpcCommandList = []; // force reload of notecard
			NPCEnabled = FALSE;
			if (NPCKey() != NULL_KEY){
				Kill(sNPCName);
			} else {
					bNPC_STOP = TRUE;
				makeText("Enter name of an NPC to stop");
			}
		}
		else if (message == "Menu" ) {
			makeMainMenu();
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
			DoMenuForCommands();        // show them the recording menu
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
		else if (message == "Sense is On") {
			mSensor ="Sense is Off";
			KeyValueSet("se", "off");
			llOwnerSay(mSensor);
			makeMainMenu();
		}
		else if (message == "Sense is Off") {
			mSensor ="Sense is On";
			llOwnerSay(mSensor);
			KeyValueSet("se", "on");

			NPCEnabled = TRUE;

			integer count = checkNoteCards();
			if (count >= 2)  {
				DEBUG("Notecards ok, DoProcessNPCLine");
				DoProcessNPCLine();
				return;
			}
			if (LSLEditor) {
				DoProcessNPCLine();
				return;
			}

			llOwnerSay("You have not saved a recording and/or appearance, so you cannot start a NPC");
			makeMainMenu();
		}
		else if (message == "Appearance")  {
			llRemoveInventory(Appearance);            // delete the notecard
			osAgentSaveAppearance(kUserKey,Appearance);    // make the ntecard
			llOwnerSay("Your outfit has been saved");
			makeMainMenu();
		}
		else if (message == "Save") {
			if (llGetListLength(lCommands) == 0) {
				llOwnerSay("Nothing recorded, you need to make a recording first");
				makeMainMenu();
				return;
			}
			DoSave();
		}
		else if (message == "Help"){
			llLoadURL(kUserKey,"Click to view help","http://www.outworldz.com/opensim/posts/NPC/");
			makeMainMenu();
		}
		else if (message == "Start NPC")    {
			integer count = checkNoteCards();

			NPCEnabled = TRUE;

			if (LSLEditor) {
				DoProcessNPCLine();
				return;
			}

			if (count >= 2) {
				DEBUG("Notecards approved , calling DoProcessNPCLine");
				SetStop(FALSE); // Let's run the notecard
				DoProcessNPCLine();
				return;
			}

			llOwnerSay("You have not saved a recording or maybe an appearance, so we cannot start a NPC");

		}
		else if (bNPC_STOP){
			bNPC_STOP = FALSE;
			Kill(message);
		}
		else if (message == ">>"){
			makeMenu(lMenu2);
		}
		else if (message == ">>>"){
			makeMenu(lMenu3);
		}
		else if (message == "<<") {
			makeMenu(lAtButtons);
		}
		else if (message == "<<<") {
			makeMenu(lMenu2);
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
		else if (message == "@teleport"){
			lCommands += "@teleport=" + Pos() + "\n";
			llOwnerSay("teleport to position: " + Pos());
			makeMenu(lMenu3);
		}
		else if (message == "@touch"){
			Text("@touch=","Enter name of object to touch","");
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
		else if (message == "@attach"){
			Text("@animate=","Enter inventory name to attach","Enter number of the attachment point (1-40)");
		}
		else if (message == "@speed"){
			Text("@speed=","Enter a speed for the NPC, 1=100% normal speed, 0.5=50% speed","");
		}


		// Save NPC name
		else if (MakeNotecard == STATE) {
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
			llRemoveInventory(Notecard);        // delete the old notecard
			osMakeNotecard(Notecard,sNotecard); // Makes the notecard.
			llSay(0,sNotecard);
			llOwnerSay("Commands notecard has been written");
			STATE = NULL;
		} // MakeNotecard

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



	timer(){
		// DEBUG("tick");

		// if llDialog is up, kill the listener for the dialog box.
		if (iHandle) {
			llOwnerSay("Menu timed out");
			llListenRemove(iHandle);
			iHandle = 0;
			return;             // ^^^^^^^^^^^^^^^^^^^^^^^
		}
		// if NoBodyHome, we are sensing for an avatar
		else if (NobodyHome == STATE) {
			ProcessSensor();
			return;
		}
		// if we are spawning, we need time to rez the NPC, then start processing NPC Commands.
		else if (Spawning == STATE) {
			STATE = NULL;
			TimerEvent(TIMER);
		}
		// We end aniamtions with a timer
		else if (Animate == STATE){
			NPCAnimate(STAND);
			TimerEvent(TIMER);
		}

		else if (Walking == STATE) {
			if (--iWaitCounter) {
				DEBUG("still walking...");
				if (llVecDist(osNpcGetPos(NPCKey()), newDest) > MAXDIST)  {
					return;
				}
			}

			DEBUG("At Destination: " + (string) newDest);

			// walk, fly, run, land
			if (walkstate == 1) {
				NPCAnimate(STAND);
				NPCWalkOption = OS_NPC_NO_FLY;
			} else if (walkstate == 2)  {
					// nothing
				} else if (walkstate == 3) {
						NPCAnimate(STAND);
				NPCWalkOption = OS_NPC_NO_FLY;
			} else if (walkstate == 4) {
					llShout(FLIGHT,"landing");
				NPCAnimate(STAND);
				NPCWalkOption = OS_NPC_NO_FLY;
			}
		}
		// Wandering timer
		else if (Wander == STATE) {
			if (--iWaitCounter) {          // wait 60 seconds to get to a destination.
				if (llVecDist(osNpcGetPos(NPCKey()), vWanderPos) > MAXDIST)
					return;
			}

			// see if wander counter == 0, if so, stop walking, go to stand and process next line
			if(RAMwc == 0) {
				NPCAnimate(STAND);
				DEBUG("Wander ended, calling DoProcessNPCLine");
				STATE = NULL;
				return;
			}
			// one less time to wander around
			RAMwc--;
			NPCAnimate(STAND);
			TimerEvent(TIMER);
			StateWanderhold();
			return;
		}
		// Wandering requires us to re-wander when we reach a destination
		else if (WanderHold == STATE) {
			StateWander();
			return;
		}
		else if (DoProcess == STATE) {
			TimerEvent(QUICK);
		}

		STATE = NULL;

		// We always process a NPC line at end of timer.
		DEBUG("Tick end, calling DoProcessNPCLine");
		DoProcessNPCLine();
	}

	// sensors are used for sitting on prims
	// Neo Cortex: added different states to trigger sit or touch
	sensor(integer num) {
		if (Sit == STATE ) {
			osNpcSit(NPCKey(), llDetectedKey(0), OS_NPC_SIT_NOW);
			DEBUG("Seated, calling DoProcessNPCLine");

			STATE = 0;
		} else if (Touch == STATE) {
				osNpcTouch(NPCKey(), llDetectedKey(0), LINK_THIS);
			DEBUG("Touched, calling DoProcessNPCLine");
			STATE = 0;
		}
		DoProcessNPCLine();
	}
	no_sensor(){
		DEBUG ("no target prim located, calling DoProcessNPCLine");
		DoProcessNPCLine();
		STATE = NULL;
	}


	link_message(integer sender, integer num, string str, key id){
		if (num == 0)
			ParseMsg(str);
	}

}

// __ END__



