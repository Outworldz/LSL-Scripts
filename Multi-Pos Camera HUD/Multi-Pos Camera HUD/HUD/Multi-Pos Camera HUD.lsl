// :SHOW:
// :CATEGORY:Camera
// :NAME:Multi-Pos Camera HUD
// :AUTHOR:albertlr Landar
// :KEYWORDS:
// :CREATED:2015-05-29 12:26:02
// :EDITED:2015-05-29  11:26:02
// :ID:1077
// :NUM:1751
// :REV:1
// :WORLD:Opensim
// :DESCRIPTION:
// Menu-drive Camera HUD with multiple positions
// :CODE:
//:LICENSE: CC-BY-SA
// 
// Rev 1.1 05/14/2015 Pathches to make this actually work by Ferd Frederix - 'agent' was incorrectly used.
// Originally from http://forums.osgrid.org/viewtopic.php?f=5&t=3655

// Well here is the camera hud I promised. It is based on one that was originally released by Dan
// Linden a while back. I have modified it and added some new camera views to it. I have also made
// sure that the listener turns off after 20 seconds to prevent any lag. I have the full hud available
//  again at my Freebie Warehouse on austeria9 and it will be in the Wright Plaza Freebie Building.
// I also included a modified version of my Lock Hud, however it does not have the toggle option as
//  that got a little too complicated to implement with the other settings. But it does have an Unlock.
// I have the hud using the center placement, but you can place it anywhere on your desktop. 
//
// Instructions:
// Insert this script in a small prim. Attach the prim to any convenient HUD position. Click on Cam On to use.
// Click on yes to grant permissions - if you click on no you will not be able to run any of the cam settings.
// You can turn the cam hud off by clicking Cam Off. There is a 20 second timer which will turn the listener
// off to prevent lag.

// Choose one of the Cam Buttons. Sometimes you will need to touch an arrow key in order
// for the camera to change settings. If you choose the Lock Cam button the hud will turn red to indicate
//  this selection. You can then go to other settings however it is best to click Unlock Cam to turn it off,
//  and return the hud to Blue. The Focus On Me Cam will give you an overhead view of your avatar, good
// for use in a crowded area such as a club. Click on the same Focus On Me Button to release this view.
// The Hip Cam is good for tunnels, or low ceiling areas and can be used for Tiny Avatars. The Large Avatar
//  Cam is for a large Avatar point of view, this is normally done with an animation which will raise your
//  avatar about 5 meters in the air. The other buttons should be self explainatory. Please feel free to
//  make adjustments or additions to your own preferences. But if you come up with new and better
// setting please share with everyone.


// SOURCE
// Camera Hud OS.lsl
// Put this script in a prim and attach the prim as HUD. Click the HUD and select your camera position in the dialog menu

// Originally created by Linden Labs Dan Linden
//Modified and Enhanced by albertlr Landar for OSGRID
// This program is free software; you can redistribute it and/or modify it.
// License information must be included in any script you give out or use.
// This script is licensed under the Creative Commons Attribution-Share Alike 3.0
// License from http://creativecommons.org/licenses/by-sa/3.0 unless licenses are
// included in the script or comments by the original author,in which case
// the authors license must be followed.

// Please leave any authors credits intact in any script you use or publish.
///////////////////////////////////////////////////////////////////////////////

vector CamPos;
rotation CamRot;
vector CamFoc;
integer CHANNEL; // dialog channel
float Timeout=60.0;

//**********************
list MENU_MAIN = ["Default", "Overhead Cam", "Focus On Me", "Hip Cam", "Drop Cam 5", "5M Large Av", "Driving Cam", "LOCK Cam", "UNLOCK Cam", "Cam ON", "Cam OFF", "More..."]; // the main menu
//**********************
list MENU_2 = ["Cr Shoulder", "L Shoulder", "R Shoulder", "L Side Cam", "R Side Cam", "Spaz Cam", "Spin Cam", "Worm Cam", "...Back"]; // menu 2

integer spaz = 0;
integer trap = 0;
integer handle;


release_camera_control()
{
    llSetCameraParams([CAMERA_ACTIVE, 0]); // 1 is active, 0 is inactive
    llClearCameraParams();
}

