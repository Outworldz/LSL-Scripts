// :SHOW:1
// :CATEGORY:Fire
// :NAME:Realfire by Rene
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting
// :CREATED:2015-06-11 14:37:29
// :EDITED:2015-06-12  11:25:11
// :ID:1078
// :NUM:1765
// :REV:3.0.1
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Main script for Realfire
// :CODE:
// :LICENSE: CC0 (Public Domain). To the extent possible under law, Rene10957 has waived all copyright and related or neighboring rights.For more information, see http://creativecommons.org/publicdomain/zero/1.0/.

string title = "RealFire";      // title
string version = "3.0.1";       // version
string notecard = "config";     // notecard name

// Constants

integer _PUBLIC_ = 1;           // public access bit
integer _GROUP_ = 2;            // group access bit
integer _OWNER_ = 4;            // owner access bit
integer _GRPOWN_ = 6;           // group + owner
integer smokeChannel = -15790;  // smoke channel
float minParticle = 0.0625;     // smallest possible particle dimension (SL limit = 0.03125)
float maxRed = 1.0;             // max. red
float maxGreen = 1.0;           // max. green
float maxBlue = 1.0;            // max. blue
float maxIntensity = 1.0;       // max. light intensity
float maxRadius = 20.0;         // max. light radius
float maxFalloff = 2.0;         // max. light falloff
float maxVolume = 1.0;          // max. volume for sound

// Notecard variables

integer verbose = FALSE;        // show more/less info during startup
integer switchAccess;           // access level for switch
integer menuAccess;             // access level for menu
integer msgNumber;              // number part of incoming link messages
string msgSwitch;               // string part of incoming link message: switch (on/off)
string msgOn;                   // string part of incoming link message: switch on
string msgOff;                  // string part of incoming link message: switch off
string msgMenu;                 // string part of incoming link message: show menu
string extButton;               // "Close" replaced by button text (sends link message)
integer extNumber;              // number part of outgoing link message
integer switchNumber;           // number part of outgoing on/off messages
integer burnDown = FALSE;       // burn down or burn continuously
float burnTime;                 // time to burn in seconds before starting to die
float dieTime;                  // time it takes to die in seconds
integer loop = FALSE;           // restart after burning down
integer changeLight = FALSE;    // change light with fire
integer changeSmoke = FALSE;    // change smoke with fire
integer changeVolume = FALSE;   // change volume with fire
integer singleFire = FALSE;     // single fire or multiple fires
integer defSize;                // default fire size (percentage)
float minSize;                  // min. fire size (percentage)
vector defStartColor;           // default start (bottom) color (percentage R,G,B)
vector defEndColor;             // default end (top) color (percentage R,G,B)
integer defVolume;              // default volume for sound (percentage)
integer defSmoke = FALSE;       // default smoke on/off
integer defSound = FALSE;       // default sound on/off
integer defIntensity;           // default light intensity (percentage)
integer defRadius;              // default light radius (percentage)
integer defFalloff;             // default light falloff (percentage)

// Particle parameters (general)

float age = 1.0;                // particle lifetime
float rate = 0.1;               // particle burst rate
integer count = 10;             // particle count
vector startColor = <1, 1, 0>;  // particle start color
vector endColor = <1, 0, 0>;    // particle end color
float startAlpha = 1.0;         // particle start alpha
float endAlpha = 0.0;           // particle end alpha

// Particle parameters (resizing)

vector startScale = <0.4, 2, 0>;// particle start size (100%)
vector endScale = <0.4, 2, 0>;  // particle end size (100%)
float minSpeed = 0.0;           // particle min. burst speed (100%)
float maxSpeed = 0.04;          // particle max. burst speed (100%)
float burstRadius = 0.4;        // particle burst radius (100%)
vector partAccel = <0, 0, 10>;  // particle accelleration (100%)

// Variables

