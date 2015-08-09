// :CATEGORY:Camera
// :NAME:Camera_on_Top
// :AUTHOR:Frost White
// :CREATED:2012-07-08 17:30:46.710
// :EDITED:2013-09-18 15:38:50
// :ID:146
// :NUM:213
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Camera_on_Top
// :CODE:
key id;
default
{
    attach(key id)
    {
        if (id == NULL_KEY)
        {
            if (llGetPermissions() & PERMISSION_CONTROL_CAMERA)llClearCameraParams();
        }
        else
        {
            llRequestPermissions(id, PERMISSION_CONTROL_CAMERA);
            llInstantMessage(id,"Online! Camera will be facing down on you until you start walking.");
        }
    }
    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_CONTROL_CAMERA)
        {
            llSetCameraParams([

            CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
            CAMERA_DISTANCE, 5.0, // ( 0.5 to 10) meters
            CAMERA_PITCH, 10.0, // (-45 to 80) degrees

            CAMERA_BEHINDNESS_ANGLE, 0.0, // (0 to 180) degrees
            CAMERA_BEHINDNESS_LAG, 0.1, // (0 to 3) seconds

            CAMERA_FOCUS_OFFSET, <0.0,0.0,1.5>, // <-10,-10,-10> to <10,10,10> meters

            CAMERA_FOCUS, llGetPos(), // region-relative position
            CAMERA_FOCUS_LAG, 0.1, // (0 to 3) seconds
            CAMERA_FOCUS_THRESHOLD, 0.1, // (0 to 4) meters
            CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)

            CAMERA_POSITION, llGetPos(), // region-relative position
            CAMERA_POSITION_LAG, 0.5, // (0 to 3) seconds
            CAMERA_POSITION_THRESHOLD, 0.5, // (0 to 4) meters
            CAMERA_POSITION_LOCKED, FALSE // (TRUE or FALSE)

            ]);
        }
    }
} 
