// :SHOW:
// :CATEGORY:NPC
// :NAME:All In One NPC Recorder and Player
// :AUTHOR:Ferd Frederix
// :KEYWORDS:
// :CREATED:2015-07-17 13:16:10
// :EDITED:2015-07-17  12:16:10
// :ID:27
// :NUM:1809
// :REV:1
// :WORLD:Second Life
// :DESCRIPTION:
// sample Stop processing script for NPC
// :CODE:

default
{
     state_entry() {
        llSetText("Click to make the NPC stop processing commands",<1,1,1>,1.0);
    }

    touch_start(integer total_number)
    {
        llMessageLinked(LINK_ROOT,0, "@stop","");
    }
}
