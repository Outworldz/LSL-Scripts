// :CATEGORY:Building
// :NAME:Bezier_Curve_Demo
// :AUTHOR:Lionel Forager
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:88
// :NUM:119
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// oint Mark// Description// // The Point Marks are the prims drawn in each interpolated point of the bezier curve when markers mode is active.// You can use any prim, as a small sphere for example.// The Point Mark object should be in the inventory of the bezier server object, as it is rezzed from the script of that object.
// The Point Marks are very simple, as they don't need to communicate with other scripts.
// For convenience, they just listen in channel # 1 for clear commands, to delete themselves.
// 
// Commands - How to use
// 
// The point marks listen in channel #1 for clear commands to delete themselves.
// say "/1 clear": deletes all point marks.
// 
// How to Create the Point Mark object
// 
// Create the prim or object you want to be rezzed in each point position. Name it Point Mark. Then put the following script in it.
// Take the object to your inventory and copy it from there to the inventory of the bezier server object.
// :CODE:
default
{
    state_entry()
    {
        llListen(1,"","","");
    }

    listen(integer channel, string name, key id, string m)
    {
        if (llGetOwnerKey(id) == llGetOwner())
        {
            if (m == "clear")
            {
                llDie();
            }
        }
    }
}
