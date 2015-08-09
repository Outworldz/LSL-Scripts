// :CATEGORY:Train
// :NAME:Train_car_motor
// :AUTHOR:Barney Boomslang
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:08
// :ID:914
// :NUM:1312
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Train_car_motor
// :CODE:
// copyright 2007 Barney Boomslang
//
// this is under the CC GNU GPL
// http://creativecommons.org/licenses/GPL/2.0/
//
// prim-based builds that just use this code are not seen as derivative
// work and so are free to be under whatever license pleases the builder.
//
// Still this script will be under GPL, so if you build commercial works
// based on this script, keep this script open!

// This script moves the train car to the given position using warping to
// allow even updates over a longer distance. This script needs to be inside
// the train cars multiple times, at least 2 times. Each instance of this
// script needs to have it's own "mynum" value. It gets the number in the
// on_rez event from it's own name (multiple instances will be numbered
// by SL automatically and so get different numbers)

// my motor number (each motor script needs it's own)
integer mynum = 0;

// offset for car height with regard to engine
vector offset = <0,0,0.434>;

// jump to a target in one big swipe
llWarp2Pos( vector d, rotation rot )
{
        if ( d.z > 768 )
        d.z = 768;
        integer s = (integer)(llVecMag(d-llGetPos())/10)+1;
        if ( s > 100 )
        s = 100;
        integer e = (integer)( llLog( s ) / llLog( 2 ) );
        list rules = [ PRIM_POSITION, d ];
        integer i;
        for ( i = 0 ; i < e ; ++i )
        rules += rules;
        integer r = s - (integer)llPow( 2, e );
        if ( r > 0 )
        rules += llList2List( rules, 0, r * 2 + 1 );
        llSetPrimitiveParams( [PRIM_ROTATION, rot] + rules );
}

default
{
    on_rez(integer start_param)
    {
        list parts = llParseString2List(llGetScriptName(), [" "], []);
        if (llGetListLength(parts) == 2)
        {
            integer i = (integer)llList2String(parts, 1);
            if (i) mynum = i;
        }
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if (num == mynum)
        {
            list parts = llParseString2List(str, ["|"], []);
            if (llGetListLength(parts) == 2)
            {
                vector pos = (vector)llList2String(parts, 0) - llGetRegionCorner();
                rotation rot = (rotation)llList2String(parts, 1);
                pos += offset;
                llWarp2Pos(pos, rot);
            }
        }
    }
}
