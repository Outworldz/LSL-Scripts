// :CATEGORY:Typing
// :NAME:Typing animation
// :AUTHOR:Fred Beckhusen (Ferd Frederix)    
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:08
// :ID:930
// :NUM:1336
// :REV:1.0
// :WORLD:Second Life, OpenSim
// :DESCRIPTION:
// Makes a typewriter or other gadget appear when you type.// THis goes into 'screen prim' that will eppear when you type.// When you type it makes that prim appear.  
// :CODE:

default
{
	state_entry()
	{
		llOwnerSay((string) llGetScale());
		llSetTextureAnim (ANIM_ON |SMOOTH| LOOP, ALL_SIDES, 0, 0,0, 0 ,.3);
	}


	link_message(integer sender, integer num, string mess, key id){

		if(mess == "Screen on"){
			llSleep(.12);
			llSetAlpha(0.5, ALL_SIDES);
			llSetScale(  <0.40, 0.11088, 0.32>);
		}
		if(mess == "Screen off") {
			llSetScale(<0.01, 0.01, 0.01>);
			llSetAlpha(0.0, ALL_SIDES);
		}
	}
}
