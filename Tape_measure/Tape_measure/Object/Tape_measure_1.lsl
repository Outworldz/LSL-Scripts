// :CATEGORY:Building
// :NAME:Tape_measure
// :AUTHOR:Anonymous
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:39:06
// :ID:868
// :NUM:1228
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Tape measure.lsl
// :CODE:

integer count = 0;

vector MEASURING_TAPE= <1,.5,1>;
vector AVATAR_HEIGHT = <1.45, .05, 2.1>;
vector DOOR_SIZE_HEIGHT = <1.45, .05, 2.8>;
vector CEILING_HEIGHT = <1.45, .05, 3.8>;
vector HALLWAY_WIDTH = < 3.0, 0.5,1>;
vector ROOM_SIZE = < 10.0, 10.0, 0.5>;
vector SECOND_FLOOR_HEIGHT = <1.45, .05, 7.6>;

float groundpos;

list scalelist = [MEASURING_TAPE,AVATAR_HEIGHT,DOOR_SIZE_HEIGHT, CEILING_HEIGHT, HALLWAY_WIDTH, ROOM_SIZE, SECOND_FLOOR_HEIGHT];
list stringlist = ["Measuring Tape, click me","Average Avatar height, click again for door height", "Door height and width, click again for first floor height", "First floor ceiling height, click again for hallway width", "Hallway width, click again for room size","Room size, click again for second floor ceiling height","Second floor ceiling height, click again to reset"];
list soundlist =[ "tape out", "tape in"];
change(integer which)
{ 
    // Update scale 
    vector newscale = llList2Vector(scalelist, which);
    llSetScale(newscale);

    // Update our position according to the scale so 
    // that we are just touching the ground. 
    vector newpos = llGetPos();
    //float groundpos = llGround(<0.0,0.0,0.0>);
    newpos.z = groundpos + .5 * newscale.z;
    llSetPos(newpos);

    // Update the texture and tell the user
    string size_name = llList2String(stringlist, which);
    llPlaySound("tape out", 0.5);
    llWhisper(0, size_name );
    llSetTexture(size_name , 1);
    llSetTexture(size_name , 3);
    llSetTexture(size_name , 0);
     
}

init()
{
   count = 0;
   vector pos = llGetPos();
   vector scale = llGetScale();
   groundpos = pos.z - scale.z/2.0;
   change( count );
}

default
{
    state_entry()
    {
        init();
    }

    on_rez( integer start_param )
    {
        init();
    }

    touch_start(integer total_number)
    {
        count++;
        if( count >= llGetListLength( scalelist ) )
        {
            count = 0;
        }
        change(count);
    }
}
// END //
