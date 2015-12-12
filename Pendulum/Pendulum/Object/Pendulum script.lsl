// :SHOW:
// :CATEGORY:Pendulum
// :NAME:Pendulum
// :AUTHOR:Dora Gustafson, Studio Dora 
// :KEYWORDS:
// :CREATED:2015-11-24 20:38:39
// :EDITED:2015-11-24  19:38:39
// :ID:1094
// :NUM:1870
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Will swing a prim like a simple pendulum pivoting at an axis parallel to the prim's Y-axis
// :CODE:
// Pendulum motion by Dora Gustafson, Studio Dora 2012
// Will swing a prim like a simple pendulum pivoting at an axis parallel to the prim's Y-axis
// The pivot axis will be at the top of a prim with the Z-axis pointing up
// Quote from http://en.wikipedia.org/wiki/Pendulum_(mathematics)
// • A simple pendulum is an idealization of a real pendulum using the following assumptions:
// • The rod or cord on which the bob swings is massless, inextensible and always remains taut;
// • Motion occurs only in two dimensions, i.e. the bob does not trace an ellipse but an arc.
// • The motion does not lose energy to friction or air resistance.
// The periode time increase with the Z dimension (the pendulum length)...
// If it is too small the motion will not be well because of the time limitation with Key Framed Motions
// The parameters set in the script works nice with a 3m long pendulum
// If the pendulum is moved, rotated or resized the script must be reset to update the motion
 
float angle=1.0; // max swing from resting (radians)
float steps=12.0; // number of Key Frames
float step=0.0;
list KFMlist=[];
vector U; 
vector V;
float angleU=0.0; 
float angleV;
integer swing=TRUE;
vector basePos;
rotation baseRot;
 
default
{
    state_entry()
    {
        llSetMemoryLimit( llGetUsedMemory()+0x1000);
        llSetPrimitiveParams([PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_CONVEX]);
        basePos = llGetPos();
        baseRot = llGetRot();
        vector v1 = llGetScale();
        float periode = TWO_PI*llSqrt( v1.z/9.81);
        float dT = periode/steps;
        dT = llRound(45.0*dT)/45.0;
        if ( dT < 0.11111111 ) dT = 0.11111111;
        v1.x = 0.0;
        v1.y = 0.0;
        v1 = -0.5*v1*llGetRot();
        U = v1;
        while ( step < steps )
        {
            step += 1.0;
            angleV = angle*llCos( TWO_PI*step/steps + PI_BY_TWO);
            V = v1*llAxisAngle2Rot(llRot2Fwd(llGetRot()), angleV);
            KFMlist += [V-U, llEuler2Rot(< angleV-angleU, 0.0, 0.0>), dT];
            angleU = angleV;
            U = V;
        }
    }
    touch_start( integer n)
    {
        llSetKeyframedMotion( [], []);
        llSleep(0.2);
        llSetPrimitiveParams([PRIM_POSITION, basePos, PRIM_ROTATION, baseRot]);
        if ( swing ) llSetKeyframedMotion( KFMlist, [ KFM_MODE, KFM_LOOP]);
        swing = !swing;
    }
    on_rez( integer n) { llResetScript(); }
}
