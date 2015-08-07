// :CATEGORY:Camera
// :NAME:3_scripts_for_Fun_With_Dynamic_Came
// :AUTHOR:Ariane Brodie
// :KEYWORDS:
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2014-02-15
// :ID:3
// :NUM:5
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Now one of the things I like to do in SL is hang out in clubs and go to parties, and I like to see who is all there and put faces with names. So here is a script to "scan the room" at parties and point the camera directly at the closest 16 people in the room. Just create a prim, put this script in it, and attach it as a HUD. Click to start the room scan, click again to pause. Once it is done scanning, it will return to default.
// :CODE:
//scan the room script by Ariane Brodie



//Dump it in any prim an attach it as a HUD;

//touching once will start a scan of the surrounding areas and 

//point the camera at each person in the room

//touch to pause the scan, touch again to continue.

//when the tour is done, the camera will return to default



key agent;

vector pos; 

vector rotz;

integer permissions;

list whoishere;



default

{

    state_entry()

    {

        agent=llGetOwner();

        llSetText("",<0,0,0>,0);

        whoishere = [];

        llSetCameraParams([CAMERA_ACTIVE, 0]); // 1 is active, 0 is inactive

        llReleaseCamera(agent);

    }



    touch_start(integer total_number)

    {

        state cam_on;

    }

}



state cam_on

{

    state_entry()

    {

        llSensorRepeat("","",AGENT, 90, PI,5);

    }

    

    touch_start(integer total_number)

    {

        llSensorRemove();

        state pause;

    }



    sensor(integer n) 

    { 

        integer i; 

        integer j;

        rotation rot;

        list temp;

        string iSee = "";

        string newpeople = "";

        integer FoundOne = FALSE;

        for(i=0;(i<n && FoundOne == FALSE);i++)

        { 

            if(llDetectedKey(i) != llGetOwner())

            {

                pos = llDetectedPos(i); 

                rot = llDetectedRot(i);

                rotz = llRot2Fwd(rot);

                    rotz.x = rotz.x * 2;

                    rotz.y = rotz.y * 2;

                    rotz.z = 1;

                iSee = llDetectedName(i);

                temp = llParseString2List(iSee,[],[]);

                j = llListFindList(whoishere,temp);

                if (j < 0) {

                    whoishere = llListInsertList(temp,whoishere,0);

                    FoundOne = TRUE;

                }

                else {

                    iSee = "";

                }

            } 

        }

        if(iSee != "") {

            llOwnerSay(iSee);

            llSetText(iSee,<1,1,1>,1.0);

            llRequestPermissions(llGetOwner(), PERMISSION_CONTROL_CAMERA);

        }

        else {

            llOwnerSay("no more found");

            llSetText("",<1,1,1>,1.0);

            state default;

        }

    }

    

    no_sensor()

    {

        llOwnerSay("none found");

        llSetText("",<1,1,1>,1.0);

        state default;

    }

    

    run_time_permissions(integer perm) {

        permissions = perm;

        if ((perm & PERMISSION_CONTROL_CAMERA) == PERMISSION_CONTROL_CAMERA) {

        llSetCameraParams([

        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive

        CAMERA_BEHINDNESS_ANGLE, 0.0, // (0 to 180) degrees

        CAMERA_BEHINDNESS_LAG, 0.0, // (0 to 3) seconds

        CAMERA_DISTANCE, 0.0, // ( 0.5 to 10) meters

        CAMERA_FOCUS, pos, // region relative position

        CAMERA_FOCUS_LAG, 0.0 , // (0 to 3) seconds

        CAMERA_FOCUS_LOCKED, TRUE, // (TRUE or FALSE)

        CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters

//        CAMERA_PITCH, 80.0, // (-45 to 80) degrees

        CAMERA_POSITION, pos + rotz, // region relative position

        CAMERA_POSITION_LAG, 0.0, // (0 to 3) seconds

        CAMERA_POSITION_LOCKED, TRUE, // (TRUE or FALSE)

        CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters

        CAMERA_FOCUS_OFFSET, ZERO_VECTOR // <-10,-10,-10> to <10,10,10> meters



        ]);

        }

    }

}





state pause

{

    touch_start(integer total_number)

    {

        state cam_on;

    }

}
