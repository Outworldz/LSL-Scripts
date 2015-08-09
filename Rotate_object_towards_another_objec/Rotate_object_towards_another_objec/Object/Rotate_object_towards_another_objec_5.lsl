// :CATEGORY:Useful Subroutines
// :NAME:Rotate_object_towards_another_objec
// :AUTHOR:Chalice Yao
// :CREATED:2010-11-16 11:29:36.330
// :EDITED:2013-09-18 15:39:01
// :ID:709
// :NUM:973
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// There we go. The needed left/right rotation. Now, let's combine and get the result!// // We take the up/down rotation, and multiply the left/right roation to it..which is the way of combining rotations...and it basically goes in reverse order. Think of the left/right applied first before the up/down gets done to the result rotation. Basically read from right to left when mupltiplying rotations.// // And there we go. Correct rotation towards a target without rotating around the own axis. Hope this was educational!
// :CODE:
vector vTarget=llList2Vector(llGetObjectDetails("targetkey",[OBJECT_POS]),0);
vector vPos=llGetPos(); //object position
float fDistance=llVecDist(<vTarget.x,vTarget.y,0>,<vPos.x,vPos.y,0>); // XY Distance, disregarding height differences.
llSetRot(llRotBetween(<1,0,0>,llVecNorm(<fDistance,0,vTarget.z - vPos.z>)) * llRotBetween(<1,0,0>,llVecNorm(<vTarget.x - vPos.x,vTarget.y - vPos.y,0>)));