focus_on_me()
{
    //llOwnerSay("focus_on_me"); // say function name for debugging
    llClearCameraParams(); // reset camera to default
    vector here = llGetPos();
    llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 180.0, // (0 to 180) degrees
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
    //  llOwnerSay("default_cam"); // say function name for debugging
    llClearCameraParams(); // reset camera to default
    llSetCameraParams([CAMERA_ACTIVE, 1]);
}

driving_cam()
{
    //  llOwnerSay("driving_cam"); // say function name for debugging
    default_cam();
    llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 90.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.5, // (0 to 3) seconds
        CAMERA_DISTANCE, 8.0, // ( 0.5 to 10) meters
        //CAMERA_FOCUS, <0,0,5>, // region relative position
        CAMERA_FOCUS_LAG, 0.05 , // (0 to 3) seconds
        CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_PITCH, 20.0, // (-45 to 80) degrees
        //CAMERA_POSITION, <0,0,0>, // region relative position
        CAMERA_POSITION_LAG, 0.1, // (0 to 3) seconds
        CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, <3,0,2> // <-10,-10,-10> to <10,10,10> meters
            ]);
}

large()
{
    //  llOwnerSay("Large Av Cam"); // say function name for debugging
    default_cam();
    llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 90.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.5, // (0 to 3) seconds
        CAMERA_DISTANCE, 8.0, // ( 0.5 to 10) meters
        //CAMERA_FOCUS, <0,0,5>, // region relative position
        CAMERA_FOCUS_LAG, 0.05 , // (0 to 3) seconds
        CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_PITCH, 20.0, // (-45 to 80) degrees
        //CAMERA_POSITION, <0,0,0>, // region relative position
        CAMERA_POSITION_LAG, 0.1, // (0 to 3) seconds
        CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, <3,0,5> // <-10,-10,-10> to <10,10,10> meters
            ]);
}

r_shoulder_cam()
{
    //  llOwnerSay("right cam"); // say function name for debugging
    default_cam();
    llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 5.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.5, // (0 to 3) seconds
        CAMERA_DISTANCE, 0.5, // ( 0.5 to 10) meters
        //CAMERA_FOCUS, <0,0,5>, // region relative position
        CAMERA_FOCUS_LAG, 0.01 , // (0 to 3) seconds
        CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_PITCH, 15.0, // (-45 to 80) degrees
        CAMERA_POSITION, <0.0,0.0,0.0>, // region relative position
        CAMERA_POSITION_LAG, 0.1, // (0 to 3) seconds
        CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, <-0.5,-0.5,1.0> // <-10,-10,-10> to <10,10,10> meters
            ]);
}

l_shoulder_cam()
{
    //  llOwnerSay("left cam"); // say function name for debugging
    default_cam();
    llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 5.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.5, // (0 to 3) seconds
        CAMERA_DISTANCE, 0.5, // ( 0.5 to 10) meters
        //CAMERA_FOCUS, <0,0,5>, // region relative position
        CAMERA_FOCUS_LAG, 0.01 , // (0 to 3) seconds
        CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_PITCH, 15.0, // (-45 to 80) degrees
        CAMERA_POSITION, <0.0,0.0,0.0>, // region relative position
        CAMERA_POSITION_LAG, 0.1, // (0 to 3) seconds
        CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, <-0.5,0.5,1.0> // <-10,-10,-10> to <10,10,10> meters
            ]);
}

shoulder_cam()
{
    //   llOwnerSay("shoulder cam"); // say function name for debugging
    default_cam();
    llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 5.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.0, // (0 to 3) seconds
        CAMERA_DISTANCE, 1.0, // region relative position
        CAMERA_FOCUS_LAG, 0.01 , // (0 to 3) seconds
        CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_PITCH, 15.0, // (-45 to 80) degrees
        //CAMERA_POSITION, <0,0,0>, // region relative position
        CAMERA_POSITION_LAG, 0.1, // (0 to 3) seconds
        CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, <0.0,0.0,1.0> // <-10,-10,-10> to <10,10,10> meters
            ]);
}

