// :CATEGORY:Stair
// :NAME:Spiral Stair Maker
// :AUTHOR:Anonymous
// :KEYWORDS:
// :CREATED:2014-11-18 12:55:17
// :EDITED:2014-11-18
// :ID:1055
// :NUM:1675
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// A simple spiral staircase, one step at a time.  XML files, too, so it is easy to load
// :CODE:
 
rotation rot_xyzq;
 
default
{
    state_entry()
    {
        vector xyz_angles = <0,0,20>; // This is to define a 1 degree change
        vector angles_in_radians = xyz_angles*DEG_TO_RAD; // Change to Radians
        rot_xyzq = llEuler2Rot(angles_in_radians); // Change to a Rotation
    }
 
    touch_start(integer s)
    {
        llSetRot(llGetRot()*rot_xyzq); //Do the Rotation...
 
    }
}
 
