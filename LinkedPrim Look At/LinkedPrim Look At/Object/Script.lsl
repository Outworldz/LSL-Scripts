// :CATEGORY:Look At
// :NAME:LinkedPrim Look At
// :AUTHOR:Anonymous
// :KEYWORDS:
// :CREATED:2014-04-04 22:01:39
// :EDITED:2014-04-04
// :ID:1032
// :NUM:1608
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Lets you point a linked prim at an object
// :CODE:
// If you want to use the LookAt function on a linked object...
// License CC BY-NC-SA 3.0.
// Original function by http://digigrids.free.fr/wiki/index.php?title=LlLookAt

LinkedLookAt( vector Target){
    rotation rotvec = llRotBetween(<0,1,0>,llVecNorm((Target - llGetPos())));
    rotation rotbet = rotvec/llGetRootRotation();
    llSetRot(rotbet);
}
 
default
{
    state_entry()
    {
        llSensorRepeat("", "", AGENT, 20.0, PI, 1.0);
    }
 
    sensor(integer total_number)
    {
        vector p = llDetectedPos(0);
        LinkedLookAt(p);
    }
}
