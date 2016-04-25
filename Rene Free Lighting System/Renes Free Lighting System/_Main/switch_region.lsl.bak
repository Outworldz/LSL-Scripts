// :SHOW:1
// :CATEGORY:Light
// :NAME:Rene's Free Lighting System
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting light
// :CREATED:2015-06-11 14:41:50
// :EDITED:2015-06-12  12:30:32
// :ID:1079
// :NUM:1785
// :REV:2.1
// :WORLD:Opensim
// :DESCRIPTION:
 // Light Switch for region
// :CODE:
// :LICENSE: CC0 (Public Domain)
// Rene's Free Lighting System - Light Switch
//
// Author: Rene10957 Resident
// Date: 31-05-2015

string title = "Light Switch";    // title
string version = "2.1";           // version
integer linkSet = FALSE;          // REGION mode

// Constants

integer _PUBLIC_ = 1;             // public access bit
integer _GROUP_ = 2;              // group access bit
integer _OWNER_ = 4;              // owner access bit
integer _GRPOWN_ = 6;             // group + owner
integer switchChannel = -10957;   // switch channel
float maxRed = 1.0;               // max. red
float maxGreen = 1.0;             // max. green
float maxBlue = 1.0;              // max. blue
float maxRadius = 20.0;           // max. light radius
float maxFalloff = 2.0;           // max. light falloff
float maxGlow = 1.0;              // max. prim glow
float maxAlpha = 1.0;             // max. prim alpha
string configPrefix = "config";   // prefix for configuration notecards
string configSeparator = ":";     // separator between prefix and name
string defNotecard = "Default";   // default notecard

// Notecard variables

integer verbose = FALSE;          // show more/less info during startup
integer switchAccess;             // access level for switch
integer menuAccess;               // access level for menu
integer msgNumber;                // number part of incoming link messages
string msgSwitch;                 // string part of incoming link message: switch (on/off)
string msgOn;                     // string part of incoming link message: switch on
string msgOff;                    // string part of incoming link message: switch off
string msgMenu;                   // string part of incoming link message: show menu
integer percent;                  // increase/decrease percentage for +/- buttons
integer changePrimColor = FALSE;  // TRUE = prim color changes with light color, FALSE = white
integer changeParticleColor = FALSE; // TRUE = particle color changes with light color, FALSE = white
integer particleInc;              // increase/decrease percentage for particle effect (menu)
string particleTexture;           // texture UUID for particle effect
integer particleMenu = FALSE;     // TRUE = "On/Off" replaced by "Particles" (particle menu)
integer notecardMenu = FALSE;     // TRUE = "On/Off" replaced by "Presets" (notecard menu)
string extButton;                 // "On/Off" replaced by button text (sends link message)
integer extNumber;                // number part of outgoing link message
integer lightGroups = FALSE;      // TRUE = use prim description for light groups, FALSE = ignore prim description
string faces;                     // color/glow/fullbright on all faces (ALL_SIDES = -1), one face or CSV list
integer baseIntensity;            // base for light intensity

// Notecard variables: menu defaults

vector defColor;                  // default color (R,G,B)
vector defColorOff;               // default color (R,G,B) when OFF
integer defAlpha;                 // default prim alpha
integer defAlphaOff;              // default prim alpha when OFF
integer defIntensity;             // default light intensity
integer defRadius;                // default light radius
integer defFalloff;               // default light falloff
integer defGlow;                  // default prim glow
integer defFullbright = FALSE;    // default fullbright
integer defParticleSize;          // default particle size

// Variables

key owner;                        // object owner
key user;                         // key of last avatar to touch object
list notecardButtons;             // list of notecards in inventory
string notecard;                  // notecard name
integer line;                     // notecard line
integer loading = FALSE;          // notecard loading
integer menuChannel;              // main menu channel
integer colorChannel;             // color menu channel
integer particleChannel;          // particle menu channel
integer notecardChannel;          // notecard menu channel
integer menuHandle;               // handle for main menu listener
integer colorHandle;              // handle for color menu listener
integer particleHandle;           // handle for particle menu listener
integer notecardHandle;           // handle for notecard menu listener
integer on = FALSE;               // on-off switch
integer particles = TRUE;         // particles on/off
integer perRed;                   // percent red
integer perGreen;                 // percent green
integer perBlue;                  // percent blue
integer perAlpha;                 // percent prim alpha
integer perRedOff;                // percent red when OFF
integer perGreenOff;              // percent green when OFF
integer perBlueOff;               // percent blue when OFF
integer perAlphaOff;              // percent prim alpha when OFF
integer perIntensity;             // percent light intensity
integer perRadius;                // percent light radius
integer perFalloff;               // percent light falloff
integer perGlow;                  // percent prim glow
integer fullbright = TRUE;        // fullbright

