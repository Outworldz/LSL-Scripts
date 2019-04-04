// :SHOW:
// :CATEGORY:Lights
// :NAME:Flashing Light
// :AUTHOR:Fred Beckhusen
// :KEYWORDS:
// :CREATED:2019-03-21 14:45:15
// :EDITED:2019-03-21  13:45:15
// :ID:1118
// :NUM:1963
// :REV:1.0
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// A rapidly blinking light made from a prim
// :CODE:

integer primnum = 0 ; // change to the number of a prim that you want to flash
integer counter = 0;
Off() {
	llSetLinkPrimitiveParamsFast(0,[PRIM_POINT_LIGHT, TRUE, <1,1,1>, 1.0, 10, .1, PRIM_FULLBRIGHT, ALL_SIDES,1, PRIM_GLOW, ALL_SIDES, 1.0]);
}
On() {
	llSetLinkPrimitiveParamsFast(0,[PRIM_POINT_LIGHT, FALSE, <1,1,1>, 1.0, 10, .1, PRIM_FULLBRIGHT, ALL_SIDES,0, PRIM_GLOW, ALL_SIDES, 0.0]);
}
default
{
	state_entry()
	{
		Off();
	}
	touch_start(integer total_number)
	{
		llSetTimerEvent(.1); // 1/10 a second between events
	}
	timer()
	{
		if (counter == 0)
			On();
		else if (counter == 1)
			Off();
		else if (counter == 2)
			On();
		else if (counter == 2) {
			Off();
			llSetTimerEvent(0);
		}
		counter++;
	}

}
