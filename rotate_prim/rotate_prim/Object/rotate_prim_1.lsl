// :CATEGORY:Prim
// :NAME:rotate_prim
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:01
// :ID:710
// :NUM:974
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// rotate prim.lsl
// :CODE:

rotation rot_xyzq;
 
default
{
    state_entry()
    {
        vector xyz_angles = <0,1.0,0>; // This is to define a 1 degree change
        vector angles_in_radians = xyz_angles*DEG_TO_RAD; // Change to Radians
        rot_xyzq = llEuler2Rot(angles_in_radians); // Change to a Rotation
    }
 
    touch_start(integer s)
    {
        llSetRot(llGetRot()*rot_xyzq); //Do the Rotation...
 
    }
}
 // END //