key owner;                      // object owner
integer line;                   // notecard line
integer loading = FALSE;        // notecard loading
integer menuChannel;            // main menu channel
integer startColorChannel;      // start color menu channel
integer endColorChannel;        // end color menu channel
integer menuHandle;             // handle for main menu listener
integer startColorHandle;       // handle for start color menu listener
integer endColorHandle;         // handle for end color menu listener
integer perRedStart;            // percent red for startColor
integer perGreenStart;          // percent green for startColor
integer perBlueStart;           // percent blue for startColor
integer perRedEnd;              // percent red for endColor
integer perGreenEnd;            // percent green for endColor
integer perBlueEnd;             // percent blue for endColor
integer perSize;                // percent particle size
integer perVolume;              // percent volume
integer on = FALSE;             // fire on/off
integer burning = FALSE;        // burning constantly
integer smokeOn = FALSE;        // smoke on/off
integer soundOn = FALSE;        // sound on/off
integer menuOpen = FALSE;       // a menu is open or canceled (ignore button)
float time;                     // timer interval in seconds
float percent;                  // percentage of perSize (changed by burning down)
float percentSmoke;             // percentage of smoke
float decPercent;               // how much to burn down (%) every timer interval
vector lightColor;              // light color
float lightIntensity;           // light intensity (changed by burning down)
float lightRadius;              // light radius (changed by burning down)
float lightFalloff;             // light falloff
float soundVolume;              // sound volume (changed by burning down)
string sound;                   // first sound in inventory
string texture;                 // first texture in inventory
float startIntensity;           // start value of lightIntensity (before burning down)
float startRadius;              // start value of lightRadius (before burning down)
float startVolume;              // start value of volume (before burning down)

// Functions

string getName(integer link)
{
	string str = llStringTrim(llGetLinkName(link), STRING_TRIM);
	return llToLower(str);
}

string getGroup()
{
	string str = llStringTrim(llGetObjectDesc(), STRING_TRIM);
	if (llToLower(str) == "(no description)" || str == "") str = "Default";
	return str;
}

toggleFire()
{
	if (on) stopSystem(); else startSystem();
}

toggleSmoke()
{
	if (smokeOn) {
		sendMessage(0);
		smokeOn = FALSE;
	}
	else {
		if (changeSmoke) sendMessage(llRound(percentSmoke)); else sendMessage(100);
		smokeOn = TRUE;
	}
}

toggleSound()
{
	if (soundOn) {
		llStopSound();
		soundOn = FALSE;
	}
	else {
		if (sound) llLoopSound(sound, soundVolume);
		soundOn = TRUE;
	}
}

updateSize(float size)
{
	vector start;                            // start scale
	vector end;                              // end scale
	float radius;                            // burst radius
	float min = minSpeed / 100.0 * size;     // min. burst speed
	float max = maxSpeed / 100.0 * size;     // max. burst speed
	vector push = partAccel / 100.0 * size;  // accelleration

	if (size < minSize) {
		start = startScale / 100.0 * minSize;
		end = endScale / 100.0 * minSize;
		radius = burstRadius / 100.0 * minSize;
	}
	else {
		start = startScale / 100.0 * size;
		end = endScale / 100.0 * size;
		radius = burstRadius / 100.0 * size;
	}

	if (size > (float)defSize) {
		lightIntensity = startIntensity;
		lightRadius = startRadius;
		percentSmoke = 100.0;
		soundVolume = startVolume;
	}
	else {
		size *= 100.0 / (float)defSize;
		if (changeLight) {
			lightIntensity = percentage(size, startIntensity);
			lightRadius = percentage(size + 50.0 - size / 2.0, startRadius);
		}
		else {
			lightIntensity = startIntensity;
			lightRadius = startRadius;
		}
		if (changeSmoke) percentSmoke = size; else percentSmoke = 100.0;
		if (changeVolume) soundVolume = percentage(size, startVolume); else soundVolume = startVolume;
	}

	updateColor();
	updateParticles(start, end, min, max, radius, push);
	if (smokeOn) sendMessage(llRound(percentSmoke));
	if (sound) if (soundOn) llAdjustSoundVolume(soundVolume);
}

