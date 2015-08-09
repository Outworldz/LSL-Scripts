// :CATEGORY:Building
// :NAME:Fractal_Generator
// :AUTHOR:Seifert Surface
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:53
// :ID:336
// :NUM:450
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Child
// :CODE:
///////////////////////////////////////////
///////Fractal Generator 1.0 Child/////////
///////////////////////////////////////////
///////////////////by//////////////////////
///////////////////////////////////////////
/////////////Seifert Surface///////////////
/////////////2G!tGLf 2nLt9cG/////Aug 2005//
///////////////////////////////////////////

default
{
    state_entry()
    {
    }
    link_message(integer sender_num, integer num, string str, key id)
    {
        vector pos = llGetLocalPos();
        rotation rot = llGetLocalRot();
        vector temp = llGetScale();
        float scale = temp.x;  //everything assumes scaling happens on all 3 axes equally, so just pick one
        list data = [pos, rot, scale];
        string reply = llDumpList2String(data, "|");
        llMessageLinked(1, 0, reply, NULL_KEY);
    }
}
