// :CATEGORY:Building
// :NAME:Bezier_Curve_Demo
// :AUTHOR:Lionel Forager
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:48
// :ID:88
// :NUM:118
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// // Control Points// Description// // The Control Point objects are the prims that you can position in place to control the shape of the bezier curve.// A Bezier curve has three control points (p1,p2, and p3).
// The curve passes through p1 and p3 and p2 controls the curvature and tangent direction of the curve in p1 and p3.
// When a control point is moved or you touch it, it says its position through channel #1 to the bezier server.
// 
// To use them, just rezz one object of each type (p1,p2 and p3) and move it to the position you want. The curve should be drawn if you have rezzed the bezier server first.
// 
// Commands - How to use
// The control points don't obey any command. They just have a simple script to say their position to the bezier server trough channel #1
// 
// How to Create the Control Points
// 
// Create three prims (may be a simple sphere prim) with different colors and name them p1, p2 and p3 (be sure to name it that way: the server uses the name to differentiate which point has been moved or touched).
// 
// Then put the following script in each control point.
// :CODE:
reportPos()
{
    vector pos = llGetPos();
    llSay(1, (string)pos);
}

default
{
    touch_start(integer total_number)
    {
        if (llDetectedKey(0) == llGetOwner())
        {
            reportPos();
        }
    }
    
    moving_end()
    {
        reportPos();
    }
}
