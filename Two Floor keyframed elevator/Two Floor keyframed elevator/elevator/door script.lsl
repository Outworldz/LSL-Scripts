// :CATEGORY:Elevator
// :NAME:Two Floor keyframed elevator
// :AUTHOR:Soen Eber
// :KEYWORDS:
// :CREATED:2014-12-04 12:45:38
// :EDITED:2014-12-04
// :ID:1062
// :NUM:1705
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Two floor key frame elevator door script
// :CODE:
integer ch = -11;
integer floor;
open()
{
    llSetLinkPrimitiveParamsFast(
        LINK_THIS,[PRIM_TYPE,PRIM_TYPE_CYLINDER,PRIM_HOLE_CIRCLE,<0.375,0.4,0.0>,0.95,<0,0,0>,<1,1,0>,<0,0,0>]
    );
}
close()
{
    llSetLinkPrimitiveParamsFast(
        LINK_THIS,[PRIM_TYPE,PRIM_TYPE_CYLINDER,PRIM_HOLE_CIRCLE,<0.375,0.625,0.0>,0.95,<0,0,0>,<1,1,0>,<0,0,0>]
    );
}
default
{
    state_entry()
    {
        floor = (integer)llGetObjectDesc();
        llListen(ch,"",NULL_KEY,"");
    }
    listen(integer ch,string name,key id,string msg)
    {
        if (msg == (string)floor+" arrived") {
            open();
        }
        else if (msg == (string)floor+" depart") {
            close();
        }
    }
}