l_side_cam()
{
    //  llOwnerSay("l_side_cam"); // say function name for debugging
    default_cam();
    llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 0.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.0, // (0 to 3) seconds
        CAMERA_DISTANCE, 3.0, // ( 0.5 to 10) meters
        //CAMERA_FOCUS, <0,0,5>, // region relative position
        CAMERA_FOCUS_LAG, 0.0 , // (0 to 3) seconds
        //        CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
        //        CAMERA_PITCH, 80.0, // (-45 to 80) degrees
        //CAMERA_POSITION, <0,0,0>, // region relative position
        CAMERA_POSITION_LAG, 0.0, // (0 to 3) seconds
        //        CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, <0,1.5,0> // <-10,-10,-10> to <10,10,10> meters
            ]);
}

r_side_cam()
{
    //  llOwnerSay("r_side_cam"); // say function name for debugging
    default_cam();
    llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 0.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.0, // (0 to 3) seconds
        CAMERA_DISTANCE, 3.0, // ( 0.5 to 10) meters
        //CAMERA_FOCUS, <0,0,5>, // region relative position
        CAMERA_FOCUS_LAG, 0.0 , // (0 to 3) seconds
        //        CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
        //        CAMERA_PITCH, 80.0, // (-45 to 80) degrees
        //CAMERA_POSITION, <0,0,0>, // region relative position
        CAMERA_POSITION_LAG, 0.0, // (0 to 3) seconds
        //        CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, <0,-1.5,0> // <-10,-10,-10> to <10,10,10> meters
            ]);
}

overhead_cam()
{
    //  llOwnerSay("overhead_cam"); // say function name for debugging
    default_cam();
    llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 180.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.5, // (0 to 3) seconds
        CAMERA_DISTANCE, 10.0, // ( 0.5 to 10) meters
        //CAMERA_FOCUS, <0,0,5>, // region relative position
        CAMERA_FOCUS_LAG, 0.05 , // (0 to 3) seconds
        CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_PITCH, 80.0, // (-45 to 80) degrees
        //CAMERA_POSITION, <0,0,0>, // region relative position
        CAMERA_POSITION_LAG, 0.0, // (0 to 3) seconds
        CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, <0,0,0> // <-10,-10,-10> to <10,10,10> meters
            ]);
}

drop_camera_5_seconds()
{
    //  llOwnerSay("drop_camera_5_seconds"); // say function name for debugging
    llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 0.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.5, // (0 to 3) seconds
        CAMERA_DISTANCE, 3.0, // ( 0.5 to 10) meters
        //CAMERA_FOCUS, <0,0,5>, // region relative position
        CAMERA_FOCUS_LAG, 2.0, // (0 to 3) seconds
        CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_PITCH, 0.0, // (-45 to 80) degrees
        //CAMERA_POSITION, <0,0,0>, // region relative position
        CAMERA_POSITION_LAG, 0.05, // (0 to 3) seconds
        CAMERA_POSITION_LOCKED, TRUE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, <0,0,0> // <-10,-10,-10> to <10,10,10> meters
            ]);
    llSleep(5);
    default_cam();
}

worm_cam()
{
    //   llOwnerSay("worm_cam"); // say function name for debugging
    default_cam();
    llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 180.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.0, // (0 to 3) seconds
        CAMERA_DISTANCE, 3.0, // ( 0.5 to 10) meters
        //CAMERA_FOCUS, <0,0,5>, // region relative position
        CAMERA_FOCUS_LAG, 0.0 , // (0 to 3) seconds
        CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 2.0, // (0 to 4) meters
        CAMERA_PITCH, -30.0, // (-45 to 80) degrees
        //CAMERA_POSITION, <0,0,0>, // region relative position
        CAMERA_POSITION_LAG, 1.0, // (0 to 3) seconds
        CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 1.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, <0,0,0> // <-10,-10,-10> to <10,10,10> meters
            ]);
}


