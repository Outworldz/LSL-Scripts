// :CATEGORY:Vehicle
// :NAME:Tour Airplane
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2014-12-04 12:40:12
// :EDITED:2014-12-04
// :ID:1060
// :NUM:1695
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Camera controller
// :CODE:
release_camera_control()
{
    llSetCameraParams([CAMERA_ACTIVE, 0]); // 1 is active, 0 is inactive  
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
    for (i=0; i< 2*TWO_PI; i+=.05)
    {
        camera_position = llGetPos() + <0.0, 4.0, 0.0> * llEuler2Rot(<0.0, 0.0, i>);
        llSetCameraParams([CAMERA_POSITION, camera_position]);
    }
    focus_on_me();
}



     
focus_on_me()
{
    llOwnerSay("focus_on_me"); // say function name for debugging
    //    llClearCameraParams(); // reset camera to default
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


CameraOut()
{
    llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 2.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.2, // (0 to 3) seconds
        CAMERA_DISTANCE, 20.0, // ( 0.5 to 10) meters
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
    

default
{


    changed(integer change)
    {
        if (change & CHANGED_LINK)
        {          
            key agent = llAvatarOnSitTarget();
         
            if (agent != NULL_KEY)
            {
                llRequestPermissions(agent, PERMISSION_CONTROL_CAMERA);
            }
            else 
            {                           
               release_camera_control();
            }
        }
    }

    run_time_permissions(integer perm)
    {
        if (perm & PERMISSION_CONTROL_CAMERA)
        {
            focus_on_me();
            llSleep(2);
            CameraOut();
        }
    }

    
  

    
   }
