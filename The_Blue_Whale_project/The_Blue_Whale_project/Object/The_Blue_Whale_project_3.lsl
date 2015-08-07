// :CATEGORY:Animal
// :NAME:The_Blue_Whale_project
// :AUTHOR:Ferd Frederix
// :CREATED:2010-05-28 12:46:01.023
// :EDITED:2013-09-18 15:39:07
// :ID:883
// :NUM:1248
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Pose ball with camera animation script.  Put this in a round pose ball above the whale.  You also need to drop an animation inside the object. This is preset for 'rooftop crouch'.
// :CODE:
// pose ball script
// position to sit on the ball e.g <0.0, 0.0, 0.1>
// sit  0.1 meter above the ball.
// NOTE: if all these are 0, then the sit location is removed

// position to sit on the ball e.g <0.0, 0.0, 0.43>
// sit  0.5 meter above the ball
vector POSITION=<0.0, 0.0, 0.1>;

// hovertext above ball. "" for none.
// add '\n ' at the end to move text up i.e.
// string HOVERTEXT="Sit Here\n ";
string HOVERTEXT="";

// Pie Menu Sit Text. Will only work for the
// main prim but included it anyway. If no text
// is entered between "" it won't be used.
string SIT_TEXT="";





list rgb;
string animation;
integer listener;
default
{
	state_entry()
	{

		if (llStringLength(SIT_TEXT)>0)
			llSetSitText(SIT_TEXT);
		llSitTarget(POSITION, ZERO_ROTATION);


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
				llRequestPermissions(llAvatarOnSitTarget(), PERMISSION_CONTROL_CAMERA|PERMISSION_TRIGGER_ANIMATION);
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

		if ( perm & PERMISSION_CONTROL_CAMERA )
		{
			llClearCameraParams(); // reset camera to default
			llSetCameraParams([
				CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
				CAMERA_BEHINDNESS_ANGLE, 15.0, // (0 to 180) degrees
				CAMERA_BEHINDNESS_LAG, 1.0, // (0 to 3) seconds
				CAMERA_DISTANCE, 10.0, // ( 0.5 to 10) meters
				CAMERA_FOCUS_LAG, 0.05 , // (0 to 3) seconds
				CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
				CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
				CAMERA_PITCH, 10.0, // (-45 to 80) degrees
				CAMERA_POSITION_LAG, 0.0, // (0 to 3) seconds
				CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
				CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
				CAMERA_FOCUS_OFFSET, <-2.0, 0.0, -3.0> // <-10,-10,-10> to <10,10,10> meters
					]);




		}
	}


}
