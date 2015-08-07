// :CATEGORY:Camera
// :NAME:3_scripts_for_Fun_With_Dynamic_Came
// :AUTHOR:Ariane Brodie
// :KEYWORDS:
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:46
// :ID:3
// :NUM:3
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// While vehicle scripts are being rewritten to take advantage of dynamic cameras, here is a script that you wear as a HUD that gives you the same effect while driving or flying a vehicle. Just create a prim, put this script in it, and attach it as a HUD. Click blue to enable the camera, click red to return to default camera.
// :CODE:
//Follow Camera by Ariane Brodie



//Dump it in any prim an attach it as a HUD;

//touching once will start a dynamic camera that lags behind

//touching again will go back to default



//This is great for using older vehicles that lock the camera down





key agent;

integer permissions;



default

{

    state_entry()

    {

        agent=llGetOwner();

        llSetText("",<0,0,0>,0);

        llSetCameraParams([CAMERA_ACTIVE, 0]); // 1 is active, 0 is inactive

        llReleaseCamera(agent);

        llSetPrimitiveParams([

            PRIM_TEXTURE, ALL_SIDES, "05e736d6-fc50-cc61-ea97-51993ec47c24",

            <0.4,0.1,0>, <0.2,0.41,0>, 0.0]);

    }



    touch_start(integer total_number)

    {

        state follow_cam;

    }

}



state follow_cam

{

    state_entry()

    {

        llRequestPermissions(llGetOwner(), PERMISSION_CONTROL_CAMERA);

        llSetPrimitiveParams([

            PRIM_TEXTURE, ALL_SIDES, "91a0e647-a69e-f13c-ed93-9bb84d7e790d",

            <0.4,0.1,0>, <0.2,0.41,0>, 0.0]);

    }

    

    touch_start(integer total_number)

    {

        if(permissions&PERMISSION_CONTROL_CAMERA) {

            llSetCameraParams([CAMERA_ACTIVE, FALSE]);

            state default;

        }

    }



    run_time_permissions(integer perm)

    {

        permissions = perm;

        if (PERMISSION_CONTROL_CAMERA) {

            llSetCameraParams([

                CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive

                CAMERA_BEHINDNESS_ANGLE, 2.0, // (0 to 180) degrees

                CAMERA_BEHINDNESS_LAG, 0.2, // (0 to 3) seconds

                CAMERA_DISTANCE, 8.0, // ( 0.5 to 10) meters

                //CAMERA_FOCUS, <0,0,5>, // region relative position

                CAMERA_FOCUS_LAG, 0.02 , // (0 to 3) seconds

                CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)

                CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters

                CAMERA_PITCH, 0.0, // (-45 to 80) degrees

                //CAMERA_POSITION, <0,0,0>, // region relative position

                CAMERA_POSITION_LAG, 0.15, // (0 to 3) seconds

                CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)

                CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters

                CAMERA_FOCUS_OFFSET, <0,0,1> // <-10,-10,-10> to <10,10,10> meters

            ]);

        }

    }

}
