// :CATEGORY:Camera
// :NAME:Camera_Follower
// :AUTHOR:WolfWings Majestic
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:50
// :ID:144
// :NUM:210
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Camera Follower by WolfWings Majestic.lsl
// :CODE:

//********************************************************
//This Script was pulled out for you by YadNi Monde from the LSL WIKI at http://www.lslwiki.org, it is intended to stay FREE by it s author(s) and all the comments here in ORANGE must NOT be deleted. They include notes on how to use it and no help will be provided either by YadNi Monde or it s Author(s). IF YOU DO NOT AGREE WITH THIS JUST DONT USE!!!
//********************************************************







// Camera Follower by WolfWings Majestic
//
//Originally created by ArkLehane who edited the version posted here and credited to him on this Wiki out of existance.
//Re-created and rebuilt by WolfWings Majestic because the script idea is useful, but the original version could be improved on.
//
//Moves an object to the position of your camera.

integer channel = 0;

default {
    state_entry() {
        llRequestPermissions(llGetOwner(),PERMISSION_TRACK_CAMERA);
    }
    run_time_permissions(integer perm) {
        if (perm & PERMISSION_TRACK_CAMERA) {
            state camera_captured;
        }
    }
}

state camera_captured {
    state_entry() {
        llListen(channel,"",llGetOwner(),"");
        llSetStatus(STATUS_PHYSICS,TRUE);
        llSetTimerEvent(0.1);
    }
    timer() {
        llMoveToTarget(llGetCameraPos()+<0,0,1>,0.1);
    }
    listen(integer channel, string name, key id, string message) {
        if (llToLower(message) == "hold") {
            state camera_captured_disabled;
        }
    }
}

state camera_captured_disabled {
    state_entry() {
        llListen(channel,"",llGetOwner(),"");
        llSetStatus(STATUS_PHYSICS,FALSE);
    }
    listen(integer channel, string name, key id, string message) {
        if (llToLower(message) == "follow") {
            state camera_captured;
        }
    }
}


// END //