updateColor()
{
	startColor.x = percentage((float)perRedStart, maxRed);
	startColor.y = percentage((float)perGreenStart, maxGreen);
	startColor.z = percentage((float)perBlueStart, maxBlue);

	endColor.x = percentage((float)perRedEnd, maxRed);
	endColor.y = percentage((float)perGreenEnd, maxGreen);
	endColor.z = percentage((float)perBlueEnd, maxBlue);

	lightColor = (startColor + endColor) / 2.0; // light color = average of start & end color
}

integer accessGranted(key user, integer access)
{
	integer bitmask = _PUBLIC_;
	if (user == owner) bitmask += _OWNER_;
	if (llSameGroup(user)) bitmask += _GROUP_;
	return (bitmask & access);
}

integer checkAccess(string par, string val)
{
	if (llToLower(val) == "public") return _PUBLIC_;
	if (llToLower(val) == "group") return _GROUP_;
	if (llToLower(val) == "owner") return _OWNER_;
	if (llToLower(val) == "group+owner") return _GRPOWN_;
	llWhisper(0, "[Notecard] " + par + " out of range, corrected to PUBLIC");
	return _PUBLIC_;
}

integer checkInt(string par, integer val, integer min, integer max)
{
	if (val < min || val > max) {
		if (val < min) val = min;
		else if (val > max) val = max;
		llWhisper(0, "[Notecard] " + par + " out of range, corrected to " + (string)val);
	}
	return val;
}

vector checkVector(string par, vector val)
{
	if (val == ZERO_VECTOR) {
		val = <100,100,100>;
		llWhisper(0, "[Notecard] " + par + " out of range, corrected to " + (string)val);
	}
	return val;
}

integer checkYesNo(string par, string val)
{
	if (llToLower(val) == "yes") return TRUE;
	if (llToLower(val) == "no") return FALSE;
	llWhisper(0, "[Notecard] " + par + " out of range, corrected to NO");
	return FALSE;
}

loadNotecard()
{
	verbose = TRUE;
	switchAccess = _PUBLIC_;
	menuAccess = _PUBLIC_;
	msgNumber = 10959;
	msgSwitch = "switch";
	msgOn = "on";
	msgOff = "off";
	msgMenu = "menu";
	extButton = "";
	extNumber = 10960;
	switchNumber = 10961;
	burnDown = FALSE;
	burnTime = 300.0;
	dieTime = 300.0;
	loop = FALSE;
	changeLight = TRUE;
	changeSmoke = TRUE;
	changeVolume = TRUE;
	singleFire = TRUE;
	defSize = 25;
	defStartColor = <100,100,0>;
	defEndColor = <100,0,0>;
	defVolume = 100;
	defSmoke = TRUE;
	defSound = TRUE;
	defIntensity = 100;
	defRadius = 50;
	defFalloff = 40;
	line = 0;

	if (!burnDown) burnTime = 315360000;   // 10 years
	time = dieTime / 100.0;                // try to get a one percent timer interval
	if (time < 1.0) time = 1.0;            // but never smaller than one second
	decPercent = 100.0 / (dieTime / time); // and burn down decPercent% every time

	startIntensity = percentage(defIntensity, maxIntensity);
	startRadius = percentage(defRadius, maxRadius);
	lightFalloff = percentage(defFalloff, maxFalloff);
	startVolume = percentage(defVolume, maxVolume);

	if (llGetInventoryType(notecard) == INVENTORY_NOTECARD) {
		loading = TRUE;
		llSetText("Loading notecard...", <1,1,1>, 1.0);
		llGetNotecardLine(notecard, line);
	}
	else {
		reset(); // initial values for menu
		if (on) startSystem();
		if (verbose) {
			llWhisper(0, "Notecard \"" + notecard + "\" not found or empty, using defaults");
			llWhisper(0, "Touch to start/stop fire");
			llWhisper(0, "Long touch to show menu");
			if (sound) llWhisper(0, "Sound in object inventory: Yes");
			else llWhisper(0, "Sound in object inventory: No");
			llWhisper(0, title + " " + version + " ready");
		}
	}
}

