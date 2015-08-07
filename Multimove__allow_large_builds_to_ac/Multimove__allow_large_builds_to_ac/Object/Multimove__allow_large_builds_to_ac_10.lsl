// :CATEGORY:Vehicle
// :NAME:Multimove__allow_large_builds_to_ac
// :AUTHOR:Amanda Vanness
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:58
// :ID:542
// :NUM:738
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// controller
// :CODE:
// MultiMove Shuttle Controller Script
//
// Manages pilot seat, remote control and movement for a specific detachable object of a multimove set

integer offchan = -100;    // this is the unique identifier for this type of vehicle
integer unichan;    // the channel used by the controller and objects to
            // sync and move, will be composed of this and part
            // of your UUID

integer shuttlechan;    // set randomly

integer controlstaken;        // control keys taken by the script, initialised later

integer listener;
integer maxl = 8;
float rate = 0.05;        // interval between updates

vector sitoffset = <0.25,0,0.35>;    // sitting position
rotation sitrot = ZERO_ROTATION;    // sitting rotation
vector camoffset = ZERO_VECTOR;        // camera position (static)
vector camtarget = ZERO_VECTOR;        // camera direction (static)

float speed = 2.0;        // distance to move within rate
float vspeed = 1.0;        // vertical distance to move within rate
float lspeed = 1.0;        // lateral distance to move within rate
float rspeed = 0.062831853;        // angle in radians to rotate left or right within rate
float inertia = 0.8;
float moment = 0.5;
vector accel = <0.0625, 0.0625, 0.03125>;    // acceleration rates fwd, strafe and vert
float raccel = 0.03125;                // turning acceleration rate
float banking = -0.5;        // how much the vehicle banks in turns with forward speed
float tilting = 0.125;        // how much the vehicle tilts fore and aft with forward accel

vector velocity;
float rotacity;
float azimut;

integer pressed;

rotation rtarget;

list cam = [CAMERA_ACTIVE, TRUE, CAMERA_BEHINDNESS_ANGLE, 180.0, CAMERA_BEHINDNESS_LAG, 0.5, CAMERA_POSITION_LAG, 1.0, CAMERA_FOCUS_LAG, 0.5, CAMERA_POSITION_LOCKED, TRUE];

// camera positions
vector neutral = <-9, 0, 2>;
vector back = <6, -3, 1>;
vector down = <-7, 0, 8>;
vector up = <-9, 0, -2>;
vector out = <0, 9, 3>;

float cam_vel = 0.25;    // velocity at which camera will switch, so that you can maneuver at slow speed from angles

