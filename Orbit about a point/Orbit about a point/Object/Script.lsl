// :CATEGORY:Rotation
// :NAME:Orbit about a point
// :AUTHOR:Anonymous
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:38:59
// :ID:598
// :NUM:820
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Orbit around a point like a moon
// :CODE:

// Orbitting around a single point with cos and sin.
// Made by Juntalis
// Cleaned & Hacked by Strife Onizuka
vector VECTOR_ORIGIN;
float angle;
float radius = 1; //in meters out from the start
float increment = -5; // positive = counterclockwise
default {
    touch_start(integer total_number)
    {
        VECTOR_ORIGIN = llGetPos();
        llSetTimerEvent(0.01);
    }
    timer() {
        llSetPos( <llCos(angle * DEG_TO_RAD), llSin(angle * DEG_TO_RAD), 0> * radius + VECTOR_ORIGIN );
        angle += increment;
    }
} 

