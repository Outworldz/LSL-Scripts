// :CATEGORY:Door
// :NAME:Iris_Opener_v1
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:55
// :ID:407
// :NUM:563
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Iris Opener v1.lsl
// :CODE:

//listen(integer channel, string name, key id, string message)




default
{
    state_entry()
    {
        llListen(8,"","","");
    }

    listen(integer channel, string name, key id, string message)
    {
        if(message== "open")
        {
        llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_BOX, 16, <0.0, 1.0, 0.0>, 0.10, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>]);
        llSleep(.001);
        llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_BOX, 16, <0.0, 1.0, 0.0>, 0.20, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>]);
        llSleep(.001);
        llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_BOX, 16, <0.0, 1.0, 0.0>, 0.30, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>]);
        llSleep(.001);
        llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_BOX, 16, <0.0, 1.0, 0.0>, 0.40, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>]);
        llSleep(.001);
        llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_BOX, 16, <0.0, 1.0, 0.0>, 0.50, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>]);
        llSleep(.001);
        llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_BOX, 16, <0.0, 1.0, 0.0>, 0.60, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>]);
        llSleep(.001);
        llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_BOX, 16, <0.0, 1.0, 0.0>, 0.70, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>]);
        llSleep(.001);
        llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_BOX, 16, <0.0, 1.0, 0.0>, 0.80, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>]);
        llSleep(.001);
        llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_BOX, 16, <0.0, 1.0, 0.0>, 0.90, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>]);
        }       
    
        if(message== "close")
        {
        llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_BOX, 16, <0.0, 1.0, 0.0>, 0.80, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>]);
        llSleep(.01);
        llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_BOX, 16, <0.0, 1.0, 0.0>, 0.70, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>]);
        llSleep(.01);
        llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_BOX, 16, <0.0, 1.0, 0.0>, 0.60, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>]);
        llSleep(.01);
        llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_BOX, 16, <0.0, 1.0, 0.0>, 0.50, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>]);
        llSleep(.01);
        llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_BOX, 16, <0.0, 1.0, 0.0>, 0.40, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>]);
        llSleep(.01);
        llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_BOX, 16, <0.0, 1.0, 0.0>, 0.30, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>]);
        llSleep(.01);
        llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_BOX, 16, <0.0, 1.0, 0.0>, 0.20, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>]);
        llSleep(.01);
        llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_BOX, 16, <0.0, 1.0, 0.0>, 0.10, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>]);
        llSleep(.01);
        llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_BOX, 16, <0.0, 1.0, 0.0>, 0.0, <0.0, 0.0, 0.0>, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>]);
        }
    }
    
}

// END //
