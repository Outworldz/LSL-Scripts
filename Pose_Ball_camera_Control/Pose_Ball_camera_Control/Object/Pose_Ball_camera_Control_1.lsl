// :CATEGORY:Camera
// :NAME:Pose_Ball_camera_Control
// :AUTHOR:Ferd Frederix
// :CREATED:2012-03-10 23:41:43.637
// :EDITED:2013-09-18 15:39:00
// :ID:642
// :NUM:872
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Pose_Ball_camera_Control
// :CODE:
//Original idea by Linden Lab's Dan Linden
// Mods by Ferd Frederix

key agent;

integer CHANNEL; // dialog channel
list MENU_MAIN = ["Default", "Overhead Cam", "Spin Cam", "Spaz Cam", "Drop Cam",
	"Worm Cam",  "Top Cam","Cam ON", "Cam OFF"]; // the main menu


integer on = FALSE;

integer spaz = 0;
take_camera_control(key agent)
{
		llRequestPermissions(agent, PERMISSION_CONTROL_CAMERA);
	llSetCameraParams([CAMERA_ACTIVE, 1]); // 1 is active, 0 is inactive
	on = TRUE;
}

release_camera_control(key agent)
{
	
	llSetCameraParams([CAMERA_ACTIVE, 0]); // 1 is active, 0 is inactive
	llReleaseCamera(agent);
	on = FALSE;
}

focus_on_me()
{
		vector here = llGetPos();
	llSetCameraParams([
		CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
		CAMERA_BEHINDNESS_ANGLE, 0.0, // (0 to 180) degrees
		CAMERA_BEHINDNESS_LAG, 0.0, // (0 to 3) seconds
		CAMERA_DISTANCE, 0.0, // ( 0.5 to 10) meters
		CAMERA_FOCUS, here, // region relative position
		CAMERA_FOCUS_LAG, 0.0 , // (0 to 3) seconds
		CAMERA_FOCUS_LOCKED, TRUE, // (TRUE or FALSE)
		CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
		//        CAMERA_PITCH, 80.0, // (-45 to 80) degrees
		CAMERA_POSITION, here + <4.0,4.0,4.0>, // region relative position
		CAMERA_POSITION_LAG, 0.0, // (0 to 3) seconds
		CAMERA_POSITION_LOCKED, TRUE, // (TRUE or FALSE)
		CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
		CAMERA_FOCUS_OFFSET, ZERO_VECTOR // <-10,-10,-10> to <10,10,10> meters
			]);
}

default_cam()
{
	
	llClearCameraParams(); // reset camera to default
	llSetCameraParams([CAMERA_ACTIVE, 1]);
}


driving_cam()
{
	
	default_cam();
	llSetCameraParams([
		CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
		CAMERA_BEHINDNESS_ANGLE, 45.0, // (0 to 180) degrees
		CAMERA_BEHINDNESS_LAG, 0.5, // (0 to 3) seconds
		CAMERA_DISTANCE, 8.0, // ( 0.5 to 10) meters
		//CAMERA_FOCUS, <0.0,0.0,5.0>, // region relative position
		CAMERA_FOCUS_LAG, 0.05 , // (0 to 3) seconds
		CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
		CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
		CAMERA_PITCH, 20.0, // (-45 to 80) degrees
		//CAMERA_POSITION, <0.0,0.0,0.0>, // region relative position
		CAMERA_POSITION_LAG, 0.1, // (0 to 3) seconds
		CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
		CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
		CAMERA_FOCUS_OFFSET, <3.0,0.0,2.0> // <-10,-10,-10> to <10,10,10> meters
			]);
}


side_cam()
{
	
	llClearCameraParams(); // reset camera to default
	llSetCameraParams([
		CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
		CAMERA_BEHINDNESS_ANGLE, 0.0, // (0 to 180) degrees
		CAMERA_BEHINDNESS_LAG, 0.0, // (0 to 3) seconds
		CAMERA_DISTANCE, 0.0, // ( 0.5 to 10) meters
		//CAMERA_FOCUS, <0.0,0.0,5.0>, // region relative position
		CAMERA_FOCUS_LAG, 0.0 , // (0 to 3) seconds
		//        CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
		CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
		//        CAMERA_PITCH, 80.0, // (-45 to 80) degrees
		//CAMERA_POSITION, <0.0,0.0,0.0>, // region relative position
		CAMERA_POSITION_LAG, 0.0, // (0 to 3) seconds
		//        CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
		CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
		CAMERA_FOCUS_OFFSET, <0.0,6.0,0.0> // <-10,-10,-10> to <10,10,10> meters
			]);
}

