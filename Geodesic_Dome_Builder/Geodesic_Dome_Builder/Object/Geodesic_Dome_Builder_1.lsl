// :CATEGORY:Building
// :NAME:Geodesic_Dome_Builder
// :AUTHOR:Shine Renoir
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:54
// :ID:345
// :NUM:465
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// This code makes Geodesic Domes and was given to the Open Source Scripting group by Shine Renoir.<img src="http://www.sparticarroll.com/public/Upload/dome.jpg">// You can read about the math here, http://www.geometer.org/mathcircles/geodesic.pdf// // The Dome Builder uses 3 scripts. One in the builder object and two simple scale/scale and shear scripts in the component parts.
// 
// You can pick up a complete Dome Builder tool for free in Chessport, near the telehub.
// 
// First - this script goes in the builder object.
// 
// BUILDER
// :CODE:

// Dome Builder
// 2007 Copyright by Shine Renoir (fb@frank-buss.de)
// Use it for whatever you want, but keep this copyright notice
// and credit my name in notecards etc., if you use it in
// closed source objects

integer subdivision = 2;
float length = 3.0;

vector base;
float r;

move(vector destination)
{
    // llSetPos is limited to 10m distances,
    // so it is called until the target is reached
    vector p = ZERO_VECTOR;
    while (p.z != destination.z) {
        llSetPos(destination);
        p = llGetPos();
    }
}

drawLine(vector v1, vector v2)
{
    vector line = v2 - v1;
    vector pos = base + line / 2 + v1;
    float len = llVecMag(line);
    vector size = <0.1, 0.1, len>;
    vector up = <0, 0, 1>;
    rotation rot = llRotBetween(up, llVecNorm(line));
    move(pos);
    llRezObject("Line", pos, ZERO_VECTOR, rot, 0);
    llSay(-42, (string) size);
}

drawTriangle(vector v1, vector v2, vector v3)
{
    // assuming a normal triangle: no zero area

    // make v1-v3 the longest side
    integer i = 0;
    for (i = 0; i < 2; i++) {
        float a = llVecDist(v2, v3);
        float b = llVecDist(v1, v3);
        float c = llVecDist(v1, v2);
        if (a > b || c > b) {
            vector tmp = v1;
            v1 = v2;
            v2 = v3;
            v3 = tmp;
        }
    }
    
    // calculate side lengths
    float a = llVecDist(v2, v3);
    float b = llVecDist(v1, v3);
    float c = llVecDist(v1, v2);

    // b=b1+b2, a^2=h^2+b2^2, c^2=b1^2+h^2, solving:
    float b2 = (a*a + b*b - c*c)/2.0/b;
    float b1 = b - b2;
    float h = llSqrt(a*a - b2*b2);  // triangle height

    // calculate triangle height vector and shear value
    float hPosition = b1 / b;
    vector vb1 = (v3 - v1) * hPosition;
    vector vh = v2 - (v1 + vb1);
    float shear = hPosition - 0.5;

    // calculate position and rotation
    vector pos = base + v1 + (v3 - v1) / 2 + vh / 2;
    vector size = <b, 0.05, h>;
    vector up = <0.0, 0.0, 1.0>;
    rotation rot = llRotBetween(up, llVecNorm(vh));
    vector fwd = llVecNorm(v3 - v1);  // fwd is the base
    vector left = llVecNorm(vh);
    left = llVecNorm(left % fwd);  // "left" is cross product (orthogonal to base and left)
    rot = llAxes2Rot(fwd, left, fwd % left);  // calculate the needed rotation
    
    // create object
    llRezObject("Triangle", pos, ZERO_VECTOR, rot, 0);
    
    // set size and shear value
    list send = [size, shear ] ;
    llSay(-42, llList2CSV(send));
}

vector scaleToSphere(vector v)
{
    float l = llVecMag(v);
    return r / l * v;
}

drawSide(vector bottomLeft, vector top, vector bottomRight)
{
    integer i;
    integer segments = subdivision + 1;
    vector dx = (bottomRight - bottomLeft) / segments;
    vector dy = (top - bottomLeft) / segments;
    for (i = 0; i < segments; i++) {
        integer j;
        for (j = 0; j < subdivision * 2 + 1 - 2 * i; j++) {
            if ((j % 2) == 0) {
                // even, draw left and bottom line
                integer l = j / 2;
                vector v1 = scaleToSphere(bottomLeft + l * dx + i * dy);
                vector v2 = scaleToSphere(bottomLeft + l * dx + (i+1) * dy);
                vector v3 = scaleToSphere(bottomLeft + (l+1) * dx + i * dy);
                drawLine(v1, v2);
                drawLine(v1, v3);
                drawTriangle(v1, v2, v3);
            } else {
                // odd, draw right line
                integer l = (j - 1) / 2;
                vector v1 = scaleToSphere(bottomLeft + l * dx + (i+1) * dy);
                vector v2 = scaleToSphere(bottomLeft + (l+1) * dx + i * dy);
                vector v3 = scaleToSphere(bottomLeft + (l+1) * dx + (i+1) * dy);
                drawLine(v1, v2);
                drawTriangle(v1, v2, v3);
            }
        }
    }
}

drawDome()
{
    float l2 = length / 2.0;
    vector bottomLeft = <-l2, -l2, 0.0>;
    vector topLeft = <-l2, l2, 0.0>;
    vector topRight = <l2, l2, 0.0>;
    vector bottomRight = <l2, -l2, 0.0>;
    vector top = <0, 0, length * llSqrt(6.0) / 3.0>;
    r = llVecMag(bottomLeft - topRight) / 2.0;
    drawSide(bottomLeft, top, bottomRight);
    drawSide(topLeft, top, bottomLeft);
    drawSide(topRight, top, topLeft);
    drawSide(bottomRight, top, topRight);
}

initialize()
{
    llSetSitText("Build");
    llSetText("Right click and 'Build'", <1, 0, 0>, 1.0);
    llSitTarget(<0.5, 0.0, 0.7>, ZERO_ROTATION);
    base = llGetPos();
}

default
{
    touch_start(integer total_number)
    {
        llSay(0, "Right click me and choose 'Build' to start build");
    }

    on_rez(integer start_param) 
    {
        initialize();
    }
    
    state_entry()
    {
        initialize();
    }
    
    changed(integer change)
    {
        // sitdown or standup
        if (change & CHANGED_LINK) {
            key av = llAvatarOnSitTarget();
            if (av) {
                // sitdown
                initialize();
                drawDome();
                base.z += length + 1.0;
                move(base);
            }
        }
    }
}
