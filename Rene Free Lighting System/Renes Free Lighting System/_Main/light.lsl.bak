// :SHOW:1
// :CATEGORY:Light
// :NAME:Rene's Free Lighting System
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting light
// :CREATED:2015-06-11 14:41:42
// :EDITED:2015-06-12  12:30:32
// :ID:1079
// :NUM:1782
// :REV:2.0
// :WORLD:Opensim
// :DESCRIPTION:
// Light Bulb for Menu-controlled lighting system with many features
// :CODE:
// :LICENSE: CC0 (Public Domain)

// Rene's Free Lighting System - Light Bulb
//
// Author: Rene10957 Resident
// Date: 31-05-2015

// License: CC0 (Public Domain).
// To the extent possible under law, Rene10957 has waived all copyright and related or neighboring rights.
// For more information, see http://creativecommons.org/publicdomain/zero/1.0/.

string title = "Light Bulb";        // title
string version = "2.0";             // version
integer linkSet = TRUE;             // LINKSET mode
integer silent = TRUE;              // silent startup

// Constants

integer switchChannel = -10957;     // switch channel
integer particleChannel = -75901;   // particle channel
integer feedbackChannel = -57910;   // feedback channel

// Variables

key owner;                          // object owner
string particleMsg;                 // message for particle plugin (on/off, color, size)

// Functions

string getGroup()
{
	string str = llStringTrim(llGetObjectDesc(), STRING_TRIM);
	if (llToLower(str) == "(no description)" || str == "") str = "Default";
	return str;
}

unpackMessage(string msg)
{
	list msgList = llCSV2List(msg);
	integer lightGroups = (integer)llList2String(msgList, 16);

	if (lightGroups && llToLower(llList2String(msgList, 0)) != llToLower(getGroup())) return;

	integer on = (integer)llList2String(msgList, 1);
	vector color = (vector)llList2String(msgList, 2);
	float intensity = (float)llList2String(msgList, 3);
	float radius = (float)llList2String(msgList, 4);
	float falloff = (float)llList2String(msgList, 5);
	float alpha = (float)llList2String(msgList, 6);
	float glow = (float)llList2String(msgList, 7);
	integer fullbright = (integer)llList2String(msgList, 8);
	vector primColor = (vector)llList2String(msgList, 9);
	vector particleColor = (vector)llList2String(msgList, 10);
	float particleSize = (float)llList2String(msgList, 11);
	float particleInc = (float)llList2String(msgList, 12);
	string particleTexture = llList2String(msgList, 13);
	integer particlesOn = (integer)llList2String(msgList, 14);
	string faces = llList2String(msgList, 15);
	// Placeholder for 16 (see above)

	// Forward 10 (particleColor), 11 (particleSize), 12 (particleInc), 13 (particleTexture) and 14 (particlesOn)
	// to particle script (same prim)

	if (particleMsg == "") particleInc = 999;  // first message after script reset: set particle size to default
	list pList = [particlesOn, particleColor, particleSize, particleInc, particleTexture];
	particleMsg = llList2CSV(pList);  // global variable
	llMessageLinked(LINK_THIS, particleChannel, particleMsg, "");

	// Set light and prim properties

	list faceList = llParseString2List(faces, ["<", ",", " ", ">"], []);
	integer length = llGetListLength(faceList);
	integer face;
	integer i;

	llSetLinkPrimitiveParamsFast(LINK_THIS, [
		PRIM_POINT_LIGHT, on, color, intensity, radius, falloff]);

	for (i = 0; i < length; ++i) {
		face = (integer)llList2String(faceList, i);
		llSetLinkPrimitiveParamsFast(LINK_THIS, [
			PRIM_COLOR, face, primColor, alpha,
			PRIM_GLOW, face, glow,
			PRIM_FULLBRIGHT, face, fullbright]);
	}
}

resetParticleSize(string msg)
{
	list msgList = llCSV2List(msg);
	list pList = llListReplaceList(msgList, [999], 3, 3);
	particleMsg = llList2CSV(pList);  // global variable
	llMessageLinked(LINK_THIS, particleChannel, particleMsg, "");
}

default
{
	state_entry()
	{
		owner = llGetOwner();
		if (linkSet) state sLinkSet;
		else state sRegion;
	}
}

state sLinkSet
{
	state_entry()
	{
		if (!silent) llWhisper(0, title + " " + version + "-LINKSET ready");
	}

	on_rez(integer start_param)
	{
		llResetScript();
	}

	link_message(integer sender_number, integer number, string msg, key id)
	{
		if (number == switchChannel) {
			unpackMessage(msg);
		}
		else if (number == feedbackChannel) {
			if (msg == "READY") {
				llSleep(0.2);  // give new particle script time to reset
				if (particleMsg) resetParticleSize(particleMsg);  // start particles with default size
			}
		}
	}

	changed(integer change)
	{
		if (change & CHANGED_INVENTORY) {
			llParticleSystem([]);  // stop particles in case particle script was removed
			if (particleMsg) llMessageLinked(LINK_THIS, particleChannel, particleMsg, "");  // start particles
		}
	}
}

state sRegion
{
	state_entry()
	{
		llListen(switchChannel, "", "", "");
		if (!silent) llWhisper(0, title + " " + version + "-REGION ready");
	}

	on_rez(integer start_param)
	{
		llResetScript();
	}

	listen(integer channel, string name, key id, string msg)
	{
		if (channel == switchChannel) if (llGetOwnerKey(id) == owner) unpackMessage(msg);
	}
 
	link_message(integer sender_number, integer number, string msg, key id)
	{
		if (number != feedbackChannel) return;

		if (msg == "READY") {
			llSleep(0.2);  // give new particle script time to reset
			if (particleMsg) resetParticleSize(particleMsg);  // start particles with default size
		}
	}

	changed(integer change)
	{
		if (change & CHANGED_INVENTORY) {
			llParticleSystem([]);  // stop particles in case particle script was removed
			if (particleMsg) llMessageLinked(LINK_THIS, particleChannel, particleMsg, "");  // start particles
		}
	}
}