readNotecard (string ncLine)
{
	string ncData = llStringTrim(ncLine, STRING_TRIM);

	if (llStringLength(ncData) > 0 && llGetSubString(ncData, 0, 0) != "#") {
		list ncList = llParseString2List(ncData, ["=","#"], []);  // split into parameter, value, comment
		string par = llStringTrim(llList2String(ncList, 0), STRING_TRIM);
		string val = llStringTrim(llList2String(ncList, 1), STRING_TRIM);
		string lcpar = llToLower(par);
		if (lcpar == "verbose") verbose = checkYesNo(par, val);
		else if (lcpar == "switchaccess") switchAccess = checkAccess(par, val);
		else if (lcpar == "menuaccess") menuAccess = checkAccess(par, val);
		else if (lcpar == "msgnumber") msgNumber = (integer)val;
		else if (lcpar == "msgswitch") msgSwitch = val;
		else if (lcpar == "msgon") msgOn = val;
		else if (lcpar == "msgoff") msgOff = val;
		else if (lcpar == "msgmenu") msgMenu = val;
		else if (lcpar == "extbutton") extButton = llGetSubString(val, 0, 23);
		else if (lcpar == "extnumber") extNumber = (integer)val;
		else if (lcpar == "switchnumber") switchNumber = (integer)val;
		else if (lcpar == "burndown") burnDown = checkYesNo(par, val);
		else if (lcpar == "burntime") burnTime = (float)checkInt(par, (integer)val, 1, 315360000); // 10 years
		else if (lcpar == "dietime") dieTime = (float)checkInt(par, (integer)val, 1, 315360000); // 10 years
		else if (lcpar == "loop") loop = checkYesNo(par, val);
		else if (lcpar == "changelight") changeLight = checkYesNo(par, val);
		else if (lcpar == "changesmoke") changeSmoke = checkYesNo(par, val);
		else if (lcpar == "changevolume") changeVolume = checkYesNo(par, val);
		else if (lcpar == "singlefire") singleFire = checkYesNo(par, val);
		else if (lcpar == "size") defSize = checkInt(par, (integer)val, 5, 100);
		else if (lcpar == "topcolor") defEndColor = checkVector(par, (vector)val);
		else if (lcpar == "bottomcolor") defStartColor = checkVector(par, (vector)val);
		else if (lcpar == "volume") defVolume = checkInt(par, (integer)val, 5, 100);
		else if (lcpar == "smoke") defSmoke = checkYesNo(par, val);
		else if (lcpar == "sound") defSound = checkYesNo(par, val);
		else if (lcpar == "intensity") defIntensity = checkInt(par, (integer)val, 0, 100);
		else if (lcpar == "radius") defRadius = checkInt(par, (integer)val, 0, 100);
		else if (lcpar == "falloff") defFalloff = checkInt(par, (integer)val, 0, 100);
		else llWhisper(0, "Unknown parameter in notecard line " + (string)(line + 1) + ": " + par);
	}

	line++;
	llGetNotecardLine(notecard, line);
}

menuDialog (key id)
{
	menuOpen = TRUE;
	string strSmoke = "OFF"; if (smokeOn) strSmoke = "ON";
	string strSound = "NONE"; if (sound) if (soundOn) strSound = "ON"; else strSound = "OFF";
	string strButton = "Close"; if (extButton) strButton = extButton;
	menuChannel = (integer)(llFrand(-1000000000.0) - 1000000000.0);
	llListenRemove(menuHandle);
	menuHandle = llListen(menuChannel, "", "", "");
	llSetTimerEvent(0);
	llSetTimerEvent(120);
	llDialog(id, title + " " + version +
		"\n\nSize: " + (string)perSize + "%\t\tVolume: " + (string)perVolume + "%" +
		"\nSmoke: " + strSmoke + "\t\tSound: " + strSound, [
		"Smoke", "Sound", strButton,
		"-Volume", "+Volume", "Reset",
		"-Fire", "+Fire", "Color",
		"Small", "Medium", "Large" ],
		menuChannel);
}