rearview_cam()
{
	
	llSetCameraParams([
		CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
		CAMERA_BEHINDNESS_ANGLE, 180.0, // (0 to 180) degrees
		CAMERA_BEHINDNESS_LAG, 0.0, // (0 to 3) seconds
		//        CAMERA_DISTANCE, 10.0, // ( 0.5 to 10) meters
		//CAMERA_FOCUS, <0.0,0.0,5.0>, // region relative position
		CAMERA_FOCUS_LAG, 3.0 , // (0 to 3) seconds
		//        CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
		CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
		//        CAMERA_PITCH, 80.0, // (-45 to 80) degrees
		//CAMERA_POSITION, <0.0,0.0,0.0>, // region relative position
		//        CAMERA_POSITION_LAG, 0.0, // (0 to 3) seconds
		//        CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
		CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
		CAMERA_FOCUS_OFFSET, <5.0,2.0,-2.0> // <-10,-10,-10> to <10,10,10> meters
			]);
}

overhead_cam()
{
	
	default_cam();
	llSetCameraParams([
		CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
		CAMERA_BEHINDNESS_ANGLE, 180.0, // (0 to 180) degrees
		CAMERA_BEHINDNESS_LAG, 0.5, // (0 to 3) seconds
		CAMERA_DISTANCE, 10.0, // ( 0.5 to 10) meters
		//CAMERA_FOCUS, <0.0,0.0,5.0>, // region relative position
		CAMERA_FOCUS_LAG, 0.05 , // (0 to 3) seconds
		CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
		CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
		CAMERA_PITCH, 80.0, // (-45 to 80) degrees
		//CAMERA_POSITION, <0.0,0.0,0.0>, // region relative position
		CAMERA_POSITION_LAG, 0.0, // (0 to 3) seconds
		CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
		CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
		CAMERA_FOCUS_OFFSET, <0.0,0.0,0.0> // <-10,-10,-10> to <10,10,10> meters
			]);
}

drop_camera_5_seconds()
{

	llSetCameraParams([
		CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
		CAMERA_BEHINDNESS_ANGLE, 0.0, // (0 to 180) degrees
		CAMERA_BEHINDNESS_LAG, 0.5, // (0 to 3) seconds
		CAMERA_DISTANCE, 3.0, // ( 0.5 to 10) meters
		//CAMERA_FOCUS, <0.0,0.0,5.0>, // region relative position
		CAMERA_FOCUS_LAG, 2.0, // (0 to 3) seconds
		CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
		CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
		CAMERA_PITCH, 0.0, // (-45 to 80) degrees
		//CAMERA_POSITION, <0.0,0.0,0.0>, // region relative position
		CAMERA_POSITION_LAG, 0.05, // (0 to 3) seconds
		CAMERA_POSITION_LOCKED, TRUE, // (TRUE or FALSE)
		CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
		CAMERA_FOCUS_OFFSET, <0.0,0.0,0.0> // <-10,-10,-10> to <10,10,10> meters
			]);

}



worm_cam()
{
	
	llSetCameraParams([
		CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
		CAMERA_BEHINDNESS_ANGLE, 180.0, // (0 to 180) degrees
		CAMERA_BEHINDNESS_LAG, 0.0, // (0 to 3) seconds
		CAMERA_DISTANCE, 8.0, // ( 0.5 to 10) meters
		//CAMERA_FOCUS, <0.0,0.0,5.0>, // region relative position
		CAMERA_FOCUS_LAG, 0.0 , // (0 to 3) seconds
		CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
		CAMERA_FOCUS_THRESHOLD, 4.0, // (0 to 4) meters
		CAMERA_PITCH, -45.0, // (-45 to 80) degrees
		//CAMERA_POSITION, <0.0,0.0,0.0>, // region relative position
		CAMERA_POSITION_LAG, 1.0, // (0 to 3) seconds
		CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
		CAMERA_POSITION_THRESHOLD, 1.0, // (0 to 4) meters
		CAMERA_FOCUS_OFFSET, <0.0,0.0,0.0> // <-10,-10,-10> to <10,10,10> meters
			]);
}

