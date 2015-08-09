// :CATEGORY:Useful Subroutines
// :NAME:Rotate_object_towards_another_objec
// :AUTHOR:Chalice Yao
// :CREATED:2010-11-16 11:29:36.330
// :EDITED:2013-09-18 15:39:01
// :ID:709
// :NUM:969
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Here is a little snippet for the rotationally-challenged, or those who have some complex solution but want something much simpler.// How to rotate an object so it points its X axis (which is the 'forward' axis on prims) towards another object?// One complex solution is to take the object's rotation, take the other object's position, try to calculate the angle/rotation in between, adding it to the current rotation...// // Way too complex. It's much simpler to calculate the total rotation that needs to be set in one swoop.
// :CODE:
llSetRot(llRotBetween(<1,0,0>,llVecNorm(targetPosition - llGetPos())));
