// :CATEGORY:Vehicle
// :NAME:A_working_CrossGrid_Non_Physical_Vehicle
// :AUTHOR:Michael R. Horton
// :CREATED:2013-07-31 21:44:21.357
// :EDITED:2013-09-18 15:38:47
// :ID:11
// :NUM:16
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Multi-Grid non physical vehicle. Jerky, but it works
// :CODE:

//   Yes, a WORKING Cross-Grid (X-Grids) Non Physical Vehicle Script.
//
//   I have personally tested this script to work in
//   Second Life, InWorldz, & OpenSim. It works great
//   in all grids that I have tested so far, and can
//   be used as a flying/levitating vehicle of sorts.
//
//   Pro Tips: Non physical vehicles are not as CPU intensive
//             as physical vehicles for the sim, and they can
//             help protect you from being pushed across the
//             sim from giant bullets, sim cleaners, and chaos.
//             Setting the object to phantom further reduces
//             CPU load on the sim because the physics engine
//             is no longer used for collision detection with
//             the phantom object. Micro optimizations include
//             renaming all child links in a linkset to ".",
//             keeping all object, script, and animation names
//             under 16 characters, and setting all object
//             textures to the factory "Blank" texture for
//             very small sim and viewer load reductions.
//
//   Copyright 2013 Michael R. Horton
//
//   Real Life ............. Michael R. Horton
//   Second Life ........... Mick Scarbridge
//   InWorldZ .............. Mick Daftwood
//
//   This program is free software; you can redistribute it and/or modify
//   it under the terms of the GNU General Public License as published by
//   the Free Software Foundation; Version 32 of the License.
//
//   This program is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
//
//   You should have received a copy of the GNU General Public License
//   along with this program; if not, write to the Free Software
//   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
//   MA 02110-1301, USA.
//
//   This header must remain in tact for your application of this script.
//   Any modifications that you do should be recorded below with each new
//   version, including your name or avatar name, etc for proper credit to
//   your modifications.
//
//   Upgrades
//
//   v0.4.6 Features:
//
//    * llSetRegionPos() used for higher efficiency than llSetPos().
//    * Tested to work across all grids as of 2013.05.15
// 
//   v0.4.8 Features:
//
//    * Tested to self-delete when user stands for AutoCleanup.
//    * Tested to self-delete when user accidentally sits on another object.
//    * Tested to self-delete when user crashes or teleports.
//
//   v0.5.0 Features:
//
//    * Final code cleanup.
//    * Inserted GPL licensing information.
//    * Adjusted formatting for better readability.
//    * Final testing for directional speeds.
//
//   Instructions:
//
//    * Build a one prim object, such as a box or sphere.
//    * Set the rotation to <0,0,0> and set texture to "Blank".
//    * Drop in an animation you like, then rename the animation to "dz" inside the object.
//    * Create a new script in the object then paste this into it.
//    * Set the default action to "Sit" for the object.
//    * Set to compile in MONO instead of LSO/LSL for greater efficiency.
//    * Rename the object you created to something you will remember, such as "npv.xgrids".
//    * Take the object into inventory before sitting or it will self-delete when you stand.
//    * Rez the object in-world and left click to sit.
//    * Enjoy!

integer r=FALSE;
key s;
key t;
key p=NULL_KEY;
string a="";
integer b=FALSE;
c(key d,string n)
{
    p=d;
    a=n;
    llRequestPermissions(d,PERMISSION_TAKE_CONTROLS);
}

q(){
    if(b)
    {
        p=NULL_KEY;
        b=FALSE;
        llReleaseControls();
    }
}

f(vector g)
{
    llSetRot(llEuler2Rot(llRot2Euler(llGetRot())+g*DEG_TO_RAD));
}

default
{
    on_rez(integer h)
    {
        llResetScript();
        llSetSitText("^,..,^");// Better than boring "Sit Here".
        llSetStatus(STATUS_PHANTOM,TRUE);// Reduces CPU load on the sim server.
        llVolumeDetect(FALSE);// Set to TRUE if you desire collision detection.
        t=llGetOwner();
    }

    state_entry()
    {
        llSitTarget(<0.0,0.0,1.0>,<0.0,0.0,0.0,1.0>);// Haxx - seems to allow sit even if rezzed inside a megaprim sensor type.
//        llSitTarget(ZERO_VECTOR,ZERO_ROTATION);// Alternative that may work better than the previous line in YOUR sim grid.
        llSetCameraEyeOffset(<-5.0,0.0,2.0>);// I nuu wanna be staring at every hair follicle in the back o my head.
        llSetCameraAtOffset(<0.0,0.0,2.0>);
//        llCollisionSound("",0.0);// If non phantom, why sound like beating them when bumping them?
    }

    touch(integer j)
    {
        if(llDetectedKey(0))
        {
            c(llDetectedKey(0),llDetectedName(0));
        }
    }

    changed(integer u)
    {
        s=llAvatarOnSitTarget();
        if(u&CHANGED_LINK)
        {
            if((s==p)&&(r))
            {
                llStopAnimation("sit_ground");
                llReleaseControls();
                r=FALSE;
                llSleep(0.1);
                llDie();
            }

        else if(!r)
        {
            t=llAvatarOnSitTarget();
            r=TRUE;
            llRequestPermissions(t,PERMISSION_TAKE_CONTROLS|PERMISSION_TRIGGER_ANIMATION);
            llSetAlpha(0.0,ALL_SIDES);
        }
    }
}

    control(key n,integer l,integer e)
    {
        if(l&CONTROL_FWD){llSetRegionPos(llGetPos()+(<4.0,0,0>)*llGetRot());}
        if(l&CONTROL_BACK){llSetRegionPos(llGetPos()+(<-4.0,0,0>)*llGetRot());}
        if(l&CONTROL_LEFT||l&CONTROL_ROT_LEFT){f(<0,0,25.0>);}
        if(l&CONTROL_RIGHT||l&CONTROL_ROT_RIGHT){f(<0,0,-25.0>);}
        if(l&CONTROL_UP){llSetRegionPos(llGetPos()+(<0,0,4.0>)*llGetRot());}
        if(l&CONTROL_DOWN){llSetRegionPos(llGetPos()+(<0,0,-4.0>)*llGetRot());}
    }

    run_time_permissions(integer k)
    {
        if(k&PERMISSION_TAKE_CONTROLS)
        {
            llTakeControls(CONTROL_FWD|CONTROL_BACK|CONTROL_LEFT|
            CONTROL_RIGHT|CONTROL_ROT_LEFT|CONTROL_ROT_RIGHT|
            CONTROL_UP|CONTROL_DOWN,TRUE,FALSE);
            b=TRUE;
        }

        if(k & PERMISSION_TRIGGER_ANIMATION)
        {
            llStartAnimation("dz");
            llStopAnimation("sit");
        }

        else
        {
            q();
        }
    }
}
///////////////////////////////////////// Code end.
// EOF