spaz_cam()
{
	float i;
	for (i=0; i< 50; i+=1)
	{
		vector xyz = llGetPos() + <llFrand(80.0) - 40, llFrand(80.0) - 40, llFrand(10.0)>;
		//        llOwnerSay((string)xyz);
		vector xyz2 = llGetPos() + <llFrand(80.0) - 40, llFrand(80.0) - 40, llFrand(10.0)>;
		llSetCameraParams([
			CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
			CAMERA_BEHINDNESS_ANGLE, 180.0, // (0 to 180) degrees
			CAMERA_BEHINDNESS_LAG, llFrand(3.0), // (0 to 3) seconds
			CAMERA_DISTANCE, llFrand(10.0), // ( 0.5 to 10) meters
			//CAMERA_FOCUS, xyz, // region relative position
			CAMERA_FOCUS_LAG, llFrand(3.0), // (0 to 3) seconds
			CAMERA_FOCUS_LOCKED, TRUE, // (TRUE or FALSE)
			CAMERA_FOCUS_THRESHOLD, llFrand(4.0), // (0 to 4) meters
			CAMERA_PITCH, llFrand(125.0) - 45, // (-45 to 80) degrees
			CAMERA_POSITION, xyz2, // region relative position
			CAMERA_POSITION_LAG, llFrand(3.0), // (0 to 3) seconds
			CAMERA_POSITION_LOCKED, TRUE, // (TRUE or FALSE)
			CAMERA_POSITION_THRESHOLD, llFrand(4.0), // (0 to 4) meters
			CAMERA_FOCUS_OFFSET, <llFrand(20.0) - 10, llFrand(20.0) - 10, llFrand(20) - 10> // <-10,-10,-10> to <10,10,10> meters
				]);
		llSleep(0.2);
	}
	default_cam();
}

spin_cam()
{
	llSetCameraParams([
		CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
		CAMERA_BEHINDNESS_ANGLE, 180.0, // (0 to 180) degrees
		CAMERA_BEHINDNESS_LAG, 0.5, // (0 to 3) seconds
		//CAMERA_DISTANCE, 10.0, // ( 0.5 to 10) meters
		//CAMERA_FOCUS, <0.0,0.0,5.0>, // region relative position
		CAMERA_FOCUS_LAG, 0.05 , // (0 to 3) seconds
		CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
		CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
		CAMERA_PITCH, 30.0, // (-45 to 80) degrees
		//CAMERA_POSITION, <0.0,0.0,0.0>, // region relative position
		CAMERA_POSITION_LAG, 0.0, // (0 to 3) seconds
		CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
		CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
		CAMERA_FOCUS_OFFSET, <0.0,0.0,0.0> // <-10,-10,-10> to <10,10,10> meters
			]);

	float i;
	vector camera_position;
	for (i=0; i< 6*TWO_PI; i+=.05)
	{
		camera_position = llGetPos() + <0.0, 6.0, 0.0> * llEuler2Rot(<0.0, 0.0, i>);
		llSetCameraParams([CAMERA_POSITION, camera_position]);
	}
	default_cam();
}

setup_listen()
{
	llListenRemove(1);
	CHANNEL = llRound(llFrand(1) * 100000);
	integer x = llListen(CHANNEL, "", "", ""); // listen for dialog answers
}

default
{
	state_entry()
	{
		setup_listen();
	}

	listen(integer channel, string name, key id, string message)
	{
		if (~llListFindList(MENU_MAIN, [message]))  // verify dialog choice
		{
			if (message == "Cam ON")
			{
				take_camera_control(id);
			}

			else if (message == "Cam OFF")
			{
				release_camera_control(id);
			}

			else if (message == "Default")
			{
				default_cam();
			}

			else if (message == "Top Cam")
			{
				driving_cam();
			}

			else if (message == "Worm Cam")
			{
				worm_cam();
			}

			else if (message == "Overhead Cam")
			{
				overhead_cam();
			}

			else if (message == "Spaz Cam")
			{
				spaz_cam();
			}

			else if (message == "Side Cam")
			{
				side_cam();
			}

			else if (message == "Drop Cam")
			{
				drop_camera_5_seconds();
			}

			else if (message == "Spin Cam")
			{
				spin_cam();
			}

		} 

		llDialog(agent, "What do you want to do?", MENU_MAIN, CHANNEL); // present dialog on click

	}

	run_time_permissions(integer perm) {
		if (perm & PERMISSION_CONTROL_CAMERA) {
			llSetCameraParams([CAMERA_ACTIVE, 1]); // 1 is active, 0 is inactive
			//llOwnerSay("Camera permissions have been taken");
		}
	}

	changed(integer change)
	{
		if (change & CHANGED_LINK)
		{
			agent = llAvatarOnSitTarget();

			if (agent)
			{

				setup_listen();
				llDialog(agent, "What do you want to do?", MENU_MAIN, CHANNEL); // present dialog on click
				llRequestPermissions(agent, PERMISSION_CONTROL_CAMERA);
			}
		}
	}

	attach(key agent)
	{
		if (agent)
		{
			setup_listen();
			llRequestPermissions(agent, PERMISSION_CONTROL_CAMERA);
		}
	}


}
