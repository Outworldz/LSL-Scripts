// :CATEGORY:Elevator
// :NAME:Two Floor keyframed elevator
// :AUTHOR:Soen Eber
// :KEYWORDS:
// :CREATED:2014-12-04 12:45:36
// :EDITED:2014-12-04
// :ID:1062
// :NUM:1704
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
Two floor key frame elevator door Call Script (for 2 floors)// Write the floor number (1 or 2) in the description
// :CODE:
integer ch = -11;
integer floor;
integer ready = TRUE;
status(integer flg)
{
    ready = flg;
    llSetLinkPrimitiveParamsFast(LINK_THIS,[PRIM_FULLBRIGHT,ALL_SIDES, flg]);
}
default
{
    state_entry()
    {
        llListen(ch,"",NULL_KEY,"");
        floor = (integer)llGetObjectDesc();
    }
    listen(integer ch,string name,key id,string msg)
    {
        if (llSubStringIndex(msg,"arrived") != -1) {
            llSleep(3);
            status(TRUE);
        }
        else if (msg == (string)floor+" depart") {
            status(FALSE);
        }
    }
    touch_start(integer total_number)
    {
        if (ready == TRUE) llWhisper(ch, (string)floor+" call");
        else               llWhisper(0, "Please Wait");
    }
}
