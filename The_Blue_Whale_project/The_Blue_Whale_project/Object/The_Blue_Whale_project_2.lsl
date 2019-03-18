// :CATEGORY:Animal
// :NAME:The_Blue_Whale_project
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2010-05-28 12:46:01.023
// :EDITED:2013-09-18 15:39:07
// :ID:883
// :NUM:1247
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Water spout script to spurt water out of the whales  blowhole.  Pu this in a prim just below the blowhole and aim the Z axis upwards
// :CODE:

updateParticles()
{
	llParticleSystem([

		PSYS_SRC_PATTERN, PSYS_SRC_PATTERN_ANGLE,
		PSYS_SRC_MAX_AGE, 0.,
		PSYS_SRC_BURST_RATE, .3,
		PSYS_SRC_BURST_PART_COUNT, 50,

		PSYS_SRC_BURST_RADIUS, 1,
		PSYS_SRC_BURST_SPEED_MIN, 1.,
		PSYS_SRC_BURST_SPEED_MAX, 5.,
		PSYS_SRC_ACCEL, <0.0,0.0,-1.>,

		PSYS_SRC_ANGLE_BEGIN, PI,
		PSYS_SRC_ANGLE_END, PI,
		PSYS_SRC_OMEGA, <0.,0.0,0.0>,

		PSYS_PART_MAX_AGE, 4.,

		PSYS_PART_START_COLOR, <1,1,1>,
		PSYS_PART_END_COLOR, <1,1,1>,

		PSYS_PART_START_ALPHA, .7,
		PSYS_PART_END_ALPHA, 0.1,

		PSYS_PART_START_SCALE, <.08,.8,0>,
		PSYS_PART_END_SCALE, <.05,.1,0>, PSYS_PART_FLAGS, 0 | PSYS_PART_INTERP_COLOR_MASK | PSYS_PART_INTERP_SCALE_MASK | PSYS_PART_FOLLOW_VELOCITY_MASK  | PSYS_PART_WIND_MASK]);

}

default
{
	state_entry()
	{
		llParticleSystem([]);

	}
	link_message(integer sender, integer num, string str, key id)
	{
		if (str == "on") {
			updateParticles();

		} else if (str == "off") {

				llParticleSystem([]);
		}
	}


}
