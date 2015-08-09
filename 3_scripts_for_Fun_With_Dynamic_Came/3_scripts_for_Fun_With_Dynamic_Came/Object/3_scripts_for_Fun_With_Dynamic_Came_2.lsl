// :CATEGORY:Camera
// :NAME:3_scripts_for_Fun_With_Dynamic_Came
// :AUTHOR:Ariane Brodie
// :KEYWORDS:
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2014-02-15
// :ID:3
// :NUM:4
// :REV:2.0 
// :WORLD:Second Life
// :DESCRIPTION:
// A popular use for these cameras is to detach the camera from yourself, and see through nearby walls. The first scripts for these dynamic cameras allow you to steer your camera around, using arrow keys (forward, back, turn left, turn right) and page up/page down (up and down). I rewrote parts of the script to work like a HUD. Click blue to enable the camera, click red to return to default camera.
// :CODE:

// ControlCam script, by Azurei Ash, feel free to use and distribute
// To be used as a HUD attachment, touch to turn on, touch again to turn off
// HUD toggle by Ariane Brodie
// Rev 1.1 8-17-2013 Patched to compile by Ferd Frederix, un-initted owner vs llGetOwner()

// Initial camera position relative to avatar
// <1,0,.75> = 1 meter forward, 0 meters left, .75 meters up
vector CAMOFFSET=<1,0,.75>;

// camera is moved MOVERATE meters each control event for movement
// used by these controls: forward, back, left, right, up, down
// lower is slower/smoother, higher is faster/jumpier
float MOVERATE=0.5;

// camera is rotated SPINRATE degrees each control event for rotation
// used by these controls: rotate left, rotate right
// lower is slower/smoother, higher is faster/jumpier
// also a good idea to have this number divide 360 evenly
float SPINRATE=6.0;

// The above MOVERATE/SPINRATE will be multiplied by their corresponding
// LFACTOR while the left mouse button is held down
// LFACTORM corresponds to MOVERATE
// LFACTORS corresponds to SPINRATE
float LFACTORM=0.5;
float LFACTORS=0.5;

// maximum distance the camera can move away from the user, currently (SL1.9) this is 50m
float MAXDIST=50.0;

// ==================== SCRIPTERS ONLY BELOW THIS POINT! ;) ==================== //

integer permissions=FALSE;


vector position;
rotation facing;


updateCamera()
{
    vector focus=position+llRot2Fwd(facing);
    // The camera was turned on earlier, the position and focus also locked
    llSetCameraParams([
        CAMERA_FOCUS, focus, // region relative position
        CAMERA_POSITION, position // region relative position
    ]);
}

default
{

    state_entry()
    {
        llSetPrimitiveParams([
            PRIM_TEXTURE, ALL_SIDES, "05e736d6-fc50-cc61-ea97-51993ec47c24",
            <0.4,0.1,0>, <0.2,0.41,0>, 0.0]);
        if(permissions&PERMISSION_CONTROL_CAMERA)
            llSetCameraParams([CAMERA_ACTIVE, FALSE]);
        llReleaseControls();
    }
    
    touch_start(integer n)
    {
        state cam_on;
    }
}
    
state cam_on
{
    state_entry()
    {
        llSetPrimitiveParams([
            PRIM_TEXTURE, ALL_SIDES, "91a0e647-a69e-f13c-ed93-9bb84d7e790d",
            <0.4,0.1,0>, <0.2,0.41,0>, 0.0]);
        llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS|PERMISSION_CONTROL_CAMERA);
    }
    
    touch_start(integer n)
    {
        state default;
    }

    run_time_permissions(integer perm)
    {
        permissions=perm;
        if(permissions)
        {
            llClearCameraParams();
            // These camera parameters will be constant, so set them only once
            llSetCameraParams([
                CAMERA_ACTIVE, 1, // 1 is active, 0 is inactive
                CAMERA_FOCUS_LOCKED, TRUE, // (TRUE or FALSE)
                CAMERA_POSITION_LOCKED, TRUE // (TRUE or FALSE)
            ]);

            // level out their rotation
            vector rot=llRot2Euler(llGetRot());
            rot.x = rot.y = 0;
            facing = llEuler2Rot(rot);

            // offset and update the camera position
            position = llGetPos()+CAMOFFSET*facing;
            updateCamera();
            llTakeControls(CONTROL_LBUTTON|CONTROL_FWD|CONTROL_BACK|CONTROL_ROT_LEFT|CONTROL_ROT_RIGHT|CONTROL_UP|CONTROL_DOWN|CONTROL_LEFT|CONTROL_RIGHT, TRUE, FALSE);
        }
    }

    control(key id, integer held, integer change)
    {
        // adjust the LFACTORs in response to changes in LBUTTON
        if(change&CONTROL_LBUTTON)
        {
            if(held&CONTROL_LBUTTON) // LBUTTON pressed
            {
                MOVERATE *= LFACTORM;
                SPINRATE *= LFACTORS;
            }
            else // LBUTTON released
            {
                MOVERATE /= LFACTORM;
                SPINRATE /= LFACTORS;
            }
        }

        // Only continue if some key is held, other than the left mouse button
        // Mouselook will override the scripted camera, so don't move the camera if in mouselook
        if((held&~CONTROL_LBUTTON) && !(llGetAgentInfo(llGetOwner())&AGENT_MOUSELOOK))
        {
            // Temporary position used, updated position may be out of range
            vector pos=position;
    
            // react to any held controls
            if(held&CONTROL_ROT_LEFT)
            {
                facing *= llAxisAngle2Rot(<0,0,1>, SPINRATE*DEG_TO_RAD);
            }
            if(held&CONTROL_ROT_RIGHT)
            {
                facing *= llAxisAngle2Rot(<0,0,1>, -SPINRATE*DEG_TO_RAD);
            }
            if(held&CONTROL_FWD)
            {
                pos += MOVERATE*llRot2Fwd(facing);
            }
            if(held&CONTROL_BACK)
            {
                pos -= MOVERATE*llRot2Fwd(facing);
            }
            if(held&CONTROL_UP)
            {
                pos += MOVERATE*llRot2Up(facing);
            }
            if(held&CONTROL_DOWN)
            {
                pos -= MOVERATE*llRot2Up(facing);
            }
            if(held&CONTROL_LEFT)
            {
                pos += MOVERATE*llRot2Left(facing);
            }
            if(held&CONTROL_RIGHT)
            {
                pos -= MOVERATE*llRot2Left(facing);
            }
    
            // only update position with the new one if it is in range
            if(llVecDist(pos, llGetPos()) <= MAXDIST)
                position = pos;
    
            updateCamera();
        }
    }
}
