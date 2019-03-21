// :CATEGORY:Tour
// :NAME:swan tour guide
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:05
// :ID:854
// :NUM:1189
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tour
// :CODE:

float on = 0.0;
float off = 1.0;
list params_on ;
list params_off ;
list params_up ;
list params_out ;

float ona = 0.0;
float offa = 1.0;

integer softness = 2;
float gravity = 2;
float friction =3.0;
float wind = 0.0;
float tension = 1.5;
vector force =<0,0,0>;
default
{
	state_entry()
	{
		params_on = [ PRIM_FLEXIBLE, TRUE, softness, -2, friction, wind, tension, force];
		params_off = [ PRIM_FLEXIBLE, TRUE, softness, -gravity, friction, wind, tension,  force];
		params_up = [ PRIM_FLEXIBLE, TRUE, softness, 3, friction, wind, tension,  force];
		params_out = [ PRIM_FLEXIBLE, TRUE, softness, 0, friction, wind, tension,  force];

		llSetPrimitiveParams(params_out);
		llSetAlpha(offa,ALL_SIDES);
	}


	link_message(integer sender_num, integer num, string msg , key id)
	{
		if (num == 0 && msg == "FLY")
		{
			llSetPrimitiveParams(params_off);
		}
		else if (num == 0 && msg == "SIT")
		{
			llSetPrimitiveParams(params_on);
		}
		else if (num == 0 && msg == "FLAP")
		{
			llSetPrimitiveParams(params_up);
			llSleep(1.0);
			llSetPrimitiveParams(params_on);
		}
	}

	on_rez(integer param)
	{
		llResetScript();
	}
}