spaz_cam()
{
    //  llOwnerSay("spaz_cam for 5 seconds"); // say function name for debugging
    float i;
    for (i=0; i< 50; i+=1)
    {
        vector xyz = llGetPos() + <llFrand(80) - 40, llFrand(80) - 40, llFrand(10)>;
        //        llOwnerSay((string)xyz);
        vector xyz2 = llGetPos() + <llFrand(80) - 40, llFrand(80) - 40, llFrand(10)>;
        llSetCameraParams([
            CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
            CAMERA_BEHINDNESS_ANGLE, 180.0, // (0 to 180) degrees
            CAMERA_BEHINDNESS_LAG, llFrand(3), // (0 to 3) seconds
            CAMERA_DISTANCE, llFrand(10), // ( 0.5 to 10) meters
            //CAMERA_FOCUS, xyz, // region relative position
            CAMERA_FOCUS_LAG, llFrand(3), // (0 to 3) seconds
            CAMERA_FOCUS_LOCKED, TRUE, // (TRUE or FALSE)
            CAMERA_FOCUS_THRESHOLD, llFrand(4), // (0 to 4) meters
            CAMERA_PITCH, llFrand(125) - 45, // (-45 to 80) degrees
            CAMERA_POSITION, xyz2, // region relative position
            CAMERA_POSITION_LAG, llFrand(3), // (0 to 3) seconds
            CAMERA_POSITION_LOCKED, TRUE, // (TRUE or FALSE)
            CAMERA_POSITION_THRESHOLD, llFrand(4), // (0 to 4) meters
            CAMERA_FOCUS_OFFSET, <llFrand(20) - 10, llFrand(20) - 10, llFrand(20) - 10> // <-10,-10,-10> to <10,10,10> meters
                ]);
        llSleep(0.1);
    }
    default_cam();
}

hip_cam()
{
    //  llOwnerSay("hip_cam"); // say function name for debugging
    default_cam();
    llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 0.01, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.05, // (0 to 3) seconds
        CAMERA_DISTANCE, 4.0, // ( 0.5 to 10) meters
        //CAMERA_FOCUS, <0,0,5>, // region relative position
        CAMERA_FOCUS_LAG, 0.01 , // (0 to 3) seconds
        CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_PITCH, 10.0, // (-45 to 80) degrees
        //CAMERA_POSITION, <0,0,0>, // region relative position
        CAMERA_POSITION_LAG, 0.01, // (0 to 3) seconds
        CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, <0,0,0> // <-10,-10,-10> to <10,10,10> meters
            ]);
}

Lock()
{
    llOwnerSay("Locking current camera position.");
    CamPos = llGetCameraPos();
    CamRot = llGetCameraRot();
    CamFoc = CamPos + llRot2Fwd(CamRot);
    llSetColor(<1,0,0>,ALL_SIDES);
    llSetCameraParams([
        CAMERA_ACTIVE, 1,
        CAMERA_FOCUS, CamFoc,
        CAMERA_POSITION, CamPos,
        CAMERA_FOCUS_LOCKED, 1,
        CAMERA_POSITION_LOCKED, 1
            ]);
    vector CamFocStr = CamFoc;
    vector CamPosStr = CamPos;
}

Unlock()
{
    llSetColor(<0,0,1>,ALL_SIDES);
    llOwnerSay("Unlocking current camera position.");
    llSetCameraParams([
        CAMERA_ACTIVE, 1,
        CAMERA_FOCUS, CamFoc,
        CAMERA_POSITION, CamPos,
        CAMERA_FOCUS_LOCKED, 0,
        CAMERA_POSITION_LOCKED, 0
            ]);
}


spin_cam()
{
    //   llOwnerSay("spin_cam"); // say function name for debugging
    default_cam();
    llSetCameraParams([
        CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
        CAMERA_BEHINDNESS_ANGLE, 180.0, // (0 to 180) degrees
        CAMERA_BEHINDNESS_LAG, 0.5, // (0 to 3) seconds
        //CAMERA_DISTANCE, 10.0, // ( 0.5 to 10) meters
        //CAMERA_FOCUS, <0,0,5>, // region relative position
        CAMERA_FOCUS_LAG, 0.05 , // (0 to 3) seconds
        CAMERA_FOCUS_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_FOCUS_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_PITCH, 30.0, // (-45 to 80) degrees
        //CAMERA_POSITION, <0,0,0>, // region relative position
        CAMERA_POSITION_LAG, 0.0, // (0 to 3) seconds
        CAMERA_POSITION_LOCKED, FALSE, // (TRUE or FALSE)
        CAMERA_POSITION_THRESHOLD, 0.0, // (0 to 4) meters
        CAMERA_FOCUS_OFFSET, <0,0,0> // <-10,-10,-10> to <10,10,10> meters
            ]);

    float i;
    vector camera_position;
    for (i=0; i< 2*TWO_PI; i+=.05)
    {
        camera_position = llGetPos() + <0, 4, 0> * llEuler2Rot(<0,0,i>);
        llSetCameraParams([CAMERA_POSITION, camera_position]);
        llSleep(0.1);
    }
    default_cam();
}

