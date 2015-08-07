// :CATEGORY:Tour
// :NAME:swan tour guide
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:05
// :ID:854
// :NUM:1185
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tour
// :CODE:

// Poseball script for both pose balls
// Author: Ferd Frederix


vector TARGET = <-.5,0,-0.1>;		// 1/2 meter up, back a tenth.
vector ROT = <0, -90, 0>;	//rotated 90 degrees

default
{
	state_entry()
	{
		llSetAlpha(1.0,ALL_SIDES);
		llSetCameraEyeOffset(<-3, 0, -5> );	// move camera back
		llSetCameraAtOffset(<-2, 0, 1>);

		rotation rot     = llEuler2Rot(ROT * DEG_TO_RAD);     // convert the degrees to radians, then convert that vector into a rotation, rot30x
		llSitTarget(TARGET, rot); // where they sit
	}

	changed(integer change)
	{
		if (change & CHANGED_LINK)
		{
			key av = llAvatarOnSitTarget();
			if (av) //evaluated as true if not NULL_KEY or invalid
			{
				llRequestPermissions(av, PERMISSION_TRIGGER_ANIMATION);
			}
			else
			{
				llSetAlpha(1.0,ALL_SIDES);	// make visible when they stand
			}
		}
	}

	run_time_permissions(integer perm)
	{
		if(PERMISSION_TRIGGER_ANIMATION & perm)
		{
			llStopAnimation("sit");
			llStartAnimation("sit");	// you can choose a different animation for sitting
			llSetAlpha(0.0,ALL_SIDES);
			llMessageLinked(LINK_SET,0,"sit","");	// tell the main script we are ready.
		}
	}
	on_rez(integer p)
	{
		llResetScript();
	}
}

