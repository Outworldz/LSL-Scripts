// CATEGORY:Skirt Maker
// NAME:Skirt_Maker
// PART:1
// AUTHOR:Ged Larsen
// CREATED:2006-12-20 00:00:00.000
// EDITED:2006-12-20 00:00:00.000
// ID:
// NUM:
// REV:1.0
// WORLD: Second Life, OpenSim
// DESCRIPTION:LoopRezzer for skirts and jewelry.
// CODE 


////////////////////////////////////////////////////////////////////////////////
// LoopRez v0.6, by Ged Larsen, 20 December 2006
//
// - rez a number of objects in an ellipse, whose size is determined by xRadius and yRadius
// - all facing "outwards", along a tangent to the ellipse
// - can set how much the objects flare outwards
// - properly handles object rotation corrections (for example, X-axis 180 degree rotation helps for flexi-prim skirts)
// - can also get a 'saddle' bend, to generate a bend that might help for necklaces (from Ariane Brodie)
//
// To use:
//    1) create a prim that will contain this script and the object to use
//    2) put the script into the prim
//     3) create an object that will be used, and name it "Object"
//    4) put "Object" into the prim containing the script, by dragging it from your inventory
//    5) get out of Edit Mode, and touch the prim
//
// Random note:
// - this version does NOT insure equal spacing of objects along the perimeter of the ellipse
// - i.e., objects "bunch up" at the long ends of an ellipse; the effect should be acceptable for non-extreme ellipses
// - even spacing of objects can be accomplished, but requires simulation of integral calculus, which slows down the script
//
// References:
// - tangent formulas from: http://mathworld.wolfram.com/Ellipse.html


////////////////////////////////////////////////////////////////////////////////
// CONFIGURATION PARAMETERS, change these to your liking

string objectName = "skirtpart";            // object to use; will need to be in the inventory of the prim containing this script
integer numObjects = 15;                // how many objects
float xRadius = .08;                    // ellipse x-axis radius in meters
float yRadius = .11;                        // ellipse y-axis radius in meters
float flareAngle = 30.0;                // how many DEGREES the bottom of object will flare outwards, the "poof" factor
float bendCoefficient = 0.0;            // makes a "saddle shape", bends DOWN this number of meters at extremes of X-axis
vector rotOffset = <0.0, 180.0, 0.0>;     // rotation offset in DEGREES -- fixes the rotation of ALL objects; for flexi prims, often you will want <180.0, 0.0, 0.0>
vector posOffset = <0.0, 0.0, 1.0>;        // position offset



////////////////////////////////////////////////////////////////////////////////
// No need to mess with anything below here

makeLoop()
{
    integer n;                            // which object is being placed
    float theta;                        // angle in radians
    vector pos;                            // position
    rotation rot;                        // rotation in quaternion format

    for(n = 0; n < numObjects; n++) {

        theta = TWO_PI * ( (float)n / (float)numObjects );

        pos.x = xRadius * llCos(theta);                            // ellipse: 2x xRadius meters wide
        pos.y = yRadius * llSin(theta);                            // ellipse: 2x yRadius meters wide
        pos.z = -bendCoefficient*llCos(theta)*llCos(theta);        // saddle shape, bending downwards on X-axis
        pos = pos + llGetPos() + posOffset;

        rot = llEuler2Rot(<rotOffset.x*DEG_TO_RAD, rotOffset.y*DEG_TO_RAD, rotOffset.z*DEG_TO_RAD>);    // user-chosen rotation offset correction
        rot = rot * llEuler2Rot(<0, -1*flareAngle*DEG_TO_RAD, 0>);                                        // flare generation (poof)

        // the following make the objects face outwards properly for an ellipse; using theta alone is only correct for a circle
        // the scary formula calculates a unit vector TANGENTIAL to the ellipse, and llRotBetween is used to figure out how much the object needs to rotate to lie parallel to the tangent
        rot = rot * llRotBetween(<0.0,1.0,0.0>, <-1.0 * xRadius * llSin(theta) / ( llSqrt ( (yRadius*yRadius * llCos(theta) * llCos(theta)) + (xRadius*xRadius * llSin(theta) * llSin(theta))) ),yRadius * llCos(theta) / ( llSqrt ( (yRadius*yRadius * llCos(theta) * llCos(theta)) + (xRadius*xRadius * llSin(theta) * llSin(theta))) ),0.0>);
        if ( n== (numObjects/2) )        // LSL's implementation of llRotBetween at theta = pi radians is reversed at 180 degrees, so this manually corrects it
            rot = rot * llEuler2Rot( <0,PI,0> );

        llRezObject(objectName, pos, ZERO_VECTOR, rot, 0);
    }
}

default
{
    touch_start(integer total_number)
    {
        if (llDetectedOwner(0) == llGetOwner())
        {
            makeLoop();
        }
    }
}
