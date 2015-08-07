// :CATEGORY:Sphere World
// :NAME:Sphere_World__Walk_and_live_on_a_sphere
// :AUTHOR:Ferd Frederix
// :CREATED:2013-12-13 14:01:06
// :EDITED:2013-12-13 13:13:13
// :ID:824
// :NUM:1556
// :REV:1.1
// :WORLD:Second Life
// :DESCRIPTION:
// Notes on how to make things walk on a sphere <img src="/images/robotworld.png" width="100">
// :CODE:

Make a large sphere.   Add the moon script.  Put it somewhere within 100 meters of the ground.

Put the pose ball script in a small sphere  at ground level, along with one walk animation named 'walk'. 
Click the pose ball to auto-walk around on your moon.

A second pose ball script requires a '"Walk: Power Slow' and a 'avatar_stand_1",
 or you can edit that script and change to any suitable alk and stand animation from your inventory.  

string WALK = "Walk: Power Slow";
string STAND = "avatar_stand_1";

You can put out have  as many pose balls  as you want.



