// :CATEGORY:Boat
// :NAME:DaVinci Boat
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-08
// :EDITED:2013-09-18 15:38:51
// :ID:220
// :NUM:302
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// A passenger seat
// :CODE:
default
{
    state_entry()
    {
        
        vector input = <-90.0, 0.0, -90.0> * DEG_TO_RAD;
        rotation rot = llEuler2Rot(input);
        
        llSitTarget(<.25, 0.75, 0>, rot);        // z = fwd, x = side to side, Y = hight
        llSetCameraEyeOffset(<0.0,2.0, 5.0>);
        llSetCameraAtOffset(<0.0, 0.0, -2.0>);
    }


}
