// :SHOW:1
// :CATEGORY:Animation
// :NAME:Easy Ladder
// :AUTHOR:Pedlar Decosta
// :KEYWORDS:Ladder
// :CREATED:2015-07-15 10:04:12
// :ID:1081
// :NUM:1800
// :REV:2
// :WORLD:Second Life, Opensim
// :DESCRIPTION:
// Easy ladder script
// :CODE:

// Rev 2:  12-18-2015 added region pos for return

///* Climb ladder
//http://community.secondlife.com/t5/Scripting/Ladder-Climb/td-p/256433
//Edited for opensimulator to unsit user at top via offset vector

//BVH: climb-rope

//Fred Beckhusen (Ferd Frederix)z - removed cruft, added offsets and removed ugly hacks.

//*/

//Pedlar Decosta 2020 - edited it to use object description for the ladder height.
//Added support to climb down using a negative number. Adjusted the variables accordingly.
//Added appropriate sit text. For use in a poseball. 1 at the bottom and one at the top. They work indepently from each other.
// Don't forget to reset scripts when you change the ladder height.


float LADDERHEIGHT;    // how far to move up
float STEPHEIGHT = 0.25;    // how far to move each step
float OFFSET = 0;           // tilt of the ladder;
float Extra  = 1;           // extra move onto the roof or in the door before unsit

climbup()
{

	llSetAlpha(0,ALL_SIDES);
	llStopAnimation("sit");
	llStartAnimation(llGetInventoryName(INVENTORY_ANIMATION,0));


	integer i;
	vector original;
	float steps = LADDERHEIGHT / STEPHEIGHT;
	float offset = OFFSET / steps;  // to one side

	original = llGetPos();
	do
	{
		i++;
		vector newPos = llGetPos() + <offset,0, STEPHEIGHT> * llGetRot();
		llSetPos(newPos);
	} while (i <= (steps));

	llSetPos(llGetPos() + <Extra, 0, 0> * llGetRot()); // extra, then unsit

	llStopAnimation(llGetInventoryName(INVENTORY_ANIMATION,0));

	if (llAvatarOnSitTarget() != NULL_KEY)
	{ // somebody is sitting on me
		llUnSit(llAvatarOnSitTarget()); // unsit him or her
	}

	llSetRegionPos(original);
	llSetAlpha(1,ALL_SIDES);
}  // end climbup

default
{

	state_entry() {
		LADDERHEIGHT = (integer)llGetObjectDesc();
		llSetSitText("Climb");
		if(LADDERHEIGHT <=0){ STEPHEIGHT = -0.25;
			Extra  = -1;  llSetSitText("Descend");}
		// if(LADDERHEIGHT <=0){ STEPHEIGHT = -0.25;}
		llSitTarget(<0.0, 0.0, 0.1>, ZERO_ROTATION);
	}

	changed(integer change)
	{
		if(change == CHANGED_LINK)
		{
			key avatar = llAvatarOnSitTarget();

			if(avatar != NULL_KEY)
			{
				llRequestPermissions(avatar,PERMISSION_TRIGGER_ANIMATION);
				climbup();
			}
		}
	} //end changed
} //end default