startColorDialog (key id)
{
	menuOpen = TRUE;
	startColorChannel = (integer)(llFrand(-1000000000.0) - 1000000000.0);
	llListenRemove(startColorHandle);
	startColorHandle = llListen(startColorChannel, "", "", "");
	llSetTimerEvent(0);
	llSetTimerEvent(120);
	llDialog(id, "Bottom color" +
		"\n\nRed: " + (string)perRedStart + "%" +
		"\nGreen: " + (string)perGreenStart + "%" +
		"\nBlue: " + (string)perBlueStart + "%", [
		"Top color", "One color", "Main menu",
		"-Blue",  "+Blue",  "B min/max",
		"-Green", "+Green", "G min/max",
		"-Red",   "+Red",   "R min/max" ],
		startColorChannel);
}

endColorDialog (key id)
{
	menuOpen = TRUE;
	endColorChannel = (integer)(llFrand(-1000000000.0) - 1000000000.0);
	llListenRemove(endColorHandle);
	endColorHandle = llListen(endColorChannel, "", "", "");
	llSetTimerEvent(0);
	llSetTimerEvent(120);
	llDialog(id, "Top color" +
		"\n\nRed: " + (string)perRedEnd + "%" +
		"\nGreen: " + (string)perGreenEnd + "%" +
		"\nBlue: " + (string)perBlueEnd + "%", [
		"Bottom color", "One color", "Main menu",
		"-Blue",  "+Blue",  "B min/max",
		"-Green", "+Green", "G min/max",
		"-Red",   "+Red",   "R min/max" ],
		endColorChannel);
}

float percentage (float per, float num)
{
	return num / 100.0 * per;
}

integer min (integer x, integer y)
{
	if (x < y) return x; else return y;
}

integer max (integer x, integer y)
{
	if (x > y) return x; else return y;
}

reset()
{
	smokeOn = defSmoke;
	soundOn = defSound;
	perSize = defSize;
	perVolume = defVolume;
	perRedStart = (integer)defStartColor.x;
	perGreenStart = (integer)defStartColor.y;
	perBlueStart = (integer)defStartColor.z;
	perRedEnd = (integer)defEndColor.x;
	perGreenEnd = (integer)defEndColor.y;
	perBlueEnd = (integer)defEndColor.z;
}

startSystem()
{
	if (!on) llMessageLinked(LINK_SET, switchNumber, (string)TRUE, getGroup());
	on = TRUE;
	burning = TRUE;
	percent = 100.0;
	percentSmoke = 100.0;
	smokeOn = !smokeOn;
	toggleSmoke();
	startVolume = percentage(perVolume, maxVolume);
	lightIntensity = startIntensity;
	lightRadius = startRadius;
	soundVolume = startVolume;
	updateSize((float)perSize);
	llStopSound();
	if (sound) if (soundOn) llLoopSound(sound, soundVolume);
	llSetTimerEvent(0);
	llSetTimerEvent(burnTime);
	if (menuOpen) {
		llListenRemove(menuHandle);
		llListenRemove(startColorHandle);
		llListenRemove(endColorHandle);
		menuOpen = FALSE;
	}
}

stopSystem()
{
	if (on) llMessageLinked(LINK_SET, switchNumber, (string)FALSE, getGroup());
	on = FALSE;
	burning = FALSE;
	percent = 0.0;
	percentSmoke = 0.0;
	llSetTimerEvent(0);
	updateParticles(ZERO_VECTOR, ZERO_VECTOR, 0, 0, 0, ZERO_VECTOR);
	llStopSound();
	sendMessage(0);
	if (menuOpen) {
		llListenRemove(menuHandle);
		llListenRemove(startColorHandle);
		llListenRemove(endColorHandle);
		menuOpen = FALSE;
	}
}

