// :CATEGORY:Building
// :NAME:control
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:51
// :ID:202
// :NUM:276
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// control.lsl
// :CODE:

// MultiMove Controller Script

//

// Manages pilot seat and movement for the whole set



integer unichan = -28091988;    // this is the channel used by the controller and

                // objects to sync and move



float deltat = 0.125;        // interval between updates



integer controlstaken;        // control keys taken by the script, initialised later



integer listener;

integer maxl = 4;



vector sitoffset = <0.2,0,-0.2>;    // sitting position

vector camoffset = <-24,0,9>;    // camera position

vector camtarget = <12,0,0>;    // camera direction

float speed = 1.0;        // distance to move within deltat

float vspeed = 0.5;        // vertical distance to move within deltat

integer rspeed = 3;        // angle in degrees to rotate left or right within deltat



integer azimut;            // direction in degrees around the Z axis (vertical)



default

{

    on_rez(integer c)

    {

        llResetScript();

    }



    state_entry()

    {

        llMinEventDelay(deltat);

        llSitTarget(sitoffset, ZERO_ROTATION);

        llSetCameraAtOffset(camtarget);

        llSetCameraEyeOffset(camoffset);

        controlstaken = CONTROL_FWD|CONTROL_BACK|CONTROL_ROT_LEFT|CONTROL_ROT_RIGHT|CONTROL_LEFT|CONTROL_RIGHT|CONTROL_UP|CONTROL_DOWN;

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

                    llRequestPermissions(id, PERMISSION_TAKE_CONTROLS);

                } else llUnSit(id);

            } else {

                llReleaseControls();

            }

        }

    }



    run_time_permissions(integer p)

    {

        if (p & PERMISSION_TAKE_CONTROLS)

        {

            integer n;

            for (n=0; n<maxl; ++n)

                llShout(unichan + n, (string)(llGetRootPosition() + llGetRegionCorner()) + "*" + (string)azimut);


            llSleep(1.0);

            llTakeControls(controlstaken, TRUE, FALSE);

        } else {

            llReleaseControls();

            llShout(unichan, (string)llGetRootPosition() + "*" + (string)azimut);

        }

    }



    control(key id, integer pressed, integer change)

    {

        vector target = llGetRootPosition() + llGetRegionCorner();

        rotation rtarget = llGetRootRotation();



        if (pressed & (CONTROL_LEFT|CONTROL_ROT_LEFT))

        {

            // turning left

            azimut = (azimut + rspeed) % 360;

            rtarget *= llEuler2Rot(<0,0,DEG_TO_RAD * (float)rspeed>);

        } else if (pressed & (CONTROL_RIGHT|CONTROL_ROT_RIGHT))

        {

            // turning right

            azimut = (azimut - rspeed) % 360;

            rtarget *= llEuler2Rot(<0,0,-DEG_TO_RAD * (float)rspeed>);

        }

        

        if (pressed & CONTROL_FWD)

        {

            // going forward

            target += speed * llRot2Fwd(rtarget);



        } else if (pressed & CONTROL_BACK)

        {

            // going backward

            target += -speed * llRot2Fwd(rtarget);

        }

        

        if (pressed & CONTROL_UP)

        {

            // going forward

            target += vspeed * llRot2Up(rtarget);



        } else if (pressed & CONTROL_DOWN)

        {

            // going backward

            target += -vspeed * llRot2Up(rtarget);

        }

        

        if (pressed | change)

        {

            listener = (listener + 1) % maxl;

            llShout(unichan + listener, (string)target + "*" + (string)azimut);

        }

    }

}// END //
