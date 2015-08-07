// :CATEGORY:Invisibility
// :NAME:Makes_an_item_an_invisiprim
// :AUTHOR:Joker Opus
// :CREATED:2010-01-10 05:20:56.000
// :EDITED:2013-09-18 15:38:57
// :ID:504
// :NUM:674
// :REV:1.0
// :WORLD:Second Life
// :DESCRIPTION:
// Makes_an_item_an_invisiprim
// :CODE:
///////Created by Joker Opus, November 8th//////
//Feel free to mod this, do not steal//
default
{
    state_entry()
    {
        key owner = llGetOwner();
        llListen(1,"",owner,"");
        llSetTexture("38b86f85-2575-52a9-a531-23108d8da837", ALL_SIDES);
        llSetTexture("e97cf410-8e61-7005-ec06-629eba4cd1fb", ALL_SIDES);
        llSetPrimitiveParams([PRIM_BUMP_SHINY, ALL_SIDES, PRIM_SHINY_NONE, PRIM_BUMP_BRIGHT]);
        llOffsetTexture(0.468, 0.0, ALL_SIDES);
        llScaleTexture(0.0, 0.0, ALL_SIDES);
        llSetAlpha(1.0, ALL_SIDES);
        llSetTimerEvent(5);
    }

    listen(integer channel, string name, key id, string msg)
    {
        if( msg== "uncloak" )
        {
            llSetTexture("4c1ce202-4196-f1c1-0409-367b3a71543e", ALL_SIDES);
        }
    }
}
