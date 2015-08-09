// :CATEGORY:Useful Subroutines
// :NAME:Rotate_object_towards_another_objec
// :AUTHOR:Chalice Yao
// :CREATED:2010-11-16 11:29:36.330
// :EDITED:2013-09-18 15:39:01
// :ID:709
// :NUM:972
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Ta-dah. This will return the rotation that will make our object point upward correctly at the other object. Not left/right, just the correct upwards angle. the 'vTarget.z - vPos.z' gets done to get the height difference between the two objects.// // Now how to do left/right? Easy, it uses the same idea as the above concept of getting the needed up/down rotation, except this time we disregard the Z coordinate and just use the XY difference.// // Like this:// Code:
// 
// Y
// ^
// |
// |                                 *B
// |
// |
// |    *A
// |
// ------------------> X (<1,0,0>)
// 
// This time we don't even need to take care of any distance considerations. What we want, we'll get with:
// :CODE:
llRotBetween(<1,0,0>,llVecNorm(<vTarget.x - vPos.x,vTarget.y - vPos.y,0>))