default
{
    on_rez(integer c)
    {
        llSleep(1.6);
        llResetScript();
    }

    state_entry()
    {
        unichan = offchan - (integer)("0x" + llGetSubString((string)llGetOwner(), 0, 6));
        llSetTimerEvent(0.0);
        velocity = ZERO_VECTOR;
        rotacity = 0.0;
        vector temp = llRot2Fwd(llGetRootRotation());
        temp.z = 0.0;
        llVecNorm(temp);
        azimut = llAcos(temp.x);
        if (llAsin(temp.y) < 0.0)
            azimut = -azimut;
        llMinEventDelay(0.05);
        llSitTarget(sitoffset, sitrot);
        llSetCameraAtOffset(camtarget);
        llSetCameraEyeOffset(camoffset);
        controlstaken = CONTROL_FWD|CONTROL_BACK|CONTROL_ROT_LEFT|CONTROL_ROT_RIGHT|CONTROL_LEFT|CONTROL_RIGHT|CONTROL_UP|CONTROL_DOWN;
        do { shuttlechan = (integer)llFrand(500000000) + 11; } while (llAbs(shuttlechan - unichan) < 10);
    }

    changed(integer c)
    {
        if (c & CHANGED_LINK)
        {
            key id = llAvatarOnSitTarget();
            if (id != NULL_KEY)
            {
                if (id == llGetOwner())
                {
                    llRequestPermissions(id, PERMISSION_TAKE_CONTROLS|PERMISSION_CONTROL_CAMERA);
                } else llUnSit(id);
            } else {
                llReleaseControls();
                llSetTimerEvent(0.0);
                llMessageLinked(LINK_ROOT, 0, "attach", "");
            }
        }
    }

    run_time_permissions(integer p)
    {
        if (p & PERMISSION_TAKE_CONTROLS)
        {
            integer n;
            llMessageLinked(LINK_ROOT, shuttlechan, "detach", "");
            rtarget = llGetRootRotation();
            velocity = ZERO_VECTOR;
            rotacity = 0.0;
            vector temp = llRot2Fwd(llGetRootRotation());
            temp.z = 0.0;
            llVecNorm(temp);
            azimut = llAcos(temp.x);
            if (llAsin(temp.y) < 0.0)
                azimut = -azimut;

            llSleep(1.0);
            llTakeControls(controlstaken, TRUE, FALSE);
            llSetTimerEvent(rate);
            llSetCameraParams(cam + [CAMERA_POSITION, neutral * rtarget + llGetRootPosition(), CAMERA_FOCUS, llGetRootPosition()]);
            for (n=0; n<maxl; ++n)
                llShout(shuttlechan + n, (string)(llGetRootPosition() + llGetRegionCorner()) + "*" + (string)rtarget);
        } else {
            llReleaseControls();
        }
    }

    control(key id, integer level, integer edge)
    {
        pressed = level;
    }

    timer()
    {
        vector pos = llGetRootPosition() + llGetRegionCorner();
        rotation orig = llGetRootRotation();

        listener = (listener + 1) % maxl;
        integer cam_set = FALSE;

        float oldvel = velocity.x;
        float bank = 0.0;
        float tilt = 0.0;

        if (pressed & CONTROL_FWD)
        {
            velocity.x += accel.x;
            if (velocity.x > speed) velocity.x = speed;

            if (velocity.x > cam_vel)
            {
                llSetCameraParams([CAMERA_POSITION, neutral * orig + llGetRootPosition(), CAMERA_FOCUS, llGetRootPosition()]);
                cam_set = TRUE;
            }
        } else if (pressed & CONTROL_BACK)
        {
            velocity.x -= accel.x;
            if (velocity.x < -speed) velocity.x = -speed;

            if (velocity.x < -cam_vel)
            {
                llSetCameraParams([CAMERA_POSITION, back * orig + llGetRootPosition(), CAMERA_FOCUS, llGetRootPosition()]);
                cam_set = TRUE;
            }
        } else velocity.x *= inertia;

        if (pressed & CONTROL_UP)
        {
            velocity.z += accel.z;
            if (velocity.z > vspeed) velocity.z = vspeed;

            if ((cam_set == FALSE) && (velocity.z > cam_vel))
            {
                llSetCameraParams([CAMERA_POSITION, out * orig + llGetRootPosition(), CAMERA_FOCUS, llGetRootPosition()]);
                cam_set = TRUE;
            }
        } else if (pressed & CONTROL_DOWN)
        {
            velocity.z -= accel.z;
            if (velocity.z < -vspeed) velocity.z = -vspeed;

            if ((cam_set == FALSE) && (velocity.z < -cam_vel))
            {
                llSetCameraParams([CAMERA_POSITION, up * orig + llGetRootPosition(), CAMERA_FOCUS, llGetRootPosition()]);
                cam_set = TRUE;
            }
        } else velocity.z *= inertia;

        if (pressed & CONTROL_LEFT)
        {
            velocity.y += accel.y;
            if (velocity.y > lspeed) velocity.y = lspeed;

            if ((cam_set == FALSE) && (velocity.y > cam_vel))
                llSetCameraParams([CAMERA_POSITION, down * orig + llGetRootPosition(), CAMERA_FOCUS, llGetRootPosition()]);
        } else if (pressed & CONTROL_RIGHT)
        {
            velocity.y -= accel.y;
            if (velocity.y < -lspeed) velocity.y = -lspeed;

            if ((cam_set == FALSE) && (velocity.y < -cam_vel))
                llSetCameraParams([CAMERA_POSITION, down * orig + llGetRootPosition(), CAMERA_FOCUS, llGetRootPosition()]);
        } else velocity.y *= inertia;

        if (pressed & CONTROL_ROT_LEFT)
        {
            rotacity += raccel;
            if (rotacity > rspeed) rotacity = rspeed;
        } else if (pressed & CONTROL_ROT_RIGHT)
        {
            rotacity -= raccel;
            if (rotacity < -rspeed) rotacity = -rspeed;
        } else rotacity *= moment;

        if (llFabs(rotacity) > 0.005)
        {
            azimut += rotacity;
            bank = rotacity * banking * velocity.x;
            tilt = tilting * (velocity.x - oldvel);
            orig = llEuler2Rot(<bank, tilt, 0.0>) * llEuler2Rot(<0,0,azimut>);
            llShout(shuttlechan + listener, (string)(pos + velocity * orig) + "*" + (string)orig);
        } else if (llVecMag(velocity) > 0.01)
        {
            tilt = tilting * (velocity.x - oldvel);
            orig = llEuler2Rot(<0.0, tilt, 0.0>) * llEuler2Rot(<0,0,azimut>);
            llShout(shuttlechan + listener, (string)(pos + velocity * orig) + "*" + (string)orig);
        }
    }
}