updateParticles(vector start, vector end, float min, float max, float radius, vector push)
{
	list particles = [
		PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_EXPLODE,
		PSYS_SRC_TEXTURE, texture,
		PSYS_PART_START_COLOR, startColor,
		PSYS_PART_END_COLOR, endColor,
		PSYS_PART_START_ALPHA, startAlpha,
		PSYS_PART_END_ALPHA, endAlpha,
		PSYS_PART_START_SCALE, start,
		PSYS_PART_END_SCALE, end,
		PSYS_PART_MAX_AGE, age,
		PSYS_SRC_BURST_RATE, rate,
		PSYS_SRC_BURST_PART_COUNT, count,
		PSYS_SRC_BURST_SPEED_MIN, min,
		PSYS_SRC_BURST_SPEED_MAX, max,
		PSYS_SRC_BURST_RADIUS, radius,
		PSYS_SRC_ACCEL, push,
		PSYS_PART_FLAGS,
		0 |
		PSYS_PART_EMISSIVE_MASK |
		PSYS_PART_FOLLOW_VELOCITY_MASK |
		PSYS_PART_INTERP_COLOR_MASK |
		PSYS_PART_INTERP_SCALE_MASK ];

	if (singleFire) {
		if (on) {
			llParticleSystem(particles);
			llSetPrimitiveParams([PRIM_POINT_LIGHT, TRUE, lightColor, lightIntensity, lightRadius, lightFalloff]);
		}
		else {
			llParticleSystem([]);
			llSetPrimitiveParams([PRIM_POINT_LIGHT, FALSE, ZERO_VECTOR, 0, 0, 0]);
		}
		return;
	}

	integer i;
	integer number = llGetNumberOfPrims();
	integer link = llGetLinkNumber();
	string name = getName(link);

	for (i = number; i >= 0; --i) {
		if (name == getName(i)) {
			if (i == link || getName(i) != "object") {
				if (on) {
					llLinkParticleSystem(i, particles);
					llSetLinkPrimitiveParamsFast(i, [
						PRIM_POINT_LIGHT, TRUE, lightColor, lightIntensity, lightRadius, lightFalloff]);
				}
				else {
					llLinkParticleSystem(i, []);
					llSetLinkPrimitiveParamsFast(i, [PRIM_POINT_LIGHT, FALSE, ZERO_VECTOR, 0, 0, 0]);
				}
			}
		}
	}
}

sendMessage(integer size)
{
	llMessageLinked(LINK_ALL_OTHERS, smokeChannel, (string)size, getGroup());
}

