// :CATEGORY:Useful Subroutines
// :NAME:Rotate_object_towards_another_objec
// :AUTHOR:Chalice Yao
// :CREATED:2010-11-16 11:29:36.330
// :EDITED:2013-09-18 15:39:01
// :ID:709
// :NUM:970
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Awesome, isn't it? That one line does all the magic. The logic here is that the llRotBetween returns the rotation between the norm'd vector <1,0,0>, which would be the forward vector of an object without any rotation applied (remember, X axis = forward in prims), and the normal vector that points from your object to the target. And that's the whole rotation that needs to be set.// // // Code:// //                              B
//                              *
//                              |   Z height
//                              | 
// A     XYdistance     |
// *--------------------------- X axis (<1,0,0>)
// 
// 
// Now, this is already dead seksi, but it can have an effect that some people want to avoid: the object that does the pointing will rotate around its own length. I.e. it will roll left/right along its body axis. How to avoid that?
// 
// Solution: Do two different rotations. one that does the left/right turning, followed by a rotation that simply tilts the object up/down. Think of a classic concept like a gun turret. The turret barrel never rotates around the axis it points at, it just moves up/down and left/right.
// 
// Hokay, let's do the up/down first. The easiest way to get that rotation is to act like both object positions have the same Y value, and just are their combined XY distance apart on the X axis. Think two-dimensional.
// :CODE:
vector vTarget=target position;
vector vPos=llGetPos(); //object position
float fDistance=llVecDist(<vTarget.x,vTarget.y,0>,<vPos.x,vPos.y,0>); // XY Distance, disregarding height differences.
