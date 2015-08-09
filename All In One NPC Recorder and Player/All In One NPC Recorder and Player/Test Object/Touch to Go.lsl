// :SHOW:
// :CATEGORY:NPC
// :NAME:All In One NPC Recorder and Player
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2015-07-17 13:16:29
// :EDITED:2015-07-17  12:16:29
// :ID:27
// :NUM:1810
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// Sample touch to go script for all in one NPC animator
// :CODE:

default
{
     state_entry() {
        llSetText("Click to make the NPC continue processing commands",<1,1,1>,1.0);
    }

    touch_start(integer total_number)
    {
        llMessageLinked(LINK_ROOT,0, "@go","");
    }
}