// Functions

list orderButtons(list buttons)
{
	return llList2List(buttons, -3, -1) + llList2List(buttons, -6, -4) + llList2List(buttons, -9, -7) +
		llList2List(buttons, -12, -10);
}

discoverNotecards()
{
	llSetText("Discovering notecards...", <1,1,1>, 1.0);

	notecardButtons = [];
	integer i;
	integer pos;
	integer number = llGetInventoryNumber(INVENTORY_NOTECARD);
	string name;
	string prefix;
	string suffix;

	for (i = 0; i < number; ++i) {
		name = llGetInventoryName(INVENTORY_NOTECARD, i);
		pos = llSubStringIndex(name, configSeparator);
		if (pos > -1) {
			prefix = llGetSubString(name, 0, pos - 1);
			suffix = llGetSubString(name, pos + 1, -1);
			if (prefix == configPrefix && suffix != defNotecard && llGetListLength(notecardButtons) < 10)
				notecardButtons += suffix;
		}
	}

	notecardButtons = llListSort(notecardButtons, 1, TRUE);  // sort ascending
	if (llGetInventoryType(configPrefix + configSeparator + defNotecard) == INVENTORY_NOTECARD)
		notecardButtons += defNotecard;

	if (llGetListLength(notecardButtons) > 0) {
		notecardButtons += "Main menu";
		notecardButtons = orderButtons(notecardButtons);  // reverse row order
	}

	llSetText("", ZERO_VECTOR, 0.0);
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

string checkKey(string par, string val)
{
	if ((key)val) return val;
	if (val == "") return val;
	llWhisper(0, "[Notecard] " + par + " out of range (not a valid key)");
	return "";
}

string truncMenuButton(string par, string val)
{
	string trunc = llBase64ToString(llGetSubString(llStringToBase64(val), 0, 31));
	if (val != trunc) llWhisper(0, "[Notecard] " + par + " will be truncated to 24 bytes");
	return trunc;
}

loadNotecard()
{
	verbose = TRUE;
	switchAccess = _PUBLIC_;
	menuAccess = _PUBLIC_;
	msgNumber = 10957;
	msgSwitch = "switch";
	msgOn = "on";
	msgOff = "off";
	msgMenu = "menu";
	percent = 10;
	changePrimColor = TRUE;
	changeParticleColor = TRUE;
	particleTexture = "";
	particleMenu = FALSE;
	notecardMenu = FALSE;
	extButton = "";
	extNumber = 10958;
	lightGroups = FALSE;
	faces = "-1";
	baseIntensity = 100;
	defColor = <100,100,100>;
	defColorOff = <100,100,100>;
	defAlpha = 100;
	defAlphaOff = 100;
	defIntensity = 100;
	defRadius = 50;
	defFalloff = 40;
	defGlow = 0;
	defFullbright = TRUE;
	defParticleSize = 20;
	line = 0;

	if (llGetInventoryType(notecard) == INVENTORY_NOTECARD) {
		loading = TRUE;
		llSetText("Loading notecard...", <1,1,1>, 1.0);
		llGetNotecardLine(notecard, line);
	}
	else {
		reset();
		particleInc = 999;  // reset particle size in plugin script
		sendMessage(getGroup());
		if (verbose) {
			llWhisper(0, "Notecard \"" + notecard + "\" not found or empty, using defaults");
			llWhisper(0, "Touch to turn light on or off");
			llWhisper(0, "Long touch to show menu");
			if (linkSet) llWhisper(0, title + " " + version + "-LINKSET ready");
			else llWhisper(0, title + " " + version + "-REGION ready");
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
		else if (lcpar == "msgswitch") msgSwitch = truncMenuButton(par, val);
		else if (lcpar == "msgon") msgOn = truncMenuButton(par, val);
		else if (lcpar == "msgoff") msgOff = truncMenuButton(par, val);
		else if (lcpar == "msgmenu") msgMenu = truncMenuButton(par, val);
		else if (lcpar == "menupercent") percent = checkInt(par, (integer)val, 1, 100);
		else if (lcpar == "changeprimcolor") changePrimColor = checkYesNo(par, val);
		else if (lcpar == "changeparticlecolor") changeParticleColor = checkYesNo(par, val);
		else if (lcpar == "particletexture") particleTexture = checkKey(par, val);
		else if (lcpar == "particlemenu") particleMenu = checkYesNo(par, val);
		else if (lcpar == "notecardmenu") notecardMenu = checkYesNo(par, val);
		else if (lcpar == "extbutton") extButton = truncMenuButton(par, val);
		else if (lcpar == "extnumber") extNumber = (integer)val;
		else if (lcpar == "lightgroups") lightGroups = checkYesNo(par, val);
		else if (lcpar == "faces") faces = truncMenuButton(par, val);
		else if (lcpar == "baseintensity") baseIntensity = checkInt(par, (integer)val, 1, 100);
		else if (lcpar == "coloron") defColor = checkVector(par, (vector)val);
		else if (lcpar == "coloroff") defColorOff = checkVector(par, (vector)val);
		else if (lcpar == "alphaon") defAlpha = checkInt(par, (integer)val, 0, 100);
		else if (lcpar == "alphaoff") defAlphaOff = checkInt(par, (integer)val, 0, 100);
		else if (lcpar == "intensity") defIntensity = checkInt(par, (integer)val, 0, 100);
		else if (lcpar == "radius") defRadius = checkInt(par, (integer)val, 0, 100);
		else if (lcpar == "falloff") defFalloff = checkInt(par, (integer)val, 0, 100);
		else if (lcpar == "glow") defGlow = checkInt(par, (integer)val, 0, 100);
		else if (lcpar == "fullbright") defFullbright = checkYesNo(par, val);
		else if (lcpar == "particlesize") defParticleSize = checkInt(par, (integer)val, 1, 100);
		else llWhisper(0, "Unknown parameter in notecard line " + (string)(line + 1) + ": " + par);
	}

	line++;
	llGetNotecardLine(notecard, line);
}

menuDialog (key id)
{
	string strOn = "OFF"; if (on) strOn = "ON";
	string strLinkSet = "REGION"; if (linkSet) strLinkSet = "LINKSET";
	string strFullbright = "NO"; if (fullbright) strFullbright = "YES";
	string strButton = "On/Off"; if (particleMenu) strButton = "Particles";
	else if (notecardMenu) strButton = "Presets";
	else if (extButton) strButton = extButton;
	menuChannel = (integer)(llFrand(-1000000000.0) - 1000000000.0);
	llListenRemove(menuHandle);
	menuHandle = llListen(menuChannel, "", "", "");
	llSetTimerEvent(0);
	llSetTimerEvent(300);
	llDialog(id, title + " " + version +
		"\n\nIntensity: " + (string)perIntensity + "%\t\tState: " + strOn +
		"\nRadius: " + (string)perRadius + "%\t\tFullbright: " + strFullbright +
		"\nFalloff: " + (string)perFalloff + "%\t\tMode: " + strLinkSet +
		"\nGlow: " + (string)perGlow + "%\t\tGroup: " + getGroup(), [
		"-Glow",      "+Glow",      strButton,
		"-Falloff",   "+Falloff",   "Reset",
		"-Radius",    "+Radius",    "Fullbright",
		"-Intensity", "+Intensity", "Color" ],
		menuChannel);
}

colorDialog (key id)
{
	colorChannel = (integer)(llFrand(-1000000000.0) - 1000000000.0);
	llListenRemove(colorHandle);
	colorHandle = llListen(colorChannel, "", "", "");
	llSetTimerEvent(0);
	llSetTimerEvent(300);
	if (on) {
		llDialog(id, "Color & Alpha when ON" +
			"\n\nRed: " + (string)perRed + "%" +
			"\nGreen: " + (string)perGreen + "%" +
			"\nBlue: " + (string)perBlue + "%" +
			"\nAlpha: " + (string)perAlpha + "%", [
			"-Alpha", "+Alpha", "Main menu",
			"-Blue",  "+Blue",  "B min/max",
			"-Green", "+Green", "G min/max",
			"-Red",   "+Red",   "R min/max" ],
			colorChannel);
	}
	else {
		llDialog(id, "Color & Alpha when OFF" +
			"\n\nRed: " + (string)perRedOff + "%" +
			"\nGreen: " + (string)perGreenOff + "%" +
			"\nBlue: " + (string)perBlueOff + "%" +
			"\nAlpha: " + (string)perAlphaOff + "%", [
			"-Alpha", "+Alpha", "Main menu",
			"-Blue",  "+Blue",  "B min/max",
			"-Green", "+Green", "G min/max",
			"-Red",   "+Red",   "R min/max" ],
			colorChannel);
	}
}

particleDialog (key id)
{
	string strLightOn = "OFF"; if (on) strLightOn = "ON";
	string strParticlesOn = "OFF"; if (particles) strParticlesOn = "ON";
	particleChannel = (integer)(llFrand(-1000000000.0) - 1000000000.0);
	llListenRemove(particleHandle);
	particleHandle = llListen(particleChannel, "", "", "");
	llSetTimerEvent(0);
	llSetTimerEvent(300);
	llDialog(id, "Particle effect" +
		"\n\nLight: " + strLightOn +
		"\nParticles: " + strParticlesOn, [
		"Min", "Max", "Main menu",
		"-10%", "+10%", "Reset",
		"-5%", "+5%", "Part. on/off",
		"-1%", "+1%", "Light on/off" ],
		particleChannel);
}

notecardDialog (key id)
{
	string name = llGetSubString(notecard, llStringLength(configPrefix) + llStringLength(configSeparator), -1);
	notecardChannel = (integer)(llFrand(-1000000000.0) - 1000000000.0);
	llListenRemove(notecardHandle);
	notecardHandle = llListen(notecardChannel, "", "", "");
	llSetTimerEvent(0);
	llSetTimerEvent(300);
	llDialog(id, "Configuration notecards\n\nLoaded notecard: " + name, notecardButtons, notecardChannel);
}

string getGroup()
{
	if (!lightGroups) return "None";
	string str = llStringTrim(llGetObjectDesc(), STRING_TRIM);
	if (llToLower(str) == "(no description)" || str == "") str = "Default";
	return str;
}

float percentage (integer per, float num)
{
	return num / 100.0 * (float)per;
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
	perRed = (integer)defColor.x;
	perGreen = (integer)defColor.y;
	perBlue = (integer)defColor.z;
	perRedOff = (integer)defColorOff.x;
	perGreenOff = (integer)defColorOff.y;
	perBlueOff = (integer)defColorOff.z;
	perAlpha = defAlpha;
	perAlphaOff = defAlphaOff;
	perIntensity = defIntensity;
	perRadius = defRadius;
	perFalloff = defFalloff;
	perGlow = defGlow;
	fullbright = defFullbright;
}

sendMessage(string group)
{
	vector color;
	vector colorOn;
	vector colorOff;
	float intensity;
	float radius;
	float falloff;
	float alpha;
	float glow;
	integer fullbr;
	vector primColor;
	vector particleColor;
	integer particlesOn;

	colorOn.x = percentage(perRed, maxRed);
	colorOn.y = percentage(perGreen, maxGreen);
	colorOn.z = percentage(perBlue, maxBlue);
	colorOff.x = percentage(perRedOff, maxRed);
	colorOff.y = percentage(perGreenOff, maxGreen);
	colorOff.z = percentage(perBlueOff, maxBlue);

	if (on) {
		color = colorOn;
		intensity = percentage(perIntensity, (float)baseIntensity / 100.0);
		radius = percentage(perRadius, maxRadius);
		falloff = percentage(perFalloff, maxFalloff);
		alpha = percentage(perAlpha, maxAlpha);
		glow = percentage(perGlow, maxGlow);
		fullbr = fullbright;
		if (changePrimColor) primColor = color;
		else primColor = colorOff;
		if (changeParticleColor) particleColor = color;
		else particleColor = colorOff;
		particlesOn = particles;
	}
	else {
		color = colorOff;
		alpha = percentage(perAlphaOff, maxAlpha);
		glow = 0.0;
		fullbr = FALSE;
		primColor = color;
		particlesOn = FALSE;
	}

	list msgList = [group, on, color, intensity, radius, falloff, alpha, glow, fullbr,
		primColor, particleColor, defParticleSize, particleInc, particleTexture, particlesOn,
		"<" + faces + ">", lightGroups];
	string msg = llList2CSV(msgList);
	particleInc = 0;

	if (linkSet) llMessageLinked(LINK_SET, switchChannel, msg, "");
	else llRegionSay(switchChannel, msg);
}

default
{
	state_entry()
	{
		owner = llGetOwner();
		notecard = configPrefix + configSeparator + defNotecard;
		discoverNotecards();
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

		user = llDetectedKey(0);

		if (llGetTime() > 1.0) {
			if (accessGranted(user, menuAccess)) menuDialog(user);
			else llInstantMessage(user, "[Menu] Access denied");
		}
		else {
			if (accessGranted(user, switchAccess)) {
				on = !on;
				sendMessage(getGroup());
			}
			else llInstantMessage(user, "[Switch] Access denied");
		}
	}

	listen(integer channel, string name, key id, string msg)
	{
		llSetTimerEvent(0);

		if (channel == menuChannel) {
			llListenRemove(menuHandle);
			if (msg == "-Intensity") perIntensity = max(perIntensity - percent, 0);
			else if (msg == "-Radius") perRadius = max(perRadius - percent, 0);
			else if (msg == "-Falloff") perFalloff = max(perFalloff - percent, 0);
			else if (msg == "-Glow") perGlow = max(perGlow - percent, 0);
			else if (msg == "+Intensity") perIntensity = min(perIntensity + percent, 100);
			else if (msg == "+Radius") perRadius = min(perRadius + percent, 100);
			else if (msg == "+Falloff") perFalloff = min(perFalloff + percent, 100);
			else if (msg == "+Glow") perGlow = min(perGlow + percent, 100);
			else if (msg == "Color") colorDialog(id);
			else if (msg == "Fullbright") fullbright = !fullbright;
			else if (msg == "Reset") reset();
			else if (msg == "On/Off") on = !on;
			else if (msg == "Particles") particleDialog(id);
			else if (msg == "Presets") {
				if (llGetListLength(notecardButtons) > 0) notecardDialog(id);
				else llWhisper(0, "No configuration notecards found");
			}
			else if (msg == extButton) llMessageLinked(LINK_SET, extNumber, msg, id);
			if (msg != "Color" && msg != "Particles" && msg != "Presets" && msg != extButton) {
				sendMessage(getGroup());
				menuDialog(id);
			}
		}
		else if (channel == colorChannel) {
			llListenRemove(colorHandle);
			if (on) {
				if (msg == "-Red") perRed = max(perRed - percent, 0);
				else if (msg == "-Green") perGreen = max(perGreen - percent, 0);
				else if (msg == "-Blue") perBlue = max(perBlue - percent, 0);
				else if (msg == "-Alpha") perAlpha = max(perAlpha - percent, 0);
				else if (msg == "+Red") perRed = min(perRed + percent, 100);
				else if (msg == "+Green") perGreen = min(perGreen + percent, 100);
				else if (msg == "+Blue") perBlue = min(perBlue + percent, 100);
				else if (msg == "+Alpha") perAlpha = min(perAlpha + percent, 100);
				else if (msg == "R min/max") { if (perRed) perRed = 0; else perRed = 100; }
				else if (msg == "G min/max") { if (perGreen) perGreen = 0; else perGreen = 100; }
				else if (msg == "B min/max") { if (perBlue) perBlue = 0; else perBlue = 100; }
				else if (msg == "Main menu") menuDialog(id);
			}
			else {
				if (msg == "-Red") perRedOff = max(perRedOff - percent, 0);
				else if (msg == "-Green") perGreenOff = max(perGreenOff - percent, 0);
				else if (msg == "-Blue") perBlueOff = max(perBlueOff - percent, 0);
				else if (msg == "-Alpha") perAlphaOff = max(perAlphaOff - percent, 0);
				else if (msg == "+Red") perRedOff = min(perRedOff + percent, 100);
				else if (msg == "+Green") perGreenOff = min(perGreenOff + percent, 100);
				else if (msg == "+Blue") perBlueOff = min(perBlueOff + percent, 100);
				else if (msg == "+Alpha") perAlphaOff = min(perAlphaOff + percent, 100);
				else if (msg == "R min/max") { if (perRedOff) perRedOff = 0; else perRedOff = 100; }
				else if (msg == "G min/max") { if (perGreenOff) perGreenOff = 0; else perGreenOff = 100; }
				else if (msg == "B min/max") { if (perBlueOff) perBlueOff = 0; else perBlueOff = 100; }
				else if (msg == "Main menu") menuDialog(id);
			}
			if (msg != "Main menu") {
				sendMessage(getGroup());
				colorDialog(id);
			}
		}
		else if (channel == particleChannel) {
			llListenRemove(particleHandle);
			if (msg == "-1%") particleInc = -1;
			else if (msg == "+1%") particleInc = 1;
			else if (msg == "-5%") particleInc = -5;
			else if (msg == "+5%") particleInc = 5;
			else if (msg == "-10%") particleInc = -10;
			else if (msg == "+10%") particleInc = 10;
			else if (msg == "Min") particleInc = -100;
			else if (msg == "Max") particleInc = 100;
			else if (msg == "Light on/off") on = !on;
			else if (msg == "Part. on/off") particles = !particles;
			else if (msg == "Reset") particleInc = 999;  // reset particle size
			else if (msg == "Main menu") menuDialog(id);
			if (msg != "Main menu") {
				sendMessage(getGroup());
				particleDialog(id);
			}
		}
		else if (channel == notecardChannel) {
			llListenRemove(notecardHandle);
			if (msg == "Main menu") menuDialog(id);
			else {
				notecard = configPrefix + configSeparator + msg;
				loadNotecard();
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

		if (id) user = id;
		else {
			llWhisper(0, "A valid avatar key must be provided in the link message");
			return;
		}

		if (msg == msgSwitch) {
			if (accessGranted(id, switchAccess)) {
				on = !on;
				sendMessage(getGroup());
			}
			else llInstantMessage(id, "[Switch] Access denied");
		}
		else if (msg == msgOn) {
			if (accessGranted(id, switchAccess)) {
				if (!on) {
					on = TRUE;
					sendMessage(getGroup());
				}
			}
			else llInstantMessage(id, "[Switch] Access denied");
		}
		else if (msg == msgOff) {
			if (accessGranted(id, switchAccess)) {
				if (on) {
					on = FALSE;
					sendMessage(getGroup());
				}
			}
			else llInstantMessage(id, "[Switch] Access denied");
		}
		else if (msg == msgMenu) {
			if (accessGranted(id, menuAccess)) menuDialog(id);
			else llInstantMessage(id, "[Menu] Access denied");
		}
	}

	dataserver(key req, string data)
	{
		if (data == EOF) {
			defColor.x = checkInt("ColorOn (RED)", (integer)defColor.x, 0, 100);
			defColor.y = checkInt("ColorOn (GREEN)", (integer)defColor.y, 0, 100);
			defColor.z = checkInt("ColorOn (BLUE)", (integer)defColor.z, 0, 100);
			defColorOff.x = checkInt("ColorOff (RED)", (integer)defColorOff.x, 0, 100);
			defColorOff.y = checkInt("ColorOff (GREEN)", (integer)defColorOff.y, 0, 100);
			defColorOff.z = checkInt("ColorOff (BLUE)", (integer)defColorOff.z, 0, 100);
			reset();
			particleInc = 999;  // reset particle size in plugin script
			sendMessage(getGroup());
			if (verbose) if (user) {} else {
				llWhisper(0, "Touch to turn light on or off");
				llWhisper(0, "Long touch to show menu");
				if (linkSet) llWhisper(0, title + " " + version + "-LINKSET ready");
				else llWhisper(0, title + " " + version + "-REGION ready");
			}
			loading = FALSE;
			llSetText("", ZERO_VECTOR, 0.0);
			if (user) notecardDialog(user);
		}
		else {
			readNotecard(data);
		}
	}

	changed(integer change)
	{
		if (change & CHANGED_INVENTORY) {
			user = "";
			discoverNotecards();
			loadNotecard();
		}
	}

	timer()
	{
		llSetTimerEvent(0);
		llListenRemove(menuHandle);
		llListenRemove(colorHandle);
		llListenRemove(particleHandle);
		llListenRemove(notecardHandle);
	}
}
