// :CATEGORY:Movement
// :NAME:Demon Circle
// :AUTHOR:Ferd Frederix
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:51
// :ID:228
// :NUM:314
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Moves a pointer in a circle
// :CODE:

﻿
integer positions = 4;
integer primnum = 6;

rotate(integer N)
{

    vector xyz_angles = <0,0.0,N>; // This is to define a 90 degree change
    vector angles_in_radians = xyz_angles*DEG_TO_RAD; // Change to Radians
    rotation rot_xyzq = llEuler2Rot(angles_in_radians); // Change to a Rotation
    

    llSetLinkPrimitiveParamsFast( primnum, [PRIM_FULLBRIGHT,ALL_SIDES,FALSE,PRIM_ROT_LOCAL, rot_xyzq] );
    llSleep(.5);
    llSetLinkPrimitiveParamsFast( primnum, [PRIM_FULLBRIGHT,ALL_SIDES,TRUE] );
}
default
{
    state_entry()
    {
        vector input = <0.0, 0.0, 0.0> * DEG_TO_RAD;
        rotation initrot = llEuler2Rot(input);
        llSetLinkPrimitiveParamsFast( primnum, [PRIM_ROT_LOCAL, initrot] );

    }
 
    touch_start(integer s)
    {
        integer i;
        for (i =0; i < positions *90; i+=90)
        {
            rotate(i);
            llSleep(1.0);
        }
    }
}