Menu()
{
    llSetTimerEvent(Timeout);
    handle = llListen(CHANNEL, "","", ""); // listen for dialog answers
    llDialog(llAvatarOnSitTarget(), "What do you want to do?", MENU_MAIN, CHANNEL); // present dialog on click
}


Menu2()
{
    llSetTimerEvent(Timeout);
    handle = llListen(CHANNEL, "","", ""); // listen for dialog answers
    llDialog(llAvatarOnSitTarget(), "Pick an option!", MENU_2, CHANNEL); // present submenu on request
}

default
{
    state_entry()
    {
        CHANNEL = llRound(llFrand(1) * 100000);
        llSitTarget(<0.2,0,0.5>,ZERO_ROTATION);
        llSetSitText("Action!");
    }

    touch_start(integer total_number)
    {
        llRequestPermissions(llAvatarOnSitTarget(), PERMISSION_CONTROL_CAMERA | PERMISSION_TRACK_CAMERA);
        Menu();
    }   
 
    listen(integer CHANNEL, string name, key id, string message)
    {    
        llListenRemove(handle);
        
        if (message == "More...")
            Menu2();
        else if (message == "...Back")
            Menu();

        else if (message == "Cam ON"){
            llRequestPermissions(llAvatarOnSitTarget(), PERMISSION_CONTROL_CAMERA | PERMISSION_TRACK_CAMERA);
        } else if (message == "Cam OFF") {
            release_camera_control();
        } else if (message == "Default"){
            default_cam();
            Menu();
        }else if (message == "Driving Cam"){
            driving_cam();
            Menu();
        }else if (message == "5M Large Av"){
            large();
            Menu();
        }else if (message == "L Shoulder"){
            l_shoulder_cam();
            Menu();
        }else if (message == "R Shoulder"){
            r_shoulder_cam();
            Menu();
        }else if (message == "Cr Shoulder"){
            shoulder_cam();
            Menu();
        }else if (message == "Worm Cam"){
            worm_cam();
            Menu();
        }else if (message == "Overhead Cam"){
            overhead_cam();
            Menu();
        }else if (message == "Spaz Cam"){
            spaz_cam();
            Menu();
        }else if (message == "L Side Cam"){
            l_side_cam();
            Menu();
        }else if (message == "R Side Cam"){ 
            r_side_cam();
            Menu();
        }else if (message == "Drop Cam 5"){
            drop_camera_5_seconds();
            Menu();
        }else if (message == "Hip Cam"){
            hip_cam();
            Menu();
        }else if (message == "LOCK Cam"){
            Lock();
            Menu();
        }else if (message == "UNLOCK Cam"){
            Unlock();
            Menu();
        }else if (message == "Focus On Me"){
            trap = !trap;
            if (trap == 1) {
                llOwnerSay("focus is on me");
                focus_on_me();
                Menu();
            }else {
                llOwnerSay("focus is off me");
                default_cam();
                Menu();
            }
        } else if (message == "Spin Cam"){
            spin_cam();
            Menu();
        }
    }
    
    changed(integer what)
    {
        if (what & CHANGED_LINK)
        {
            key avi = llAvatarOnSitTarget();
            if (avi != NULL_KEY) {
                Menu();
            } 
        }
    }

    run_time_permissions(integer perm) {
        if (perm & PERMISSION_CONTROL_CAMERA) {
            Menu();
            llSetCameraParams([CAMERA_ACTIVE, 1]); // 1 is active, 0 is inactive
        } 
    }
 
    timer()
    {
        llSetTimerEvent(0);
        llOwnerSay("Menu timeout");
        llListenControl(handle, FALSE);
    }
}  