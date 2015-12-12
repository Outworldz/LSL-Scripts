// :SHOW:1
// :CATEGORY:Light
// :NAME:Rene's Free Lighting System
// :AUTHOR:Rene10957 Resident
// :KEYWORDS: light,lamp,lighting light
// :CREATED:2015-06-11 14:42:00
// :EDITED:2015-06-12  16:41:14
// :ID:1079
// :NUM:1793
// :REV:1.4
// :WORLD:Opensim
// :DESCRIPTION:
// - Particle Plugin "Candle flame sensual"
// :CODE:
// :LICENSE: CC0 (Public Domain)
// Rene's Free Lighting System - Particle Plugin "Candle flame sensual"
//
// Author: Rene10957 Resident
// Date: 21-03-2014

////////////////////////////////////////////////////////////////////////////////
// HOW TO USE: drop this script into the same prim where the LIGHT is located //
////////////////////////////////////////////////////////////////////////////////

string title = "Particle Plugin";        // title
string name = "Candle flame sensual";    // name
string version = "1.4";                  // version
integer silent = TRUE;                   // silent startup

// Constants

// Note: the official upper limit for particles is 4.0 meters but for more delicate particle effects
// it can be useful to set maxScale to a lower value, in order to achieve more fine-grained control.

integer particleChannel = -75901;        // particle channel
integer feedbackChannel = -57910;        // feedback channel
float minScale = 0.03125;                // min. startScale or endScale
float maxScale = 0.4;                    // max. startScale or endScale

// Particle parameters

// Note: startScale and endScale are not actual sizes, but more like aspect ratios.
// The real size is determined by particleSize in the notecard, a percentage of maxScale.

float age = 1.0;                         // particle lifetime
float rate = 0.01;                       // particle burst rate
integer count = 1;                       // particle count
vector startScale = <0.05, 0.1, 0.0>;    // particle start size
vector endScale = <0.0, 0.0, 0.0>;       // particle end size
float minSpeed = 0.1;                    // particle min. burst speed
float maxSpeed = 0.1;                    // particle max. burst speed
float burstRadius = 0.0;                 // particle burst radius
vector partAccel = <0.0, 0.0, 0.0>;      // particle accelleration

// Variables

float particleSize;                      // particle size (percentage)
float defParticleSize;                   // default particle size (percentage)
float minParticleSize;                   // minimum particle size (percentage)

// Functions

startParticles(vector color, vector start, vector end, float min, float max, float radius, vector push, string txtr)
{
	llParticleSystem([
		PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE_CONE,
		PSYS_PART_START_COLOR, color,
		PSYS_PART_END_COLOR, <1.0, 0.25, 0.0>,
		PSYS_PART_START_ALPHA, 0.5,
		PSYS_PART_END_ALPHA, 0.0,
		PSYS_PART_START_SCALE, start,
		PSYS_PART_END_SCALE, end,
		PSYS_PART_MAX_AGE, age,
		PSYS_SRC_BURST_RATE, rate,
		PSYS_SRC_BURST_PART_COUNT, count,
		PSYS_SRC_BURST_SPEED_MIN, min,
		PSYS_SRC_BURST_SPEED_MAX, max,
		PSYS_SRC_BURST_RADIUS, radius,
		PSYS_SRC_ACCEL, push,
		PSYS_SRC_OMEGA, <0.02, 0.02, 0.4>,
		PSYS_SRC_TEXTURE, txtr,
		PSYS_PART_FLAGS,
		0 |
		PSYS_PART_EMISSIVE_MASK |
		PSYS_PART_FOLLOW_SRC_MASK |
		PSYS_PART_FOLLOW_VELOCITY_MASK |
		PSYS_PART_INTERP_COLOR_MASK |
		PSYS_PART_INTERP_SCALE_MASK ]);
}

/////////////////////////////////////////////////////////////////
// From this point onwards, every particle script is identical //
/////////////////////////////////////////////////////////////////

// Particle size = largest dimension across both scale vectors

float getParticleSize (vector start, vector end)
{
	float max = 0.0;
	if (start.x > max) max = start.x;
	if (start.y > max) max = start.y;
	if (end.x > max) max = end.x;
	if (end.y > max) max = end.y;
	return max / (maxScale / 100.0);
}

// Particle size is too small if both start.x and end.x < minScale (0.03125), or...
// both start.y and end.y < minScale (0.03125)

float getMinSize (vector start, vector end, float size)
{
	float maxX = 0.0;
	float maxY = 0.0;
	float minXY = 0.0;

	if (start.x < minScale && end.x < minScale) {
		if (start.x > end.x) maxX = start.x;
		else maxX = end.x;
	}

	if (start.y < minScale && end.y < minScale) {
		if (start.y > end.y) maxY = start.y;
		else maxY = end.y;
	}

	if (maxX == 0.0 && maxY == 0.0) return size;

	if (maxX == 0.0) minXY = maxY;
	else if (maxY == 0.0) minXY = maxX;
	else if (maxX < maxY) minXY = maxX;
	else minXY = maxY;

	return (float)llCeil((minScale / minXY) * size);
}

unpackMessage(string msg)
{
	list msgList = llCSV2List(msg);

	integer on = (integer)llList2String(msgList, 0);                       // particles on/off
	vector color = (vector)llList2String(msgList, 1);                      // particle color
	float size = (float)llList2String(msgList, 2);                         // particle size (%) from notecard
	float inc = (float)llList2String(msgList, 3);                          // particle increase/decrease (%) from menu
	string texture = llList2String(msgList, 4);                            // particle texture from notecard

	if (inc == 999) particleSize = size;                                   // reset particle size
	else particleSize += inc;                                              // increase/decrease particle size
	if (particleSize < 1) particleSize = 1;                                // correct if size < 1%
	else if (particleSize > 100) particleSize = 100;                       // correct if size > 100%
	if (particleSize < minParticleSize) particleSize = minParticleSize;    // correct undersized particles

	if (on) {
		vector start = startScale / defParticleSize * particleSize;        // start scale
		vector end = endScale / defParticleSize * particleSize;            // end scale
		float min = minSpeed / defParticleSize * particleSize;             // equally resize min. burst speed
		float max = maxSpeed / defParticleSize * particleSize;             // equally resize max. burst speed
		float radius = burstRadius / defParticleSize * particleSize;       // equally resize burst radius
		vector push = partAccel / defParticleSize * particleSize;          // equally resize accelleration
		startParticles(color, start, end, min, max, radius, push, texture);
	}
	else {
		llParticleSystem([]);
	}
}

default
{
	state_entry()
	{
		defParticleSize = getParticleSize(startScale, endScale);   // default particle size (percentage)
		vector start = startScale / defParticleSize;               // start scale = 1%
		vector end = endScale / defParticleSize;                   // end scale = 1%
		minParticleSize = getMinSize(start, end, 1.0);             // minimum particle size (percentage)
		if (!silent) llWhisper(0, title + " \"" + name + "\" " + version + " ready");
		llMessageLinked(LINK_THIS, feedbackChannel, "READY", "");  // request particle info from light script
	}

	on_rez(integer start_param)
	{
		llResetScript();
	}

	link_message(integer sender_number, integer number, string msg, key id)
	{
		if (number == particleChannel) unpackMessage(msg);
	}
}
