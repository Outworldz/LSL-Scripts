// :CATEGORY:Movement
// :NAME:Harmonic_Oscillator_motion
// :AUTHOR:Dora Gustafson
// :CREATED:2012-03-14 14:24:55.553
// :EDITED:2013-09-18 15:38:54
// :ID:373
// :NUM:517
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Harmonic_Oscillator_motion
// :CODE:
// Harmonic oscillator motion by Dora Gustafson, Studio Dora 2012
// will oscillate a prim along a straight line in space
// only the first half periode is computed, the second is the first in reverse
 
float phase=PI;
vector amplitude=< 0.0, 0.0, 2.0>; // amplitude and direction for oscillation
float Hperiode=2.0; // half periode time S
float steps=12; // number of Key Frames for a half periode
float step=0.0;
list KFMlist=[];
vector U;
vector V;
integer osc=TRUE;
vector basePos;
 
default
{
    state_entry()
    {
        llSetMemoryLimit( llGetUsedMemory()+0x1000);
        llSetPrimitiveParams([PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_CONVEX]);
        basePos = llGetPos();
        float dT = Hperiode/steps;
        dT = llRound(45.0*dT)/45.0;
        if ( dT < 0.11111111 ) dT = 0.11111111;
        U = amplitude*llCos( phase);
        while ( step < steps )
        {
            step += 1.0;
            V = amplitude*llCos( PI*step/steps + phase);
            KFMlist += [V-U, dT];
            U = V;
        }
    }
    touch_start( integer n)
    {
        llSetKeyframedMotion( [], []);
        llSleep(0.2);
        llSetRegionPos( basePos);
        llSetPos( basePos);
        if ( osc ) llSetKeyframedMotion( KFMlist, [KFM_DATA, KFM_TRANSLATION, KFM_MODE, KFM_PING_PONG]);
        osc = !osc;
    }
    on_rez( integer n) { llResetScript(); }
}
