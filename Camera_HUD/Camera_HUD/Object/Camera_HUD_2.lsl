// :CATEGORY:Camera
// :NAME:Camera_HUD
// :AUTHOR:Fred Gandt
// :CREATED:2012-03-24 16:49:43.897
// :EDITED:2013-09-18 15:38:50
// :ID:145
// :NUM:212
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// CamHUD Script// Drop this script into the prim you just created. Wear the object as a HUD. If you do not see two distinct buttons separated by a black line, it is probably back to front or something.
// :CODE:
/This work uses content from the Second Life® Wiki article http://wiki.secondlife.com/wiki/User:Fred_Gandt/Scripts/Continued_5. Copyright © 2007-2009 Linden Research, Inc. Licensed under the Creative Commons Attribution-Share Alike 3.0 License

// V1 //
 
integer perms;
 
integer track;
 
integer on;
 
vector red = <1.0,0.0,0.0>;
 
vector green = <0.0,1.0,0.0>;
 
SetCameraParams(integer o, integer t)
{
    list focus = [];
    llClearCameraParams();
    if(t)
    focus = [CAMERA_FOCUS, llGetPos()];
    else
    focus = [CAMERA_FOCUS_LOCKED, TRUE];
    llSetCameraParams([CAMERA_ACTIVE, o, CAMERA_POSITION_LOCKED, TRUE] + focus);
}
 
default
{
    on_rez(integer param)
    {
        llResetScript();
    }
    state_entry()
    {
        if(llGetAttached())
        llRequestPermissions(llGetOwner(), PERMISSION_CONTROL_CAMERA);
    }
    run_time_permissions(integer perm)
    {
        if(perm & PERMISSION_CONTROL_CAMERA)
        {
            perms = TRUE;
            llSetText("   Track | Power", <1.0,1.0,1.0>, 1.0);
            llSetLinkPrimitiveParamsFast(-1, [PRIM_COLOR, -1, <0.0,0.0,0.0>, 1.0,
                                              PRIM_COLOR, 6, red, 1.0,
                                              PRIM_COLOR, 7, red, 1.0]);
        }
    }
    touch_start(integer nd)
    {
        if(perms)
        {
            integer face;
            vector color;
            if((face = llDetectedTouchFace(0)) == 6)
            {
                SetCameraParams((on = (!on)), track);
                if(on)
                color = green;
                else
                color = red;
            }
            else if(face == 7)
            {
                SetCameraParams(on, (track = (!track)));
                if(track)
                color = green;
                else
                color = red;
            }
            llSetLinkPrimitiveParamsFast(-1, [PRIM_COLOR, face, color, 1.0]);
        }
    }
}
