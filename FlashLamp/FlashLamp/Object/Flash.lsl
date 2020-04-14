// :SHOW:
// :CATEGORY:Light
// :NAME:Flashing Light
// :AUTHOR:Unknown
// :KEYWORDS:Light
// :REV:1
// :WORLD:Opensim, Second Life
// :DESCRIPTION:
// Blinks a light
// :CODE:


integer root = 0 ; // change to the number of a prim that you want to flash
float timeval = 0.1; //the interval between events, smaller = faster
integer counter = 0;

On() {
	llSetLinkPrimitiveParamsFast(root,[PRIM_POINT_LIGHT, TRUE, <1,1,1>, 1.0, 10, .1, PRIM_FULLBRIGHT, ALL_SIDES,TRUE, PRIM_GLOW, ALL_SIDES, 1.0]);
}
Off() {
	llSetLinkPrimitiveParamsFast(root,[PRIM_POINT_LIGHT, FALSE, <1,1,1>, 1.0, 10, .1, PRIM_FULLBRIGHT, ALL_SIDES,FALSE, PRIM_GLOW, ALL_SIDES, 0.0]);
}
default
{
	state_entry()
	{
		Off();

		llSetTimerEvent(timeval); // between events
	}
	timer()
	{
		if (counter %2 == 0)
			On();
		else
			Off();
		counter++;
	}
}