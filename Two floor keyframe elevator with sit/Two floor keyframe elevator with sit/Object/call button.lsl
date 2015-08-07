// :CATEGORY:Elevator
// :NAME:Two floor keyframe elevator with sit
// :AUTHOR:Soen Eber
// :KEYWORDS:
// :CREATED:2014-12-04 12:45:19
// :EDITED:2014-12-04
// :ID:1061
// :NUM:1701
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Call Button for two floor elevator
// :CODE:
// Elevator Call Script (for 2 floors)
// Write the floor number (1 or 2) in the description
// Altered by Vegaslon Plutonian to use shout instead of whisper for communication since some elevators are really tall.
// from http://forums.osgrid.org/viewtopic.php?f=5&t=5201&hilit=lift

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
        if (ready == TRUE) llShout(ch, (string)floor+" call");
        else               llWhisper(0, "Please Wait");
    } 
}
