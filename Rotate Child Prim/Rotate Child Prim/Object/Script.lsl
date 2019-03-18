// :CATEGORY:Rotation
// :NAME:Rotate Child Prim
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :KEYWORDS:
// :CREATED:2014-12-17 18:09:54
// :EDITED:2014-12-17
// :ID:1064
// :NUM:1707
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Drop this one in a child prim to have it rotate around the world's Y axis in 1 degree increments. It won't work in the root if it is rotated.
// You have to send it a message "[BTN_1]" on channel -101 as it is intended for a HUD
// :CODE:

rotation  rot_xyzq;
 
default
{
    state_entry()
    {
        vector xyz_angles = <1,1,0>; // This is to define a 1 degree change in X axis
        vector angles_in_radians = xyz_angles*DEG_TO_RAD; // Change to Radians
        rot_xyzq = llEuler2Rot(angles_in_radians); // Change to a Rotation

        llListen(-101,"","","");
    }
 
    listen(integer channel, string name, key id, string message){
        //If owner do something
        if ( llGetOwnerKey(id)==llGetOwner()){
            if (message == "[BTN_1]") {
                llSay(0, "Button 1 pressed");
                llSetRot(llGetRot()*rot_xyzq/llGetRootRotation()/llGetRootRotation()); //Do the Rotation...
                // Get the prims rotation.  Add (*) to that the new rotation, and subtract (/) the root rotation twice
                // You subtract it twice because the Lindens screwed up the math.
            }
        }
    }
}
