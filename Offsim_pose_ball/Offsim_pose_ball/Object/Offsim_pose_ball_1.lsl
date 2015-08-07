// :CATEGORY:Pose Balls
// :NAME:Offsim_pose_ball
// :AUTHOR:Ferd Frederix
// :CREATED:2012-03-10 23:37:13.950
// :EDITED:2013-09-18 15:38:58
// :ID:581
// :NUM:797
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Offsim_pose_ball
// :CODE:
// off sim sit by Ferd Frederix

// position to sit on the ball e.g <0.0, 0.0, 0.43>
// sit  0.5 meter above the ball
vector POSITION=<0.0, 28, 8>;  // must not be all zeros or the sit will be removed, this moves you 'up' 8 and out 28
vector ROT = <0,0,0>;

// hovertext above ball. "" for none. Add '\n ' at the end to move text up i.e.

string HOVERTEXT="Dance in the Sky";

// Pie Menu Sit Text. If no text
// is entered between "" it won't be used.
string SIT_TEXT="Dance";

string animation;    // a place to store the animation name so we can stop it

default
{
	state_entry()
	{

		if (llStringLength(SIT_TEXT)>0)
			llSetSitText(SIT_TEXT);

		rotation rot     = llEuler2Rot(ROT * DEG_TO_RAD);     // convert the degrees to radians, then convert that vector into a rotation, rot30x


		llSitTarget(POSITION, rot);
	}

	on_rez(integer r)
	{
		llResetScript();
	}


	changed(integer change)
	{
		if (change & CHANGED_LINK)
		{
			if (llAvatarOnSitTarget() != NULL_KEY)
			{
				llRequestPermissions(llAvatarOnSitTarget(), PERMISSION_TRIGGER_ANIMATION);
			}
			else
			{
				integer perm=llGetPermissions();
				if ((perm & PERMISSION_TRIGGER_ANIMATION) && llStringLength(animation)>0)
					llStopAnimation(animation);
				animation="";
			}
		}
	}
	run_time_permissions(integer perm)
	{
		if (perm & PERMISSION_TRIGGER_ANIMATION)
		{
			llStopAnimation("sit");
			animation=llGetInventoryName(INVENTORY_ANIMATION,0);
			llStartAnimation(animation);
		}
	}


}
