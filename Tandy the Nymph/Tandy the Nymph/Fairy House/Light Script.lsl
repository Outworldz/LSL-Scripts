// :CATEGORY:Tandy
// :NAME:Tandy the Nymph
// :AUTHOR:Fred Beckhusen (Ferd Frederix)
// :CREATED:2013-09-06
// :EDITED:2013-09-18 15:39:06
// :ID:867
// :NUM:1212
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Tandy
// :CODE:

integer flag;

default
{
    state_entry()
    {
        llSetPrimitiveParams([PRIM_POINT_LIGHT,TRUE,
                                    <1.0,0.7,1.0>,  // light color vector range: 0.0-1.0 *3
                                    1.0,            // intensity    (0.0-1.0)
                                    10.0,           // radius       (.1-20.0)
                                    0.6 ]);         // falloff      (.01-2.0)
    }


    touch_start(integer p)
    {
        flag = ~ flag;
        if (flag)
        {
            llSetPrimitiveParams([PRIM_POINT_LIGHT,TRUE,
                                    <1.0,0.7,1.0>,  // light color vector range: 0.0-1.0 *3
                                    1.0,            // intensity    (0.0-1.0)
                                    10.0,           // radius       (.1-20.0)
                                    0.6 ]);         // falloff      (.01-2.0)
        }
        else
        {
            llSetPrimitiveParams([PRIM_POINT_LIGHT,FALSE,
                                    <1.0,0.7,1.0>,  // light color vector range: 0.0-1.0 *3
                                    1.0,            // intensity    (0.0-1.0)
                                    10.0,           // radius       (.1-20.0)
                                    0.6 ]);         // falloff      (.01-2.0)
        }
    }
   
}