default
{
	state_entry()
	{
		minSize = 100.0 / (startScale.x / minParticle); // smallest possible fire size (percentage)
		owner = llGetOwner();
		sound = llGetInventoryName(INVENTORY_SOUND, 0); // get first sound from inventory
		texture = llGetInventoryName(INVENTORY_TEXTURE, 0); // get first texture from inventory
		if (sound) llPreloadSound(sound);
		stopSystem();
		loadNotecard();
	}

	on_rez(integer start_param)
	{
		llResetScript();
	}

	touch_start(integer total_number)
	{
		llResetTime();
	}

	touch_end(integer total_number)
	{
		if (loading) {
			llWhisper(0, "Notecard is still loading");
			return;
		}

		key user = llDetectedKey(0);

		if (llGetTime() > 1.0) {
			if (accessGranted(user, menuAccess)) {
				startSystem();
				menuDialog(user);
			}
			else llInstantMessage(user, "[Menu] Access denied");
		}
		else {
			if (accessGranted(user, switchAccess)) toggleFire();
			else llInstantMessage(user, "[Switch] Access denied");
		}
	}

	listen(integer channel, string name, key id, string msg)
	{
		if (channel == menuChannel) {
			llListenRemove(menuHandle);
			if (msg == "Small") perSize = 25;
			else if (msg == "Medium") perSize = 50;
			else if (msg == "Large") perSize = 75;
			else if (msg == "-Fire") perSize = max(perSize - 5, 5);
			else if (msg == "+Fire") perSize = min(perSize + 5, 100);
			else if (msg == "-Volume") {
				perVolume = max(perVolume - 5, 5);
				startVolume = percentage(perVolume, maxVolume);
			}
			else if (msg == "+Volume") {
				perVolume = min(perVolume + 5, 100);
				startVolume = percentage(perVolume, maxVolume);
			}
			else if (msg == "Smoke") toggleSmoke();
			else if (msg == "Sound") toggleSound();
			else if (msg == "Color") endColorDialog(id);
			else if (msg == "Reset") { reset(); startSystem(); }
			else if (msg == extButton) llMessageLinked(LINK_SET, extNumber, msg, id);
			if (msg != "Color" && msg != "Close" && msg != extButton) {
				if (msg != "Smoke" && msg != "Sound" && msg != "Reset") updateSize((float)perSize);
				menuDialog(id);
			}
			else {
				llSetTimerEvent(0); // stop dialog timer
				llSetTimerEvent(burnTime); // restart burn timer
				menuOpen = FALSE;
			}
		}
		else if (channel == startColorChannel) {
			llListenRemove(startColorHandle);
			if (msg == "-Red") perRedStart = max(perRedStart - 10, 0);
			else if (msg == "-Green") perGreenStart = max(perGreenStart - 10, 0);
			else if (msg == "-Blue") perBlueStart = max(perBlueStart - 10, 0);
			else if (msg == "+Red") perRedStart = min(perRedStart + 10, 100);
			else if (msg == "+Green") perGreenStart = min(perGreenStart + 10, 100);
			else if (msg == "+Blue") perBlueStart = min(perBlueStart + 10, 100);
			else if (msg == "R min/max") { if (perRedStart) perRedStart = 0; else perRedStart = 100; }
			else if (msg == "G min/max") { if (perGreenStart) perGreenStart = 0; else perGreenStart = 100; }
			else if (msg == "B min/max") { if (perBlueStart) perBlueStart = 0; else perBlueStart = 100; }
			else if (msg == "Top color") endColorDialog(id);
			else if (msg == "Main menu") menuDialog(id);
			else if (msg == "One color") {
				perRedEnd = perRedStart;
				perGreenEnd = perGreenStart;
				perBlueEnd = perBlueStart;
			}
			if (msg != "Top color" && msg != "Main menu") {
				updateSize((float)perSize);
				startColorDialog(id);
			}
		}
		else if (channel == endColorChannel) {
			llListenRemove(endColorHandle);
			if (msg == "-Red") perRedEnd = max(perRedEnd - 10, 0);
			else if (msg == "-Green") perGreenEnd = max(perGreenEnd - 10, 0);
			else if (msg == "-Blue") perBlueEnd = max(perBlueEnd - 10, 0);
			else if (msg == "+Red") perRedEnd = min(perRedEnd + 10, 100);
			else if (msg == "+Green") perGreenEnd = min(perGreenEnd + 10, 100);
			else if (msg == "+Blue") perBlueEnd = min(perBlueEnd + 10, 100);
			else if (msg == "R min/max") { if (perRedEnd) perRedEnd = 0; else perRedEnd = 100; }
			else if (msg == "G min/max") { if (perGreenEnd) perGreenEnd = 0; else perGreenEnd = 100; }
			else if (msg == "B min/max") { if (perBlueEnd) perBlueEnd = 0; else perBlueEnd = 100; }
			else if (msg == "Bottom color") startColorDialog(id);
			else if (msg == "Main menu") menuDialog(id);
			else if (msg == "One color") {
				perRedStart = perRedEnd;
				perGreenStart = perGreenEnd;
				perBlueStart = perBlueEnd;
			}
			if (msg != "Bottom color" && msg != "Main menu") {
				updateSize((float)perSize);
				endColorDialog(id);
			}
		}
	}

	link_message(integer sender_number, integer number, string msg, key id)
	{
		if (number != msgNumber) return;

		if (loading) {
			llWhisper(0, "Notecard is still loading");
			return;
		}

		if (id) {} else {
			llWhisper(0, "A valid avatar key must be provided in the link message");
			return;
		}

		if (msg == msgSwitch) {
			if (accessGranted(id, switchAccess)) toggleFire();
			else llInstantMessage(id, "[Switch] Access denied");
		}
		else if (msg == msgOn) {
			if (accessGranted(id, switchAccess)) startSystem();
			else llInstantMessage(id, "[Switch] Access denied");
		}
		else if (msg == msgOff) {
			if (accessGranted(id, switchAccess)) stopSystem();
			else llInstantMessage(id, "[Switch] Access denied");
		}
		else if (msg == msgMenu) {
			if (accessGranted(id, menuAccess)) {
				startSystem();
				menuDialog(id);
			}
			else llInstantMessage(id, "[Menu] Access denied");
		}
	}

	dataserver(key req, string data)
	{
		if (data == EOF) {
			if (!burnDown) burnTime = 315360000;   // 10 years
			time = dieTime / 100.0;                // try to get a one percent timer interval
			if (time < 1.0) time = 1.0;            // but never smaller than one second
			decPercent = 100.0 / (dieTime / time); // and burn down decPercent% every time

			defStartColor.x = checkInt("ColorOn (RED)", (integer)defStartColor.x, 0, 100);
			defStartColor.y = checkInt("ColorOn (GREEN)", (integer)defStartColor.y, 0, 100);
			defStartColor.z = checkInt("ColorOn (BLUE)", (integer)defStartColor.z, 0, 100);
			defEndColor.x = checkInt("ColorOff (RED)", (integer)defEndColor.x, 0, 100);
			defEndColor.y = checkInt("ColorOff (GREEN)", (integer)defEndColor.y, 0, 100);
			defEndColor.z = checkInt("ColorOff (BLUE)", (integer)defEndColor.z, 0, 100);

			startIntensity = percentage(defIntensity, maxIntensity);
			startRadius = percentage(defRadius, maxRadius);
			lightFalloff = percentage(defFalloff, maxFalloff);
			startVolume = percentage(defVolume, maxVolume);

			reset(); // initial values for menu
			if (on) startSystem();

			if (verbose) {
				llWhisper(0, "Touch to start/stop fire");
				llWhisper(0, "Long touch to show menu");
				if (sound) llWhisper(0, "Sound in object inventory: Yes");
				else llWhisper(0, "Sound in object inventory: No");
				llWhisper(0, title + " " + version + " ready");
			}
			loading = FALSE;
			llSetText("", ZERO_VECTOR, 0.0);
		}
		else {
			readNotecard(data);
		}
	}

	changed(integer change)
	{
		if (change & CHANGED_INVENTORY) {
			sound = llGetInventoryName(INVENTORY_SOUND, 0); // get first sound from inventory
			texture = llGetInventoryName(INVENTORY_TEXTURE, 0); // get first texture from inventory
			if (sound) llPreloadSound(sound);
			loadNotecard();
		}
	}

	timer()
	{
		if (menuOpen) {
			llListenRemove(menuHandle);
			llListenRemove(startColorHandle);
			llListenRemove(endColorHandle);
			llSetTimerEvent(0); // stop dialog timer
			llSetTimerEvent(burnTime); // restart burn timer
			menuOpen = FALSE;
			return;
		}

		if (burning) {
			llSetTimerEvent(0);
			llSetTimerEvent(time);
			burning = FALSE;
		}

		if (percent >= decPercent) {
			percent -= decPercent;
			updateSize(percent / (100.0 / (float)perSize));
		}
		else {
			if (loop) startSystem();
			else stopSystem();
		}
	}
}
